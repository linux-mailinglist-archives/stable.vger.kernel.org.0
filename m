Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1EE4547A1
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbhKQNnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbhKQNnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 08:43:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1224EC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:40:15 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r5so2289898pgi.6
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8EqMmWEm+YZsu7epTEQ+OBkPJq2yo7FjOHnna0Oyeiw=;
        b=jccggDpl84k/L80X2dz4UICUuVH4uVR1MgbjeP9oYGEneA2Q4Z/Yb7Ro4FWcMziI/k
         siBMsxq+nQ1V/ybkgK6/kz1lUBopzcxs+p3wDX1XPVhqWc42M/8GijxZNTzqODSewovR
         4zx/dLNZLIGc3azGm2WRIHqIXptiUeY9M6z/fdXLTCL3kwfaMDMqRfsEVL0C8ewgtEnG
         LIirmgGIThZ4AHEI5KXvX7i8N4SpSLcdeeRIQYfZDdUHMqYpY+9+gl/PbjWY7p2DIEcV
         aP9ydoEZGX0/lg++AoGGWoOUq5gx+kX5QbuxTGk5jHcQh2lexDNthEXtcvxLGQ7SNsWv
         sLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8EqMmWEm+YZsu7epTEQ+OBkPJq2yo7FjOHnna0Oyeiw=;
        b=Ebm7n+sospcHzUMtlphVCKIABDDMb5aeg21WYVAkagyVnNvNypt9qq47IMWU4OgADX
         a919UrKyIy6VvC2XpXwx1h2cpQEl8n0NqZizGIrWtcHB3++xW8jzLXFoR4NDgBJIugdw
         HdtExulfpu2nBwFuIDuXGiI1+Lb27+2GJS9kxuheTW+sMRbzqe3u65rmsEyNNhb87qlx
         SiF1lyHj5h5NVl18aHdCWudjydl+/9A83ZqWF7MAbvgcWDvfFrhcIK+2DB3jyoD9cGB/
         moUlQMfwzbKvVCOA1R6bEeWtmxtWWkLR/ciHvhG6dwz5x2p9nusj2IVESqtWFGRFMDGU
         sdpA==
X-Gm-Message-State: AOAM533pWMoPm0Bp/e6aSkEWr7/33KcU8QaC5DCtB2hYxcUFhEdViBBc
        dvlBgQLSS05lhi1kA+w5u4IGFISezNtLG/a+
X-Google-Smtp-Source: ABdhPJy0D3KOH3UHU3zHYZLPUPHJUeXXg3CSvKgwlDskq87jlceSe4YpcYlDnGLzPIcUgrxJKw9TVQ==
X-Received: by 2002:a62:1d09:0:b0:4a2:82d7:17a5 with SMTP id d9-20020a621d09000000b004a282d717a5mr36234187pfd.64.1637156414450;
        Wed, 17 Nov 2021 05:40:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm17736837pgd.40.2021.11.17.05.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:40:14 -0800 (PST)
Message-ID: <6195063e.1c69fb81.41d25.2c17@mx.google.com>
Date:   Wed, 17 Nov 2021 05:40:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-250-g8d9f0f1c26ce
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 111 runs,
 1 regressions (v4.19.217-250-g8d9f0f1c26ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 111 runs, 1 regressions (v4.19.217-250-g8d9f=
0f1c26ce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-250-g8d9f0f1c26ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-250-g8d9f0f1c26ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d9f0f1c26ce8b774edfc5f15c5afe362134ef3e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194cab8f03b7e7d4a3358ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-g8d9f0f1c26ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-g8d9f0f1c26ce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6194cab8f03b7e7=
d4a3358ef
        failing since 2 days (last pass: v4.19.217-72-gf6a03fda7e567, first=
 fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-17T09:26:01.548658  <8>[   21.269409] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T09:26:01.592738  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-17T09:26:01.601949  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
