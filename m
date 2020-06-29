Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE0220D81D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgF2TgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729305AbgF2TgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:36:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F70C03E979
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 12:36:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d194so5392512pga.13
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 12:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e/HMOviLYr8L9cgPpZGKv2xtJsCyhLSDLFrqjXg1ed8=;
        b=f2LzTC2a9soz/n8u11iBQsNgPS2Tuw/oAI4e+4+x+MkaMSYAZMEjILbhPdxgA9CSdv
         AC40zc+ygp0gfAhEGA/QV8immr/kMqJpcIIX/JKi5Lc8f7vxOdQYEvwpD6ibPMxa3ZZ1
         Y1zFFgiJiep2eB7eB1hnTOEzy/5hFpTKr9wPg9j7zUcEyXJcOsyTKtGyULLKHckl7KR0
         YFDdL/7P7Ew1QqAE0cwEN+cKzKu+R9KfHGC09wKeGla7S/BLuzM/1i1X2wo/fbY0T5XD
         SNca60JF0V54Wr9p/ATj/OQDPVrqYcwIxRbX6AykL2u0oA2QgSasY3t53UpBJlxUXvLj
         3JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e/HMOviLYr8L9cgPpZGKv2xtJsCyhLSDLFrqjXg1ed8=;
        b=HI9+8fvl+rGEp4GjsPvcUWlFkhKJqHDZPZ4a+pvxtx80+oKf7Dssc15W30VsTZKI7l
         J5c7IU3IcTSd/Ks7XzD1Wj5rzfXatbe1O+C2lOcWZ4YJRBpf/m40e8HORDzUFbpm3xsr
         3bVybFfIClXYiTnCXisu2vbhr/d+e5xUJCcWuW4M9i7r02GrnyWaRzsOZsqImQ+bE1mR
         Tchzer+0NDVWxVmyuOdiUIuqZopK45zaxZfFwGwBUI7OklWJpu7OqO+RemdwhR152l0T
         VGFv4JkwQrTSbdkz0a9YfztrO94hSmRARQiwr//jT82i4ZhBTbOKVH7X3mucnD8szEJD
         UlsQ==
X-Gm-Message-State: AOAM5302ixTRZVySsj1lI0METOvcJzbfs4/mwpkjkhL1Bd/KJChuujH8
        0HB2O0Un1nvN7YOPYAC+riXXe1MLnfw=
X-Google-Smtp-Source: ABdhPJzb6RJpiu+WZIUG2MsmmQJHAxa1ZpkII2l5bkTn0TSpB1WmldTHABexX62e5Z23d2MmyBNc8g==
X-Received: by 2002:a63:b915:: with SMTP id z21mr12231587pge.145.1593459369076;
        Mon, 29 Jun 2020 12:36:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m1sm316120pjy.0.2020.06.29.12.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 12:36:08 -0700 (PDT)
Message-ID: <5efa42a8.1c69fb81.e2303.1091@mx.google.com>
Date:   Mon, 29 Jun 2020 12:36:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.186-76-g332dde51480f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 63 runs,
 1 regressions (v4.14.186-76-g332dde51480f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 63 runs, 1 regressions (v4.14.186-76-g332d=
de51480f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.186-76-g332dde51480f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.186-76-g332dde51480f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      332dde51480f772588d72dddeaa821587464a758 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5efa0e119366773c7c85bb47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86-76-g332dde51480f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86-76-g332dde51480f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5efa0e119366773c7c85b=
b48
      failing since 90 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
