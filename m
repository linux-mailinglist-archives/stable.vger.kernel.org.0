Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B974524DF0E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 20:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHUSEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 14:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgHUSEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 14:04:12 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E6EC061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:04:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x6so1349205pgx.12
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 11:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hMIylkmjk7pxLNyF9/2AsPK/VDefknEdUjkiTdrZfFw=;
        b=1VMKCi58abquz+PgfaFIJ45DUJUaA59KaNBYp38DPBNZvSywG0nDPOZ/LMAuNeZppc
         ouX0qs+l9faFJ6B4ftoH7ahpECR9QUR7pijxe3diTGf5IIKTMy9a2Wj+KhxOQ3jM/2qK
         VULo/InvJ0FZe7je6+9YP+kwGgjNucXjKWn4MNlWGXPYonDkUKlFUjnTI7HhX0Wd19Ng
         34bo4F0UcnrtpXMkI2iqUiJW8MUi1JRMC4N7x2I9iZiHDkU7aSS/g25AU/7kTvfuStHY
         LZrmvIdOK5ZIwtNtcUhEgusQgIYAHqoNpTDYEwn0PZ1Mmcaquy5IJQsuBsdFSCwRrot5
         075Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hMIylkmjk7pxLNyF9/2AsPK/VDefknEdUjkiTdrZfFw=;
        b=hz7icQ9ujqijgGyrbrjfACh3rOhPdv7ka7QjgCuD8dopOji2+Xcc0T7g8Fo+8X9aYa
         jMEr1vr4XGzNXPpEnpnaST6QMvLvyzcLCyWxcWm1xwcxMjJOuG638rxXIf73DLBh5wjN
         8nyt5XoDVXOiNq44zEEhzpOCrCOd1VH+0o71N46z1zOkwMKCSM5i6aS05dO3DvoH4wmO
         HhcxnpR4Fky5cLaizxEUka64uVXYjGfAVtGM56ae7VXs0GxoYif+e22h4zNFg7ICikC4
         smU6vOPYB/XT7PS42Wng3PKp4t4fVUZ1hg6Vg0lLUAZjvWrwHitgAcqJi+1KMVVM+7BX
         fGiQ==
X-Gm-Message-State: AOAM533DVw/RjYqXzz6Nj5B6wQdEFIlznhYn39x+eXWLb0HvOwHkCJsR
        ZllaUJ8xZLWj/tuAXfpchzmAoCDvHSQvcg==
X-Google-Smtp-Source: ABdhPJwbhol+h6iJfM+ZZuAlK5a6Y7zo+JDWz2MG0Ugdlk7XQ1qBl9HD06+zOEVpBo0rGfqmkQXxxA==
X-Received: by 2002:aa7:8683:: with SMTP id d3mr3480336pfo.232.1598033050424;
        Fri, 21 Aug 2020 11:04:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm3436108pfj.35.2020.08.21.11.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 11:04:09 -0700 (PDT)
Message-ID: <5f400c99.1c69fb81.22fd8.9560@mx.google.com>
Date:   Fri, 21 Aug 2020 11:04:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.60
Subject: stable/linux-5.4.y baseline: 172 runs, 1 regressions (v5.4.60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 172 runs, 1 regressions (v5.4.60)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.60/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      77fcb48939fc863d9ba9d808fac9000959e937d3 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3fed066a0e5fac609fb439

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.60/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.60/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3fed066a0e5fac609fb=
43a
      failing since 64 days (last pass: v5.4.46, first fail: v5.4.47)  =20
