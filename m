Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B752999B0
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394521AbgJZWaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 18:30:01 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:40625 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394447AbgJZWaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 18:30:00 -0400
Received: by mail-pj1-f54.google.com with SMTP id l2so3797345pjt.5
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dnA3qTiSFNghYZawJMiNhnZbj9czUThzfCR7N32C3P0=;
        b=F2HcwKLb9Mt71/08dnbtePYdlf714XaudaMr0+2BIjJiVbCXkG8nlVazIC0qCuVXvM
         39T4mX19g/6UMq6GbYoUFTwx5ZyQcPMrfroGD+XryzUO+nz48p4b3ZS12ZP+Qd2IqlEr
         9El/RcxcNUVGBPJ0iz79qOwhdjM/yMUqTdE0AlnHeqqE7MDwNZ8AV9pwmy8Iv9CK1aKh
         PnPJgWiT+mKuCzid6RxH9JLPvTGrR+sRaCKnmllSxsjDZo+9iWjNTHSAK918NGZQcFGz
         0KO2axuMB/+DyP4SOTuX7fvz5jx39jN1eHvOi8Su4+ibMBgfoMs9sT43aJp2NQkp9uZj
         m96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dnA3qTiSFNghYZawJMiNhnZbj9czUThzfCR7N32C3P0=;
        b=c1++RLYRluzNxw1UdvKOimZLgDrLmpLf/H7uk7Zf4SYcG28SUH6e21OuM9x1L+B1Ql
         jeoDrqVbPdPoWaJTu47FH3qx5RtZHDGkh4rVFlH8DvHOYdLplwh7QYuC/aDrY4jQNrlY
         LWmh3zZyz/e57VvsUAjerif66coTLKV+Hm8OO76jPtdVCdYE7yepqcyEoKSyqraQVJ0I
         coviC+HLelFqae4IIaO19ETjq6miMtiHHgwTewUw3YTicI7Ilf/ReWG4StkGMhBnMt1P
         yMISxjBr4gTYJIKCtLw9lUV5M4uKI/ctg0dgawddCWCMI8Z9UJR4YRawFEggk+Nav9J0
         ctHQ==
X-Gm-Message-State: AOAM531CMdevKnJdd5KZ1EtYrC8495oFHS5VLd379w8vDaHeLuYgw/Ac
        XZ7UTtjPbQ4+4fdDxgvCSupOwQvNkDMPWg==
X-Google-Smtp-Source: ABdhPJw7umseU7Y/rcHG4dqoptLL81n4930wLIqt6DM/u5BCaNODBckUsJY1xSjooT3/sbAVL+JuVg==
X-Received: by 2002:a17:90b:1043:: with SMTP id gq3mr3221708pjb.213.1603751399752;
        Mon, 26 Oct 2020 15:29:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e5sm15201335pjd.0.2020.10.26.15.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 15:29:59 -0700 (PDT)
Message-ID: <5f974de7.1c69fb81.daaae.ec9b@mx.google.com>
Date:   Mon, 26 Oct 2020 15:29:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.240-135-g36fe4866bfc7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 1 regressions (v4.9.240-135-g36fe4866bfc7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 1 regressions (v4.9.240-135-g36fe48=
66bfc7)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.240-135-g36fe4866bfc7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.240-135-g36fe4866bfc7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36fe4866bfc7a9ae7837680957d1ed301810eb76 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f971b1124bb49940a381197

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
35-g36fe4866bfc7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.240-1=
35-g36fe4866bfc7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f971b1124bb49940a381=
198
        new failure (last pass: v4.9.240-135-gf13fef6e3b39) =

 =20
