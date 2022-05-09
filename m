Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E04A51FD77
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 14:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiEINBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 09:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiEINBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 09:01:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598741C8FD6
        for <stable@vger.kernel.org>; Mon,  9 May 2022 05:57:10 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t13so11957412pgn.8
        for <stable@vger.kernel.org>; Mon, 09 May 2022 05:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qgJt9d5BYD8qH5Il+D2wLwrp6Gx/ioG49lSVTIbilsA=;
        b=E/oR0T5Xz+bCVQiW8VJaKUyLcZ8txR/QFVk0RRzqWXHZf1lKiAq2lsaKG7HiPhO4QE
         FIncDUiI3zHiPFO1H3PAR3PZMI1u6BglDnVVrndD0cqe1bEXp0PQ2KvcB3iCJMi9mac3
         +9YJ/+JbS61LNWfaJODgrfjMNFQXu+k2ETTaQxAOreNre+B6rn0JivJYL9axZQiDGmNz
         MNRO2VHmNSqr+IqCEZAB5nHlonqcZZLWWltnVUjaSObIgaJlulntp/C7yxsEnLRTpNFo
         +kCX+7dt0QbMI0MqCUBVwaL9gl9nDQoGWX9V80egv3BVCGAMQ4OtKCDgdiazK1UpiFpM
         hFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qgJt9d5BYD8qH5Il+D2wLwrp6Gx/ioG49lSVTIbilsA=;
        b=L5K8FdE/57nMNlrvB9iq5GlzweX6zmBOYJQWF84SsfGqhHciIBXe+/h6H6GfCvDoVT
         W6Tnxkn1+DHI/f1V5E6utqJcGYwEowA/C7QkSUvgHBX348QJjK8PvHxfXFyeG9W2Ipt/
         v7RtMmAxIinFwLVDh5ESRq03wc0O8qiaslk0IewROpdVOXBv3yGRgpETtiqWLxRXcBNO
         7qtPEHt6GhXwTpH4FCqwU1xjK3zTWLm8O9bnPE9R2kvc+BAmJ4Fv0/Ma9WhLHDIGOZ/8
         wWY5pWkVJzeF5FKDntZko1j78JhTd69dlS6vesTndy1neQ+4ZyqDVt8RTkM0woaQbzHy
         9qsg==
X-Gm-Message-State: AOAM533ns5eQdbHK4k4VWgnvfqtnMyuG5BSGx6TI2xkF2jaTr34ABjMq
        Ko1EpBZqV8Aj6rZ4A49m+GUPtnTRxBGRiyjr
X-Google-Smtp-Source: ABdhPJx9r9gYNkzDNVjWYeHdJizOwDKEyHIK8BOZJOuzySrQ8m4MKDrh/D7ohbGAoyyvSUvg7uUMZg==
X-Received: by 2002:a63:4723:0:b0:3c2:69ab:df80 with SMTP id u35-20020a634723000000b003c269abdf80mr12889546pga.23.1652101029710;
        Mon, 09 May 2022 05:57:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a191e00b001cd4989ff3fsm8803095pjg.6.2022.05.09.05.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 05:57:09 -0700 (PDT)
Message-ID: <62790fa5.1c69fb81.d682.3c66@mx.google.com>
Date:   Mon, 09 May 2022 05:57:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.113-129-g2a88b987a070
Subject: stable-rc/queue/5.10 baseline: 169 runs,
 1 regressions (v5.10.113-129-g2a88b987a070)
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

stable-rc/queue/5.10 baseline: 169 runs, 1 regressions (v5.10.113-129-g2a88=
b987a070)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-129-g2a88b987a070/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-129-g2a88b987a070
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a88b987a0700ca5f0200a2d1ee1ab078755c9ca =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6278d9c1ecaf7b18538f5743

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-g2a88b987a070/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-129-g2a88b987a070/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6278d9c1ecaf7b18538f5765
        failing since 62 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-05-09T09:07:02.270789  <8>[   60.077414] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-09T09:07:03.292985  /lava-6306079/1/../bin/lava-test-case   =

 =20
