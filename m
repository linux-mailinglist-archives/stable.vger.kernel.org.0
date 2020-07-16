Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32F422243E
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 15:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgGPNsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 09:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgGPNsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 09:48:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4E9C061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 06:48:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l6so3893912plt.7
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 06:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZEhNuGc0BSG3aQwW5OtqOsBcnHhwP41mEmt9aqqKC0w=;
        b=m13JV0sLZVNsA2/Q100BpO7+1C/lKlfYpH87G3OuWNd9Xlx9H8tEp+nCwvu3pvLntQ
         mBDWQbHwu63jrVh5wcicxfwqTpjSe54fMVDOP39TfoIHqJFBYfda9cCdTS0bC2yUnJlu
         6HUiL6Cr7a7r6IyWDIczqe7CaHaq23ZXl1ObEcUah6BB1DbRRvrJeR1vnJcsxryiyuNN
         Qf2BF0Vk+IUFj9M5NnbS2bN/eAuXCCgAW0l2nq8pT7LV+kG0Su2U0b7edSI24KyHs51u
         Xs8+RE/oH65DcgdcwpZQRKotubp3V98DnnwvY76dM4na1PQLk+Zvk9BXI8LTd5yN1I5N
         xOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZEhNuGc0BSG3aQwW5OtqOsBcnHhwP41mEmt9aqqKC0w=;
        b=FbkJCjf9CFDd4TJ9FUi+nadNKKhwLMxsn0MqF70hWtuFmj99z789j8lDzuAruitwLR
         6FDO84mJTjh0nmMQag0pgpAc7gUYEY/gbaHD0aD80/fBbYdsYjN2wauxeQrlWaWh94e8
         aHPl4k/EhtUQj9fPgsQOI/WjdnnATeihNLnJUc62tT8PKCpoXxY8izuRMuaycKqHQDl7
         mXsRsd8phtepkgb81B7TWsuETFpHo9OJHhPny9AwlB0+WYAU1nO9m5G3p8ELBWvJiuAF
         DHkZSMSqc6ry+BoPps/kN9hrHuJQbGmYPuCeNS6Bd04aNKqJGXAnUrrFiYfBLKJ7CWaK
         /Qig==
X-Gm-Message-State: AOAM532tJ+XZjfDdYM5ea084U5Cr5g66223qj0F4syP2VvhBYJrzfBR9
        ZQfSWI6RVBFCh0AM0uZTNNwWW5pjDCU=
X-Google-Smtp-Source: ABdhPJzYop4X9HNRDEbfsBphJQlcgKS9smf3dtlWeebrEnSeUsIBPYZ586qoJN4vwV5lym6Ss5JTyA==
X-Received: by 2002:a17:902:b693:: with SMTP id c19mr3657058pls.102.1594907332105;
        Thu, 16 Jul 2020 06:48:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx2sm257061pjb.16.2020.07.16.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 06:48:51 -0700 (PDT)
Message-ID: <5f105ac3.1c69fb81.749b2.110e@mx.google.com>
Date:   Thu, 16 Jul 2020 06:48:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.133
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 82 runs, 1 regressions (v4.19.133)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 82 runs, 1 regressions (v4.19.133)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.133/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.133
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      17a87580a8856170d59aab302226811a4ae69149 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1018026c11986cc185bb35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.133/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.133/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1018026c11986cc185b=
b36
      new failure (last pass: v4.19.124) =20
