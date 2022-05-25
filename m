Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85085345CD
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 23:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiEYVeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 17:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiEYVeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 17:34:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD83CA76DD
        for <stable@vger.kernel.org>; Wed, 25 May 2022 14:34:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a17so3613152plb.4
        for <stable@vger.kernel.org>; Wed, 25 May 2022 14:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PMRIilZdJsT5Ei6kew27hcMAbgsGGuFxcHZAtTzWEJc=;
        b=5tIP9rEljFtaWT9mSdDNGetxAbVAS2iAcTZdiQNPjKVx/HO/JsUp21uqDq1XmOzTNO
         389BktHb91OVaEvMfDygdOCOG0RZ+QSzJGET2BMwKeCjvMPID+zLIvX6MAT9M/w1QAz/
         c+z0sTj+lJhmd9tSwLNS+zxfZ6WiYkqFs/ZmH2pRRsyvPAAvSo8lO7PAhtUwBcd5rgUO
         pN4jGm5h96XdKNAuVsq0cXOVlX7iacnE7gyKrbmzK6iFC9977Gx+am7MPXKGNj5XnurT
         kbQlb+K66yk2fPtJCYssXanAOrn6uRCgWpb+ZnG2VsuWeS0dPkeow3pfZbqArSsi04E7
         niZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PMRIilZdJsT5Ei6kew27hcMAbgsGGuFxcHZAtTzWEJc=;
        b=Rph8KnwuoFTlBMSVT+2Tqrxpq3qNvTCHay5tiUkln7+lgeox9sNIL1CQffcriKBSww
         RZ+uOXS8jTs/anpnotkPGW6/7/CfwUq+Esrqj3GaVCivjFOPfOCK+r20Xi4GKzLKpq6y
         Z4gsiNFtso3LyslYWblwNaMY9BxNok+Ib/pU8wEo7Co1aFzxom+BNkIdSTwEESWi+pRo
         igR076UjokMWaDqnzn9n3JCqeJlR6yg0JAIOILK6KVXLE50TWzTgy5FfHwMjnTX0xzQ7
         ft1qLgTO4fPdL3INRuFtX7LaoMw3zuUpy3NzaFwY1GGyvjrDuOy+AEVj2rswcUZTGtvy
         3z4A==
X-Gm-Message-State: AOAM533bhcYB1ZLGXS3Kw1FSlTM0It6yEBxkg2NB6HYrU+dLSSxW9+Pu
        h2XwfcPAKhLL4X38wCKTE+YXgggCsIIHJe0qtv8=
X-Google-Smtp-Source: ABdhPJydfnyV3oBt1I8YzW22R+eiuVJyZA1jj8KdTCj/RrlKJUrVnIhzJiz5EbCQ7i88heT0JJgOTQ==
X-Received: by 2002:a17:902:a585:b0:14d:58ef:65 with SMTP id az5-20020a170902a58500b0014d58ef0065mr34259475plb.139.1653514449064;
        Wed, 25 May 2022 14:34:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13-20020aa7864d000000b0051829b1595dsm11922849pfo.130.2022.05.25.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 14:34:08 -0700 (PDT)
Message-ID: <628ea0d0.1c69fb81.51da8.cd53@mx.google.com>
Date:   Wed, 25 May 2022 14:34:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.196-1-g39a93474bb1f5
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 88 runs,
 4 regressions (v5.4.196-1-g39a93474bb1f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 88 runs, 4 regressions (v5.4.196-1-g39a93474b=
b1f5)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.196-1-g39a93474bb1f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.196-1-g39a93474bb1f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39a93474bb1f5429c879ec2f92bcc7d7bcd69eb5 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/628e71507a07c2c235a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e71507a07c2c235a39=
bdf
        failing since 15 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/628e7178ccf4cb325ba39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e7178ccf4cb325ba39=
bd7
        failing since 15 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/628e71a0e95bce5139a39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e71a0e95bce5139a39=
bd7
        failing since 15 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/628e718cc5043c13aca39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.196-1=
-g39a93474bb1f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e718cc5043c13aca39=
bee
        failing since 15 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
