Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE045342F0
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 20:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiEYSYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 14:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiEYSYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 14:24:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0498CAE260
        for <stable@vger.kernel.org>; Wed, 25 May 2022 11:24:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cv10so3764730pjb.4
        for <stable@vger.kernel.org>; Wed, 25 May 2022 11:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zkd3hpAzMRJdeo/Wu4m3/uol9F/TerZbqOICQj5Rt0g=;
        b=PAKAXwnfkBs44SR0PKzo/Jh9buBE2Qw0Ur2/b0SSL17OOHyedgB9pM29tCkKam9VRQ
         CHQXDy6A/efuPf48kEtBYF2bIQxDvMwtWN09abWmigUu8EprBK637Pi5iUZITP07HmYj
         g54BsABguxTF6Q1EX0lvB65IaxWDDFgOXeHnHryGj2tni2NEgETTOSgr6Qf82H49iuqM
         mCymjZtW9Gt3fRfKWtrwfwnQmN8p+R/K+lNha6bdxGpso3OZO1i4Ppb2g+0V7TnCZ9lM
         95GJpji5UNS1iKCN9zcH6NeHwHIA+yj1dCkZX9UwmHQdr9Io8MO9kMYrnonsEXVvUrRB
         G9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zkd3hpAzMRJdeo/Wu4m3/uol9F/TerZbqOICQj5Rt0g=;
        b=OgcdScpNLXxWs/aMfkwGJ/Q/Oz58J6gJDZTgJe2wAdJFY2ugjcsc2RHZes0L9i5eb5
         QBLpPxEJxSQBCmr+HjHnezSVoG82hFVD47Hs6up3pt6X3RpaV6bEDsL+ft43SD1VuOam
         llfTsNUdXscqTHiW3W96lij14GJpHXKDsoWNiyGcOTlvyFspTYgW6EUqfc7oI7Vuspa0
         BpmgvLtMWej3dcijG60+2IHdwWNMuBuW8v9XJo9mQvZ0OUHFVG8dD+oirs6xXnJUFihX
         XBUiJPBJrbgythaQJ9eVwmtIELGzNsC0DZa92YUM/81KBvm/IFL6kNA3mpTnH6lHon/g
         m97A==
X-Gm-Message-State: AOAM531owRZvGWOL52wdCS51HilXIm6+BR70gMuxU52WnDjwCC/jZgpT
        3PLUCW3m5BvzaRWSNb9HuWBtu5shT8SG5wp8NJU=
X-Google-Smtp-Source: ABdhPJzA/PwvmQjfTfLcdpYEWL1aNXkv3PjzsgwgniDlMAq6KbeD/AEXZyqmyzaTw6bNwOMt/BbgeQ==
X-Received: by 2002:a17:90b:3e8b:b0:1e0:582d:fc23 with SMTP id rj11-20020a17090b3e8b00b001e0582dfc23mr11909478pjb.228.1653503078381;
        Wed, 25 May 2022 11:24:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b001618b4d86b3sm9829680plx.180.2022.05.25.11.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 11:24:37 -0700 (PDT)
Message-ID: <628e7465.1c69fb81.ce92b.7491@mx.google.com>
Date:   Wed, 25 May 2022 11:24:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 117 runs, 3 regressions (v5.15.43)
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

stable/linux-5.15.y baseline: 117 runs, 3 regressions (v5.15.43)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.43/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0e5bb338bf471ec46924f744c4301751bab8793a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628e4421ca7b983367a39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e4421ca7b983367a39=
c03
        failing since 0 day (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628e40c304c41c111ea39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e40c304c41c111ea39=
bcf
        failing since 0 day (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628e48a867e72607a7a39bd3

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.43/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628e48a867e72607a7a39bf5
        failing since 77 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-25T15:17:42.492931  /lava-6467809/1/../bin/lava-test-case
    2022-05-25T15:17:42.503841  <8>[   33.880126] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
