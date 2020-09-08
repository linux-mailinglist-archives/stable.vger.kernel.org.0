Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDBC261A50
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgIHSep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731498AbgIHSen (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 14:34:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3816C061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 11:34:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t7so41685pjd.3
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 11:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4VvXTx6fOh2h6ltXJGm8iF8O0mJkbaeaysYlorVqa8w=;
        b=a/ffGmec7eCb1wEtjsD3+KlGOxIMX9h1pftRiccCVmGOnqPPlJQ+VVFk7eHMZHbcty
         FVariET2i7FvwH2m0r6UQgaU5C38RhfPH9+8Y4+Zxet/o5DWBCEETeUogtZo0taClJEf
         yTr7QIC7A0Qhg2uJ4USDhCAq1meSaQ17d3hvy07XQNSctQOxhxxevjRkVS+G/2cHBLKN
         uTbpCQZWRCyTFvwwyhMqyDUkEk/Y35O8ZFtihClAo1esXo3f0udN13Vu7uggpHFfNvrC
         LNngyPy2EeTwn9q8v/gW82R4VsDfFLbh5+XqTil2lOyax0HnKuLcG8IxmjBPz6O8pVYX
         yOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4VvXTx6fOh2h6ltXJGm8iF8O0mJkbaeaysYlorVqa8w=;
        b=nEuQ002rxTNOdAUEtsqUYWPYa3OMf1lltmZvMGL33hHbrFpanF9MVDRhDjQ1tpshMI
         cn4Qv+O1Fb5JokvoPeRXQLGfZombVs8m9ra9873VFqqboHjhXeM0i94JTKWfWhwFwqXC
         ZmieVhDRmEweWRpKo8FyZl+YUqOjnkDa0cfQliv13Bzm/3n4pvazXSiwLSP52YaiOATp
         7q5PbHtuH0uqaQ7g3RYMwuTAEwh1GHP1FW/WxPyJTEPxoVLWMcf2xBPl+wgWEWB2gEZz
         kOzUR3j6CnvmZCK9I3TddlL0U7COBZDBlCskfG9zaFV5xkkPQNDZv3YEDjNT+AdQr95C
         Y2VQ==
X-Gm-Message-State: AOAM530VL1TWDVz3y3fMPkeaBMCLjJXf9TCLpcoFx2OXtfQqqwbvNWL4
        MbI3r7941YGtPwaJtablvHMXMdBa4SMfVA==
X-Google-Smtp-Source: ABdhPJy2gQN+5YzYAy1uswUNcPmEK1QgnuBAVTbAZjqb2gPU3W2NOv2a7m/+B/EWp8/OrQ0lGEdAag==
X-Received: by 2002:a17:90a:62c5:: with SMTP id k5mr174916pjs.100.1599590079002;
        Tue, 08 Sep 2020 11:34:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 64sm121588pfz.204.2020.09.08.11.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 11:34:38 -0700 (PDT)
Message-ID: <5f57cebe.1c69fb81.22d41.0643@mx.google.com>
Date:   Tue, 08 Sep 2020 11:34:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.196-62-g7caf56a727ec
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 111 runs,
 1 regressions (v4.14.196-62-g7caf56a727ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 111 runs, 1 regressions (v4.14.196-62-g7ca=
f56a727ec)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.196-62-g7caf56a727ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.196-62-g7caf56a727ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7caf56a727ec99b29ad3e6b57e5d7d7b8ee2d940 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f57ce3478e07a2d5cd3537a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96-62-g7caf56a727ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96-62-g7caf56a727ec/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f57ce3478e07a2d5cd35=
37b
      failing since 161 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
