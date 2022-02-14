Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE324B5831
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356918AbiBNRLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 12:11:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiBNRLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:11:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE7B6517B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:11:04 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso19454985pjt.4
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=05kwEUCUyswxwUU5UNxIaNUJXVdCDCWKsQ4ZHlM0MCQ=;
        b=4rbqdfDaMgVlHeOmzjXnrSdniVjvJhwHNX/ANmvEbHCr9YFiKG7jJuDGMMYXyfn7Yz
         ZuQzjiFjkZfbUXSu0/KmvMfLxAUu2cbOorLMuif5WcfZWDxpMbv8ghCF/SLFTuzbPMkE
         H8jcwds5C+uo6TzqMtZfyRCA32MVMVdQ9TxTCw22tbXGYmtmPm/eWFzuFqIyJfdRIT4E
         VuDy86v/DncMYxrji6nE36o4R0brGIJvO1EAaDmaObnbRuh3U3Lo+6HUXUbcSmu2PNiG
         wCEso7IEh/WdXyhgjXnL4izQbzm9nnHkuIoBcnkO+xde/Yht2k8V+Mkc2jh/658AYK1c
         fBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=05kwEUCUyswxwUU5UNxIaNUJXVdCDCWKsQ4ZHlM0MCQ=;
        b=i3kR988gDldMG/SpH1nGAD4gM2UCNmXTJ1yyVT2IoIxc19MmWmcliOyL3v+7nbjRC1
         +ws/rW81MFMRGs8qWEajff8H0ofNrVnbJOXBzdJ0TkIyHjDRSJABIutKKgRZTnm4Gt5E
         COKlO2X0DpbR1QdGgV72gMafWpFTBhJg59wxBhTMQ0fM7tHftyiR17bYO73Q4TrUT5aj
         sjLhRRAQMZD1nv0ybCKjgVWaTze/yNKJERHNWSFrVf6DwDhRpmgWo8tBh4rFi07Qcb8y
         u6+VG40b06SBIMYTRlSuuzvK53W5zYKqRY9FT79TyVvDVOFRXTYIX+jgpOCohHG20ySQ
         79Eg==
X-Gm-Message-State: AOAM532R4UJWmFP5jbNSIJ9nd0xGsQeaBzkdB10v+Lj7fGAQ15WQ26vC
        y61pMaLlbtjwoaeOFreBm/2yyEAlniybCtDQ
X-Google-Smtp-Source: ABdhPJx2e3CnVw3vsS2ed3DGZ1PLIn0nGPGzLD6BdoDY5NjI8/6D3ke6kYzYVsvedIgRU2in8jUvGQ==
X-Received: by 2002:a17:903:1246:: with SMTP id u6mr597683plh.101.1644858664028;
        Mon, 14 Feb 2022 09:11:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm36261940pfm.27.2022.02.14.09.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:11:03 -0800 (PST)
Message-ID: <620a8d27.1c69fb81.a753f.9d32@mx.google.com>
Date:   Mon, 14 Feb 2022 09:11:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.23-173-g2092ea833107
Subject: stable-rc/linux-5.15.y baseline: 108 runs,
 9 regressions (v5.15.23-173-g2092ea833107)
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

stable-rc/linux-5.15.y baseline: 108 runs, 9 regressions (v5.15.23-173-g209=
2ea833107)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

r8a77950-salvator-x        | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.23-173-g2092ea833107/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.23-173-g2092ea833107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2092ea8331071900a0b3ed6ce06daae663215b92 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a518552e696f607c629a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a518552e696f607c62=
9a2
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a518552e696f607c629a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a518552e696f607c62=
9a5
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a518752e696f607c629ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a518752e696f607c62=
9bb
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a518752e696f607c629bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a518752e696f607c62=
9be
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a5188204f49560dc62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a5188204f49560dc62=
976
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a517252e696f607c62972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a517252e696f607c62=
973
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a5186204f49560dc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a5186204f49560dc62=
96b
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a518652e696f607c629a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a518652e696f607c62=
9aa
        failing since 4 days (last pass: v5.15.21-112-g0472630a5621, first =
fail: v5.15.21-118-g722769939d60) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
r8a77950-salvator-x        | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a52aa7df7859529c62974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
3-173-g2092ea833107/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a52aa7df7859529c62=
975
        new failure (last pass: v5.15.21-118-g722769939d60) =

 =20
