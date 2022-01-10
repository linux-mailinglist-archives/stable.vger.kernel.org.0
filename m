Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE2B489DE6
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 17:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiAJQyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 11:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiAJQyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 11:54:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584BEC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 08:54:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p14so12764507plf.3
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 08:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4DjKzPSaPLVnrRfVNe9J7Qq8iml9PMHN2hGWapiC1+U=;
        b=6S6fd5BEhDqCg1CEAOX/IvoillPqVGxFutyslYIGJvZsOLXCIH9Th57AOunzLZ5J4E
         MYlof5i9oPzjg1QQWjbIpvHvV2zI4nALBNrN1wVDGkGeRVEP1fewP71f3M5RcK4ofF9D
         9bWvPGcN9T0ZfUkWyKS6W4ODkWpV7t7ZJ75ZMPXTeTINgsQAoNv4db27DvvulxVufcpC
         p2cWJR7JT0jbJGTicMi/B2rq2VQN8yKgyycC2COtep7X4MGHDH/m9uBC4VSMi/NrXPh0
         fKiiWI2UQYFBjXRPKGsI7EEw/NCQFpMpMk1KneZj+Bh3RWmQgRvoX783kALi8z2Q7HcC
         l6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4DjKzPSaPLVnrRfVNe9J7Qq8iml9PMHN2hGWapiC1+U=;
        b=r8tYf2JGigi9IDm666FlFgIjUuPyBIsy7kZRq0nM3q5NKSPByckNtraYRZP/7QlQ83
         lHldcPVUSo/SFhJKjDDuW3uwiIGytNUjCxFCviOeX5W1cK9Wse7gQq//4YFJm9TgJV3U
         r/EfFR2RfrPmPHlsCXFXAilnUv6adwe5BEhp2VPcX2W9NdPzHbjrFVvSWb16YbU0/5ht
         P/yaRjcnrJcRcAfYuhYFtCGduKwqHoRu3CHgkcWPDZ8VoJIqd2PiHQIh6KuuuraRp3al
         jKCw5N0wR53nFM6ieE+wCdRwIA/wGDxYbNeSQRumRxAvb3oGONxfuhxKxpMoLV2tuThc
         f+IQ==
X-Gm-Message-State: AOAM533xeBL+niF8zxCQKlSQo+0ldU/+2a3wYUpw+MMYsv3IooJDFyA1
        jjGsUbaIiZ5Ua+IReP2tetvksS+mb8ZFPb+1
X-Google-Smtp-Source: ABdhPJw3ziJgK9vtF4ZI5mVIp1CiZOm8xPyKT82fmMokwOS/3iQXy1cS2YQzyJjObAfjKdPzXKD0rg==
X-Received: by 2002:a63:f16:: with SMTP id e22mr495697pgl.221.1641833692684;
        Mon, 10 Jan 2022 08:54:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm7986839pfv.85.2022.01.10.08.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 08:54:52 -0800 (PST)
Message-ID: <61dc64dc.1c69fb81.74c27.289e@mx.google.com>
Date:   Mon, 10 Jan 2022 08:54:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-22-g21eed7b761de
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 1 regressions (v4.14.261-22-g21eed7b761de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 1 regressions (v4.14.261-22-g21eed=
7b761de)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-22-g21eed7b761de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-22-g21eed7b761de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21eed7b761dec354f10e20710cbf7461fa231dc1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc312fa47557aef3ef6743

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g21eed7b761de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g21eed7b761de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc312fa47557a=
ef3ef6746
        failing since 7 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-10T13:14:07.822188  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-10T13:14:07.831794  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
