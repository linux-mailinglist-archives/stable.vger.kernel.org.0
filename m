Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5C0496626
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 21:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiAUUGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 15:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiAUUGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 15:06:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6FDC06173D
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 12:06:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id g9-20020a17090a67c900b001b4f1d71e4fso9983939pjm.4
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 12:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TUGOxN0LvpyHuxVHhSE4WIVB8Nw3IJ7gEpbAEsEQ/TQ=;
        b=ojUMVPyqcKhZSDZLXJWZTfwPdAboVkBifXuOeLPdZ7v0GHj7XMjBPjvKRq7dnrJubQ
         6zqzNFb7fSWUqwRVApLKx+BIsGBEqslYa6W/f8Hmzw6qRvTozKSLlXsTq9+bfIiUn0WG
         JuPrU/yytQV2DHU5TaSmntUiI/j+aRTuLU2wncw4unf107NmmmT/SlBeic1Ik+qDgsZc
         rYhurSFzbqBB1BIN/TIIOlnbEsFeG/aOggj9Y4Sn3pzVI5+ymaihvPGP1eMLIL80Wyz5
         pEhhc6Oel/0P7XpnM12mfjuv0uyTywwS280fVAYYZ72gz8f+xl2SKw/vxvVijWXQ4BeQ
         jsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TUGOxN0LvpyHuxVHhSE4WIVB8Nw3IJ7gEpbAEsEQ/TQ=;
        b=43sBOKJ/547S10lt251cSm827K8IRCViH2F85Tstg77FYa05kAATgu4B4mW4g0f3T+
         nbKDEstyRINI3C2P8ZZMBVOiZAZhoLpbVrc2/atEmPWSCfp271s8doArGIyDwup6qOXD
         KRlhYxerRIfXmZlfo8h0FWNj9/k7gltxNzGOQeOZU3UgEG7r8rWbnlZqLdnJrKJd9k8K
         dYNKRoAPmAVfD9dnlvlfvTojw00CiTDSB5qc4xu8M8qIw7fOrzoKPZlqLtCCGc+hjr1o
         fVVF8L6dq3ekSIc1GXAvcVp2GqvPaBWtNRasDPVdCyuPAh7/r72jOeqQWjIu6HtnOjqU
         dmsw==
X-Gm-Message-State: AOAM5327lAUJ1ygHh8HIhcT1OpsFdNkKDY/vKkKc4aCTwoUakwHBUhDW
        TxUq4NvXcoTpLQLKwARuTPnUQfJw7nEEQXdZ
X-Google-Smtp-Source: ABdhPJxNq9HWDBrzjg6zUYUpXi8A25obTvdClTzhDfuoJux+U7nXpRLjKMRsiQqkbglLBmFO+FtFYw==
X-Received: by 2002:a17:902:b489:b0:14a:4747:9917 with SMTP id y9-20020a170902b48900b0014a47479917mr5099905plr.26.1642795610005;
        Fri, 21 Jan 2022 12:06:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm7592352pfu.160.2022.01.21.12.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 12:06:49 -0800 (PST)
Message-ID: <61eb1259.1c69fb81.e19d4.648b@mx.google.com>
Date:   Fri, 21 Jan 2022 12:06:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-21-g4c83268cc695
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 168 runs,
 1 regressions (v4.19.225-21-g4c83268cc695)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 168 runs, 1 regressions (v4.19.225-21-g4c832=
68cc695)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-21-g4c83268cc695/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-21-g4c83268cc695
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c83268cc69512303abae29e2a3ae90018ca4fa7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eada7fc7d33b4b56abbd24

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g4c83268cc695/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g4c83268cc695/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eada7fc7d33b4=
b56abbd2a
        failing since 9 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-21T16:08:17.711602  <8>[   21.392333] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-21T16:08:17.756978  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-21T16:08:17.766181  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
