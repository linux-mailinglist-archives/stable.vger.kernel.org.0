Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA054D70EF
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 21:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiCLU4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 15:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiCLU4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 15:56:32 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C941BAF33
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 12:55:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p17so10495660plo.9
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 12:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rp9B23fRQqV3UTsRdyalMw9NmxoEtP92d48UuXQd6OI=;
        b=BjbN32vC8cbyCOrFRXy/Snfom4HG6E/BbiSgwgY6tsGCmH7ApJBW+gLeC4rIz7rE2h
         zmtVrd89NtqGN0uhEl29QHEPsBbwQRe4epz7my9fgCsdkLhv9/zhsMOGFwY/gIT86b6d
         PpMOx5hxqfaaImxORLFHRItFpsEfxFHs8pLMpoojBm2xVFkOYsCDRpcMh63oAtZ/ZeAb
         PS5v8Xq8LmjymV2sMzDwm6R4OKVvy9FwnjhxKZv0M8ljmFSNUYd9Utvfxe0LTMUPEf9p
         B/AUjudSJ1nznZOXlQjvlAzle2bQllDFka6GevVcGy19S8Lr84M7qPMPwW1ewLj4WJeV
         IpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rp9B23fRQqV3UTsRdyalMw9NmxoEtP92d48UuXQd6OI=;
        b=Qwpy2XBGB0sYbSl1bK+no428EnW2U6j3mB0RBvI+XcLOGXDUWEWqO6USA0/+Ej3DtR
         ozPLuFcNDLhGRI93tk2WCKaIscKdkMTtD9/BEhloGvjL4PkpYvL3wAa3xETM7ObZlHAL
         BxnXT92bRXAMrCBQY7lYazx1DkmpNUaA+epXrOTi0xOfWSTmyyK3evDDc4jhGPtiRQdf
         PYIKFaz4/OT0wVnvgGSXlmKQIDGctpwPkek2Pf604kKmfSN3i7MQfiSElKYrhq1Auyq3
         SkQ1nQoUTZoyxTGMhlyWlUxqAAf0+t6ry73jNY//xMOUb+wN2VMmJ1iSz18Gotp0UwK2
         T1rQ==
X-Gm-Message-State: AOAM533nYZu3tAQf1p8d71gsBupc7ccw0YOHVLlIFL6SmTELB8AemSn9
        HzxuyUUzESkhxpeRK/HAc7oX7danznoFFmh0JwI=
X-Google-Smtp-Source: ABdhPJwP0wcXynEqow0n2EdJZoUn7ZDV74+2MAAYUq37GrOZUB+VC8T1je+GPdDz1UDOXynw37hkEw==
X-Received: by 2002:a17:90b:3a81:b0:1c2:bf38:b57a with SMTP id om1-20020a17090b3a8100b001c2bf38b57amr12664270pjb.172.1647118525968;
        Sat, 12 Mar 2022 12:55:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a056a00188f00b004f7675962d5sm12644643pfh.175.2022.03.12.12.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 12:55:25 -0800 (PST)
Message-ID: <622d08bd.1c69fb81.3e428.092e@mx.google.com>
Date:   Sat, 12 Mar 2022 12:55:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.234
Subject: stable-rc/linux-4.19.y baseline: 67 runs, 2 regressions (v4.19.234)
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

stable-rc/linux-4.19.y baseline: 67 runs, 2 regressions (v4.19.234)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beaglebone-black | arm   | lab-cip       | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.234/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.234
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c2c7e4a12c7e274adda3b334d912169c515efe7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beaglebone-black | arm   | lab-cip       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/622cd2fd878360acf9c62971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622cd2fd878360acf9c62=
972
        new failure (last pass: v4.19.232-53-ge227a7bfe445) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622cd12b9046603fd2c6297f

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
34/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622cd12b9046603fd2c629a3
        failing since 6 days (last pass: v4.19.232, first fail: v4.19.232-4=
5-g5da8d73687e7)

    2022-03-12T16:58:11.970536  /lava-5866869/1/../bin/lava-test-case   =

 =20
