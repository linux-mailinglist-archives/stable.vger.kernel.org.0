Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453A242227
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 23:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHKV5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 17:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgHKV5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 17:57:55 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65697C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 14:57:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m8so8344247pfh.3
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 14:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ma9kzmzCnrTbG9FfkSd6cJ1E/bCPPoCCSqNMMf2+do=;
        b=eH5gTxErhRuJXFs6CKul2SObfNUyWgZDB0PfFidrUud7eSQTujUJ0q+R7bgxeb1x/A
         WhNNnbUfTzmB3Qhts6e21MbPaCuTWQ8IKRfxTNo2fIQbyyk43MGtZtNMa51kL6IUtYPR
         YquJr+xFebaIHsIdFYAXxjaCZSWyKJWO95cZaSrQMQjRCskD6mL21+9R4jLfcuCDTkIJ
         cEBP83rSfBljVDoMHfXJ+v8ceg/qx6pzo+y5sfpzKGAz4nLruxFUtYK+Ar7DKymWYumK
         6IoJ1jyqT1fBy5/wwZKojs8hD0vBH79Yva7fJwJ3r4QyZTVX5KtpMDBZEsgcTSQAx+i3
         BEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ma9kzmzCnrTbG9FfkSd6cJ1E/bCPPoCCSqNMMf2+do=;
        b=UDmFLZGXJgdwEI9Wek9NlJ0ViwkZxMr5dfge5CeGu3J4GDhWm/UDhclY/IGH8UsaNt
         cI1METXos0EQNR8vKVnNhS4QmOI/E5+TKTaYuA6hmJKsVBF5x2scgAKRSSB8B0uvBDH8
         QxMKS1usTC4b7HKJNpl6IgB/7Vc3VVeqAc+7gTsnAuP6VbogLBGToPhZjwINBrTjWlS0
         0Sfci+NQSgBC8MBNqWrE12FXIICk6xscrc8FQujVSpDMDMtdFvS77n7Aaxs2/QT1MMRd
         bQ7/g7W+O6FgOKnLYOfDg4aDUzxL1cpJMxFtGTIrhW13ARCOqlK+Otv7Egor1wJ42xaF
         yfJg==
X-Gm-Message-State: AOAM533VFce8jIZHxaHQDFuWMmaxRESTsR1UQnbb0qTf4L7Wo6EblwHz
        muX9JV5+WR/8WQEAwj8zWvUodM5oQV8=
X-Google-Smtp-Source: ABdhPJz+DPPxUykxG6asTO9eaLxcc2c3whF/dxpDzAXAqAx8F03bi8IRTFMfiNOBhT/U/oPkdOA7aA==
X-Received: by 2002:a63:1211:: with SMTP id h17mr2343946pgl.265.1597183074646;
        Tue, 11 Aug 2020 14:57:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv3sm3837453pjb.45.2020.08.11.14.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 14:57:54 -0700 (PDT)
Message-ID: <5f331462.1c69fb81.1cdfa.d8ef@mx.google.com>
Date:   Tue, 11 Aug 2020 14:57:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.15
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.7.y baseline: 192 runs, 1 regressions (v5.7.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.7.y baseline: 192 runs, 1 regressions (v5.7.15)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.7.y/kernel/=
v5.7.15/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.7.y
  Describe: v5.7.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0e446529d34888ac57fe059ec32e9114a381c800 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f32d670c295f5c6fe52c1fa

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.7.y/v5.7.15/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.7.y/v5.7.15/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f32d670c295f5c6=
fe52c1fd
      new failure (last pass: v5.7.14)
      2 lines =20
