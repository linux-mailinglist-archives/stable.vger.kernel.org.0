Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD14D0B4C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 23:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiCGWlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 17:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiCGWlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 17:41:50 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F3B20D
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 14:40:55 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d17so6860245pfv.6
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 14:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zw+2en8c773Nx7Wqj5xME/FmsQtN7mSQAPZ+5MuSnDo=;
        b=jpPJQVYHkHaT8UtxzR/uzOGXlmGCzIxEnMW1TwagY0ekaSIUdCHYzU9w/ZL7FrFpKl
         eyYYws9yKjOphO6y9g0zpv/HGXXlPVDL3T2cDPf+39hWXEN2fXBU4Hbp2AQkIEn9zsX5
         WFEo9fL17NV8mP7dvZLym+KdyLqxUeokKTvSpGZr/LwKzpgUsRjniYnJQv5QZjWT3NEU
         9JZ1B0XzZIniOS2bhjoOQCPC5qDC/9H43S1J9TF60xKoB9cSYqCnH1Zpf10jRl5ucz+t
         gf+aYRxc7SQsjnhJbCMt+sBg7E534ckOJKx/zizCW6f65QtXbWyJ1PBmtmQ21Jut+r3a
         xykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zw+2en8c773Nx7Wqj5xME/FmsQtN7mSQAPZ+5MuSnDo=;
        b=msy7x2WRO4BqpaNRguGf5MPSiCFhdb0SPZDkz+N6MgmvRZAlai3rw499RsWzPwTzcj
         zQ5VNen3AIhpQCPYAbQ8mtM0Q+zbkUYLVo1mHxJeI9RtTad1+aJJ38nsGKp28cXn43Cv
         U986mso1MhCfNs4TxEf3Bez8EKt77jtTm52HIvODW5Oof57Gi6QSnnvZnQTyXiRJ3ucc
         OhH7x5sgBBoYVJyvMF3/CUZcF6qBj8heMA1TVIoNsEjvOTmlvsJAt0ZCBlHbqEZC5Ur2
         sLNxDB830d8HqVHXOwbIKTp8T6Kl5YLsqQ5L+tX/G3WFrXdkez0H5uxqWQwS8RjadBY0
         ycdA==
X-Gm-Message-State: AOAM5319kib+DXTMDf2LOE9hkedEHC6ZFIphTNkrYkZrMDGYiXZl2+u+
        GR8MnpnczrWHYwi2A8iY2sVfl/TsrJL4NQEokas=
X-Google-Smtp-Source: ABdhPJwu+oIYgC84tXYiZfBmdJkR28KLyPNjgpSq03egxhL3qytQLNjQb+EnX6vwpq/TjnaeZqktuA==
X-Received: by 2002:a62:8c44:0:b0:4c4:8072:e588 with SMTP id m65-20020a628c44000000b004c48072e588mr15374265pfd.11.1646692855230;
        Mon, 07 Mar 2022 14:40:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00228600b004f709f5f3c1sm4015900pfe.28.2022.03.07.14.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:40:54 -0800 (PST)
Message-ID: <622689f6.1c69fb81.22254.a82f@mx.google.com>
Date:   Mon, 07 Mar 2022 14:40:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.12-185-gc596a0efed21
Subject: stable-rc/linux-5.16.y baseline: 128 runs,
 1 regressions (v5.16.12-185-gc596a0efed21)
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

stable-rc/linux-5.16.y baseline: 128 runs, 1 regressions (v5.16.12-185-gc59=
6a0efed21)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.12-185-gc596a0efed21/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.12-185-gc596a0efed21
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c596a0efed21d96ec6d26eb247911dbfc7c3e36c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62265086f06efba54ac62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
2-185-gc596a0efed21/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
2-185-gc596a0efed21/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62265086f06efba54ac6298e
        failing since 1 day (last pass: v5.16.12, first fail: v5.16.12-166-=
g373826da847f)

    2022-03-07T18:35:41.476676  <8>[   32.684562] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-07T18:35:42.498716  /lava-5830152/1/../bin/lava-test-case   =

 =20
