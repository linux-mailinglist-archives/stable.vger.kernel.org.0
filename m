Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A784E5518
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiCWPYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiCWPYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:24:06 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C270B71EF2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:22:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v4so1995529pjh.2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qkP7T0PLsAlg1By9acbwVKlsRWY0Q5M4l+F+E1lZn4U=;
        b=QkJH4ANMMGQPEtqP5OKvUZDsUWbWFKGmnpnk/z6nbVfQaOqNiaCuBAxGic9Mk+DKyY
         yXvLWBV4INdoa7ARHCMsdXle59s5M6eIs6ZfDo84FdmT5PP/iNCc0RrDIqQWdKGrYW8f
         YVjMPaOf0JZmfYx+1BYoRXxcZHQCNKG2M/2L0B6qQ6sav6V2tIcHOk79IuilERGr9UQa
         M+TIhmXcK1VffXXkgsdwrecvL+m0txBX06zr7aYlp7bY83Eid7eopTt6RvEdCqS0UMzF
         8qwHWBOmxrNsufS9rMleVtqJALPswAw+jvJyDFvs4mhuGw3N4nAJMy6z9hjZImMsui0i
         7U6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qkP7T0PLsAlg1By9acbwVKlsRWY0Q5M4l+F+E1lZn4U=;
        b=lRGcIAMbZ/v5UaIzdt7k7CDMeCEAEyUZm+9uTatmtZP0JHuLzeW83bWqQ+WkKJvYRK
         hFZ85EuaAWsuckly0wn1q4hTxV1NYFZcsIejPkF9506v7nPFyiH3lvbM+Q+IYAy1Audm
         xrBPJffeHSyouWcExFdCQZNNhSH9wnEXfmaGOdpwNekVs3Yf04Yr1JSoLowuN0I5vBDF
         IyElx0bfBnhY9+ro1BgpFDPcerDWdeqJPKgCcg8l7VM+r/QiJmvLw/uWfIqtWm6SpH+7
         U4Stm/UmY1W/9HYC109RwFtbmKkUMKnqQGkzaigrODkUceC3Wjo4qN5ag6cZT2r8yPNX
         oWkw==
X-Gm-Message-State: AOAM532LY2Vj3ROg2zuJZVfPqJxpGeKsxZHD5VqLyTqNVa6ABT8vRA8J
        MMBRQNCxR2EUXX524VHQWbhoPryXBBciA1It0Tg=
X-Google-Smtp-Source: ABdhPJyAkWu0LUx7+Vd0FG/GuVD/Ty1fFI3QzIPdQDIqRQkpJrBxyHbQpQ+V/HGIMqVEcpISdY2UVw==
X-Received: by 2002:a17:90a:9412:b0:1bc:f629:43bc with SMTP id r18-20020a17090a941200b001bcf62943bcmr12299019pjo.103.1648048956136;
        Wed, 23 Mar 2022 08:22:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v26-20020a63ac1a000000b003831aa89c45sm172700pge.42.2022.03.23.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:22:35 -0700 (PDT)
Message-ID: <623b3b3b.1c69fb81.c9a7e.07ab@mx.google.com>
Date:   Wed, 23 Mar 2022 08:22:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.235-57-gd1f635cdf587
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 59 runs,
 3 regressions (v4.19.235-57-gd1f635cdf587)
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

stable-rc/queue/4.19 baseline: 59 runs, 3 regressions (v4.19.235-57-gd1f635=
cdf587)

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
nel/v4.19.235-57-gd1f635cdf587/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.235-57-gd1f635cdf587
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1f635cdf5873774afd32e6aef00012a2a10cb34 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
da850-lcdk       | arm   | lab-baylibre  | gcc-10   | davinci_all_defconfig=
      | 2          =


  Details:     https://kernelci.org/test/plan/id/623b084c073ffb9853bd918c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-57-gd1f635cdf587/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-57-gd1f635cdf587/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/623b084c073ffb9=
853bd9194
        new failure (last pass: v4.19.235-22-ge34a3fde5b20)
        6 lines

    2022-03-23T11:45:07.714659  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2022-03-23T11:45:07.714937  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-23T11:45:07.715120  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-23T11:45:07.715272  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3800
    2022-03-23T11:45:07.715416  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2022-03-23T11:45:07.715557  kern  :alert : page dumped because: nonzero=
 mapcount
    2022-03-23T11:45:07.751684  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/623b084c073ffb9=
853bd9195
        new failure (last pass: v4.19.235-22-ge34a3fde5b20)
        4 lines

    2022-03-23T11:45:07.888659  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-23T11:45:07.888900  kern  :emerg : flags: 0x0()
    2022-03-23T11:45:07.889066  kern  :emerg : page:c6f59000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2022-03-23T11:45:07.889218  kern  :emerg : flags: 0x0()
    2022-03-23T11:45:07.957261  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2022-03-23T11:45:07.957491  + set +x
    2022-03-23T11:45:07.957681  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1737028_1.5.=
2.4.1>   =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b0a3c01d6efd777bd9184

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-57-gd1f635cdf587/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-57-gd1f635cdf587/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b0a3c01d6efd777bd91a6
        failing since 17 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-23T11:53:18.401506  /lava-5931898/1/../bin/lava-test-case   =

 =20
