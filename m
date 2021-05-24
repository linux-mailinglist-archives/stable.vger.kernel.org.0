Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD15638F292
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbhEXRw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhEXRw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 13:52:57 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCAAC061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:51:28 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v14so17911778pgi.6
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TDndFkHPe7Gtam3xA1OGR4KZFQKcHn6sb/X59kaCFSs=;
        b=A6tu5twWM0o01MpdhgmYeaBPyc87wgLf7zODcFxouL8cENWixMMT2P2n0dmx/94hRe
         XDr68Bo9bmlqOJ6UwiocYM2eLQ+kL95jMMinvVlUghhKZUEkabysVVA8SV0gV0zn3gxU
         qF2HTn0AU4YoagN5Gan7zikg2UDg/zLRFfraDsTu52AtfPa60wUsc3bTsyYdxz/cUMpk
         y/uFONEUEusCXtcw5bX1zUx/OYxCBGaDEOdA4u2npnxi6DiN33icRgKrpLR1xPvQfaYy
         i3NiDkuiHrkjR/9ZadYIeOdtwDMK+b1FdM8OY5fNV/6jbB6a5g+SmqPlsrnHNk8dp0aY
         YLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TDndFkHPe7Gtam3xA1OGR4KZFQKcHn6sb/X59kaCFSs=;
        b=n6IrTEOgY1ur1vfupOQOuz7Ae5A+EiBZgxM6HwIkDUNikZ2NGRV9G1Vwk4edaaukwx
         oZECPi2wcT6fbDQapaWVYJwDUoWxSXAqUPsR2/ThxNpLUJFohgOHvDYsBrnvRaVBfEAp
         vkq7rlH/Dm/BtmTLG2iANNcuyxoS4CqcfpM7LBJkBr3qqQAeg52B88QPjSEQd/GKxn04
         jjFO9XOKGNaogKnO5fsRJ2dE0Gmv1CIJSXpUYQKE8xAudQ6BrWt4M+R3XrL5SODRrDv9
         37OwpE4t8NDgR/x2+Z+Qp9NKrerQUzYdhmy5CSsa9IJrO/Yuk90YFn3paZAjTjmPT21s
         PEsA==
X-Gm-Message-State: AOAM530kcCKt4PSQWWYKGOBa3L9bogHMsrL09lmMm+/wDdfOXXERtJYi
        ekzHRRAjvLZHv1KZwhqR/dq40P7TtSdOz0LI
X-Google-Smtp-Source: ABdhPJxb56raEvGqi1fIhYTovuGShMZSsX4GM23sp5UgJK6Xo9Cmj3x0PAsK7SI+cmRnjjT0DSQ2Uw==
X-Received: by 2002:a63:982:: with SMTP id 124mr14838990pgj.37.1621878688373;
        Mon, 24 May 2021 10:51:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm102259pjg.54.2021.05.24.10.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:51:28 -0700 (PDT)
Message-ID: <60abe7a0.1c69fb81.5125b.083a@mx.google.com>
Date:   Mon, 24 May 2021 10:51:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6-127-g65dc22920eb7
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 109 runs,
 1 regressions (v5.12.6-127-g65dc22920eb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 109 runs, 1 regressions (v5.12.6-127-g65dc22=
920eb7)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.6-127-g65dc22920eb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.6-127-g65dc22920eb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65dc22920eb7cb3a9c967632b5ebe1d62282b8de =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abb77817213355e9b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g65dc22920eb7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g65dc22920eb7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abb77817213355e9b3a=
fa9
        failing since 0 day (last pass: v5.12.5-44-ga4238f2183a8, first fai=
l: v5.12.6-95-gbb1483055945) =

 =20
