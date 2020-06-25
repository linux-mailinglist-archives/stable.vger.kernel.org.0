Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7FB209863
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 04:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbgFYCHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 22:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389070AbgFYCHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 22:07:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A98C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 19:07:11 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u5so2273657pfn.7
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 19:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kWrq0AkVRyASv9ef1ifL9E0TdZPdjvKR15aibJZ9tq0=;
        b=jBxNdJ8nc/Iy6qYsVOWrhu3GYtOFG3nnawIVie1EiikwcOxtMJBMKoWR/tilNWyUG1
         +RdPOBZLZ38IYhyTBhbCOAmp4B/yynYCjPl5PL90F02jZWsR16E77FfTZ60vdXD1Ud53
         b5Ef8MJ57kalvkfB6+zVXiJOjalu4EY88AY/htS4+r0jcEIL2UNwpa/XErQy6PTsp1R+
         MplcZQ82/JTo4eYsrivTFnQ+4MHmTuM7wZOZ5CF2N+itPT8ul2THS87CPxvB7tBOEo4r
         pOuQRozh1QQZ2Dg94DabxlHHceg8wZSdbhoODpIpG2E62P7sFC1fnkwh5jMfWDyDVivz
         hrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kWrq0AkVRyASv9ef1ifL9E0TdZPdjvKR15aibJZ9tq0=;
        b=S5DwxjhXLrM1lEvvjIPTe5qZ+fPSxvVcS4Ip9JRuLsgSA+A3VCGzhgM0/xlq/ZTgPm
         SUjfDWg5pAmSsFiWdSqawkH+zND1RU7sxECIUFcTId0EcUIcJ636+TdTfl247tu1ReNa
         2UJSi4K1kxxs8u8jVVpiFvxsKRVbNPPZP9CGk6B/IZeYKn5f7yKYoXMMd1Wbyvn1OGN6
         P8cQTRK30ZbMWj8j+iMVH7r8kesDMY33QTV+Sf5w7c02znol67EFDIIx+jM/lM5Yyxv8
         JEu53k6KtFFRrrQK+9re7p5t/vbVKHOwVRLoAdIwTIv+keCh0KkqF3SWCj4G7XQkcpnT
         DXGw==
X-Gm-Message-State: AOAM5324pwH1N/wxsmKtopso5Z/HAMhPkiTMcDuUBqzvPzx919dgFPy8
        3bxH+L50FXsJLhvAA8ZVNuJTv0fTTk4=
X-Google-Smtp-Source: ABdhPJxWgJ8yVKy5pg232t9f+53JY9rmmLPl/p84wpPpgg0oga3LpvAKhP0wy7KqZYcMJ8Xo4fZvDw==
X-Received: by 2002:a63:b90a:: with SMTP id z10mr4151183pge.277.1593050830949;
        Wed, 24 Jun 2020 19:07:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15sm18013186pgv.45.2020.06.24.19.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:07:10 -0700 (PDT)
Message-ID: <5ef406ce.1c69fb81.ee483.597d@mx.google.com>
Date:   Wed, 24 Jun 2020 19:07:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.228
Subject: stable-rc/linux-4.4.y baseline: 44 runs, 1 regressions (v4.4.228)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 44 runs, 1 regressions (v4.4.228)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.228/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.228
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddb4a7b3a08a9a2867d9ca9d22f12d28e72b5075 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef3d187451646e0e097bf25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.228=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.228=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef3d187451646e0e097b=
f26
      failing since 0 day (last pass: v4.4.226-205-g47365a65ad5f, first fai=
l: v4.4.226-219-g2ff318e63314) =20
