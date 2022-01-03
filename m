Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C4A483900
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 00:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiACXVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 18:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiACXVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 18:21:37 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77502C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 15:21:37 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id j13so25840899plx.4
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 15:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4x1u4OsUY1Hjg8CwzXi0d1BV+bViJNaey4X6E6g/2ig=;
        b=CRQmSc2PjjbOzwz+BYXJA6LYtcHbpttiuo1tb0+mJWbajol7lYfMb4ZS5pPARJD+Gv
         8ujxiaqR3UGnrmq3wnUSW4uEecN1DeyrKa908BXy2MfGCM05z2HB0iYlsEQR9EUgXw2M
         sEpeLBMfoRjszcESOZNdrf2b4uFHYl2R2s4B2S0/+JYUxPrhqDoEGyM1gU0VsLzf/57B
         GHxR5BkZfj+8iQmXHDlnESGY/9GDzfAq+j7S1ZM+sQeScszXn+UuIyIrp0feluS3C37/
         MjQdGecTb0UzvESQIg2LgiBCpffT4GsXjalOQ5GDZZ0yIRfZbaSeLztsnDi2cMp9R2zy
         ExTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4x1u4OsUY1Hjg8CwzXi0d1BV+bViJNaey4X6E6g/2ig=;
        b=oWExLgjo9GWYmzdXwAN0g1lzpC6qrTABYoSw+xNLwR2u5uLo4+UVNwm+LY+5J02c1A
         f1Sg+imiR/VvWLzm5iwYHtkQOa54Qd+FLhkoX+p+3KSoKdKjkYC6GnPbaNmAveg1UOWI
         r2aqn8OC4lN2MnxK+36l88ToSLc8aFb+0Ma7XQMP640rIRwsJOvWm76igMgH53/bWjZX
         oqTZImXy5dvJ1yKafj1+iKk9ahE34/Hv8o5LE1uyPZ/xKlxBYC8g0dz2GHuaPJEX18q+
         0oga+vf/h9jIrUm3NH5H7gBKr6v9d4ycNDJIpaNp0VZYv0uZihxtysUytjeb/u4pGhEb
         H9+w==
X-Gm-Message-State: AOAM531PXn7zqhVGdCHVLgu0ilQzndnItkrG/DJEEZFOCWuhSYVGHG0P
        HLFLtC0EP+ODy1pHo6rYP7ycNVNWtzkRYqjD
X-Google-Smtp-Source: ABdhPJyiXumKp1V2B3eUOxTZDOoycPsr5L36HM9TfTCf3F8oSjFEjo56BLwLeW3CsaL4hQYiHjEvwg==
X-Received: by 2002:a17:902:f68b:b0:148:a923:6d3 with SMTP id l11-20020a170902f68b00b00148a92306d3mr46333869plg.97.1641252096857;
        Mon, 03 Jan 2022 15:21:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m9sm25338411pjk.51.2022.01.03.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:21:36 -0800 (PST)
Message-ID: <61d38500.1c69fb81.d2b32.33ed@mx.google.com>
Date:   Mon, 03 Jan 2022 15:21:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.89-48-g20dd14a89908
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 98 runs,
 2 regressions (v5.10.89-48-g20dd14a89908)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 98 runs, 2 regressions (v5.10.89-48-g20dd14a=
89908)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.89-48-g20dd14a89908/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.89-48-g20dd14a89908
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20dd14a89908f31dfe8b128471203e22e54bb6b5 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d3548916a8edaff0ef6751

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.89-=
48-g20dd14a89908/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.89-=
48-g20dd14a89908/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d3548916a8edaff0ef6=
752
        new failure (last pass: v5.10.89-31-gbc156401c624) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d353f91df57252cbef673e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.89-=
48-g20dd14a89908/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.89-=
48-g20dd14a89908/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d353f91df57252cbef6=
73f
        new failure (last pass: v5.10.89-31-gbc156401c624) =

 =20
