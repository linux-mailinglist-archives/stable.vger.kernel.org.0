Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C7B1F1069
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 01:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgFGX2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 19:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgFGX2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 19:28:50 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9A8C061A0E
        for <stable@vger.kernel.org>; Sun,  7 Jun 2020 16:28:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x11so5923419plv.9
        for <stable@vger.kernel.org>; Sun, 07 Jun 2020 16:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b+hwi77dCEdEZMUR8Sd67Zs/g6uWMMwLw4SyXCqcis4=;
        b=KyLwvx669MOiANitWECyUfjQI5xLx3NjvMWsyqHg6zVByU3NVqgmgS7Vqdnp5O041B
         ieQvweU5yulhH80MvlbDfiHYNhP2kbxpE4Ga+yin9d2O8nXFPbILJf/UdkH5XOTcgx+u
         hlw1t3Ii8nGWRh8lT8G4pIoyw0k+oyYfIE0SOkXAk4hrwB5MwCcsheRU0NI3o0Bq1PSR
         KDihYKXRvP83SQFK2aGFJPi5J0FrsUmXPym2GXfhnev59xo29jA0qlVr6WRl/AxXj9Di
         gwxJogit6/wI8Ba3iTRvHmC+AWNwuGk4gFw37BY8rNX96vUJESDiaYHG6J+7Kd1twBoz
         Mitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b+hwi77dCEdEZMUR8Sd67Zs/g6uWMMwLw4SyXCqcis4=;
        b=qdAmlr6fYw8HvxCVFAGpSV8xJUUT+PXwluTbJVviUGpFz3UN+UMX5lkgWJp4zh1Njv
         czmjWeX3+elUYFKg7kGJW2J10DrdE178oYwciNu04Mbm/i26bvGK0sG2ZNb5i0i6oa8w
         N26cUskMHJOT8A6zFC7pZOwMHM9WBLHPLipM7FAXISUUC1wuS8BA3pFzBCkNSpSF+/as
         7FMNQs5CXz3Fbx+sJZv6MtQbSldxL/ITv9UBUXIZCLiJ7G4NG0TLHeH/1aHp5DltiH4w
         jRJsQbtpUiWyitBsQbDSelRKlvNyHcbXAAw5l1tq1x1TkCWIi/qBgKE+D7lrEdL7kiSA
         auww==
X-Gm-Message-State: AOAM533z+YHi/4S7Ol/RXfnRfp/n7HOmqUoRAjfcTcEcyKm0A7rSDrzl
        Q1Ncf9+CSGSNyYIT+2+q63vQmc5g7Pg=
X-Google-Smtp-Source: ABdhPJwGt7oZuPeHA6QkmNFGsEakAnT/glcdbdyj2w0NsCQ+a1O7253Arb5MYI4WiV76elbH5iOboA==
X-Received: by 2002:a17:902:9f90:: with SMTP id g16mr18849214plq.146.1591572529745;
        Sun, 07 Jun 2020 16:28:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2sm5402022pfd.125.2020.06.07.16.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 16:28:48 -0700 (PDT)
Message-ID: <5edd7830.1c69fb81.36198.660c@mx.google.com>
Date:   Sun, 07 Jun 2020 16:28:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-30-gefd7e05248bc
Subject: stable-rc/linux-4.14.y baseline: 46 runs,
 1 regressions (v4.14.183-30-gefd7e05248bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 46 runs, 1 regressions (v4.14.183-30-gefd7=
e05248bc)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-30-gefd7e05248bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-30-gefd7e05248bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efd7e05248bc70b1954a1d40a255eba3bce686a4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5edd47db37b648784a97bf0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-30-gefd7e05248bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-30-gefd7e05248bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5edd47db37b648784a97b=
f0d
      failing since 68 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
