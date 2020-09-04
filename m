Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583F625E3A4
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 00:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIDWVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 18:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgIDWVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 18:21:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3721CC061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 15:21:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b17so1522755pji.1
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 15:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ek5ZrJVYZ2Ff8B7UoX/MX63uv5xE+SVTaVjEJVs6HLU=;
        b=NAjwScsNScwILKlfnx1gFO897m00IlCOTUUPfXshmOqAHfOXAYVg0less5jYNCjyoy
         XaEoIthe2umvlrd9OoBEIdjm8yUFxd8QWcbdOoBkBPKhg/YGbQErvyp+o0ifg6ds6AMF
         WERGr9alCiVocTkCXy5S4MUkQMnf9qN7+Xe+hYL39Y2+ig09+uLW0jMAYuVppzVVNv+/
         YfWUncx/st75TdW9Ujy8DDov6I0gT+BXPU0sLnGgL6y73weabkI4XDBON6gDFhlWbkzu
         5S7mwvMuKUDAjTQWt6OtRT43gOkKAMbBqVtYRx/wyoAkDgoLH6aGf+WwCsgqQhW8hG/X
         y7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ek5ZrJVYZ2Ff8B7UoX/MX63uv5xE+SVTaVjEJVs6HLU=;
        b=W4xV6QOuZKnfM6BJeqQPfvuxi8/RZWZXHRKbAuNvXtljigp3ux681uXoUqt1KbhMuU
         Z20M0NwYI8p8WAg7br2aidJX7cXzb1lOPK6kbdyFjLfjfvdeVcCFDEnzOFLXzTqbMFPH
         SX/xwdbrYZuK8n0yB1YJaQ/p05PrxZeFS2nGWMvqtcGCJVeKYBOKLerj6T/jvLaIpqkw
         cXz/pYnalCqUpYyRNu4ERLztoXaKWIt3qa7znu5eSiimABM+eUtSIzFa8vsHgg1Se9L+
         omqMFSm2ZmJXYciRqqk/SMvAFAvs59auMmKhPI2w31n3Evd1bSLeoZw+tcyX2IdPzekZ
         Bn0A==
X-Gm-Message-State: AOAM533PdlpOGuwsB9Etrl99zRogaE+L1QJmGP+smYgqgYtW/WF6xGis
        vlwqbSNc27FD93W/iAKmfo70vmDVl6IcKw==
X-Google-Smtp-Source: ABdhPJxxR0XL8HdqZRtAYr1SYJndN+Zgb2K2qJKOCmazKKb8MnHlFw42McohUHibiqMkuetpJxdtsQ==
X-Received: by 2002:a17:90b:3241:: with SMTP id jy1mr4501084pjb.10.1599258096084;
        Fri, 04 Sep 2020 15:21:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l20sm7657228pfc.72.2020.09.04.15.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 15:21:35 -0700 (PDT)
Message-ID: <5f52bdef.1c69fb81.fa376.25f8@mx.google.com>
Date:   Fri, 04 Sep 2020 15:21:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.195-96-geb0d9f7da41a
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 1 regressions (v4.14.195-96-geb0d9f7da41a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 1 regressions (v4.14.195-96-geb0=
d9f7da41a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.195-96-geb0d9f7da41a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.195-96-geb0d9f7da41a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb0d9f7da41ae1fb089fe4290b5292a4c34c4fff =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5295950d42117622d35384

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95-96-geb0d9f7da41a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95-96-geb0d9f7da41a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5295950d42117622d35=
385
      failing since 157 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
