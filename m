Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B7A548C99
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385909AbiFMOws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386120AbiFMOvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:51:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9628B22526
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:55:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so8608377pjm.2
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+sSqiPCaefkCgjU6CuugYk7OyUlAldX0cHFr1OILUKk=;
        b=edhPi2Mla4GL8CW9QVdtZSd3Ty32oDnplmkmkfqAoYr1bNG+QgOFIad26mmUPq7Jg+
         3XPINES2mAMfNKPxCxR3PhUP+J4rNkdFfqbxa7xJ6gxq+R+FBi3GBBAsJnEbmYO4bbpm
         8PzUWR/PJsfmsNav2jZd+7sRD3Kbvg1hgNQgFHQvocQdhvFcOwAj6XNSGjMX3WSTiVLl
         YRIpRTGuJ/DrBRi6aNn1bDs9n54DTfo93KXKD1Tfpc/Fc7G0PoVcYzsILV++9N0RKh9i
         M2WkjxkDwdZQBoeqw4AxA4kwYBf07By+reIYM/TyHd20mNUZfCQ4m9bv3U3/8CqlUG/T
         lmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+sSqiPCaefkCgjU6CuugYk7OyUlAldX0cHFr1OILUKk=;
        b=5M08PQgAPCvkT41x9O/X1eOTAkpMrs+/RDG7wU6ce97SaWcJUvvezp/KS2e01UizA7
         Hoz1OJDZsYpZgpYYWJhRAfkQ6UaK/hikNIamMOmk2HDarhQ3NRHy7Q9t6WNF/t3TNajj
         gIzwQt/Zni+Adb/aXgqzxpUXWgceTVk7UwuD6gye1trKRIJZpIc2rWfwO0F7quZFo3/q
         jxu3F5FJ4hAbxXYveejAxM61qBNp8SZOPbJcrm4vnxWtu1QFKzjvYr8L3S5MpZvLAZMi
         IrrCVkU6zpn0ImodxLjEsjGnT3wymqMOaTdtdICcyzCUX7nO15QC2YcDNd5zHWcoNSEj
         d0tg==
X-Gm-Message-State: AOAM531JPHYiCJjddpZ4Np3Skf/uw0NGmVyda9wTwJ9ku28hB+XItbsK
        WTancqmt3RnLEj72ERApeeUr9DRVjPdEkEoH0E0=
X-Google-Smtp-Source: ABdhPJz9PNfEb0+n1bUI4wgLrcsxkkwpkHjeKuQVl26LM7QC4orZMQRdkxL4NkY3Wiy9qGRnSFJETA==
X-Received: by 2002:a17:902:cec2:b0:166:4277:e0c0 with SMTP id d2-20020a170902cec200b001664277e0c0mr55692636plg.107.1655121336861;
        Mon, 13 Jun 2022 04:55:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12-20020a62f94c000000b0051be585ab1dsm5153447pfm.200.2022.06.13.04.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 04:55:36 -0700 (PDT)
Message-ID: <62a725b8.1c69fb81.5a2e5.62fb@mx.google.com>
Date:   Mon, 13 Jun 2022 04:55:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-889-g4600c62eaa695
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 4 regressions (v5.15.45-889-g4600c62eaa695)
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

stable-rc/queue/5.15 baseline: 181 runs, 4 regressions (v5.15.45-889-g4600c=
62eaa695)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =

jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-889-g4600c62eaa695/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-889-g4600c62eaa695
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4600c62eaa6953f94bb36da266699a6e73d0fb26 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6efe772cf5f5031a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6efe772cf5f5031a39=
bf0
        failing since 2 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6f355beb694cb61a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6f355beb694cb61a39=
bce
        failing since 0 day (last pass: v5.15.45-833-g04983d84c84ee, first =
fail: v5.15.45-880-g694575c32c9b2) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6f1b23ffde97955a39be7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a6f1b23ffde97955a39c09
        failing since 97 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-13T08:13:18.096352  /lava-6603423/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6f228eca58d17dda39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
889-g4600c62eaa695/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6f229eca58d17dda39=
be9
        failing since 0 day (last pass: v5.15.45-880-g694575c32c9b2, first =
fail: v5.15.45-882-gf1e18052eb978) =

 =20
