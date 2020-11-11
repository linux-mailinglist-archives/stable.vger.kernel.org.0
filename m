Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C8E2AEB36
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 09:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgKKIZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 03:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgKKIYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 03:24:53 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D57C0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 00:24:51 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w14so1164349pfd.7
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 00:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9RSMpXhRkqBZpn9y0ecABbag1Zso7fmg5svTp6QPOkU=;
        b=zUuN+VGFPQRFYJpVB4NnG/f18WpiVBq1fOE+opvGX32zx44iNHOC0FYCISqzrBYdej
         Xq54qxAVx+L1dG5VRNIgl58iYwoU4OuCJaO++EsYP3iOra8JQAl2ZuAqRH+f+ciq3dV3
         WbIFgL77IXEr9tiD5h5DUAI7sUcIBPiw1zYJirVJos4mgEmrNfU1dIsdjAdzr1i8bl9P
         min4GkroAok7OrDmU7yD4iuJHB+so6Y1uyN3cWndwkttGdL4AqgMXdIdxtvpAFOdI8EZ
         ITanZpAJJxAXnRN9yq8Qkohvhu44IuBWwzRfCtJJuK5FGpFXTl6AkDVXylP6ZzPz2amC
         YnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9RSMpXhRkqBZpn9y0ecABbag1Zso7fmg5svTp6QPOkU=;
        b=kNCRMDNIeZzVE9rt0B6+RSmlI9PnXd5vPEOcKhi2ibWGP8ylCMsL7UWwJgpxW5Fnga
         pwBBGOFQIB1oHkL5xJmttPh2zzPZ5Z8ade0ZO/vOcZ9pUkJ4UMKbh1Rk1oIp/vPBUFUM
         SM27do5haVEd2z90RUaDwXUot1XceYn18tSeTg87AkNIuzZHKyZRcjxU3/8SHW5uDuRb
         XE9HpGvT7xSZT+k6FPkszv7P9Xy9rVuf78eFg5iooLBflYAjP7d2UkEefrQ+/cVCMyJB
         GP9ZeyAldKNfwHELqKog4nq5oW/LUK5+y7crtVDTK0EuEq4fxZoXo/zGdg2Ik3gx79w1
         UbEw==
X-Gm-Message-State: AOAM532bDL9hwAMCVmd4DBitYdPNVQVn9Cv8Zq2czF9BrgGA8EwhRXY2
        zTuPNQGg7RUJJ9MT5AKEN1NfbLgjsC3KcQ==
X-Google-Smtp-Source: ABdhPJzy/WER2rToNh8VjtAPgBX3OqqhT2c+qumNORTfN0W712LAAZEHCUbLJn5lF02wB/QydmL4aw==
X-Received: by 2002:aa7:9abb:0:b029:18b:5a1d:b729 with SMTP id x27-20020aa79abb0000b029018b5a1db729mr21021702pfi.81.1605083090615;
        Wed, 11 Nov 2020 00:24:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gz15sm1487249pjb.34.2020.11.11.00.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 00:24:49 -0800 (PST)
Message-ID: <5fab9fd1.1c69fb81.3049f.3b33@mx.google.com>
Date:   Wed, 11 Nov 2020 00:24:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.243
Subject: stable/linux-4.4.y baseline: 120 runs, 1 regressions (v4.4.243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 120 runs, 1 regressions (v4.4.243)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.243/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      04d24799676ec16aef54082a7f826ccee35dade1 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fab6c488267486ba1db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.243/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.243/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab6c488267486ba1db8=
854
        failing since 0 day (last pass: v4.4.241, first fail: v4.4.242) =

 =20
