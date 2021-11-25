Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E01645DB32
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355012AbhKYNjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355129AbhKYNhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 08:37:55 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969C3C061799
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:24:46 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l190so5238624pge.7
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v6OiJ6M+4qSFY7ywOftSrXbpGXks+Zd9rFOwTFMbSng=;
        b=6mJn4SCauW98TwP7taEab1ItZXHFDSUNb08OWQ6CsZBFMUSw+mQ1JajDHNrHClY9cN
         ou1HUQrFMIPdC626cPloJZ6oI4J4RNZSbznh9Bnyohc2H+DqrojlpDYdE/+JKKgGvhLN
         MWPrIH/jMlGXV/e1bdhDaBgijGpz66nJVBDoDs3ftglNxTvBAN8kTAUwinlWoKyEOvjk
         LbLsI+cx3TNqRA+gqpHD0wX2Rg+MHBUx6R8fn4kuV7w32zqvBuJFzhgNP42yTelELBIX
         t+VaQZj8URRMbhcXrIreTlZWsgwErlDQ49Zfooe0aRu04ifoJkvjQIomxwZ2XINNFt1l
         P/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v6OiJ6M+4qSFY7ywOftSrXbpGXks+Zd9rFOwTFMbSng=;
        b=sk+qN2Xq+EmI4fmcNOAxP26CjqLxzQ2xCISJcjh4Lf0lFRe1Bqd3WRTPnFZjIbbm70
         OnBQcAsBOBLwDGdEREc28Nb07QxdfUw7R4KsEqWE8H5Y0dxoADtm+zYWtW+vE1cjS+4a
         Svg8vePZOXuQLvMoDS/fnYxYAm8ha+S2IIAL7PWhPIZS0Z6UJf/+wE+IS1N3VZe92rVo
         x6EL0P1MDqqLHpVUciFvXDBz5tQk7QO2hBEiT8qYWEDs3a+63cXhjsNLZ4qZYsUp0NpO
         joBN6A1qi2J7gQEJySC914l8lXQQaWO7wSbx/tIhHsfxmVzV8gvlWSSxGdLFf2aWU0Bd
         v/9A==
X-Gm-Message-State: AOAM532u+VomLo3Gyy3FWGnjUruNAVPaSDqRUYTC5M9Xjw+pY1NGLL66
        IQaFVgE5eykXj9lUtmCxTwigGgWaJKRYqjhRubE=
X-Google-Smtp-Source: ABdhPJxqmZxE5Ju/qSVlHutA6R8jUpsCOWZw9ebsA5nnppI+pRmcvpTiT3eeZ4SI4Z02LGVv82tznQ==
X-Received: by 2002:a62:14c7:0:b0:4a2:a6f2:2227 with SMTP id 190-20020a6214c7000000b004a2a6f22227mr14078660pfu.22.1637846685953;
        Thu, 25 Nov 2021 05:24:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm2510319pga.14.2021.11.25.05.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 05:24:45 -0800 (PST)
Message-ID: <619f8e9d.1c69fb81.a83a.6878@mx.google.com>
Date:   Thu, 25 Nov 2021 05:24:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-320-gdc7db2be81d5
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.217-320-gdc7db2be81d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.217-320-gdc7d=
b2be81d5)

Regressions Summary
-------------------

platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-320-gdc7db2be81d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-320-gdc7db2be81d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc7db2be81d50a0ceb821c3d08ce6be22cc81e2c =



Test Regressions
---------------- =



platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/619f57570978928e96f2efa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-gdc7db2be81d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-320-gdc7db2be81d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f57570978928e96f2e=
fa3
        new failure (last pass: v4.19.217-320-gecb1c5645f62) =

 =20
