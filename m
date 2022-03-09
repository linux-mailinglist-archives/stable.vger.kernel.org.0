Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283D14D26A2
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiCIEDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 23:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCIEDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 23:03:08 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A7710E
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 20:02:10 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e13so900651plh.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 20:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=73oIqbrIRqBSwBDLAh6t7rNHiUtCpJw6Wptra2c5ivs=;
        b=mYcvq34L3ddQlVS9M4TpDsO25U+mfGdyYssDfEGgZfDfyxLPfkn9oTG7xpf9NF+pl3
         rQHEP/69CXP/ilB3K0rY/SOo98bN9l0I5p7JBMcIwIL4mNRmjDNjtms/wuH9BDbPj+xl
         joXNRmnXP1ZWa6RMjLvXwsCG89+kmdVoXaAkVCbmzm1J28Pi7p0WaLwSOIiV8p1agMl6
         fCIa2+v2sOjon0SFIy7i/RqKJYnckVTBkMWnqWQYr5RfTUjmVWOSRad86r8okYQck5/n
         cTAzvB3cmK+8+xjMqMz9VEEIuKlBCdEDcEUI4vIhgeMupMxoW6Y85uq0wqg4BDDyKOU2
         eVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=73oIqbrIRqBSwBDLAh6t7rNHiUtCpJw6Wptra2c5ivs=;
        b=xIYcccNecWZE0dnhU2QRJIv+MXGkC9dvukxbNb5p0DPT+KllP888I3uCmIVs5NhdJE
         cbMNOwvpmzczyE67m4y001U44awoDeXSARdT0fLtRU2wkJM3C/d6iYd3DvSK7UOCDscO
         GiraQx012nTwt8PTNwb18ejytzWNIeINKE92mSLVsZqp1G5YOTKr8YNUEFdXO7IHmpWi
         IClDjw5O8rkzEoy6rb2neaxnD0ejZXBE8BW+gTjIc93OcWy7y5CHNjTv0Y6DCtXiBm+h
         g1LbvclpypCb8A047cxi17KRwnx17UlZskYF/xXdImLZaS4vvP49BVjAbKt8be2zzOVA
         g+uw==
X-Gm-Message-State: AOAM532xiw/ZJPcTGnLox+WqKfNyGF39fD/sJrhDKpYU9vjwm4A6GW9r
        JjCumB33kg6ftFaozHDB9DAbDCIXJivG+UEmIUs=
X-Google-Smtp-Source: ABdhPJzc0i/Er1xm51DibW9zrIbEdNr2b2SIDlJX1eYRsCkVVdoQ9z4rzuQqZkT61qh7L5cDfHOF3A==
X-Received: by 2002:a17:902:cec6:b0:151:e4a6:6af1 with SMTP id d6-20020a170902cec600b00151e4a66af1mr14521082plg.64.1646798529331;
        Tue, 08 Mar 2022 20:02:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t24-20020a056a00139800b004f7586bc170sm339237pfg.95.2022.03.08.20.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 20:02:09 -0800 (PST)
Message-ID: <622826c1.1c69fb81.b979f.134f@mx.google.com>
Date:   Tue, 08 Mar 2022 20:02:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.13-37-g9783bffc82c9
Subject: stable-rc/queue/5.16 baseline: 91 runs,
 1 regressions (v5.16.13-37-g9783bffc82c9)
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

stable-rc/queue/5.16 baseline: 91 runs, 1 regressions (v5.16.13-37-g9783bff=
c82c9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.13-37-g9783bffc82c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.13-37-g9783bffc82c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9783bffc82c98ff0da641560f391ea2fccc96b13 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227f99db7bfb74b0cc629d2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9783bffc82c9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.13-=
37-g9783bffc82c9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227f99db7bfb74b0cc629f6
        failing since 1 day (last pass: v5.16.12-85-g060a81f57a12, first fa=
il: v5.16.12-184-g8f38ca5a2a07)

    2022-03-09T00:49:11.291409  /lava-5842110/1/../bin/lava-test-case   =

 =20
