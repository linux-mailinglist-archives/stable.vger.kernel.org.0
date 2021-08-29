Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3F23FABF9
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhH2Nil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 09:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhH2Nik (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 09:38:40 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77F0C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:37:48 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so5273073pjz.2
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 06:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XyZC8Pg/REZ0VWTIoF7TVMWJe+XkLXRoZ3CdtWYExD4=;
        b=sjZ336t+UXbJYVtI9HUA2cNBipNKNMNKDEccgqMapRZEKvC1Ayl3S8Gk/16ztm8pxq
         OFmqLUv1Nhn0BxmkoOvg9UkwAzD2u1FhOMCtQkiYIO5N7WnBUGbmx0xuCXs5sUVsBycZ
         76vb+xmXGUQaCMgoo/BeCoOj3/1Sn9BAnquP/YJ5TcWqo3R7+dm5Xa9G+NkzX6+jA8Ls
         Twtmhppjmvxf1TrhzcheBW5+6UH9bC85ePiryrWr+l8YHucXXP2xgWwtHG6wDcOrKTxo
         FKdyee9Vizlh4zryUFX7jyDSS+qISvNQecW/+bjYfiUsBSz098/gye3kWMJ83FCqlD0H
         30/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XyZC8Pg/REZ0VWTIoF7TVMWJe+XkLXRoZ3CdtWYExD4=;
        b=bc8SLXz/wMOaqlnlRkimKjmdnQ9GTvO9ERAkaYTmZvW9GqL7Gg+dQ0zmqZPeJ9ViZK
         cMTeXNTGxAdeC8Vz38WYyRH2yPHHs+1LgG75KINrp08U0yiqQDOUWXuIceN8J7/boNTb
         hb6hvVFtV17jZWdTvpRmHAfn0okAYQQRRWKjqnePQeZqeyKt6ygDcNVuVC1G1xKFcQD4
         oD0KrUKZGu1wbnsKwgyztvxu/zXZ7hFvFNazN6RhFOaWns8rFfpE8cvx+WNz77drRzSq
         kjaOzhQG4eRG6UWgLRkmDYm2uR8Z1imdwDzSuwOxEk9Yp3At9oTBacmksGGbQDep5GaH
         l5zg==
X-Gm-Message-State: AOAM530vji7k03HhgTz1qGT6SRMlnmeSCLfFRhkfVowIjOQdKzgenccG
        jhVkmNiLZcKwvlWn649z33feHkEYlc4WHq36
X-Google-Smtp-Source: ABdhPJysDSxCw+3R+yaYmB1XRQwz9Oqbh5mdDc7ZI+fgKE0Ko4ZIXzoUylXhC0XlL75Rx9t0QLhlWw==
X-Received: by 2002:a17:902:aa06:b0:12f:66dc:be7f with SMTP id be6-20020a170902aa0600b0012f66dcbe7fmr17679635plb.9.1630244268287;
        Sun, 29 Aug 2021 06:37:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4sm11634808pjq.20.2021.08.29.06.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:37:48 -0700 (PDT)
Message-ID: <612b8dac.1c69fb81.af93a.df49@mx.google.com>
Date:   Sun, 29 Aug 2021 06:37:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.245-6-g90f882f2bebc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 123 runs,
 1 regressions (v4.14.245-6-g90f882f2bebc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 123 runs, 1 regressions (v4.14.245-6-g90f882=
f2bebc)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.245-6-g90f882f2bebc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.245-6-g90f882f2bebc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90f882f2bebc2b2626d3648a15cbad3f3b272ab2 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/612b5beccfa36225138e2cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-6-g90f882f2bebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/b=
aseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-6-g90f882f2bebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/b=
aseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b5beccfa36225138e2=
cc3
        new failure (last pass: v4.14.245-1-g0e289a8b5c91) =

 =20
