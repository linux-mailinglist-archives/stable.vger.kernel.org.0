Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F80253974
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHZU6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgHZU61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:58:27 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87062C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 13:58:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id kx11so1437494pjb.5
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 13:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ddpyci65ax7TmT4eBx5+eY/1/l+l+8lL/j53SqyZMQ8=;
        b=U3ZFb+nF3wdyo2ZfNrIwCqGMAiIFZfcUbe9VI+iff9HAkTncaU7LrVf+sPwlVSfLOu
         NNpfEJBtHywP6pKFoQSzODKLI8HFClryFt5MRkz2DOBr07hlEEqkn1C8Gia0AEQ8+T0B
         aN1iUt5Jsp4r8NTu/W0GaK0SE8DKBqUy5kpbL7+MB/yWdcRfzJz/ue1UQRAYE3sA/6JG
         VmrYrYlTVn1txST2SLgcPk0RTQRF0++jHGz2g9SjOKc8yKWOjUB5TivT1+5BZnDe0acc
         na/4fKRa59c5GclbHWcq23CbYdhcPHsQCW/GUcCnNM/XRlpwPYxph8E/j9YH/7y9uqTc
         Df0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ddpyci65ax7TmT4eBx5+eY/1/l+l+8lL/j53SqyZMQ8=;
        b=V4EWjHli8SDYNzLCIpOzngjWsPc01+vbUWpY+narOOxFMuV1l5grm2nEv+HcWnukSz
         UAcAHvOMFkjI6jtwpJRht0pL0RIi8PK1yDUNL7zxBRGUV1SmBOzxa398CMOz2+wVrIRu
         YPstFRNLRO4Y/0VxPNdO6dr52SXDd2Vjb8ySO0kagU9RVq2UU3waLcQpTlLWa5K62RyB
         bRj9MIbrs5Vblge6y9IGfR6iFRAN2PJ96mZ9LAa6MalCr7XU5xaltCKyuUZokxb3fV/+
         HBdTn5I3rwag6dztp4oMqJqJxGVZugg/OwuOs0HDNIfPtYXk/xWuQK1rAXaE0eyXddeu
         djUA==
X-Gm-Message-State: AOAM5320AwiTzOuFIdWmHUNDzEWV0F7R+nZ81GeeCNxVXfFVpVTOHfzT
        r7so4kZreJKHCSuaM8bcUM7tzAkQ+t3JCw==
X-Google-Smtp-Source: ABdhPJzixQinv4nxRr/eUO5ki8/nv1bwNpP2nw85PRpOS+4Gc3Jde2faeUDU8TY8EXfK1cjLnZR1wQ==
X-Received: by 2002:a17:90a:8687:: with SMTP id p7mr8032675pjn.50.1598475503392;
        Wed, 26 Aug 2020 13:58:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y189sm72055pfb.135.2020.08.26.13.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 13:58:22 -0700 (PDT)
Message-ID: <5f46ccee.1c69fb81.f120c.07c3@mx.google.com>
Date:   Wed, 26 Aug 2020 13:58:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.195
Subject: stable-rc/linux-4.14.y baseline: 156 runs, 2 regressions (v4.14.195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 156 runs, 2 regressions (v4.14.195)

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
nel/v4.14.195/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7e78d08fa77acdea351c8f628f49ca9a0e1029a =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4693f042a800a2469fb490

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4693f042a800a2469fb=
491
      failing since 33 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f46929f4a07004eec9fb449

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f46929f4a07004eec9fb=
44a
      failing since 148 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
