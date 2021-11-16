Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAFE453A25
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhKPT3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhKPT3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:29:43 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF736C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:26:45 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u17so44635plg.9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QXIMOa6emC+Il7AiZs3u9BLHYF1gpzIwuhkZy38xQWI=;
        b=0Z+FJKNTQ2V8i2iv1OKoCKwGsJytl7gKiWmeUm5uVMPgJhHsw8hahLFprTQDO517oN
         uO56S7gQOSoAYuJUEUCPGbz1412Fs4igY/NXShHa5LkDxvnScct0FPHoailA632TI5Nb
         rsrShq/wXMRGgaqIiiUALQBUQhMBGh9gGtLPWlgANARlZezBzyPlIB2tJo1konHc8f2/
         E/Ng34kJ0LFSh8Do/nkeD/Gqh0naMkvLUeI52USBHuROHQy+m23BeAJ74c+PzLs8BCAz
         gJjnHvn1QAP3iYjbPJAHx7zXT7M1Rm5T3UKDoWLXY+U5q8aVOIAATEurHCM40/J4uzNC
         8D7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QXIMOa6emC+Il7AiZs3u9BLHYF1gpzIwuhkZy38xQWI=;
        b=H4n9A9pR3Yewgnis7hqajC5rakiVHcUOtq6lHJ3hQZhUJvtQ4jEz7PcU7fpWq8JUdJ
         M9+SoKtgxOmPYft2jka0Gq1qmkzwXmWIUSOxyxdd/ZfG4+N85oQJP7hyof6+8ubOCIdH
         YVCG0aI2Yg0JKG/CDUsiC6eI74NZJuEv1kJaEqfVicX/8f1ujwCXB382HGmCb3sdrGvk
         qHYURkaxtGq5QEIU9zGQn1rKj7wxMtW6HxwlrIR5QFbemhIXU90yTqctSwuzffLKtC0p
         4tzjccT++QSUOEFMgnm2JxQP9kWQrCuF9inuzcNyokfHVgOrZTjA9BIRg1237rnbBpPT
         d5cg==
X-Gm-Message-State: AOAM532OPlnczqodohIcqZ5AMoqsUElSYisWoYLpnAYHdDDZHuKxSXKM
        6tB86DHErAMkpc5Glkfj+ZT9OnkhdA0oMppb
X-Google-Smtp-Source: ABdhPJwq6KHNTFjjjo4Zf1uEOBYf4I9JE3flWah2lCFWqpj2Xr/ZOWsYpEYgvdl0nGASJZt+FOZrqw==
X-Received: by 2002:a17:90b:128d:: with SMTP id fw13mr1825101pjb.50.1637090805171;
        Tue, 16 Nov 2021 11:26:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1sm20515868pfu.31.2021.11.16.11.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 11:26:44 -0800 (PST)
Message-ID: <619405f4.1c69fb81.ec08a.a66e@mx.google.com>
Date:   Tue, 16 Nov 2021 11:26:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-199-g8804eb789518
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 1 regressions (v4.14.255-199-g8804eb789518)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 1 regressions (v4.14.255-199-g8804e=
b789518)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-199-g8804eb789518/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-199-g8804eb789518
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8804eb7895185b1e849798e9e66c3b357fcf7bdb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193cb4e29ae3c080e335908

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g8804eb789518/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g8804eb789518/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193cb4f29ae3c0=
80e33590b
        new failure (last pass: v4.14.255-199-g28b3349e45595)
        2 lines

    2021-11-16T15:16:09.074788  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-16T15:16:09.101280  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-16T15:16:09.110775  [   19.886474] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-16T15:16:09.111033  + set +x   =

 =20
