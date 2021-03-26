Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D46F349E76
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 02:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCZBNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 21:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhCZBMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 21:12:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFC5C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 18:12:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f10so3496636pgl.9
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 18:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ub72061VLPAv3ycjcG3e+TFGYgX2Hmhr8iWRF9Vs4OA=;
        b=hayN3nPgfQA8k2x2Ec2h2d0J+ehgjmwaIzgMVG4IbwhWXGAmSrVsAERr+ZVIMvGrOI
         5Uo7mXbPgL1ikiBhQgZK4C6exOpGPaVIaB8KQjJ4FgMpLwIvv2RGifcsQE9wnxqOUykq
         JmkGd3Yi6knG8xrjYRsjGTz8mYTtrblYnd11OwQDuQsrOsImCyewTuVa4dO0JVug2zi7
         8goT7kdGV/ekkRRiqcN6ZJDKp+lFJKWnMwGgDJI+YdzJrWX5qJgFfzbHIiRBW7ubTDjE
         TbLeMk3qRjwdXuDUmfZlFFWPkDTNjwzDdcGeXi+8Cgoov8uKyAAlCQ4BjvEs/ZrqNNEd
         5CZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ub72061VLPAv3ycjcG3e+TFGYgX2Hmhr8iWRF9Vs4OA=;
        b=nGbZ1M79lquaXX3RqUpdQUdC6ZZ4TLbEv2IQQVp4ZrZlBC2nXATElx2RpKNLhyWcRc
         k8jlKFmSNtYCkZdKW646U4RK3vBi5ngpd3MbAP3mrK4TAnievLY7g9aF6q9FXhr82f5s
         6c2OVLv4Yjk6T6neRysFHa1uA2jQrWGPf5Gu0e8rVaoJJ07tMDnxJ+4PwUjn7N2unwnm
         2tXVuAPvwpbvLZSvqQrhVqB/f5Z56PpGjAbYnaxy2nnUuJVyimJwtDX0r2sSGp1EBff0
         3a9nJAbWvI0cCTZATsxYN0LyU9IRhR55t8iCk7ZryOF26M9Z8J4VE1ZL7TOLc3SF2pFg
         ohsg==
X-Gm-Message-State: AOAM533IB+usyoYHM1k/p4aYJOo/aTSFOepRPp+PYLc7DMByB31inHh8
        HcdlO7GyQj7/SNfy5A11GxL37SPTjuIKrQ==
X-Google-Smtp-Source: ABdhPJyqzDSvAsfZ6X7hUEN6IVj55u9NgX3d0671B37v09EGIG56ZZPx9kC4phQqhagvu6K6wYr3eA==
X-Received: by 2002:a63:224c:: with SMTP id t12mr9694804pgm.289.1616721161913;
        Thu, 25 Mar 2021 18:12:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm7208218pff.40.2021.03.25.18.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 18:12:41 -0700 (PDT)
Message-ID: <605d3509.1c69fb81.9e2d9.238a@mx.google.com>
Date:   Thu, 25 Mar 2021 18:12:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.108-38-g40f4265ba0000
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 1 regressions (v5.4.108-38-g40f4265ba0000)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 1 regressions (v5.4.108-38-g40f4265=
ba0000)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.108-38-g40f4265ba0000/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.108-38-g40f4265ba0000
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40f4265ba00005c1492ab57bb9525ac64d5c5d59 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605cff53bdaf0f8f53af02e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.108-3=
8-g40f4265ba0000/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.108-3=
8-g40f4265ba0000/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605cff53bdaf0f8f53af0=
2e7
        failing since 125 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
