Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88C32A5D6E
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 05:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgKDEyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 23:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgKDEyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 23:54:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0B2C061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 20:54:19 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o3so15496980pgr.11
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 20:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=liN/svGNnWHHnCaksxHR859HRonT/axfUtAi3M0v8yQ=;
        b=kPB4UY4ybwaBNza7arb+tRmwVAao/8siSdfjtoQlo10FkxaaBRlL0Cy22l7vcAfuj+
         fSM5Ca3reLLUQsIW3fr36U5K6w1+W3ofH5ZYzNZt/ruIENUSZjhbIbEw1ffaZnT7tGS6
         X4POt8H9KMliMjnB6RqAVk4Fg21JhoF6/P+Jq0IcyPmrmt4UU0jENyFlFb6AhJgx9Z7d
         6nHgsAvYm2exq15vFO/LEzGgBybAxSM81y/IAZEJDj3RMRR46hOt+s6E8AvQG8w77iMU
         aahteR1/ULtQS2Z0QwbzGCgDehVfFXEdoJBFlicch+Nvl2abVDtAFb2UaCX97jjc2ZJp
         LeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=liN/svGNnWHHnCaksxHR859HRonT/axfUtAi3M0v8yQ=;
        b=dSI9HLmf5Ges3OnrGNjLjXPv/twCJ/X4+d2n03RG96CA/xy5N7am115cyOerpGBMCn
         nj/QEg1ffLLSE0fMttsTx57kj6f7xjpzvBXVwaC+0BBguTjDqOSS535c4+T2LCXMKrcV
         b1i7H22gvopmU5NTk6n5prgG9vSEgmEpeH3mslCNdzm92XvSqjbftlBO4OazchlisAQc
         M6On0GLov21NqgCis0kO8ur9kyQxjNwI9QxiJ5dwDlejWnJy5h3CYIIqFj9Ca9GwZpEF
         ei4acYJr8R7Aej6L6lOf50J0S/nZLF/53YQS9VEI/3jOwNEdvZbxkd/XF8/tUq4K04dK
         V5Qw==
X-Gm-Message-State: AOAM531AaN4HsgSo6LCsQwNXqO0pbXjnIEYgQKau4/1tOnv3jBMknmnO
        dEkSJUQTgMDS5LxWTSwbPAg8wchnv3yzxw==
X-Google-Smtp-Source: ABdhPJxFMnlSVvGmslS4w7FPl90BSXCDhW4eQYwm9wokKvcyL/8ZftlpY2tkUFM547pRppBloVfzVw==
X-Received: by 2002:a63:f74c:: with SMTP id f12mr19321609pgk.434.1604465658155;
        Tue, 03 Nov 2020 20:54:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w127sm724796pfc.172.2020.11.03.20.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 20:54:17 -0800 (PST)
Message-ID: <5fa233f9.1c69fb81.7c886.2997@mx.google.com>
Date:   Tue, 03 Nov 2020 20:54:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-93-ge31779e08142
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 128 runs,
 2 regressions (v4.9.241-93-ge31779e08142)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 128 runs, 2 regressions (v4.9.241-93-ge3177=
9e08142)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64      | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 1=
          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241-93-ge31779e08142/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241-93-ge31779e08142
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e31779e08142cbb44e6da285d260ccb4f93e4ffa =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64      | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5fa20116e99f7c7a8afb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-93-ge31779e08142/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-93-ge31779e08142/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa20116e99f7c7a8afb5=
309
        new failure (last pass: v4.9.241) =

 =



platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5fa200e2dc4af6f28cfb5325

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-93-ge31779e08142/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
-93-ge31779e08142/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa200e2dc4af6f28cfb5=
326
        new failure (last pass: v4.9.241) =

 =20
