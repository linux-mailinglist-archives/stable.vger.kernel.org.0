Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AFB49764C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 00:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbiAWXQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 18:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiAWXQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 18:16:34 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441DEC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:16:34 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 133so13604819pgb.0
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 15:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HlpEcUY9056aWHm3N8Fa/Q4ddyF51q5bfVsEg/ZMDGo=;
        b=uaLZ65FROKmGcahZD1eeFmpYd54UDp5WlaLQP2SoG2PHpfkzi0BD/KPhiVZ7Om6lXn
         gSSnVUvWqi1Eko71Hma81FZplMCiAcQjucRJmI6jCucQXtRfy4v1bW8EF3vhY5SjGTql
         YFatbpVQBVxFF3gq55kg2ye5sIZCC90A+EcpcDAvUeG8sVS22o4YKba2z+4uhi5Lz0Vk
         ueAHFZANxvX0aLFjw0mBFm0QmCe7kjeiuNwp9UGfkNZCPhqOOz8CGQRiO4Aup5u1rcLP
         TgO8XBuNFsMbFisCAUcQG7WOADQ9THNUY2AIYJddXc16cm65XoO0EztOITAkrmcYtTLi
         YD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HlpEcUY9056aWHm3N8Fa/Q4ddyF51q5bfVsEg/ZMDGo=;
        b=SkSMpsKVpTvZmvJHHFttpyu06FRz4+5ooIugbrKDe7Gj9Dyuxdqd0ecrEg6tmyECKk
         uaJL7WKYBCGEmmPb0lTNnzUEnGx0beOae+iR6MW7z8sZrlIi40ldp0pRTeTMWvLmOmaY
         UGEOvmDQV7Nu7Xq36w6iURglxokxJXOsHe7nbzM++nbDyOzaCIzWKQCFb1mdFLjjqyQW
         zcamGEciIuvI0fDuJTX8sHLPYO8p+kuNw8mVxvsn3ze5XyGth7480JjHmUJxfc6bwGAp
         AqTce4hjevDa9ru2Ohbo0npA3RKSMzOeTn45VlbzURyHlvlARWMRNxauRkGRYwXcLw9C
         nUng==
X-Gm-Message-State: AOAM531Fp8f+Zuz6xf0pRp4gzSeN4ViNmXqim1pFgvp2Toaqm/nD2/NJ
        eO/4ShC3PoBkCwy6I7ssnN97CclBQYEjqU3k
X-Google-Smtp-Source: ABdhPJwYcDHjKXiPTXTY2Hw9rKjw2ODfkve9oRphMGjVk+pqzcto+eyXeRPRgIUkqxilwShmgGzKEw==
X-Received: by 2002:a63:1b4c:: with SMTP id b12mr9914818pgm.281.1642979793560;
        Sun, 23 Jan 2022 15:16:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o7sm12359500pfk.184.2022.01.23.15.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 15:16:33 -0800 (PST)
Message-ID: <61ede1d1.1c69fb81.d0fe6.2a91@mx.google.com>
Date:   Sun, 23 Jan 2022 15:16:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-153-g395d30f2bc10
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 2 regressions (v4.14.262-153-g395d30f2bc10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 2 regressions (v4.14.262-153-g395d=
30f2bc10)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-153-g395d30f2bc10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-153-g395d30f2bc10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      395d30f2bc10fa8642006b35f3c0909de5f5b3e1 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61edad6e768b36c1feabbd42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-153-g395d30f2bc10/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-153-g395d30f2bc10/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61edad6e768b36c1feabb=
d43
        new failure (last pass: v4.14.262-147-gb3631a790bdc) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61eda8bc9d975734baabbd11

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-153-g395d30f2bc10/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-153-g395d30f2bc10/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eda8bc9d97573=
4baabbd17
        new failure (last pass: v4.14.262-15-g1464c5d2671d)
        2 lines

    2022-01-23T19:12:43.015851  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-01-23T19:12:43.025418  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
