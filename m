Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8134746282C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhK2XWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhK2XWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:22:32 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E6FC061763
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:18:58 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n85so18538619pfd.10
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PfoX52k1vwrXAyW5X+GUTTvxeW8UlTOpjx8Y+u1e+2g=;
        b=bBo9A9Hetv2QMxMGJYXL/3U0GRh9memW6wm0cHZY8c/uC6qp5FiipGN6MrcSwl8/RJ
         o4F0edDL6W7GCRSQXh7ctRPAz5gki163NYIrzf8iunxw8Hr7heU7x6FE7FmR3C6Y2aFb
         bJrzbE2KkpG3dqqjEYOPvYIzCghFu7jPyfyFX4tLG0jJA+N5vSIe9YVMXcQOgSdWLacP
         QYyXW6/5Rmk72WkXnDDGDaUKrJ7OiAwNq0MkyiF9RoemHhq0z/zsUJ7pi3VtLW4r20B7
         TWmY96UuuWESxVn7R7HjznsHrPARfynb8ZxhJQxyE/Jrxu7zqnhNUMJC8KkTldjH3XA5
         N8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PfoX52k1vwrXAyW5X+GUTTvxeW8UlTOpjx8Y+u1e+2g=;
        b=jSMI5/QUHyc19ZA/NPfNJH21H2F6l9AN5Ihbh4v59sPqbHjdHYpvGi/j6NYjqTA7r3
         AIHG4FB64AR0iu3PHTYT9KozLjW2KoNfDlq7pawS017tsk/gFmPfTntWIC/JrBrQ2alJ
         UlnMZEC0ltFIGAAbwHWEFK5Uk0HnP3deSz5SjqC9z/Im12BjrRHDpHlQbbfFOf6nJD9L
         009NjmtuKoXce6fLJNowFlgjcFtnq9AH62mCXrcrCLUilcq7aNaSexY2UNfWgTTDDbvw
         CRVxCfxLATI0J2Mzjg2KTP6SBo33bnnCb5ZxMa+0eiOzun96tDp2+ndSfw6YnesAkgw6
         5zEw==
X-Gm-Message-State: AOAM5313GsyvDJYhb8nYo6JRyc/8gs+PkYlhVPbatgg8qM+VUhDiekqZ
        hUwcfK/FURLV6w6s6IpwOUI2kGV6Ek1n5R0z
X-Google-Smtp-Source: ABdhPJxhYnPUv9gLtUPkhuJqBsOAuzYOYZ2DiDkmtqNitAjsuqhEJFHIR4AZzG1q5h/WZOX+xDdWjg==
X-Received: by 2002:a63:854a:: with SMTP id u71mr27086457pgd.307.1638227937539;
        Mon, 29 Nov 2021 15:18:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm19565585pfg.90.2021.11.29.15.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:18:57 -0800 (PST)
Message-ID: <61a55fe1.1c69fb81.c2e78.5ed6@mx.google.com>
Date:   Mon, 29 Nov 2021 15:18:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.5-179-gf46e126d61072
Subject: stable-rc/queue/5.15 baseline: 129 runs,
 2 regressions (v5.15.5-179-gf46e126d61072)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 129 runs, 2 regressions (v5.15.5-179-gf46e12=
6d61072)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
meson-g12b-odroid-n2     | arm64  | lab-baylibre  | gcc-10   | defconfig   =
     | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.5-179-gf46e126d61072/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.5-179-gf46e126d61072
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f46e126d6107285f63e90b11bbfc5680cf67d65f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
meson-g12b-odroid-n2     | arm64  | lab-baylibre  | gcc-10   | defconfig   =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61a52865c63158bb0718f6de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.5-1=
79-gf46e126d61072/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.5-1=
79-gf46e126d61072/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a52865c63158bb0718f=
6df
        new failure (last pass: v5.15.5-165-gdf044d40e6cfb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a5267b95415b1c6a18f6ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.5-1=
79-gf46e126d61072/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.5-1=
79-gf46e126d61072/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a5267b95415b1c6a18f=
6cb
        new failure (last pass: v5.15.5-165-gdf044d40e6cfb) =

 =20
