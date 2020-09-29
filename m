Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAB927D487
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgI2Rcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Rcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 13:32:46 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF34EC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:32:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 197so4412790pge.8
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YGQ9s5jTKZw9VXLXlAJMYjmHROfcnoftqPSXN2MGSrc=;
        b=jB9jH8t/suntQTvi4+Tc1gzCBoQYbA+rVqwqa9OY0+uUjLR47H7c3kkFCgFKTE3ZJ3
         Z2XGrgJmLcBs7dqvltDzQ1FX1GUE7aNQ2hiCQct2BIoWiBzoCRKud/JNQmaz+4aRFJqu
         Rm6Wty+Q0jCanf/Vtz08rMsPzeKomK7es6bIGChIvVQaxnbFFrwtnwyFDCfWPLFY67D8
         Q1oiEJSRpUbo2cedU4BPUH8koW3p3JgUPDF6HcaM2RBpvkcWMxiCTTHC1TLibnKrDkwU
         ckydsMY6M4zLPk3pcywkF335Y447zxbTAVDBhXa4Wta5NI8Zu/UXD7bw/BHArV41bVG1
         Nl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YGQ9s5jTKZw9VXLXlAJMYjmHROfcnoftqPSXN2MGSrc=;
        b=uDxz9iTcWE0lsExIH09e15kbcJIFZztGAUXMmot+C2oQo/KdtVzRaL4bH+jPVrCeMn
         5TfqT199CUaEyw2SVyLcxEulhp2oDPCRoJKnI5ig6vja31UpGUW7IGn7YrMfDyuCfflD
         r3uACeq3X7NY8Osvl3XlyLgXV7YCByRWWatsbGEcvDIFJR3v1GLlJ89azyINzRQOm1ij
         tlSZHbh2S3W7I7UjZTWqXYeEVzYS8W1PjBON8exvuvM7/z4uagCzBdT+b6BfZgrfwHsQ
         ZypqACDWqlIyKtvpzX3952C5ZAAIhkj90M1pjUYm4htR7957N6a4cU94BExjMAFk/zuH
         j6hA==
X-Gm-Message-State: AOAM531UWNAh2xPcd0mvyGwP9HvFBs6jDembQ8JwxN6yk3mJPJwmzHF9
        7KUqee5HFT3jR+l18hBTAXdPJweBw+KJsg==
X-Google-Smtp-Source: ABdhPJynul9iva2cirDKoNiW4CVCAfjs3UU2fZDycXUuQaAQBJZm/68b5Iqj4znWtvUo6+Ix3ekLKQ==
X-Received: by 2002:aa7:96af:0:b029:142:6a8f:c04b with SMTP id g15-20020aa796af0000b02901426a8fc04bmr5276125pfk.30.1601400765803;
        Tue, 29 Sep 2020 10:32:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c68sm6170632pfc.31.2020.09.29.10.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:32:45 -0700 (PDT)
Message-ID: <5f736fbd.1c69fb81.fa2d5.c6ee@mx.google.com>
Date:   Tue, 29 Sep 2020 10:32:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.148-246-gf0a043791d0e
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 141 runs,
 1 regressions (v4.19.148-246-gf0a043791d0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 141 runs, 1 regressions (v4.19.148-246-gf0=
a043791d0e)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.148-246-gf0a043791d0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.148-246-gf0a043791d0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0a043791d0e5cb31a1f0980703eea53ccca259f =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f733de67064921043bf9dc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48-246-gf0a043791d0e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48-246-gf0a043791d0e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f733de67064921043bf9=
dc6
      failing since 105 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =20
