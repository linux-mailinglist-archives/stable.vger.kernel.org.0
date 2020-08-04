Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE27023BF3D
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHDSWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 14:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgHDSWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 14:22:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72E6C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 11:22:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z20so2889607plo.6
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wJcJwDpUFiLDt2lbSgs98zvP7/DjFPQQIjP+64ru4aw=;
        b=HvLJLsHTmkP6EruJGycK2bTe/94A6lM6FFgHy0jSo++7IYcYrUSaTrytmgUrf5UcZD
         fdV5nRCeJdkiRCcWkWA94i2Pcbw0u6UPSfzguZZrORNuB3sXkZgQBHnoEiqH/tfM8ynR
         H2qQmdNZVmfKm1He7DXEEv1/NfU+lOYA7akNUROGX1Jlwy84kjQIIVTvFMMynGGz/BT9
         g8lAHyIu0ESh1hRS11nXO8/2z7HSnw5FOL86Ck+p0ISJUXt6iCfYGjid7KKFlE+yNM/B
         ciw/M/Yxi+bVeHB8/sV6uHdZC8YJJ3iGV/lAEvlgnLsNsp9FtqlWrfaEo6/PC3G3fWjH
         PowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wJcJwDpUFiLDt2lbSgs98zvP7/DjFPQQIjP+64ru4aw=;
        b=gO+kgAv2OHrxSbbW9DfoizxmJWZ7Nd9dfFhjO2IocPOK9r6/j1MzIncU3DLAEYFW1T
         MaFYIfEBll3qd2kaT8STXZzW4tclatPNaJxkA8MN4ImBIt8dF1ljGoZivSBvBUmRbmpK
         B9W7GG3ujjMPYgw03VhH33CfCxBqGEenHC+rLE/myDG1waedYmHxq+RK138rcNWgjUMx
         cP8V/mz0C+THcFkF/+DxvNuoIQYHOvZefFafhwIrN8yUNHNzjmTQ70lgDfU6fkDkzOCZ
         swFk6bOjEWBemkJykWQndR63PSNaQXeMXT51qM6BTRkp4KcnyPG0Ik5nS8w7XjASGYaj
         bVAw==
X-Gm-Message-State: AOAM531Edo6XV084omW1bJz9sgFibg0T+hqbqyTo/Ery3SnL848eL7jo
        cmATOW2h9I8NWztSVAW7aEhLALSoaVg=
X-Google-Smtp-Source: ABdhPJyaq9dQCGxept92io1xKRA41nnsNnVUcdLetnsxk8kta8nE8/x51PGy7OzPnlLpahlf744v3A==
X-Received: by 2002:a17:902:aa4c:: with SMTP id c12mr20608600plr.237.1596565343016;
        Tue, 04 Aug 2020 11:22:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm25807811pfu.188.2020.08.04.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 11:22:22 -0700 (PDT)
Message-ID: <5f29a75e.1c69fb81.7c800.ee67@mx.google.com>
Date:   Tue, 04 Aug 2020 11:22:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.136-53-ga820898d10fd
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 153 runs,
 2 regressions (v4.19.136-53-ga820898d10fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 153 runs, 2 regressions (v4.19.136-53-ga82=
0898d10fd)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.136-53-ga820898d10fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.136-53-ga820898d10fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a820898d10fd3f0edc999c46d087d1a170fbd043 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f297564a12892dc3452c1b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-53-ga820898d10fd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-53-ga820898d10fd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f297564a12892dc3452c=
1b1
      failing since 49 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f29733040ae9ceeeb52c224

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-53-ga820898d10fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-53-ga820898d10fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f29733040ae9cee=
eb52c227
      failing since 3 days (last pass: v4.19.134-105-g62c048b85133, first f=
ail: v4.19.136)
      1 lines =20
