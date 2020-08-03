Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A963F23ABDC
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgHCRxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbgHCRxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 13:53:49 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AA7C06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 10:53:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id r11so10668625pfl.11
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tnzGobhCKIIvv9bisQPCLx2qb+nIDQIA3NOCA4e1u3o=;
        b=yywKC4elRD8RLg1PIPZg3CBLYu0UEY4jD2tHz9ZoY6HyOtBs6w3Xhbt8/lJg2Apaiz
         qe2xFdNU+Pk/egNeRKDH5W8Tj5tIMh18HAlM+s5sh8uszQXAgFTL8CvDtoVMYwNjZdms
         QIJCqkMafBUccScx6SaOxAuPpKoCYpzI86y2K6CCJ/rU2ZiZThNA+NHon7RG1TmNTP8I
         Q2WVCivsu4O9yWCORtqEqQxMMzL2mmKdp55zyD0GEk40qfhqUA7NeNoD2TZ3VF/+ddLt
         zMPo/IM6DLso9X1xvfhSBpxHfRQkxaMz9b/aL/Z+uBExzddCLUeH3r6g/tNYpUbrW/Hb
         6sMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tnzGobhCKIIvv9bisQPCLx2qb+nIDQIA3NOCA4e1u3o=;
        b=pUzo3giURjFwCtECiJGC1TQw7L9vt7Gi8mB+DyRAeq6PLQ21XZIx5DfG0nDe0eSi3c
         aj3/uNT7SnvDOyO5WtxhBV02k12ivCZc5EaCwsaDuMfJ16VLCVIqjm6oizj9alfB5ds2
         gwdXzY3Qg1p7QF/iv+MuYFWA2pw13xJ+Dewbq42V/BueCqF1KWR6CUhBgctxaUjYiH4k
         siU7d85CKMudQjRIqYHY0TozIjKfIWidC3103IJyw4ad+sldiLYa0D9Xe+EJg9c4xY89
         7lMVkG2adD9qAD0BAwWTSENxfWteezNI8D1GbVEAXfDh8tbiKVVa41dMwvueJj0DgOGo
         kB+A==
X-Gm-Message-State: AOAM530cdU0XvuVMr3IAKfjTWiHcIFMFYUcKHNxpur1Zq4bl4qHX1Ide
        9nUtBkkqKdJPYza7J3qUrrAm004vKsg=
X-Google-Smtp-Source: ABdhPJxkF9VDyFJZYfQ4n/kJSykLb4E55sobnSj4rlm0sIZO6Hg3YFiDZSHuXx79R4ICzDWt1ooPfw==
X-Received: by 2002:a62:206:: with SMTP id 6mr13176053pfc.228.1596477227695;
        Mon, 03 Aug 2020 10:53:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v22sm19933880pfe.48.2020.08.03.10.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 10:53:46 -0700 (PDT)
Message-ID: <5f284f2a.1c69fb81.f0091.23b7@mx.google.com>
Date:   Mon, 03 Aug 2020 10:53:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.12-121-g759db541b69b
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 132 runs,
 3 regressions (v5.7.12-121-g759db541b69b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 132 runs, 3 regressions (v5.7.12-121-g759db=
541b69b)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
 | 0/1    =

bcm2837-rpi-3-b         | arm64 | lab-baylibre | gcc-8    | defconfig      =
 | 4/5    =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.12-121-g759db541b69b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.12-121-g759db541b69b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      759db541b69b8501f780ad6aefb99c104a2fdede =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f281902530f4cd0d952c1ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f281902530f4cd0d952c=
1ae
      failing since 17 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
bcm2837-rpi-3-b         | arm64 | lab-baylibre | gcc-8    | defconfig      =
 | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f281674fd85dbd53d52c1b3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f281674fd85dbd5=
3d52c1b6
      failing since 2 days (last pass: v5.7.10-199-g3d6db9c81440, first fai=
l: v5.7.12)
      2 lines =



platform                | arch  | lab          | compiler | defconfig      =
 | results
------------------------+-------+--------------+----------+----------------=
-+--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2817293242650f9b52c1d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
121-g759db541b69b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2817293242650f9b52c=
1d1
      new failure (last pass: v5.7.12) =20
