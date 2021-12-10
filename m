Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D1470E3B
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 23:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243149AbhLJW4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 17:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhLJW4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 17:56:41 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7E3C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 14:53:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so10469918pju.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 14:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4a8e0rsV6K9EDg0VTLCdctUXshyinyh6a33cXujgAao=;
        b=izXxB8uvoJqVc4TlrYxRzlXXNX2Cd2nISNOw3YS3fq4ocuoU2FrCJT7gGoUratT2CC
         qinhsBlClUd81qkZlhYA7rJfOlzO1Yiwi8eFbvldVTMsUTb5OSqHZffoNpiX9RSBrAev
         xUw5apkRgsG8+rlBpGNRz+wyqb96c3DqHDssrdsrPAKGK4kaqmSKDdkaPhRfjVrPGXhV
         ZOUrkXQb51J2THFySK4BMqZhoOmErxncgf1YKrOvufmh82BYVwO0IbxBXHqNhp1pJ4vb
         QG7pK14sO4pF1cPE32NJpyMv01lCPFoBRGDcKz+SmzPOfp3izxrqrwyVRv2C1tbph4i7
         rtsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4a8e0rsV6K9EDg0VTLCdctUXshyinyh6a33cXujgAao=;
        b=D0D93TyKd6FNM2lfbLOQqat4bVz23HKg3Hck5zrWlCBenVgRzSKJzd3CBGCxx116Br
         hU5zuOQRNrZHcGxZbi+xjpw9jee5BC12y0Sj/hJS9Q4D5PzedFEe+OIU30D7jHvDxQCW
         ggTjPc1jAYjesIhrocGXuiiYNPp0frkhp4cQJzUtkCq2fsgSFCkeKrhJRL9L1PYzqnGc
         fKlB28TBjs/wsS7Uybt4w31WZmwjkChFDAkvXDVtUgdmi3lfil2QXJrMYoPhT37J7tmx
         TjPc794K8GqRE/O1B3zrznMYipVAdcZK9h7FNYZMNTaNRljb/thaqoYUDn2wN1Ypo6+o
         G+GA==
X-Gm-Message-State: AOAM531vvRD75cauCzDjyfL3XhnHsM2WmJg9TX41ZCfG9MX5dSGdck/b
        swYCPERi/QzTKn0ESVMZimaE7nNTvdWXrp9G
X-Google-Smtp-Source: ABdhPJz73Sv8iEXA469S0/9GMydfX9JEwnP1oq8zEwLkeNzbjHDi31a+O1nG7fb7yLZH7H1pUSPDOg==
X-Received: by 2002:a17:902:8645:b0:142:8c0d:3f4a with SMTP id y5-20020a170902864500b001428c0d3f4amr77666162plt.3.1639176785806;
        Fri, 10 Dec 2021 14:53:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g13sm48022pjc.39.2021.12.10.14.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 14:53:05 -0800 (PST)
Message-ID: <61b3da51.1c69fb81.4cf9b.03be@mx.google.com>
Date:   Fri, 10 Dec 2021 14:53:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-22-g3f51770c38de
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 158 runs,
 3 regressions (v4.19.220-22-g3f51770c38de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 158 runs, 3 regressions (v4.19.220-22-g3f517=
70c38de)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hip07-d05                | arm64  | lab-collabora | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.220-22-g3f51770c38de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-22-g3f51770c38de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f51770c38de2f03c645da24e1b4e4b03f1b27bb =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
hip07-d05                | arm64  | lab-collabora | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3bb3471d542bcfa397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3bb3471d542bcfa397=
129
        new failure (last pass: v4.19.220-19-gb25ac2999a81) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3a23852994b50823971dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3a23852994b5082397=
1de
        failing since 0 day (last pass: v4.19.219-56-g730dd2023c98, first f=
ail: v4.19.220-14-gb7524491658f) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3a0148f62e5586839712d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-22-g3f51770c38de/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b3a0148f62e55=
868397130
        failing since 0 day (last pass: v4.19.220-14-gb7524491658f, first f=
ail: v4.19.220-19-gb25ac2999a81)
        2 lines

    2021-12-10T18:44:19.024688  <8>[   21.570312] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T18:44:19.068649  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-10T18:44:19.077857  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
