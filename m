Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C7844F5D3
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 01:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhKNA4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 19:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNA4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 19:56:35 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AECC061714
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 16:53:42 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r5so5363608pgi.6
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 16:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U2ehXpaCcafffLqbAaehZizlhYLE6jBrFpR/yuT1YVQ=;
        b=096qSTB16WfQfRiLnjymasmkMHRl9dtC1ehc+UXzInzaWODwuJCs3lgpq6F2tEm/Al
         kovU+CCAjPuvIVb4OszcYyP1mN0VFS1iBtdjbEkk8aT+E9Z8ejxMno0nuO5NPKjByVX/
         8HXF25+CESM9ScZxgwnF1NhKEIHKR/dw9P/4GcRt/iN3mw3DPOx+IQdYuU0FXeEf1kay
         8GXWKsp27YknRBx8ahZoAih6jKLmDTk0t4kxvzS9jNs7GSqYYfvrHZsXaloRLfQ8wpIx
         dlNbK9q9/Fxakqhy6k2UqzQ2z9jBjA5Xj8sFi7tfoARjjEr+8P5YZWMFMsvemRiGWUvc
         5Kog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U2ehXpaCcafffLqbAaehZizlhYLE6jBrFpR/yuT1YVQ=;
        b=obYCFiyCyd8YbhHFLUJDF/G1SRZxWOcIzPPmJc+leX+fMT8Yt/PR/RRBj0MMh3RTPQ
         VRmJa2SNDYQnyBoVrKvqnqsJnzJ8UHDAS1NFslSCed68FikMOEk7a68uGo4dyuDgIEcf
         pwSwGaSOxatgC8LHqmerXE4duQgfwIkUjePwt68rKVh67jfCeWe2EFkvYFveeKbbYn/g
         78QmrcY8xYPKQRFfnKsfVXHbRrDHbgg6yHOvUmZ//2KuixXqJXOWm7p9qkQOHuM7frku
         2b20OR9Er48zyVmddoqtV5Pca/tV5uL+DXEhmfSkNWw2YImIdxJNJSLyHwI19hQT4D1W
         uwLw==
X-Gm-Message-State: AOAM5312f3NLGXSKfQyKT1A1BzzPEQOuNi220XsY3hEpEgmloQRvPMNH
        c8qyKE0mZ3Uyg8y070g6z76Wse/INxHGCJck
X-Google-Smtp-Source: ABdhPJxLIhZok8EzHjMfW7BC2Y+ai7faOVk3rV7uBZNyJmv5zlQZSXjQ8ZWRArJUIYqAsEJcESQHtg==
X-Received: by 2002:a05:6a00:174e:b0:43b:80ba:99c8 with SMTP id j14-20020a056a00174e00b0043b80ba99c8mr23602218pfc.51.1636851221734;
        Sat, 13 Nov 2021 16:53:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm10230675pff.75.2021.11.13.16.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 16:53:41 -0800 (PST)
Message-ID: <61905e15.1c69fb81.87e10.dbf5@mx.google.com>
Date:   Sat, 13 Nov 2021 16:53:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-54-gb6f4d599e1d3
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 157 runs,
 2 regressions (v4.14.255-54-gb6f4d599e1d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 157 runs, 2 regressions (v4.14.255-54-gb6f=
4d599e1d3)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-54-gb6f4d599e1d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-54-gb6f4d599e1d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6f4d599e1d30f6c4fb548b676ff80e822be315f =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6190254f651f1e2cd83358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-54-gb6f4d599e1d3/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-54-gb6f4d599e1d3/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6190254f651f1e2cd8335=
8ed
        new failure (last pass: v4.14.254-23-g0e0c342dbc36) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61902a6fc71a01756533592d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-54-gb6f4d599e1d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-54-gb6f4d599e1d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61902a6fc71a017=
565335930
        new failure (last pass: v4.14.255)
        2 lines

    2021-11-13T21:13:01.432913  [   19.928192] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-13T21:13:01.474491  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/96
    2021-11-13T21:13:01.484181  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
