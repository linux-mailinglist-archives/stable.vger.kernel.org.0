Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CD4F71E3
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 04:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiDGCNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 22:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiDGCNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 22:13:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0524B5E8
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 19:11:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s8so4137171pfk.12
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 19:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UCC15wr1vanxD11bHzN/K8RjlXjvNmomTwNsgblhCXk=;
        b=hC0DPgdspNRWBYXQak06JsdUE12Un34D3UrkEQPoN8/p3nIGeQEk43JKROlhZFaMso
         owQRTbXcKmIgi5LlgsrBF0gK57KMfeUM919tlxAlwpinHuoYxCHowy7O/oaUfNeBN0iq
         VRRcdEy4iFublUTW6kRtVxSbdhoF3wpQ2H9TOuESU39neKXHTl2oL7c4Ix89XSJHfNRS
         sGybgnPELQCc1NmGS+fdcBJIp04i48Ru259GRB29nKDkMmb9RGergio31l10f1Upambp
         8RNxOdtjoOru5u9t30JptX6a+T34cMPEnRorqZZUQyp+NNUoiuOfTDs3hHMgc1SiOtTD
         +o3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UCC15wr1vanxD11bHzN/K8RjlXjvNmomTwNsgblhCXk=;
        b=OCf5aN4Whqbo0O+4vYdVnjQZ8f9cehOsK37nBIt89xohsOr85nsOOU44MqU1FIMs1L
         g6I5SpvLtYlI3RadR1se3byXNHNP0aCc5hNOkm9MrJzn+TUJlor+Ov/Mm/blOmLekp5k
         0hchIqtbqpZjUNhDUoUeNHy7W9/uZeyT9uA0nzp6VwBmiq14ZPJrImUZLafCiZ8uWUiu
         9hxDdMRAMhM0ewvjnDclx15dDPGuv945RTAdJ46RO/hNgTugCElJUNCOfIAaO33QiXbn
         hkLyaxwjGRnOC54ku3y407FLzgjLKNpaGxSn7dZsL31qfFZ39za3A4hEqpWt/g+WJe2I
         soSA==
X-Gm-Message-State: AOAM532LXvqtsF+HdnJsm0wtwTALn0eZd8YtuY2ZJoBW/tTBNvBTEn3Y
        efTW1uA8c2hP/6zKinh+3XDLgZMEvSf+KaHCkro=
X-Google-Smtp-Source: ABdhPJx9Qleyasfh6J67eeT8j4NEQBfXwi0RFcTXOp2ZRFuX2uEVTErUMfRA6pX27cgSBrqP/K1OjA==
X-Received: by 2002:a63:dc53:0:b0:381:7f41:3a2d with SMTP id f19-20020a63dc53000000b003817f413a2dmr9584657pgj.126.1649297488024;
        Wed, 06 Apr 2022 19:11:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x63-20020a17090a6c4500b001caa8689492sm7152011pjj.0.2022.04.06.19.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 19:11:27 -0700 (PDT)
Message-ID: <624e484f.1c69fb81.92b11.498f@mx.google.com>
Date:   Wed, 06 Apr 2022 19:11:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.109-598-gf8a7d8111f45a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 105 runs,
 3 regressions (v5.10.109-598-gf8a7d8111f45a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 105 runs, 3 regressions (v5.10.109-598-gf8=
a7d8111f45a)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.109-598-gf8a7d8111f45a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.109-598-gf8a7d8111f45a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8a7d8111f45af2bc1b9d989d2326a3ea61c10fb =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/624e1399ea2808acbcae0698

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-gf8a7d8111f45a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-i=
mx6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-gf8a7d8111f45a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-i=
mx6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/624e1399ea2808a=
cbcae069f
        new failure (last pass: v5.10.109-600-g45fdcc9dc72a)
        46 lines

    2022-04-06T22:26:05.201170  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2022-04-06T22:26:05.201430  kern  :emerg : Process kworker/2:2 (pid: 74=
, stack limit =3D 0x40b3eed7)
    2022-04-06T22:26:05.201701  kern  :emerg : Stack: (0xc3281d68 to 0xc328=
2000)
    2022-04-06T22:26:05.201961  kern  :emerg : 1d60:                   c3b8=
21b0 c3b821b4 c3b82000 c3b82000 c14463b0 c09e48a8
    2022-04-06T22:26:05.202461  kern  :emerg : 1d80: c3280000 c14463b0 0000=
000c c3b82000 000002f3 c3276400 c2001d80 ef85cec0
    2022-04-06T22:26:05.204489  kern  :emerg : 1da0: c09f2014 c14463b0 0000=
000c c32c0a40 c19c7990 dafe8028 00000001 c3999c00
    2022-04-06T22:26:05.244171  kern  :emerg : 1dc0: c39ecd00 c3b82000 c3b8=
2014 c14463b0 0000000c c32c0a40 c19c7990 c09f1fe8
    2022-04-06T22:26:05.244433  kern  :emerg : 1de0: c14440d4 00000000 c3b8=
2000 fffffdfb bf026000 c22d8c10 00000120 c09c7fd0
    2022-04-06T22:26:05.244706  kern  :emerg : 1e00: c3b82000 bf022120 c399=
9dc0 c3745908 c372c040 c19c79ac 00000120 c0a24a08
    2022-04-06T22:26:05.245209  kern  :emerg : 1e20: c3999dc0 c3999dc0 c223=
2c00 c372c040 00000000 c3999dc0 c19c79a4 bf0770a8 =

    ... (36 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/624e1399ea2808a=
cbcae06a0
        new failure (last pass: v5.10.109-600-g45fdcc9dc72a)
        4 lines

    2022-04-06T22:26:05.117538  kern  :alert : 8<--- cut here ---
    2022-04-06T22:26:05.151421  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2022-04-06T22:26:05.154624  kern  :alert : pgd =3D 2eb76d15<8>[   17.73=
5129] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2022-04-06T22:26:05.154887  =

    2022-04-06T22:26:05.155159  kern  :alert : [00000313] *pgd=3D00000000   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624e167e1fdb2c2d95ae0687

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-gf8a7d8111f45a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
09-598-gf8a7d8111f45a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624e167e1fdb2c2d95ae06a9
        failing since 30 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-06T22:38:31.148955  /lava-6041485/1/../bin/lava-test-case
    2022-04-06T22:38:31.160255  <8>[   33.905279] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
