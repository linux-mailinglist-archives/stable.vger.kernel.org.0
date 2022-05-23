Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44559531E5B
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiEWWIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiEWWIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:08:55 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51914BA553
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:08:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y199so14833002pfb.9
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6GbvHymtX/1alsi+DaAAQHNBPcS27X8ZzN2v92z4ySI=;
        b=k15uEw/GhvhoSdm9tjxLMgMv17GgcLAxTSv55ynbISrcHuBKf4KKOF1O+T1c/jijDW
         VkyCqjdn26oN3nFKw856t0z/RqNj5FMXjYyYOQk7ZC2OflGhhth3KZKpEjUb5zgDUgjm
         Sy8ueKG89VJevSruSxCl8ok+fzcOyyEZaC0DIGJGSld9/a/LOPZLxDoBa+DXmn0YYgAn
         C0Dvt6dlI/G8IyAe7GdDPYj6RIRkgrY+MIBB8ZbVqmiK9Um7Ghruu5/cnPj3HbWzeQ8t
         PEPAdO+sgIriQWpka9I2GaSeh4biv1Wcuuj/SePhXIlVm5eOuxnxgWvKYOmzufJ6GFoY
         xxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6GbvHymtX/1alsi+DaAAQHNBPcS27X8ZzN2v92z4ySI=;
        b=vRZsTB1+b8xBm6pjKV/tr6//hHbEhFsYp6IXolOp/3bdC1BbbPSevEsDIzMsgWfJaJ
         roAmKh46zI2lL40RtLULphmA/7QpDAhxGVCU3P7iFfLewOhSJj5O+AeKBHNRT7lRsWvh
         7mQgle38N8D3PtiDj+oWgeDxHkkEjyu7pD3Fm8ihhMwFBc097AY2XklaMBy+9vF1TT4L
         GKcuWIAxHSiG4GHPIZMvMaQFW0isHGkEQq1qI/i1qYdHYcUdH4mU8KFtGoqfK0dqeLK/
         gND5svexodKiN9rtbVQkzRtJh7PUeos70IdWwCOz29P7I/P+6yuFIjL1juzeIGIdAT1l
         Xstg==
X-Gm-Message-State: AOAM530VxAFU52YW3lpnO4Du9xBAwF7uUY2qvhQJ73+/goEHkzqvjf/p
        nj/pmwIIQ4DIu+pa57/Mx1suWViyYli0SuEIjgQ=
X-Google-Smtp-Source: ABdhPJwFH8G0UhKX8idlThcb2uZsPmfk71/i32QClMUbJxbhhfkl7H0Zh6N6UFNS6d+bTjBOYR5xYQ==
X-Received: by 2002:a63:a07:0:b0:3f2:4f47:810a with SMTP id 7-20020a630a07000000b003f24f47810amr21505849pgk.265.1653343733601;
        Mon, 23 May 2022 15:08:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n24-20020a170902969800b0015e8d4eb2e0sm5617125plp.298.2022.05.23.15.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 15:08:53 -0700 (PDT)
Message-ID: <628c05f5.1c69fb81.a31d1.d848@mx.google.com>
Date:   Mon, 23 May 2022 15:08:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41-133-g03faf123d8c8
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 143 runs,
 3 regressions (v5.15.41-133-g03faf123d8c8)
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

stable-rc/linux-5.15.y baseline: 143 runs, 3 regressions (v5.15.41-133-g03f=
af123d8c8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.41-133-g03faf123d8c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.41-133-g03faf123d8c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03faf123d8c854ca0eafbd28c2b2f11e2a3de61f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628bd7717e69f29188a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bd7717e69f29188a39=
be2
        new failure (last pass: v5.15.40) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/628bd694f3e53c154ca39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bd694f3e53c154ca39=
bee
        new failure (last pass: v5.15.40) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628bd6c1f3188c9b00a39bf5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
1-133-g03faf123d8c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628bd6c1f3188c9b00a39c17
        failing since 76 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-23T18:47:15.642030  <8>[   59.888832] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-23T18:47:16.662080  /lava-6449471/1/../bin/lava-test-case
    2022-05-23T18:47:16.673824  <8>[   60.921758] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
