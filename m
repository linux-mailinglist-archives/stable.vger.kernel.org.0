Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE5B253200
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHZOvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgHZOvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 10:51:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5A5C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 07:51:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q3so1002357pls.11
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 07:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X/qIputJLyqFNsdje+h8GZz0qfux+R7UEhXLHJ/Rw5M=;
        b=Ss43Vx1wkqp0wNZjC8SZKm56T0zaS9XwEMEa6RRhXgYg0BCTowtYzrtyiT5e/qy8qg
         lS63QOD3Dp6HjkZmdnl7e7TX2XnG/UD3/IHlR3pLhQZrpQVakvaGBaXEx2uhc9q0Eyrv
         WrOqxIDp9xdLCftkBwiRrkJBR1DUvjzASzQRtpjWLCOHB3CWFO+8uz5qWiCHSlTxUEV9
         c5QtQNuXTZY2htKnEiI7S5oxKQKqbKskd21lhJ2sbfOKxee+TMvrBaLlysqh6onUUd15
         jixUK5I8S2SJTzTRpu8Zkk11SH/KTlWWth9bX3Fcxrl3TAjGzo8ubE2eUCyYsAe68ahN
         22yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X/qIputJLyqFNsdje+h8GZz0qfux+R7UEhXLHJ/Rw5M=;
        b=ob0fNSVg6AbFql/RxANe0Dt4HgdO3uXf60ylOqhsUJTnxjeoa9ThIS3+xjPSOsqcLN
         P216ofVqHL074rPbtTmuM93Hx+veZ7sTTjyK8fVypU8LKNZoJbL1YCzYYb9MwBKsGyEe
         qpO8FuEunb0bHzLbKWB3r9klMRqvx3bhEnvycz6PIWXNRXkPf3gqonYrpHjGgQ1L1pTw
         r7bRW4KsbRwDNsEr6TBsjlTIay6buiYcVhhfjJYFlWHem5xqPuuo8q/3Q3TXLCy1+jZ+
         x9Enj118BQXZMqfp5yVhjSAKbIdi+0+EXkVCUfYAPQiIP1yGi9AVS5kPW8vI0ZbJReuA
         ky4A==
X-Gm-Message-State: AOAM533gxQOHgkAKF9V6kqRHTDmfxFMcSd6TlH/rwdDkGBvH01JUqmjX
        pnTctLx7TXJvEvozG2O9J70tEMsDJz9FEA==
X-Google-Smtp-Source: ABdhPJxz+WEs266JjFnosho0+6jhWf49RB7LmDx2E7UtWFlGBXf8Z1Pq3hPm8dcHu6ZDg2YOLFB8zQ==
X-Received: by 2002:a17:90b:c97:: with SMTP id o23mr6572048pjz.216.1598453479630;
        Wed, 26 Aug 2020 07:51:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11sm2441319pjy.40.2020.08.26.07.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 07:51:18 -0700 (PDT)
Message-ID: <5f4676e6.1c69fb81.52a27.5325@mx.google.com>
Date:   Wed, 26 Aug 2020 07:51:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.195
Subject: stable/linux-4.14.y baseline: 156 runs, 1 regressions (v4.14.195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 156 runs, 1 regressions (v4.14.195)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.195/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d7e78d08fa77acdea351c8f628f49ca9a0e1029a =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f46421132a542a8ca9fb45f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.195/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.195/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f46421132a542a8ca9fb=
460
      failing since 145 days (last pass: v4.14.172, first fail: v4.14.175) =
 =20
