Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A632F5251
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 19:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbhAMSim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbhAMSil (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 13:38:41 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD01C061794
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:38:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y8so1559423plp.8
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZxqWpnBbh2sCbCjLf9dWnp45bgINKHWRB6SVxJsxiDM=;
        b=aDu5bp8N9AiDUXS8rOEp4QA7mjDcAGBw9+9jqm0EbrUSneQoYdjX5QyYQu7Zwd3kBr
         WFc1DEkDlrf9vuuLeNUIxK5ojho/cfSyyYsTnWcKSjdDEkaWRd36Ci6wsvWWtY5XG/Qc
         g9Xl+mNn6YhXYOwP0Spqegnl3XbuwTpF4lETKBnt881ivTg3jjX3TVEKoLjw5HrfcUSM
         Fk3K1qjC4TODjHsayHrb/vVuZsB2c9zw/TNEJzRQyBCr807xY3r3K+LVMIQa56A1KfMp
         xh5LDxZbg9ei8WBqV+YYlb2DVuFBFgBug5nQG9TG44w+tibkvI7ZmOh0AGIHD6uRzkqZ
         ZFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZxqWpnBbh2sCbCjLf9dWnp45bgINKHWRB6SVxJsxiDM=;
        b=gD1uS++ttJygbtZnWfoaADW0vAv2Cess3HTV9xuHlVLADVpGPbdlVDWc0IR/p+BanQ
         /ryppRTuydHXxGEx+TW1JX6jVnR95gHoqIq/vKmfNb3meX4dVMfXXA3LsjxoyWUFU/al
         ALqKVjN0uRZZG36dH60VUDUaAWEuNRf/h5vEW7XSb+hzGFEgjoJoXo/HdxsBWcl6+Sa6
         DJQTHZd2t+04iW5eSEMrfiYANQHdXMGuv/H/vLquFcgdNSwitaTkIOV12AMFbAR8eZ/V
         w7A3nJfynF35ynn8/8N3QwrYhNrHCsOg6oTw/fJQC7Ca+YpFD8nGQIeMcRQZFIlPyA6p
         skJw==
X-Gm-Message-State: AOAM533wYYD1mdu96StzlXeyLxhVlvAKEEDAZ/27M4rTimiUYDh2I7qe
        P+nhdFn6blVLa8eCsFFUC/JK2CrahbOn2g==
X-Google-Smtp-Source: ABdhPJwyA8LnhveeNmFnk2fDIxS3RHprgcXFAEw4/ocOPCyMGs8feKCvccL1MPuUcODjJe6eUCBlhQ==
X-Received: by 2002:a17:902:758c:b029:da:a6e1:e06 with SMTP id j12-20020a170902758cb02900daa6e10e06mr3511433pll.67.1610563080566;
        Wed, 13 Jan 2021 10:38:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 77sm3492203pfv.16.2021.01.13.10.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 10:37:59 -0800 (PST)
Message-ID: <5fff3e07.1c69fb81.9b685.79b6@mx.google.com>
Date:   Wed, 13 Jan 2021 10:37:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.251
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 82 runs, 3 regressions (v4.9.251)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 82 runs, 3 regressions (v4.9.251)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe   | gcc-8    | sunxi_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.251/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.251
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10bd1f305f5f9945bac76a6ddc5371ed2d159bf2 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fff0ca9c864a7b7e7c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0ca9c864a7b7e7c94=
ce5
        new failure (last pass: v4.9.250-46-g6d954ea12bd6f) =

 =



platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig       | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fff0c7fcb84a2302ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0c7fcb84a2302ac94=
cba
        failing since 56 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =



platform             | arch  | lab          | compiler | defconfig       | =
regressions
---------------------+-------+--------------+----------+-----------------+-=
-----------
sun8i-h3-orangepi-pc | arm   | lab-clabbe   | gcc-8    | sunxi_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fff0da510a24e5099c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.251=
/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0da510a24e5099c94=
cde
        new failure (last pass: v4.9.250-46-g6d954ea12bd6f) =

 =20
