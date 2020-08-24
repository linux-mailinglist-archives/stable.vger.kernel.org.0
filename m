Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E13250B2B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 23:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHXVxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 17:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 17:53:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47FFC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 14:53:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q93so272116pjq.0
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 14:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y9K2p2InwrwECZkJXGyk5YxNp+7stHlXIHH2n3gjqIU=;
        b=snUNYq05EBu0FmIfR7Fj+tqccN724nxHTRGfDOaPNMZrdLYThSaA4CSI9AljYG1ArP
         1UIXc9QB5ueSFjwlQJzVkQ47TlzQDpSvFjPJ3ghjEMQerj3jsxRBcCiItRtKFYawM6IH
         eSjVE/V8Df1qebNCkhJTp4277BgRqtCBYCppfcMjyGZPXaOhloTR4/2vK0OKtbkU7eSj
         ERsVob8DAgBhoQjd1A2TjwE+3EKV8aBFpmI/7MtmZ++tOz6jk7+WSWj8GE0cUFehbum1
         efePzKe/JSgVb1ywyJCPylLUftr6+Ancp62zOfdmggf3HeFXHs+BUYFtYK1TU8xX/Ii9
         juIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y9K2p2InwrwECZkJXGyk5YxNp+7stHlXIHH2n3gjqIU=;
        b=dVig8yLeKaA4wEJEVM/8SJU1sn7XMheTCF0/miPWbx87yd0ue5FEoaUBt4W0np4cx6
         /CUL2hYLTnDnnCYWR0dBcczI8i3py7X7vcN+vlUVWAaTP+hUytDzRpFN2BPQljwGAwZr
         WiE7YWDaMYzHScHOEmQq7Io0S03lvBW4BCjw1D1WrC0wSqChk8LixPg/cDrrEYKFvROO
         /b3NgjpXPPtxO5HuW4/MzCeAQ/DX/uIl5dwdNY+vQWgDdfjbqXuDgf1nlWOvXz8eV/x+
         +ku+KO0Q22jx9gUAF/A331/Uc0vQZB4ugF7K43yWWJaAclDgKHjNGmF/74YJMRO8H27N
         QclQ==
X-Gm-Message-State: AOAM531ATMk41h0UI+I8MmcputT1eL5CUvjuPvElVDovjCv4HTex4xv/
        xBityRLxBPL07yHR5usbw5o8mPr/b3Im7Q==
X-Google-Smtp-Source: ABdhPJyWCVMQb3rhmvx4uQR5MyegJu3NHZGKVUGuhG/fmJnZnnFfyCFU6dUjFhnL63RwuG9m1LarLw==
X-Received: by 2002:a17:90a:468d:: with SMTP id z13mr1006212pjf.105.1598305984177;
        Mon, 24 Aug 2020 14:53:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na16sm445907pjb.30.2020.08.24.14.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 14:53:03 -0700 (PDT)
Message-ID: <5f4436bf.1c69fb81.fb2c1.1926@mx.google.com>
Date:   Mon, 24 Aug 2020 14:53:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.194-52-g376e60828efb
Subject: stable-rc/linux-4.14.y baseline: 143 runs,
 2 regressions (v4.14.194-52-g376e60828efb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 143 runs, 2 regressions (v4.14.194-52-g376=
e60828efb)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.194-52-g376e60828efb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.194-52-g376e60828efb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      376e60828efba537a502fdb54d35e2805852dbb4 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f43ff4d083d07074c9fb448

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-52-g376e60828efb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-52-g376e60828efb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f43ff4d083d07074c9fb=
449
      failing since 31 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f43ff5a083d07074c9fb45b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-52-g376e60828efb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-52-g376e60828efb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f43ff5a083d07074c9fb=
45c
      failing since 146 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
