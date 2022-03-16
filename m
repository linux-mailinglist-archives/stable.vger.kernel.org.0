Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2446B4DB502
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245478AbiCPPh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbiCPPh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:37:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851FC6D1A6
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:36:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s11so4222199pfu.13
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M1t46yOHmtMQuV0IpWXR9hT4kXlxwb4CaiXB/2wmOSY=;
        b=d0PitMFGERjCxbhijxghM642nVWNTJSeeT/5vA69eUTAYAJQn4KH14Sc+8nFLyfBq1
         FaUoS/sXDOE/xWnJScIF4wEkw1MN1Ee2GnDTi8S5J2/Sk+xMqgtpgqD1fsb/TB/jIJpZ
         z5gUO3WzbFKt4tj/037Q4KPEn3Tr0OSino+dASIgo11gVlV5+UsPQo460dKSwBY2CzBx
         2tZeRaSpdRdKG4+kuSwCR/rUFSzFSFuli1xOJnkfjOBoKVM1SnM2K49qp/0cDHygt+I6
         I5fugAqwxTdF/qUIXc2sOwWhQtOL5pPvVdVqsGtuEu+IlTuTpTjvb1H3YpLKor7aczZV
         VPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M1t46yOHmtMQuV0IpWXR9hT4kXlxwb4CaiXB/2wmOSY=;
        b=6BeP0uzCC09JgslMIFKa5bU4S9WAjYJJNrDyYItWXSmR9BKdXbmzstgn6nespxIirK
         4rxHFeOrwKBSCYYwO3GoCPJLjA4dMHoya2eDXGJvNitaSdi0AdshwpQHhui772FP69fq
         2CVwqD3w+4elspZNFiLjSK7+2UDFIntGru/7EW0uJcTnyiHkpOhK0SzTpiprN9m/y02N
         6xS39iMHNoBVUEuHkOpW7TgSmqBN5HyJYaqmhODwFTnWFmCrATcy32Y8uBmxcfbfOKIZ
         1ZR9YqTOwiMN8F9DjEI0DbBbq8DSKjXESGSWKwsdcAz6b4bhHLlHLgR3/FQz5CXo294L
         GQvg==
X-Gm-Message-State: AOAM531b7CCbgLeSzERDzjMy0GSNW8/DRw3Um5zZj39AYZ9JULxiFUkq
        LxmlOwCsaBOOLMl+WzIuM1rPLTqGEC9JpU7L6xQ=
X-Google-Smtp-Source: ABdhPJwiCUHgVhs+cCVPZ8DDmzE5XPFHQs/sZ4cCiLRokXjK5sniX1bCu1XanT1cOjYor2BAKXlyAw==
X-Received: by 2002:a63:f648:0:b0:380:a9f7:2189 with SMTP id u8-20020a63f648000000b00380a9f72189mr123787pgj.305.1647444973885;
        Wed, 16 Mar 2022 08:36:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm4183525pfl.141.2022.03.16.08.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:36:13 -0700 (PDT)
Message-ID: <623203ed.1c69fb81.8c0f9.9450@mx.google.com>
Date:   Wed, 16 Mar 2022 08:36:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.234-26-gcb61a50ab367
Subject: stable-rc/queue/4.19 baseline: 67 runs,
 3 regressions (v4.19.234-26-gcb61a50ab367)
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

stable-rc/queue/4.19 baseline: 67 runs, 3 regressions (v4.19.234-26-gcb61a5=
0ab367)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
da850-lcdk       | arm   | lab-baylibre  | gcc-10   | davinci_all_defconfig=
      | 2          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.234-26-gcb61a50ab367/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.234-26-gcb61a50ab367
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb61a50ab3670cfd1e473a2ffc4654f59d3103a4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
da850-lcdk       | arm   | lab-baylibre  | gcc-10   | davinci_all_defconfig=
      | 2          =


  Details:     https://kernelci.org/test/plan/id/6231c9d461467a5a84c629b0

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-26-gcb61a50ab367/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-26-gcb61a50ab367/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6231c9d461467a5=
a84c629b4
        new failure (last pass: v4.19.234-29-g655878b7b44c)
        6 lines

    2022-03-16T11:28:12.103309  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-03-16T11:28:12.103584  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-16T11:28:12.103754  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-16T11:28:12.103911  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-03-16T11:28:12.104064  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-16T11:28:12.104212  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-16T11:28:12.141748  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6231c9d461467a5=
a84c629b5
        new failure (last pass: v4.19.234-29-g655878b7b44c)
        4 lines

    2022-03-16T11:28:12.277732  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-16T11:28:12.277955  kern  :emerg : flags: 0x0()
    2022-03-16T11:28:12.278121  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-16T11:28:12.278278  kern  :emerg : flags: 0x0()
    2022-03-16T11:28:12.344131  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-03-16T11:28:12.344344  + set +x
    2022-03-16T11:28:12.344509  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1706584_1.5.=
2.4.1>   =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231cfe227c4310a83c62a7b

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-26-gcb61a50ab367/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-26-gcb61a50ab367/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231cfe227c4310a83c62aa1
        failing since 10 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-16T11:54:01.264119  /lava-5890041/1/../bin/lava-test-case<8>[  =
 35.433775] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>   =

 =20
