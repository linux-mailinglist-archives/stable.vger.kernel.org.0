Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5E46864A
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 17:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhLDQmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 11:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhLDQmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 11:42:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FDEC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 08:38:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so4247373plf.3
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 08:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pF4k/+Sp494eRF5Lb4yMaSyPm2ABUmfLvW+jZjyWGGo=;
        b=cCoZ7fIqC7ed1Ys3Gdxv5Jfn1EGcfE2sM8ZVYgGrJRF/39CnTQgYJdlm7Gclz9MPxZ
         mnTMwAETmqIbuBkjrmySJiLn5OOt5a1fBC+E2X091GrIRG8ieFRBvxo6dkHSkbqtC02A
         YodrcheLtIS9r1JIOk2+fTb1mUmUvObq39kEU37GE7ushQn+E7Q7JdUjVPdl5DGIRmfu
         dIgYsc57JRD/VlVxZcPu6z1T4MrAUP6xzAjaxTldz5gJoa4O0hWw4dk2IRpKVs27EEGy
         LvfuTA2smg9e0kP04jXBy9q5wRYNtZnMIhDMJmgKrk1YS1czKIby3g6T5g9sMgYkmWd9
         kT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pF4k/+Sp494eRF5Lb4yMaSyPm2ABUmfLvW+jZjyWGGo=;
        b=y0T7CgPNks7YfBQ/SKiRSesGh4lIkmg8h3HDfeQWOXHqC1C5Dq4oV/v96U9/GrLaHS
         OuhEPXxv4UxTA5vJD1z+t4FpdYl3yxb2qC+8/C9kwDh6Q2v94FEUlKk1v2wFSd3ZvjsX
         2N3mMyGgBpcQLTPqAHt9cnSXv8OgMMGPI1B5aheCGx8MrEb1eoFDAJovzKPyDRY3yANc
         oBJsRXqjnWnzEOcJwQ7BvbVYZFvJzjkKyV/ASFn1OjNzyiVnCqeqncxQCvUVF9SwonZb
         45UE0PEVYYqeQsEzrmSYuHcNXohVzkzDwBx5EmtpP2TmYlhPTXDAGSQU2/+xoWSMz4iJ
         d9gA==
X-Gm-Message-State: AOAM532xCuMsVmeTFzTay0XS1AKIxgU9usD0ssyJ0PFTwr7KaeTQ1uBX
        snCzwMYxk+OJMFoWVEcsX6ZUCO0GUgLJvhYG
X-Google-Smtp-Source: ABdhPJy8AcXQkiCBnyMzJsD1z8qs8IHllsS6eyGUC8xg+3OpiD3E1AUuHBTj1YeQhHFmoiN71oWnXA==
X-Received: by 2002:a17:90b:3b44:: with SMTP id ot4mr23821064pjb.202.1638635916538;
        Sat, 04 Dec 2021 08:38:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw1sm8869947pjb.38.2021.12.04.08.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 08:38:36 -0800 (PST)
Message-ID: <61ab998c.1c69fb81.54da8.85b9@mx.google.com>
Date:   Sat, 04 Dec 2021 08:38:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.6-64-g430a6aeb3e10e
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 144 runs,
 1 regressions (v5.15.6-64-g430a6aeb3e10e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 144 runs, 1 regressions (v5.15.6-64-g430a6ae=
b3e10e)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.6-64-g430a6aeb3e10e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.6-64-g430a6aeb3e10e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      430a6aeb3e10e3cf480ef8bac0c7d7eec8f08dbf =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61ab6dd33a492b41c61a9499

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-6=
4-g430a6aeb3e10e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-6=
4-g430a6aeb3e10e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ab6dd33a492b41c61a9=
49a
        new failure (last pass: v5.15.6-12-g53d7aedb68aa2) =

 =20
