Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20B4510DC1
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 03:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354034AbiD0BOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 21:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiD0BOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 21:14:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2A148395
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 18:11:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b12so295623plg.4
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 18:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=emRnDwMTzXsgZrQ5BIiu3vFvxy0fCeNFd5w0YEKTuno=;
        b=Smmng8uvWxPeOFesIOsXo/ltGOKtL7i5I/Cj8msT5DPjKOuLThUCxQh7rppirhPZIF
         reQPcki1iN9rp85Em7fx/YHXCi0WZp+fO+omnTH1FEH1GAOeGNezhiutaMAhyxbj1ONC
         ChBR2d+TgHp7OyEypM9w5/gSeEkrpTjJwzYXVUD7UI9nXmp6QQbZW8MJuMBTjSVU7JTq
         ZNjXjmJ/C9ACjsihEIdbMafU6b/nEBXoltkbs0b326VgptiG9utc6e//D9KlBArnCs1z
         pxRyjfFHZEpj1mjOgFkqRR1zPJvYCVFErW6N1GfJLr/ZLFwTfH/wjEY1smjIDZsXaFpj
         XESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=emRnDwMTzXsgZrQ5BIiu3vFvxy0fCeNFd5w0YEKTuno=;
        b=J/GP7JTcbd5b0p31bxptI3srprD0FMUfR2ST7WhkcjkmwS1Yk9rnpePMrgp+vs2eg/
         fsTOV1g2QTCW253nhtAwqnBUiuisCTH3h3XWZA0Z+C4VNWfJPxoGCcSF4mMnEyUPmVBw
         ZGDK5t0hZ0kgmJLEV5vK7V8gTl1Dlhwt5DnWbgDsdRGoUP9TD8d2bqLkmjoXp5M5JvIN
         knK+bqhdgX/FGy6qKOnjeClQciWfOXfUVjAjRqKQwpOpZMZ1Z6yz2VXSrafsDdxE8055
         Wbc9JKTf0+FsutEpu7yI60W4eOmVhRtpgGg19nSx6GHjJsO4bi1UG5c1OZqwR6Mn0xAf
         YBVw==
X-Gm-Message-State: AOAM533BuIXo2KFFjKvWvY1lCysmwEFWpcGTG2yOe0TvSHPWFnF7nPsO
        /J0x9ldBTYIW1ykGuzOCEcxjB110j0NFU9UXAAM=
X-Google-Smtp-Source: ABdhPJw0/+fCiwoLPgcCtOm6Ll5KOiS7xEgpmYFa3/zTkiAfenjCpA14632xeeNgFAyD/Uqe03lO7A==
X-Received: by 2002:a17:902:f2ca:b0:15d:180d:704 with SMTP id h10-20020a170902f2ca00b0015d180d0704mr12530908plc.102.1651021899466;
        Tue, 26 Apr 2022 18:11:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm13730752pgf.66.2022.04.26.18.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:11:39 -0700 (PDT)
Message-ID: <6268984b.1c69fb81.4f18c.1df2@mx.google.com>
Date:   Tue, 26 Apr 2022 18:11:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-125-gba92a7feb8d6c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 120 runs,
 2 regressions (v5.15.35-125-gba92a7feb8d6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 120 runs, 2 regressions (v5.15.35-125-gba9=
2a7feb8d6c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.35-125-gba92a7feb8d6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.35-125-gba92a7feb8d6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba92a7feb8d6c5f9baf0f85bd8b1a0e4ee2833c0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6268685272b5cb281aff945c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5-125-gba92a7feb8d6c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5-125-gba92a7feb8d6c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6268685272b5cb281aff9=
45d
        failing since 96 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6268671e0e3bfd2b06ff951a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5-125-gba92a7feb8d6c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
5-125-gba92a7feb8d6c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6268671e0e3bfd2b06ff9540
        failing since 50 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-04-26T21:41:22.716322  /lava-6183399/1/../bin/lava-test-case
    2022-04-26T21:41:22.728246  <8>[   33.617687] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
