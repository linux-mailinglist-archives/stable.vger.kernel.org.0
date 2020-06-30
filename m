Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F80920EB52
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 04:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgF3CKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 22:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgF3CKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 22:10:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE99C061755
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 19:10:45 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id p3so9200396pgh.3
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 19:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RvFwVvKbR2iSWU7cDsOlXUNOLi04J1Lxxw/hsYfnMZU=;
        b=YH2u1u0/mWqkMKLsMlJXHEcSSd/+hDYWcC0U7iRjHD243qLOuwUlYoC9OU2iMte8UD
         rNAJJ0N+GO4xJXuXq5ZGZSC7gdsJcODMH/oHOI3NBrVMRBiuWbwWD1Msb8f63abRN2BM
         QEGYgj4pUAhN6nSEK8cvsdZuwTm0SPK3SqXCREMcbCYFDtC1mKR6bTu/jMVzI8Ve+nYR
         iW8L4ohLUShscAd395O9lpnZu59UlVQJ2fXWVDO7VNkzNKA/yO2QZVaS0AG9bYSU9Tjz
         /UwMdVLrzgB1c239uTdWUUNBa4OCG0i6/dRKkzgcFCXoNO7jjhwpMJlgHDkHKoqxlX+p
         pytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RvFwVvKbR2iSWU7cDsOlXUNOLi04J1Lxxw/hsYfnMZU=;
        b=IY/Selv5ol8yCEfMi5XVuKlyMxw89zgGWTNsm89zFP/FhKN+aX8Jix/FujYmZegHF2
         jONkvneG7dupbScCfREfDRyDPqCmRN2vTCzXu9J2xO5fVSFpZ1X0A7Fn10qoh6K2JG9G
         v7YkXA1Knowk5hmubbCQQjO6iyZRcF/Ml62cy/b6UDGYRRTQz4UrGbfbWGod/8CIltSC
         R1hTZz0boR3ka/aPrNuGP8n/cwZY4WHVJ0fm1eYXIYqof5CSQKTWlEn7OFbkvBZAUw/l
         BiII/9oh2bwPBhZwA7X0avtcB3qIS3uOqimyj341CO5nbccP0ocn87tK/EHNn8roOflg
         mnlw==
X-Gm-Message-State: AOAM532C83njdELsJBfhqIw6CamaH0krp8WBRd5EXysQcMAKVp9FZrS1
        IH045RB/h8FAWwPbAMd3GzD/rTO7qPw=
X-Google-Smtp-Source: ABdhPJyiVfbCis0VPoaxOzv7XpiyURne40ruUYdzKEQBZgz7zptAo6LnEaa2X8oGlxeYd0tdYNy8Wg==
X-Received: by 2002:a05:6a00:d:: with SMTP id h13mr11015532pfk.288.1593483044390;
        Mon, 29 Jun 2020 19:10:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12sm806470pfm.158.2020.06.29.19.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 19:10:43 -0700 (PDT)
Message-ID: <5efa9f23.1c69fb81.5e218.375a@mx.google.com>
Date:   Mon, 29 Jun 2020 19:10:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.186-78-g27e703aa31e4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 78 runs,
 1 regressions (v4.14.186-78-g27e703aa31e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 78 runs, 1 regressions (v4.14.186-78-g27e7=
03aa31e4)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.186-78-g27e703aa31e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.186-78-g27e703aa31e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27e703aa31e48c3ebe64c4d8665ab5cea76eac29 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5efa6c06664844a16d85bb36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86-78-g27e703aa31e4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86-78-g27e703aa31e4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5efa6c06664844a16d85b=
b37
      failing since 90 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
