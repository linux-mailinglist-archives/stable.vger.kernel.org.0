Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20696325467
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhBYRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 12:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhBYRMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 12:12:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1E2C06174A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:11:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u11so3521511plg.13
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yw04ABUPGBDS3wvJbBEBEQ357kzXP9l7GwjwDbRO5s0=;
        b=d2MQYbxQ1qK2zVu+F8JtEOtLTZyKxinRZDWtk3rvqeRUkff3Rx0uYgrshQD6a1GJGR
         ceGSksAI3sF/d+y9XTZUhS0fGnx9rrLqMjgwTsyGpC0kjSEzHvzL2W0xiVEXVudDryxU
         x+pV7ztG3xrekaqhUwhF/UwK3Co/KZK9eVAaM40OEiPQ1ywxLnAiUJo/xZRU1Ro+jn1i
         OHTBNu5SOglkmiIqSWoYvlLVqHzcSJIUIVdm7EWNDUBcB05Pdke5CvxWx25kt6pKLCe6
         Nc89ygGKwakXah5GZA2JqvJPvMJger6vABv/18pseDuda0BFrUjWpPU8u8uCHhc8xLzX
         mrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yw04ABUPGBDS3wvJbBEBEQ357kzXP9l7GwjwDbRO5s0=;
        b=irz7uaVdN4xmlL7EEAQGTwpAoauOjErgxK9HrAQLDzoHocJ+vb5qC4hqu6aTY+wn7P
         WN2SsbjSG5M5m8p3awF0R8fAL/NxXYG+lJKzFmAhLKLnES1Hv+73qtBZrm2ASE/+TFeo
         1EgxoGjxiXZxVSjhDkbiFbi4qRy9eM3wKFaQUW2uhi5Zv2Ejesy2FM0ahf8Aoz+QwBpj
         EEug/rJp4aGn4FgDQAEZc+adlMEDkgdVGLb81VFz3dNSqYA71yAFDq0oKXQTM3RFHNkf
         vpyW+e9NDrjVHReXA+84ZKGqbxCdsXtNGHCFzWDfuBDHSKNQ7iVrD8zadcoAv5slR7mE
         b0Sg==
X-Gm-Message-State: AOAM53202rNQfEVtzkqGP1sJUjch1pVQDX2X2t08K6BEDmM9gNES4mXp
        wFn+oRJ10c7KqZLaKvFV+52eZJ4+UPghcQ==
X-Google-Smtp-Source: ABdhPJwJSzC1s6JfYNAGdImKcwfCUTgBNARzLmTBmWW+q5aCCLHvCz23XGfw2qEVmCWqwbzuOsxKkA==
X-Received: by 2002:a17:90a:72c4:: with SMTP id l4mr4354446pjk.52.1614273108598;
        Thu, 25 Feb 2021 09:11:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h123sm4749789pfe.115.2021.02.25.09.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 09:11:48 -0800 (PST)
Message-ID: <6037da54.1c69fb81.e9cb1.a6b2@mx.google.com>
Date:   Thu, 25 Feb 2021 09:11:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-9-ge98ce504074a7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 44 runs,
 1 regressions (v4.9.258-9-ge98ce504074a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 44 runs, 1 regressions (v4.9.258-9-ge98ce50=
4074a7)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258-9-ge98ce504074a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258-9-ge98ce504074a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e98ce504074a75070c405546b8f52b5474ed5c78 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6037a8c4d46f0459f1addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-9-ge98ce504074a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-9-ge98ce504074a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6037a8c4d46f0459f1add=
cb8
        failing since 99 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
