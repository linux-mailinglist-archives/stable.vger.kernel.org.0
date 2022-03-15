Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C914D9238
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 02:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbiCOBWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 21:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiCOBWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 21:22:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D579C473AC
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:20:58 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso1022686pjc.0
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pnDJi1Zkd3YMjfCb3s9VTudfzkE8IQbc1B+9zft57Ik=;
        b=O00KpH7YN7eBOqHyerK1tJRIHfOO7+S8jhElBWFCBzRiUKdn169bLuI4JHe3F88BiI
         09nPXwTL34A7IfTck6brmxJNbJUohpEY5AfqB0W2z0UcPpQGmE4avvLWllzaDpdULdJI
         24eZKVHQy2zWMtPZopMdSNFWzUdBVUnAtrKtVzwMrtfz3xZo+R3UU5YhA5D754fJ8slk
         RGQeqWjyPiwlZOnWVn/1AbA+B/hK6pvVAItSwOKxBRO7/N1sEgoHKGpwQGZDPQqGbWmb
         gagS4F6HtIqJq2VrL8tr1sQqw2LdbCMyZ6GX04DYZeYwEA86Ku+Nm/w6/atFk14Ys2Zt
         E6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pnDJi1Zkd3YMjfCb3s9VTudfzkE8IQbc1B+9zft57Ik=;
        b=1A47V8PZErgo5LajAx3X7SKqoBSAUj8MybmVD52sl0dORXlGo4h2zMY0ixtx0Lz+C1
         II9PyvpIwYUetcniJJ8LjxWuTSG3K86ksDCj+HSdghydvIR1X7G20xExvigi9eL4b8g0
         azpJICrEu2o+Ykc1kIPB0B4oJkhPTSEJKFIN3w2nfuyaPJWTRnfQanKqK0kQtMF7EVln
         EbBp1KygDKx8XxLCZeJTz5cr4lBl53u8jwyqkl6CRGUjDUXpiwALsVslR692QSxmaY0F
         +Fhl3ZKTcehtkN46t7wjVQW2z37Y1fQo5ZbtVb8Es9GySflSyedHe1+zOUhyJeyGxd0z
         GXJg==
X-Gm-Message-State: AOAM533GRQ1+BBJMdYJbqMNUXOHm0Kz0GPq4xnPLznNdHel3Jn9oM/sA
        zcf3h+Ou8fVcOvmfxLnSwMg4WxUxcWfCadWdRwg=
X-Google-Smtp-Source: ABdhPJz3Ul/6P1K5zHsJ+FCe5qoWRcik1OlReDpvRanvVoPQkINPnKuVBVMv3PTGKHV8TOo7VgQLaQ==
X-Received: by 2002:a17:90b:1e47:b0:1bf:6d79:b1fd with SMTP id pi7-20020a17090b1e4700b001bf6d79b1fdmr1892610pjb.49.1647307258119;
        Mon, 14 Mar 2022 18:20:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004f7d9dac802sm4764130pfw.114.2022.03.14.18.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 18:20:57 -0700 (PDT)
Message-ID: <622fe9f9.1c69fb81.c5202.c442@mx.google.com>
Date:   Mon, 14 Mar 2022 18:20:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.234-29-g95039df65aec
Subject: stable-rc/queue/4.19 baseline: 74 runs,
 3 regressions (v4.19.234-29-g95039df65aec)
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

stable-rc/queue/4.19 baseline: 74 runs, 3 regressions (v4.19.234-29-g95039d=
f65aec)

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
nel/v4.19.234-29-g95039df65aec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.234-29-g95039df65aec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95039df65aecb7742ba47851e45927e3853d08e0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
da850-lcdk       | arm   | lab-baylibre  | gcc-10   | davinci_all_defconfig=
      | 2          =


  Details:     https://kernelci.org/test/plan/id/622faecfa5d2489562c6298e

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g95039df65aec/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g95039df65aec/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/622faecfa5d2489=
562c62992
        new failure (last pass: v4.19.234-25-g1e5720da6f35)
        6 lines

    2022-03-14T21:08:05.885062  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-03-14T21:08:05.885305  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-14T21:08:05.885469  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-14T21:08:05.885624  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-03-14T21:08:05.885769  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-14T21:08:05.885912  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-14T21:08:05.922544  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/622faecfa5d2489=
562c62993
        new failure (last pass: v4.19.234-25-g1e5720da6f35)
        4 lines

    2022-03-14T21:08:06.058565  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-14T21:08:06.058820  kern  :emerg : flags: 0x0()
    2022-03-14T21:08:06.059000  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-14T21:08:06.059160  kern  :emerg : flags: 0x0()
    2022-03-14T21:08:06.126196  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-03-14T21:08:06.126453  + set +x
    2022-03-14T21:08:06.126630  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1694138_1.5.=
2.4.1>   =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622fb419378250b2c0c62989

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g95039df65aec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.234=
-29-g95039df65aec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622fb419378250b2c0c629af
        failing since 8 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-14T21:30:52.053152  <8>[   35.762004] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-14T21:30:53.064485  /lava-5878891/1/../bin/lava-test-case   =

 =20
