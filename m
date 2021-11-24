Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAEA45C7F1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357738AbhKXOwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357719AbhKXOv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:51:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D0AC04FDCF
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:39:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so2929522pjb.1
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QLoBXFiklofZQk5QymIS6oJMtAzL96/pV6A4bMPKR44=;
        b=4TbdBf7aVy2h8YATg54R3iyuSa2uys8+kZX6YqXq7JBUg+TWC51BkP9JYId9hL3ESD
         1D5/nitq6EV0kxZdi7euQaEWdiB2uJT1do5szhQVRZCv4Ynkm12kJXv5+8JabrUW96pU
         VaGLGv98abVrADLuJp6etXifhOXkUgfjLE8jM553p/mCuRNVV5FRrIwbbEJa7vi4MESY
         VMQtDTCx1E1Zfc2YMWWJSItJbvme4uC0Rl1S+38zL8M9+INUKLQfB90hY2jmemVuj0Ek
         JY2/asMWfZ0RvVVdaMe9vySsSoe8YisPgSkXiObP0pBQZEl6hYGpi3BpSm20KldW7bXY
         lrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QLoBXFiklofZQk5QymIS6oJMtAzL96/pV6A4bMPKR44=;
        b=Ss2v0x2fuSm7LhiEeoXtOYZuwVipL+fKe2d7XRxL0Jexu6uNfVI01YDYjoRbpKJSOR
         RAb3oK0k0KSfbOrK+pX2rUUAEam4kvBy1CQOyaaUt6DYpvT5is47eo7L8ON2G9nQgVoB
         NOc4i5fBo/6IQuTyuz/iyiJj+hAJehA/FQqG6EE7B/Ruypa11rTOv+8R3tByVezAl4x4
         QAn0zqAoAr5gk2zXbtmgG7WxLJlseRzGmijTrcvPMhXaru4vTESwfN6iD5pPcjFgCCVH
         vnHGEmtzZPaVhiRFG0kQKXW9fJ43BxcoSTarhG66HJM50chWsijw8GE4mM0htYuLv5Q+
         vHLA==
X-Gm-Message-State: AOAM533hlUPQIHL4m8Re07SjowZwQuzIN1fX/87eoGzZ9vvqc7/wELxC
        UDfwTMEDLH/9zFTOkXwrTNQFDDIh1z0cb0XE
X-Google-Smtp-Source: ABdhPJxDdVPLkSrEIgkppZoIdnWHUGopp8k24O5sUafFjb7kfpoknhoRUxzRjQom6aRiSqc4Vhw5Nw==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr9396333pjq.104.1637764768635;
        Wed, 24 Nov 2021 06:39:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o23sm5667652pfp.209.2021.11.24.06.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 06:39:28 -0800 (PST)
Message-ID: <619e4ea0.1c69fb81.881f.d0d8@mx.google.com>
Date:   Wed, 24 Nov 2021 06:39:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-206-g3294e9e5f0d89
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 80 runs,
 1 regressions (v4.9.290-206-g3294e9e5f0d89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 80 runs, 1 regressions (v4.9.290-206-g3294e9e=
5f0d89)

Regressions Summary
-------------------

platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-206-g3294e9e5f0d89/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-206-g3294e9e5f0d89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3294e9e5f0d8932860ead7f4bdc4c87eabf2fb8e =



Test Regressions
---------------- =



platform    | arch   | lab     | compiler | defconfig                    | =
regressions
------------+--------+---------+----------+------------------------------+-=
-----------
qemu_x86_64 | x86_64 | lab-cip | gcc-10   | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/619e15ad2b5ed121dcf2efce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-g3294e9e5f0d89/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-g3294e9e5f0d89/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e15ad2b5ed121dcf2e=
fcf
        new failure (last pass: v4.9.290-204-g6644175930559) =

 =20
