Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BD8448053
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 14:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhKHNhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 08:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhKHNhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 08:37:35 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BB0C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 05:34:50 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id j9so15184868pgh.1
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 05:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XSlUdrQBtDJYvTKew8a89dSNTJd+ghFoh/2VTJsIGwI=;
        b=5KJbftDFB5/KkRsm/SfxSwLAeXexadEu1n1M7tYfKrocCfjt3743OwdKkyDbSjjQkA
         AB/rU6y6gTFoxNnG1GNxLL4BS5kb8bAIfjayRgi2GBhl0JcjTta4P9/KpKct7TBWmlyr
         T8Vhq5HmipI4ZvXdfqWxMPTdm8MVBFtnUrs4NPp780B4OuQeg1ZW2+Ejz3qMoKInuvZ7
         Vc4rMkuV1kYinCGPqkthpvPatCUPQGdcgE3/K1wQ19pqfRL2qrWpxQNDAxl1I52mxfO0
         r0hDKpKTm3VUlLz4/WsFFtoG3TcrkLU9Mn0OvkCYZTGMs1/SXvf0HUHqrP2cZonhq9SQ
         ldUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XSlUdrQBtDJYvTKew8a89dSNTJd+ghFoh/2VTJsIGwI=;
        b=ltR6O0r89oe656E/l6K357gZFQxPCe5mPQwQDPAje7vDEKU2atl/qCDTWZ0sezDYxF
         rzjYJvr2O4SISBU4GvssZ2zxWLXrr45HGdPQhdXCkjh4+BQOvl7fxPZemzOnBN3DwQBF
         n+95TLIWY7DBD3Yk+eaY0YS/nio3dkeG3L76j5tl1vXEHtFxZnimiuaAlpZaQYMp4kQV
         0hUzyCbmZWfmw0Mx+QpAPm08jffc/aMvEGJEqwaqm4PvMbY8/3HS6Kmpg6MShZqoDS9f
         5LG9iq3aEOJSZZvbPcpROxY0rhhgU+LAVns5YAx4j2qGClAiJxw0/YLbpx2k9/j/Zdjp
         3+Pw==
X-Gm-Message-State: AOAM531sK1WQ260xevKLlp/FBDNILqZSi8MdOXpt/uAevPYmh/zSOTx4
        5oIJG2HKhPmM3QiPNJHKi7WkB4cmRGeZo0CR
X-Google-Smtp-Source: ABdhPJy6oiIUqGdzbTYZHDrQ5tuxyNFN8Fs9Vbm7HKiaCGwxCiGryRZU6MEGbtjvZQWAY/eJJwzqtw==
X-Received: by 2002:aa7:93c4:0:b0:49f:a7f5:7f5a with SMTP id y4-20020aa793c4000000b0049fa7f57f5amr21344674pff.8.1636378490092;
        Mon, 08 Nov 2021 05:34:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z30sm5748950pfg.30.2021.11.08.05.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 05:34:49 -0800 (PST)
Message-ID: <61892779.1c69fb81.c9c54.f1ab@mx.google.com>
Date:   Mon, 08 Nov 2021 05:34:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-9-g32e6402e132a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 162 runs,
 1 regressions (v4.14.254-9-g32e6402e132a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 162 runs, 1 regressions (v4.14.254-9-g32e640=
2e132a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-9-g32e6402e132a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-9-g32e6402e132a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32e6402e132a2b495f8c44407b6aff5af867b66a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6188efe8ff5a12b1d0335905

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-9-g32e6402e132a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-9-g32e6402e132a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6188efe8ff5a12b=
1d0335908
        new failure (last pass: v4.14.254-7-g292cb9a1cdd5)
        2 lines

    2021-11-08T09:37:26.297434  [   20.179351] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-08T09:37:26.338263  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-08T09:37:26.347470  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
