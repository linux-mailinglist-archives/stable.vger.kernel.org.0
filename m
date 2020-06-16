Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4291FBE5A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 20:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgFPSni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 14:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgFPSni (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 14:43:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF1C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 11:43:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a45so1413817pje.1
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 11:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZfkKHE0SxWre83DEvMptOMYyqSmKPeJBCFrthYxGKsY=;
        b=JDVTwa9qk/V7MVizNIRKpTym0HYk6ZjZTQNKvRuySqZ6xBVCB0d2S/FC0RDbzg98kQ
         AqQ4Qsr0qh7ccr4IJzvVCvUyoobfCX2lnDSvdUgmm1C/S/n53Wmek8J0kiTHJk9MqQCV
         tFcHZkR03T6WEL23sl1A3s95aqgp9hGdUbOP8/uitzQ5qpokHneWJ9IQZjE38ix3S084
         bvkW7IfD0MFWXxwfXw0gl1wRHsJqmwLyWgt0fykRedZz4IBAZt/7W3n0PPRvcrrwG67p
         o7qG5Vu80tkbu5nf9fGNjd/4w2u0xT3g/oywDJLPr4xAEnHuzJPjDXcQVLek3aidf2sY
         LWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZfkKHE0SxWre83DEvMptOMYyqSmKPeJBCFrthYxGKsY=;
        b=aHG4zazuO88Dmy1MeuL15WEUU1afOHh80o3D86OjAHkctYFau4DtO+El10L8hMguHv
         7Yru+QfRdjRRMDbwGcW7wFHv+bLxmbDy90BYVxuUnK7Oub/rRb4M5T4AKZu4WsUD1A5G
         kr9W3uv2GNaVwTR9rjShFIfmzi39cqrxJ9uFxJI+jhMfSfObEI5tap/86DU2+YZ7zQ91
         O0BaubtdDAWH1EXw59kv+32GC6esyRufLtpOne9vbmBFdm1uOZcOISodHrRdF3dI8AIl
         pYlT8+WGDv3Ua+CPFcX1drxwNEng8veNzvRFRapg20MQIL9vhpBVhlNWCIwOC4/8FSqM
         XUew==
X-Gm-Message-State: AOAM5332Q97kD/mBSoaEPiTJvpxwzb/Yl76peSvOBbux6lUNfymjk4FX
        0MtTZo7UQbHdLgp5ZAAOmBsSksQ+TNg=
X-Google-Smtp-Source: ABdhPJz4phvJG4JFXaHI0MTU/YfAoM8Hy5+xbjs6Oss7e5+BH2a6FvTkdgd4BgSxbOxUQNA8hxXMFQ==
X-Received: by 2002:a17:90a:1da6:: with SMTP id v35mr4145314pjv.177.1592333016963;
        Tue, 16 Jun 2020 11:43:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm17636619pft.127.2020.06.16.11.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 11:43:36 -0700 (PDT)
Message-ID: <5ee912d8.1c69fb81.2b3e9.95a0@mx.google.com>
Date:   Tue, 16 Jun 2020 11:43:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-83-gedd70df95815
Subject: stable-rc/linux-4.4.y baseline: 35 runs,
 1 regressions (v4.4.226-83-gedd70df95815)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 35 runs, 1 regressions (v4.4.226-83-gedd70d=
f95815)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-83-gedd70df95815/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-83-gedd70df95815
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edd70df9581599a24d32e781fb85e08e12c20164 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee8deca6493dd6c7997bf15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-83-gedd70df95815/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-83-gedd70df95815/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee8deca6493dd6c7997b=
f16
      failing since 6 days (last pass: v4.4.226-24-gd275a29aa983, first fai=
l: v4.4.226-37-g61ef7e7aaf1d) =20
