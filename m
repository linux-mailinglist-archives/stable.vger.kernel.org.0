Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A763493300
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 03:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350613AbiASCiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 21:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348799AbiASCiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 21:38:10 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514F1C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 18:38:10 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x83so1204826pfc.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 18:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=54DkpHqQCoitHdo1pYxLscuvlWrpHKeT473c5DubO0I=;
        b=4NtItnidmnrv1ZYjVhlbABQpZT3kqLuAZN2P1FgMqoxbG96R6IID4Fwc1l0JkKMot1
         Y0aG1ER3sRJ24hmZrg5e4fpksG+MYANlcXUBh7+SWGwxbj8aNCRGAhWoZ49+NcZAVgOo
         +VUd+WuwOyFuWomDAXOwVO6jK1PuHPGKojSpdSQwwtNInqiRNI/p9Ns42GJu8cuNhfNa
         TdyXzCyuXtgxkzanyNFcP/uu8sZF2TAsAQaI3sfALDjAcLmZdGBJ069tqeXRGs6zctWk
         WNQ48IyBfvxLRnk6M2ztR5Xf4m2+mXaGlsSYyYgX3TJJ43Zlukp0r9u7HTRjrsqZ7yL6
         Z4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=54DkpHqQCoitHdo1pYxLscuvlWrpHKeT473c5DubO0I=;
        b=buS2+k4OWeKsp/O2rCcRolc88Bp1amOGHgSD0oojI+FFHPrckjkRs0QwFQEKX6zKnb
         7bA8L5bnKKFrSVmUN0pu+aOG2H3j6GTr48af985aGGkjadoMBT1OZqg2c43ysDx/i+BR
         +WDSd6oBHD+4FYZrgj1o7vua+dzFa/PPcfhdbWI0Rnwyo2rdDDPDefh1hjo+uYZZqK0+
         lHXi/KqqDfZX6dU6m/GkaEJFAYcUIbWjiEnyJF/rIJlVZeGEZ2LMLu+GqFYJytdIoCzt
         ntcz1u4kdWzQzDST/nnUv+fEP4A5VQC6ZBtIpU6wG3/SICBrYvx+nMuwGocWiiFEnPd1
         QFYQ==
X-Gm-Message-State: AOAM533HJmXbYZUWA8QJ61yQ6xBHss+gUvML+/fOWQz+cpzgwZHxyTm5
        qRtYjvyWK81PWyDQ4/xmLEEqdsUJpGB0uNq6
X-Google-Smtp-Source: ABdhPJxEOrZeCXZBdcGMMMYttDlFo1oelMogGXlMG+Brpb3u5ffWrurGvcMjrsf22dJ+pV0T7Q6CQQ==
X-Received: by 2002:a63:6c03:: with SMTP id h3mr25597767pgc.458.1642559889708;
        Tue, 18 Jan 2022 18:38:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d7sm12328282pfh.126.2022.01.18.18.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:38:09 -0800 (PST)
Message-ID: <61e77991.1c69fb81.df276.1ff4@mx.google.com>
Date:   Tue, 18 Jan 2022 18:38:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16-66-g0a52f03a4702
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 141 runs,
 2 regressions (v5.16-66-g0a52f03a4702)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 141 runs, 2 regressions (v5.16-66-g0a52f03a4=
702)

Regressions Summary
-------------------

platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
kontron-pitx-imx8m      | arm64 | lab-kontron | gcc-10   | defconfig | 1   =
       =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16-66-g0a52f03a4702/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16-66-g0a52f03a4702
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a52f03a4702a37ecbf2ba4842268bf227c950c7 =



Test Regressions
---------------- =



platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
kontron-pitx-imx8m      | arm64 | lab-kontron | gcc-10   | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61e7426f004c62f42cabbd5d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
g0a52f03a4702/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
g0a52f03a4702/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e7426f004c62f42cabb=
d5e
        new failure (last pass: v5.16-66-gb71cc2d4ec38) =

 =



platform                | arch  | lab         | compiler | defconfig | regr=
essions
------------------------+-------+-------------+----------+-----------+-----=
-------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe  | gcc-10   | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/61e741a2f107364802abbd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
g0a52f03a4702/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16-66-=
g0a52f03a4702/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e741a2f107364802abb=
d2b
        new failure (last pass: v5.16-66-gb71cc2d4ec38) =

 =20
