Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A2120462B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 02:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbgFWAvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 20:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbgFWAvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 20:51:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50FDC061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 17:51:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a45so475643pje.1
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Umve0ZLjjSu1XfhhASd43rdAytF5YaDo9E3+IbQWG6U=;
        b=qEy3/Ia4yLm7hBo/GrPFEBKZaEppxI5zwnzNWZBqpB8zkyKpeaQsYjbUog+7F7+EnO
         NpAan3W3ZDjDbbDKkJ0vczxx43jXHxglxdJkBZFM4EhBLZWqE1/r+DCvfegjgDU0+2Bt
         WR/MMKGfzJbP2J512MY79LGU74cmNBPHE7hPnSEvwxzCVHhPfIVA/6pIR4UsNlOfOuDh
         7EBZwgKfxyrq2DzoyM9iNhv2Eox+wNwm4KHlHFoUtvepQAIL8HrSfsPVvAV0g5Xn+1+f
         nY6Ja6Uje0Q4OXItz7gAkpbEl9u1TdoVxYqwmvyoTEt02IKWJjHTnkqTMo9NoMTgoKgI
         nd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Umve0ZLjjSu1XfhhASd43rdAytF5YaDo9E3+IbQWG6U=;
        b=a63nNhmkfn4yckhBzUSH7x184teRVM+LHjycaY/uM9M+0cvjw22ybMSAsW3C8FmR0W
         atyi5UsLzPImUE0siHTJ9Mfn4OjfDm7kq/zglTcs4kwlJfzDvYXXB5dBiVb2iQ4BYgGM
         w87JdJHu7m/JwEIjSjAquK7Q0vJXIa3ihmpxB4GJQr+t9OvAyVcXP26BAhaz3tmTILRG
         SznHRFuSKoM0ORlUWJpVPSmsDafW1HWuxkJwh0W7WgV4EumXJdcaoh6PkVaZG2gfb1hq
         EOAJxKWD2tofLdgiS8/kov8vOwt+wZiiG6Bi1fMFIHnWcm0oX7WcffVpq08e55wPr4ZK
         5pNA==
X-Gm-Message-State: AOAM532f9Ay5+Ug1jMFyTeBdS4EffAwi6eJvl5iu2xZ4D0+4Pdy7sh2b
        UiLfYTsaA4a0KLCs1kcxkdwpHnJizxs=
X-Google-Smtp-Source: ABdhPJz6P7Uwa+5PqKWQtgThbfut8mh5/dh7OyFKprtiFSMPy0H+EgTh/1pO5etmN/KdBkzCeFjmIA==
X-Received: by 2002:a17:90a:ad87:: with SMTP id s7mr21904066pjq.225.1592873465973;
        Mon, 22 Jun 2020 17:51:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 191sm15495236pfz.30.2020.06.22.17.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 17:51:05 -0700 (PDT)
Message-ID: <5ef151f9.1c69fb81.6608b.f113@mx.google.com>
Date:   Mon, 22 Jun 2020 17:51:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.183-352-g94c75fd4ce50
Subject: stable-rc/linux-4.14.y baseline: 72 runs,
 1 regressions (v4.14.183-352-g94c75fd4ce50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 72 runs, 1 regressions (v4.14.183-352-g94c=
75fd4ce50)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.183-352-g94c75fd4ce50/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.183-352-g94c75fd4ce50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94c75fd4ce5001a81d9febfccb9556e2340a1f6b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef120e488fb87bc7597bf54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-352-g94c75fd4ce50/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
83-352-g94c75fd4ce50/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef120e488fb87bc7597b=
f55
      failing since 83 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =20
