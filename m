Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75D25EDAB
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 13:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIFLxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 07:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgIFLxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 07:53:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA105C061573
        for <stable@vger.kernel.org>; Sun,  6 Sep 2020 04:53:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x18so3190508pll.6
        for <stable@vger.kernel.org>; Sun, 06 Sep 2020 04:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YhvL8UNpVAoKtstz3dYyyXOpibE99qXl92GSTBsefJs=;
        b=UW96yJrrrKvgszyY4PVwiU0IOzmj0xLiY7j5I3whYE0r6jU3E7dTNRACHmhUBRTFtt
         r0cdA6pWLHY1dW1RvkQybFc06TwpK05yEMsvnQ/GoDcLDkk1Y6IueipWbl9L2+Tru8OI
         mxtEe6Pl+SUNEHiU6mYExdiQukotel3YDKhuF/522DzSQtuDuUFfAEmRXWLh4MMhwAMX
         RquBs5KUJMhYmJpwOBuAWB9wkG8fr3gTeuWt1AUSY6w3lxzV8h/ihphgWsfNbFjwSLzh
         4hF6Me/KxLP0Chh6eMa9bfZVI+NXuMqoazrTQOYVF3JvRLXBKtWyGzvTdAHI9PzvE4iG
         ySkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YhvL8UNpVAoKtstz3dYyyXOpibE99qXl92GSTBsefJs=;
        b=Nx82ChVO5ne82WUbfbBsbFOO//u6Xe4RiaqyxKS8M+LNkpQ4d1EI66rhMEQ5YAWmgB
         vRt2Q4DgEPSF9FmFbxm7bQP0pT3kNpfzmUhEXdBUv3/403KVyfX6UkTJ1KLpuPOFZHJd
         O/dd9dW/wUI5IaSkDnRwQxk/BM3BOT6PCBq0t1lYzy4tOZH11Do0MylqBofZDmsdRmkF
         e/X3KQ6vPShrzEwpKqU/hbda1Bu31ViM9NG05rEIzhGx+73z+2xGvD7869902MDjkKb2
         ASDLHuoR0Ugf5a3fACOtGI91DjKKwbCAnvu4dXo9JKbYOIYExSj3k0g9Wa+uSpoXgXH7
         5urg==
X-Gm-Message-State: AOAM533Mye8/7mAUi7EASTQRTOSoeT5CVUjdTf96cwISgzjqH6j+/2vj
        94LWYHP/AspNRxNB/yjglHYHMHiscxPvVw==
X-Google-Smtp-Source: ABdhPJydn/5Z05Ca4xy+uGrM9lqqp/6C9516GNB5LiKWJbGhOwBVz1vD/hyReYSxBnolM6z4xG7keQ==
X-Received: by 2002:a17:90b:d90:: with SMTP id bg16mr16008396pjb.199.1599393188075;
        Sun, 06 Sep 2020 04:53:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm9667418pjq.3.2020.09.06.04.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 04:53:07 -0700 (PDT)
Message-ID: <5f54cda3.1c69fb81.4adfe.6c9d@mx.google.com>
Date:   Sun, 06 Sep 2020 04:53:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.196
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.196)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 129 runs, 1 regressions (v4.14.196)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.196/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.196
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f166cdcf8a92fcf85524f2b5526cb28e16f0a60 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5496b4bccc7ee471d35392

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
96/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5496b4bccc7ee471d35=
393
      failing since 158 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
