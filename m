Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726524880D8
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 03:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiAHCLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 21:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiAHCLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 21:11:06 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16532C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 18:11:06 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s15so6355572plg.12
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 18:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2y1Hv3tCZYGcTRb07QtKSAGkAr2OsPGTT4mIP90U7VU=;
        b=MyfZllopp+C8osZRYWSf6ae4rDI9ErBZXBg3X6HT/C+98gfbInCqirlBfNMTmqk7HE
         cT0noH4NRTXe7zNhXhf3ZdjQsmuLIH8jmfLceWcL58icdvoMNLwp5lFzwPJs+W6x9DAy
         k/QWXabtYq3hCbY9uhM3zzXWwaMinYgSAMwXBJKD1Kl4zUSnL7TiCVKm5Dh3eIWApKXl
         a5BWJF0v6Q2RSrvwDRfVK+BhNl37jwdmeUDwvpQ8UW8kY8psX+iaaWJyz2UKrurtPQhV
         8BzC7e4j+cIVPerqXV/NnopNsE3BwatuwxStxd050xujE3hszc2n8qIDeRM6I6e3x8Ic
         KsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2y1Hv3tCZYGcTRb07QtKSAGkAr2OsPGTT4mIP90U7VU=;
        b=nLK1rDyigUsw6v6Hq0k2xGlg/NLDWe1Vc7sLYmDC2/tCgDW2mHOj3/d5hGwM/ym3QE
         q5igj9HH/e71aRANtpo/v0mNFu7dumdqILhB5nXo5v3n56OXEqQFmdCX8prP9pzQzJ45
         txcJct7+qT7caaX2nXbpF7ZOnfk3DooGsBmH9Ih3pcT+rq5F+GKG7THio6xFZ01PSD6n
         Na8Ye7mmdK5PUyDryvTnIAuYebpi9n/NsOrtXJNG9kKIvBNSNbzfzOHlBOcKrBi/w5XX
         vmbIcTaMu7/7uyLhD1+UQOPpm9GsUDTnmuk0s2tXSUA7qHuz9RT3b9SDjeakPakP4JPy
         /m5A==
X-Gm-Message-State: AOAM533D2tl6zi7RoZ2zYc2UIs97BtZDciz3JvG+oVZuNJVu1XRy8UCI
        l15X1v0hjLRAd6wQXYdDC4gf7t4CN1n/DSwm
X-Google-Smtp-Source: ABdhPJwxh7Yctu006BL8to50X/3ybQbc+7iIGWhNiuJdjPwZQ4MdTBPnliViXAJfeyFPUyQDzgHlkg==
X-Received: by 2002:a17:902:7149:b0:149:c123:a983 with SMTP id u9-20020a170902714900b00149c123a983mr21549815plm.79.1641607865522;
        Fri, 07 Jan 2022 18:11:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm159756pjj.4.2022.01.07.18.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 18:11:05 -0800 (PST)
Message-ID: <61d8f2b9.1c69fb81.34576.0cbb@mx.google.com>
Date:   Fri, 07 Jan 2022 18:11:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-6-g4551072c8439
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 119 runs,
 1 regressions (v4.4.298-6-g4551072c8439)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 119 runs, 1 regressions (v4.4.298-6-g4551072c=
8439)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-6-g4551072c8439/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-6-g4551072c8439
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4551072c843951bdbdcd13d9f3f2323d65804bd3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d8c148b68fb4d271ef6768

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-6=
-g4551072c8439/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-6=
-g4551072c8439/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d8c148b68fb4d=
271ef676b
        failing since 18 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-07T22:39:49.921597  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2022-01-07T22:39:49.931032  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
