Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97984514427
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiD2I2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 04:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355667AbiD2I16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:27:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E80AC1C8E
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:24:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p6so6524122plf.9
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KuS+yH1kiQLApjfE4L/tp3jDdwz85Wr4UpNM1EDBZlM=;
        b=x9qh1hlmn28S/F/8CpMvxv1xa58LOj4+WRZep6aRTwXcU2HxBSVr5L/H7mRWqQambb
         2cD2EnMIywA6e/Wejkow/qMv7bd7EXfoXpYaL/UMInRWG31Zp7XMzK2yFF45jyJi65d0
         qrDqD6Yc5V9BAsiduZ8pwK9H65ITgmFcgKoCdzQfv6KM+qIi4OMvrQN7y7NOpyYDzGdI
         SRnqjlk/Aogtoliw+NkTT3Tb+fEMsyMIN36Ff3MGBi470K+QB3WklhKFhNMXhdjFb83K
         hVreFpvwsNUHPHj/i7FhU9WhlP0XTqstM5VIMIaTuFU9tLIdfqWTTJctBvlKzwoqTj9J
         jvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KuS+yH1kiQLApjfE4L/tp3jDdwz85Wr4UpNM1EDBZlM=;
        b=jg2ixKvNKvmvzR0hBFDxJZ7r0ld1C6QU66prQN8mpglO7v+bAFNK4G8S20Qjsb7gtG
         IArwhVLguRt26Dk6S3pNKZ71gWCdxqdXVOExYctZDe8ldeBYb3KWbyNz9oVdymtqVmPh
         Wm+mf8ThZJiPQNhifBAOREqbMrGB/NjyQn8qZ49J4LwWG37T3dPjSIWLzD8wbF53AjSq
         SmmQ+IzodB1InlZ3iqYc+bt9eOitHpuGGf6ZUre/WFKeBDkVEJliFTUzAg2YejDT7oJt
         6JPBRalB4TVpMkjaEUn8sZjQtdZfpBfuWtaINM3pwvmpHVOOvPVaJk2Hjs+PbpJyc7Yd
         M+Lw==
X-Gm-Message-State: AOAM530jS1y8Icjuhim1FGV66hJMzQ1gbWK8L6xwQpHh/WiCKLFEBhwE
        iLlrM37wXD5KREkOiY+Z3t2qHsmqs3XLmw3hPx4=
X-Google-Smtp-Source: ABdhPJxit4uUBhC+Rp/dZ/jytgliFwdcNsFmS8jjGg3s0zUFzs9EHHkSdZHrM/kR54FSz3vsDrgF/w==
X-Received: by 2002:a17:902:868e:b0:15a:7c9d:b11f with SMTP id g14-20020a170902868e00b0015a7c9db11fmr38613433plo.151.1651220679919;
        Fri, 29 Apr 2022 01:24:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090a468d00b001cd4989fedfsm13799773pjf.43.2022.04.29.01.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 01:24:39 -0700 (PDT)
Message-ID: <626ba0c7.1c69fb81.3eecd.03ba@mx.google.com>
Date:   Fri, 29 Apr 2022 01:24:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113-1-gb17d6612542c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 83 runs,
 1 regressions (v5.10.113-1-gb17d6612542c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 83 runs, 1 regressions (v5.10.113-1-gb17d661=
2542c)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-1-gb17d6612542c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-1-gb17d6612542c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b17d6612542ce90b6ee71a4a9fbb00490864a1fa =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/626b6bfe573bb23e86ff9469

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-1-gb17d6612542c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-1-gb17d6612542c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/626b6bfe573bb23e86ff948b
        failing since 52 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-29T04:39:08.088708  /lava-6206206/1/../bin/lava-test-case   =

 =20
