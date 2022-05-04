Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDB9519307
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244793AbiEDAyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244789AbiEDAyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:54:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9147818B13
        for <stable@vger.kernel.org>; Tue,  3 May 2022 17:50:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so3407622pjm.1
        for <stable@vger.kernel.org>; Tue, 03 May 2022 17:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a7dQdxe4iDCbq8aSQWGuJdu24X8SwjrnMyI2suqEgV0=;
        b=KQrjUg+LJG+cpTmVBa908y03ng4U9M9Dy/jU8yjuCpW2H9rZliFRoYauaXg/EejKb9
         ZEQ83sSpBEEmffb04AsqLsg4wBQoSqwtsntGJ4Qitc28QiF12YRA0jsG59jwbuwmk072
         wpZJaS3V72kEOMgWdm5NEMCxB9AciGXuhhfwvVOWk7NZrBj++jnlzyxh7mLuBua5ysoc
         jDoI0duh84gOmnio00PnghSRRIMK2jekaguWbap8oS8nXIw1m2LIwX7fIP5FZ+t4UIBA
         GuFvFjY2HQOcvc46qFytoahgArLPMzOoBFR69cZeCAsNS1IkklVclz0ylNyigYW2XLaM
         BUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a7dQdxe4iDCbq8aSQWGuJdu24X8SwjrnMyI2suqEgV0=;
        b=xHKz499cOTI0YbQwNHj15zeiAL02sk55lunaJRhaadedXrkHH4KjERUuxm3Y15GHMJ
         hy3dZ4uhxXOYbll1CEJuk0SQQ2bvxkk1+XwMVAfNPDc1/NM3IJ+gr65Ob4f59tk+4Dzz
         ExGtt/nDCVrzI9qMaGyQlbnFF+mLJYpXb/iMxYRWvJO0OXcnjLJX2beHdanAyFzLVh74
         SbOuDVEjLDQcET9Kf6igd87wjVQrYK0lNQ0UPw4eY+k0eDHnZsFrEa8MA3ILNlKyoz7h
         WduH1KY/qaHAWf5d4ohRh0JSFYfxd0crDlICs3+i5dBkzObbd2HsyOK6bxa3VGG3fFUb
         nSkQ==
X-Gm-Message-State: AOAM531uR/KOWcsM2evffECTRKrsSNIxg74x1efem5WWBFkNiLTkppMc
        IfPcRiMyRPQ2q/X3nYPSvuCnlADRjlb8+h6trxA=
X-Google-Smtp-Source: ABdhPJyaIUYA1uRfcaNBlFQRVtWHE2b2tuH7RADHBLyg26nudexvaeRU/5OfZG1+RI+2ZQj/37KvMg==
X-Received: by 2002:a17:90b:2241:b0:1d2:54b2:64b2 with SMTP id hk1-20020a17090b224100b001d254b264b2mr7634485pjb.225.1651625428001;
        Tue, 03 May 2022 17:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bj9-20020a170902850900b0015eafc485c8sm3254677plb.289.2022.05.03.17.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 17:50:27 -0700 (PDT)
Message-ID: <6271cdd3.1c69fb81.a6f16.7ff5@mx.google.com>
Date:   Tue, 03 May 2022 17:50:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.241-57-g4b8ced4f49e7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 82 runs,
 1 regressions (v4.19.241-57-g4b8ced4f49e7)
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

stable-rc/queue/4.19 baseline: 82 runs, 1 regressions (v4.19.241-57-g4b8ced=
4f49e7)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.241-57-g4b8ced4f49e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.241-57-g4b8ced4f49e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b8ced4f49e787248a53d4863bfce9175fa4ebca =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62713d964e94c8c295dc7b3e

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-57-g4b8ced4f49e7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.241=
-57-g4b8ced4f49e7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62713d964e94c8c295dc7b64
        failing since 58 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-05-03T14:34:44.025885  <8>[   35.908401] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-03T14:34:45.041727  /lava-6250575/1/../bin/lava-test-case   =

 =20
