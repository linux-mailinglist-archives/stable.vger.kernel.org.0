Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604B450030C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 02:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiDNAie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 20:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiDNAic (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 20:38:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5C61C909
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:36:08 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s14so3345937plk.8
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HY644OtiyNpINlXGFm6hKyOrcxSt/KZWmy6hpRIcYJ4=;
        b=ZgcsXyBLzNg6M2ZYWcdYQ0uY6hEFY/iEI3dqe3E0Y3giZ2yeg15J1yUwfVBmr1/EjA
         ZI1yLCtvYgFAdfri7QwwFfJTmlG5izzwARbZOAkaPBiVS+00DEkpcGX8IPil8hHYaXpH
         Xqx+9/aJ1y/fwn9wJyNGmTzQjADWcITr9iVAJW5ti7pRwUfTPlw+vq7GQb3xW+tba9Gy
         auDxQ3RR2+5Mq8c+icbkwxQ4uVU5pHAXE+POo6w1zu8tX9eTLEIjtVgfWX4xLoKty3iZ
         AxQQqRZY7tatpLij9Fq660VThpT5+JdcDSe8azYBUb8nC2BLt+5NXsghSlu5/K8wiUe2
         zJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HY644OtiyNpINlXGFm6hKyOrcxSt/KZWmy6hpRIcYJ4=;
        b=5FjDZpVjLdyLnXZQrw+gQuviGddFQmThcCTl3m8tlpzh5wxOOKuIPx9cpAIyhDyAEo
         j/HfIZTVgKSSaSTPfbWHOzXTYfgl6PPq0c+wcf77fwTuGKZ66ByRYfUdgv8s0gvjT3vJ
         XaQ6YsBY73SePLamHSYRHf4j+igsSvOWNnuRDnUFnjw9vGy01VG31PmwOk4dsG6u5u/h
         /ZUgpQlmpm3G6eNC770ONpGXoJYOpbFaWb6uHr3fAilc/P7v7x6ATdkCp4rVKprDsNLU
         Rzk5KmqOfabgN1/2UTKdByYGevPya3zHcg5VjAwpwSB86GSTyoATA2snEIxZ4M6oLfo2
         Zycg==
X-Gm-Message-State: AOAM533YTqGJo91vyS3NUqEvdiyhagE2Dc4oSwTd7eoWvYZteX+lMi+k
        G2Vd5Qi7cJy8HM1VqyksdExM9Bpy+tsBcq+B
X-Google-Smtp-Source: ABdhPJyi+5idoOutekIgmr/dvgRY+I6aD2APGpsMWWChhRZ2/R7+XHmhGDc0j/z2nWxGbwselRKeDg==
X-Received: by 2002:a17:902:ea4f:b0:158:5013:1403 with SMTP id r15-20020a170902ea4f00b0015850131403mr20449214plg.75.1649896567953;
        Wed, 13 Apr 2022 17:36:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm234150pgc.90.2022.04.13.17.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 17:36:07 -0700 (PDT)
Message-ID: <62576c77.1c69fb81.ac6be.0eaf@mx.google.com>
Date:   Wed, 13 Apr 2022 17:36:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.20
X-Kernelci-Report-Type: test
Subject: stable/linux-5.16.y baseline: 90 runs, 2 regressions (v5.16.20)
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

stable/linux-5.16.y baseline: 90 runs, 2 regressions (v5.16.20)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.20/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c19a885e12f114b799b5d0d877219f0695e0d4de =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6257372bfab309003eae06b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.20/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.20/a=
rm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6257372bfab309003eae0=
6b3
        new failure (last pass: v5.16.19) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62574162d0bfbd9f7cae067c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.20/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.20/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62574162d0bfbd9f7cae069e
        failing since 35 days (last pass: v5.16.10, first fail: v5.16.13)

    2022-04-13T21:32:05.436856  <8>[   32.491487] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-13T21:32:06.461238  /lava-6082280/1/../bin/lava-test-case
    2022-04-13T21:32:06.471861  <8>[   33.526806] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
