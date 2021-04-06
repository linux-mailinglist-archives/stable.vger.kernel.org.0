Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5650354B23
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 05:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhDFDQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 23:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhDFDQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 23:16:36 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FC8C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 20:16:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g35so4620877pgg.9
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 20:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKZyCDgS8IQMYRHbaupkEwllV97UEzA293unWVkZ/Pw=;
        b=xhNduyvMH23C0BtEXU6/RijHfwRo+1VWE9bVLzD+27I6WVpI2KlwAjGrGKK2WNvbo0
         IefBNmcE7P/v76ckMUI5kwZoQCDaEjlIIjtFW+dR4MKwCAf8tdwEZmOXPaws02ye248g
         j/7+o73WQ/n8s1IA6M0M22FLKqI/CfFMvoWwlRZZTKSjkyeuGxa1n4CCGl5r3dG3Qbx/
         sxjopZGMVLuzJNW5y8jH5+XoVt4f56I8cbvkBLrPwiyjJuYHPA8S6/AN7oS8KRMla6ez
         dV0wgaNlgId4mPTTKw8XK9QWDyNhqe40TykIiS9MCA/YSxK4zeev6uSzaN52C6JKV3zH
         yDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKZyCDgS8IQMYRHbaupkEwllV97UEzA293unWVkZ/Pw=;
        b=SuENToxKFS05kxGCy74o0WIrZVQzHBneRASfgHfFngf02h3CBnT59MawvRMNneow1q
         BQrCpa+OcEsYeyxz3zWNfk3FPszutsun3uPHS1gSgUex4Kl5wKPi3yoKD9a3Bl6gOrz9
         agkeDbIvc9MpWEQfXX1dr5ffzfUZswskiIiavcPqf2tCMxd8cbcFIR9K3I0IY8Q/HBET
         Zc0NX7eDCdETOXXlhukl7Pi+Ty0Ku5Z4u5DqhWhupmgzuIVN7Q3HqmuJqFuP+NrpaEWd
         L0J5Q1NfvcBatJq2zYkNRVlGWsN2nfZAP+esmTCc4iyGvR0UWEgYVLFXB1z8CvR1uJoC
         qN9Q==
X-Gm-Message-State: AOAM5314XValDP3bKfFrr6rXIK78sJ/+Av/hFhx794EjOKhO9kIwFSJt
        +N/Hke9q0pGu7DLeR3sQR+DgmcSrGpVQYw==
X-Google-Smtp-Source: ABdhPJxD1xygrtNTvswGNrESs8bmxPnlNHAPwZagDqNiKwGExlIX1fTj31SuIMOe1k3Y7TRy212a9g==
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr25367274pgs.165.1617678988943;
        Mon, 05 Apr 2021 20:16:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm726771pjm.30.2021.04.05.20.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 20:16:28 -0700 (PDT)
Message-ID: <606bd28c.1c69fb81.d4dec.3538@mx.google.com>
Date:   Mon, 05 Apr 2021 20:16:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-126-g11366c456e3f1
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 1 regressions (v5.10.27-126-g11366c456e3f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 145 runs, 1 regressions (v5.10.27-126-g11366=
c456e3f1)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-126-g11366c456e3f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-126-g11366c456e3f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11366c456e3f19bfb1148ce89603636b56ce2c79 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b9b8f4c0d123835dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
126-g11366c456e3f1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
126-g11366c456e3f1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b9b8f4c0d123835dac=
6b4
        failing since 4 days (last pass: v5.10.27-36-g06b1e2d598020, first =
fail: v5.10.27-53-gcd7f2c515425) =

 =20
