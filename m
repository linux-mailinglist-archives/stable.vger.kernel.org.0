Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB632FB3C
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhCFOnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 09:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhCFOnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 09:43:16 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C62FC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 06:43:15 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so695144pjb.0
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 06:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WVx7DXxew2Ep9CczPB3VDWZXBa+VSO4sXOIHp7agn9U=;
        b=Zdus6Y7G+cmLYtthuhNABADy8bMHgOBT+10vbog/RGXLUmD3eumYHFzgRORl2xFfny
         QotYAMpxf+uulKUQpIuGp3z55m7bqxGzVtIsDozehAkf/7YSEaa1QgDesMoGy7Bedst3
         2LzlXjWBXrPGhXqPMKnmAQ68jGrnm1ugZkhxEj+MKAafTsJdZTTpcHpJ0WF0L8Pnv+Hx
         BwmywZYmTddqydxbVZtzWN4wT/8jvBE1kzk9/XyRvBUXXb9yPtI6qjJatKLJBOp2xjOV
         kwG9xkKS5sDX/rboCA1JfUwMh/mADwjNnnXD0LOfD5KIuHLlB+TYH9B/asLPlRMn8M+e
         6HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WVx7DXxew2Ep9CczPB3VDWZXBa+VSO4sXOIHp7agn9U=;
        b=aDr9zwv0R+7iAGNP5qATdLj7kSbwP8Z5EyHXG9oJxOkCcn5MD7wPjmvXo0/5DqyEG8
         Y6qivzr1UEJgDWJMwN9OwKIzSMGHiwAHj9xTxAIVHtfNBbRhW/gNW0JeN15eOStoiqXR
         /gAmZUKHlT8UoMhvQghaPcuPQa8MqOmEMBbdgRkiRtySnaOkXkpCXhd2ivUhyYqDC6pB
         o6xD6e8aZv2C+IoaeLdjQoFNT8hmzeN2vzfvjdnvxq43ejkhDfnWb/IDmVvGxs2tvsGJ
         bGwFLQstfIXYGrc++2DdPqhoFQHRsYk+3Rp1ClA+jxvrxQnx2+/+/rOGlNwWAv6uTtkk
         F1cQ==
X-Gm-Message-State: AOAM5312EtTSbp/dhDO/axSLkQSriohGK6HnDpC1f6LS6FefIMMoMLS/
        0hKgdxq2KqbfeYv1Q210p8h+qY/TLRH6gBRj
X-Google-Smtp-Source: ABdhPJy9X3vD3g5W1PvGvk2OlVOxH37/NmVdBp1RMnSNyUj9dQgtIODHU1nEQmn2lWSUo5SoKLzW8Q==
X-Received: by 2002:a17:90b:515:: with SMTP id r21mr15599511pjz.42.1615041794966;
        Sat, 06 Mar 2021 06:43:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm5677060pfh.199.2021.03.06.06.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 06:43:14 -0800 (PST)
Message-ID: <60439502.1c69fb81.f92f2.e54a@mx.google.com>
Date:   Sat, 06 Mar 2021 06:43:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.20-102-g1e6ee0c5a3a07
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 185 runs,
 2 regressions (v5.10.20-102-g1e6ee0c5a3a07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 185 runs, 2 regressions (v5.10.20-102-g1e6ee=
0c5a3a07)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
meson-gxl-s905d-p230   | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =

meson-sm1-khadas-vim3l | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.20-102-g1e6ee0c5a3a07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.20-102-g1e6ee0c5a3a07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e6ee0c5a3a079529980cf6cb2ac62a696d4a914 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
meson-gxl-s905d-p230   | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/604364f070f46ee4cbaddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g1e6ee0c5a3a07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g1e6ee0c5a3a07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604364f070f46ee4cbadd=
cca
        new failure (last pass: v5.10.20-102-g5424d9a6593d) =

 =



platform               | arch  | lab          | compiler | defconfig | regr=
essions
-----------------------+-------+--------------+----------+-----------+-----=
-------
meson-sm1-khadas-vim3l | arm64 | lab-baylibre | gcc-8    | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/604363d8a28c4c5234addcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g1e6ee0c5a3a07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.20-=
102-g1e6ee0c5a3a07/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604363d8a28c4c5234add=
ccb
        new failure (last pass: v5.10.20-102-g5424d9a6593d) =

 =20
