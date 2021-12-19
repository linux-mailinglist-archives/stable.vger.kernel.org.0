Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2E247A24E
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 22:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhLSVZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 16:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhLSVZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 16:25:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F499C061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:25:57 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso10976588pjf.3
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KGZPgjsOHG3WThKgpE0MIGgzLqb2u4wm3WdhuV8b6wU=;
        b=4/fh8nNvspL9QuBSp9RddpKA7s1wnjmlLA/W0JNkGlXDhjsNr1hqTRREEIupItOiXX
         2KdB2rF0FqJWDyTQtuhVj0MN4D8e5B/TguSZkmTBo6Cfp8QmJWPU51WxOBOcoEy1RLAW
         YO2MyrfO977z+DBRhSGpjlEiuqsOxmloKByngiaAlR7Ox3ogua3p58o/QjrKi2SuYdL6
         xmQhEA4aU89Smord0Q6m/HVaozWtKKW4qgeu5pLVALHblTgAXmgUkSWfMY0SvBHktAcQ
         WigO+Y1iFf9FABjkVTD8j3WrMHmS/MEHXjI3m0cc9SHhU9ieCOx5xF3xcLF+BGhwdJoy
         8y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KGZPgjsOHG3WThKgpE0MIGgzLqb2u4wm3WdhuV8b6wU=;
        b=jr0ULcXrFJpt+DwNCezZlp+hJQqDCQKfiEayNoVSFitQouGSqOQEs4DUi6rST6roMT
         2PzGmgC5cCs8erwmtVWI2kj6BbeVBnqeYhVCkJv3Gd1ktmcKaSsUNfO2B3s28ffKwbgb
         bIrt+WJulY12YcxMQPNbo8hkgtrR4L69T506fihxAlQLCxnbA/EFfGSXsOvtxjyjKV5s
         d/jTVuEl4sB5B0vexa3nzRcRwmBfhIY6sAPL7D+HCLZCe6qeOh3q2ZTVncLp58gslNN2
         nUj+ehXKzC6eI0vb/HL4nxqvZ2r2T1t8CZVWTuQEElHVbRYV3N2c4BiS1GqgW3M9/hDF
         tWOQ==
X-Gm-Message-State: AOAM532OQ2THbBwajqPjOhhQBRKseci02xHrxoCnzZUPmu+xB2YccTZE
        1Q9MOztWgFS3d2WZmQoOok2RSQCtBXbRfgDF
X-Google-Smtp-Source: ABdhPJxDKd53eckTbBECuawbmQTuMf2rgc19Xw3MZOy0b6LWeAIhYONb1WTsugKaZDU5vAA9n9OkZA==
X-Received: by 2002:a17:902:c214:b0:148:ce1e:e94c with SMTP id 20-20020a170902c21400b00148ce1ee94cmr13731711pll.121.1639949156662;
        Sun, 19 Dec 2021 13:25:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u32sm17569591pfg.220.2021.12.19.13.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 13:25:56 -0800 (PST)
Message-ID: <61bfa364.1c69fb81.b5071.f71d@mx.google.com>
Date:   Sun, 19 Dec 2021 13:25:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-29-g058525734897
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 157 runs,
 1 regressions (v4.19.221-29-g058525734897)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 157 runs, 1 regressions (v4.19.221-29-g05852=
5734897)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-29-g058525734897/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-29-g058525734897
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      058525734897b7de7f3cc812c82075b2f51a09f0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bf6aefa29686a15d39711e

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-29-g058525734897/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-29-g058525734897/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bf6aefa29686a=
15d397121
        failing since 2 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-19T17:24:53.016980  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-19T17:24:53.026229  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
