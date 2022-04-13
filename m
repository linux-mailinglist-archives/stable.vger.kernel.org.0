Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867554FF7E5
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 15:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiDMNmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 09:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiDMNm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 09:42:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0E31580A
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:40:04 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l127so312040pfl.6
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b7HZxBh/sAfoWYcrfpx9hpfUwEDqAPCGmsCpjTO8RtM=;
        b=EM9NUk1TxIcT+DjANuXJT3TxkbbmrnOK9ftAVhAkqXkkl5qHxSrB0aWquVUVec5zjZ
         ocT4QHLfTfFpUlAhjgLV/OlzhTkRuzdArmYWX16cKP2NAQWddlSnxM2AgIuHHk0aLAmg
         Cro7ieE7iPrfKFDCMEmxBVk24btehUS1X5LuENJijH4adfCmQmLcP6QuR517uSNAMiC1
         aGnww3U5MVT8ELjgQEljA4CQ0MvF/Z9dFyQz0eNtpRGemrUNYoQ3ZDt822Gc/ceExr91
         AhCMnwC/jWZ8IHapeZPeBImOcJGoCSvp9cNzoWLs5lqPiT7FpC7kqo19j/h7WYC6lxPg
         ImUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b7HZxBh/sAfoWYcrfpx9hpfUwEDqAPCGmsCpjTO8RtM=;
        b=RiLFMEXFXqUXGuzGRPL3mSM5zaTauq/zdqLoxhSHcrRqioctzPBpNd9XdWlYKGs1Zx
         BSKHaGygbtIbcL8/tChNv7+KPpOs4G2aSkq3GO6gucrhTu66HcWNSDw7XgmxyImFxM5/
         P1GHHHrNE6VUF8lZlGjaQWWDAFQWUTEgm6NfCCfe9rpYaOTy+UpjzGNH9WvXNyirmQ8U
         ZO6gMEC8nhgT/dqxRKhjLdMQZ2Xvdz72pB5gg6FKZZU3hcO+s5FfCSxFEmCTeAiqUiEH
         cqHQwelBwr9Q96M9XjUH5//q8cbhOd9OQoaa9x5zCxxIp7VGZo9pub3Wq58ID7BTlHDW
         2OsQ==
X-Gm-Message-State: AOAM533NP4Av8irehzwiv3NgQZ7orbLuWr7mi07Ae1iqXBpXae4tM9MJ
        t9h3nJNwooQ4MNFIEJH1L9Pb0DcFmx48l3v+
X-Google-Smtp-Source: ABdhPJy0CZK78SF4VBs43KDpIJXCMGZFsV5O4XtOO7eVxGiVuIiXJeR6+Oowda1gzSDLhVUF05LTIA==
X-Received: by 2002:a05:6a00:a0e:b0:4fd:fa6e:95fc with SMTP id p14-20020a056a000a0e00b004fdfa6e95fcmr43336233pfh.17.1649857203430;
        Wed, 13 Apr 2022 06:40:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm6373777pga.38.2022.04.13.06.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 06:40:03 -0700 (PDT)
Message-ID: <6256d2b3.1c69fb81.efbb2.0443@mx.google.com>
Date:   Wed, 13 Apr 2022 06:40:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-329-gd4bbba6a976ba
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 102 runs,
 4 regressions (v4.19.237-329-gd4bbba6a976ba)
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

stable-rc/queue/4.19 baseline: 102 runs, 4 regressions (v4.19.237-329-gd4bb=
ba6a976ba)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
da850-lcdk           | arm   | lab-baylibre | gcc-10   | davinci_all_defcon=
fig | 2          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-329-gd4bbba6a976ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-329-gd4bbba6a976ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4bbba6a976baaf7cb05e6a4c0009d7bcaede9fa =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
da850-lcdk           | arm   | lab-baylibre | gcc-10   | davinci_all_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/6256a0730c594fdd29ae067c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6256a0730c594fd=
d29ae0683
        new failure (last pass: v4.19.237-330-gbdfbd5df0daf)
        4 lines

    2022-04-13T10:05:13.293351  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-13T10:05:13.293649  kern  :emerg : flags: 0x0()
    2022-04-13T10:05:13.293819  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-04-13T10:05:13.293972  kern  :emerg : flags: 0x0()
    2022-04-13T10:05:13.361287  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-04-13T10:05:13.361501  + set +x
    2022-04-13T10:05:13.361674  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1810653_1.5.=
2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6256a0730c594fd=
d29ae0684
        new failure (last pass: v4.19.237-330-gbdfbd5df0daf)
        6 lines

    2022-04-13T10:05:13.119895  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-04-13T10:05:13.120170  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-13T10:05:13.120361  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-13T10:05:13.120534  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-04-13T10:05:13.120701  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-04-13T10:05:13.120867  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-04-13T10:05:13.156308  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =

 =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a2cb3aa38bc1a3ae068b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256a2cb3aa38bc1a3ae0=
68c
        failing since 12 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform             | arch  | lab          | compiler | defconfig         =
    | regressions
---------------------+-------+--------------+----------+-------------------=
----+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6256a30729efddf3c8ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gd4bbba6a976ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256a30729efddf3c8ae0=
682
        failing since 7 days (last pass: v4.19.237-15-g3c6b80cc3200, first =
fail: v4.19.237-256-ge149a8f3cb39) =

 =20
