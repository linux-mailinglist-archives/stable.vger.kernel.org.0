Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A68B206A81
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 05:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgFXDXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 23:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXDXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 23:23:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB4C061573
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 20:23:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ga6so528594pjb.1
        for <stable@vger.kernel.org>; Tue, 23 Jun 2020 20:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ldw10+H071A+Pb7VM8M55LP2lBbglWJd75ZRLRWAtIY=;
        b=Xz4vBVO1NnVgUYr9ATnMBKJfwK/HIr3pnI8/Ryp0O6r9nis9FLVpTG/gfVz2J+m9Dx
         lPC5pWbyKlc506THFVDpa7/msq5NejNwmmLunjgidrx9sGTR/QKTufnnebieAuN9KRhT
         VQ9U21IZ5DHM1lwhnBlwZcVLkurA5Xju5LnfvO5clEKRgZ42tB4QLqLNrfCY+L1L74Hn
         Me4UOUuUTmO45REqtD8rpMv94OqolbWDdFQEbd3NOxVFxXOFBztewCsuRYPJr8+A+1YW
         mRt9Hm/ciG53BG97koSQdZPF1ef0XHJf3y17E8D5mJee/IV6aTUmVOt1pMxCXfdH2rA4
         uMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ldw10+H071A+Pb7VM8M55LP2lBbglWJd75ZRLRWAtIY=;
        b=j41XzvzReXUzv52dqFAhOaNiZLYSqLfpfil0g/2yWkszoCFK0vzlhEoPdMMMMMNoVB
         6QdHt5/rx+I3h3BPvl2erJkMVPNF73LZ4bZeY7JR1xk2gcfexmO9pRlB4cYY6++fCTs8
         4JU+RCZ9EnAFnG/It/VpWUGZUMVcWKnQ3+SWoaUuPv0da/D8Ndhf+XLPYW6PKJ/5UWZ4
         4WUvYBg4Rkoo044rA/EP/qIbPg4yd5q2ZZwHesnQgQTsD/1r3uyOqN/DRTqCc1Z1H6eM
         MVAqegOFY3YhOgfY5Hc56EfDep4GQ4hLbtHOeau8YIk25Rsza+qWM6pYY8RV596/URZd
         V/5Q==
X-Gm-Message-State: AOAM530EM/akjuz3KL47wm+F/hNl0d1h2VPx9oxTTzFklcPhxskGIQRI
        rJplaEoCu9HZj/ByFdBVZYMo3od4Fr4=
X-Google-Smtp-Source: ABdhPJzkO/glOKz//YSpB8Uw/CGqEEWdmz+ePwZlFoACPFHAuZS/8ObpmLy2VfOG+EJ9KYtCu/Jnwg==
X-Received: by 2002:a17:90a:260b:: with SMTP id l11mr27758627pje.210.1592969015880;
        Tue, 23 Jun 2020 20:23:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12sm18475920pfr.44.2020.06.23.20.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 20:23:35 -0700 (PDT)
Message-ID: <5ef2c737.1c69fb81.3531f.a505@mx.google.com>
Date:   Tue, 23 Jun 2020 20:23:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-528-g54d0fce94603
Subject: stable-rc/linux-4.19.y baseline: 74 runs,
 1 regressions (v4.19.126-528-g54d0fce94603)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 74 runs, 1 regressions (v4.19.126-528-g54d=
0fce94603)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-528-g54d0fce94603/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-528-g54d0fce94603
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54d0fce94603001c23bb1c787b759bce6655e9bd =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef291642cd0709ab997bf1e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-528-g54d0fce94603/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-528-g54d0fce94603/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef291642cd0709a=
b997bf21
      new failure (last pass: v4.19.126-501-g74874ce1e245)
      1 lines =20
