Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6B0489AFB
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 15:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiAJOCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 09:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbiAJOB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 09:01:59 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9CAC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:01:58 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso21325317pjm.4
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G4/o62CQGiOXC9TrdJrr14uOT8pCviJBxtscOFpew9I=;
        b=k1nHoLGkfHHTrys/VXwpD8Zl7hDgYV4rTSV2lmnA/p5+8OpYUcBFlGIgRb5WlwSA9v
         tHVIfIepgHyDrxL3S4ZQfGIcUynRlxCZEevOc/hBn9wO6/Ce1bKpFGkJt3rr3EDg4/bu
         gYR9aQh6EChj4MY6Jo3h2hxjCfvU9ZFQokl0YEtnxEd6H/4L9MXKpSmTZrj7H3oqwZ0+
         WQxRBuQfll79Q8pxIFO5GcV2pRZglLvWPOPcP8J0BItypmt7j79665vYKVNvT2tWGZNK
         sYMqfbtmAPjLi4piqEMaLUlu5pL6lTWXTLazmtV90aMK7IZtdosJS7MU68ZM7uXI7lcd
         /ywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G4/o62CQGiOXC9TrdJrr14uOT8pCviJBxtscOFpew9I=;
        b=GSQPjv7odDfj5EIP6iBDqZJr26/79gV01zAxbcNNBhGKBh383E1i2mjMPsbk6OzNNq
         CC0hD5/bf0rHo8xsCjiSz8SLupiPofqeQx+8tYWabT9RTzkzlj7F9zC9yjl7g6wvYTAE
         nvDNn0yhGmNC1FC39c8XFyUfrM54JT9FH8N7BJWINJZHBFMpjibvCtuBy9AsN/UAA/Yk
         3Z22sETDjpv1+1Pu0cJ2KK6MeKYineUwUuIq71RkcdUTM6yXF0cc4eX+PFWpa55FZkOe
         lsCo8CpVRjFC+gzx5GaxGJR3mx8skl7dEtk3iFXMCxZ/hKhXmOczyTjc8/KQyLwD3vDR
         arsg==
X-Gm-Message-State: AOAM533xZbxdxHbUdB4H9TbzIEK2GuSkczGzoOVhCSOy697k+ZRe0QFs
        B0nxenqdHfqtmG93/Pe8XIg5M8HADisUv8+g
X-Google-Smtp-Source: ABdhPJzaVNW6p2qxGMrNTC7GF9W2638U9DlZ6Clwcp4U+r7hOE6vLoxEXdUNjyLLhg7ylre1pe5V9w==
X-Received: by 2002:a17:902:650c:b0:149:82bb:1145 with SMTP id b12-20020a170902650c00b0014982bb1145mr62666205plk.3.1641823318166;
        Mon, 10 Jan 2022 06:01:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm5798589pgn.26.2022.01.10.06.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 06:01:57 -0800 (PST)
Message-ID: <61dc3c55.1c69fb81.48238.e0e6@mx.google.com>
Date:   Mon, 10 Jan 2022 06:01:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-15-g73006be3a625
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 116 runs,
 2 regressions (v4.4.298-15-g73006be3a625)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 116 runs, 2 regressions (v4.4.298-15-g73006=
be3a625)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.298-15-g73006be3a625/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.298-15-g73006be3a625
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73006be3a625b225757ef55d02b5f5863bb9d794 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc08e9c37d3c3af9ef677b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g73006be3a625/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g73006be3a625/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc08e9c37d3c3=
af9ef677e
        failing since 11 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-10T10:22:12.311826  [   18.861053] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T10:22:12.363730  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-10T10:22:12.372697  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61dc0708b47a996a89ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g73006be3a625/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
-15-g73006be3a625/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc0708b47a996a89ef6=
741
        new failure (last pass: v4.4.298) =

 =20
