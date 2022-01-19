Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF7049429F
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 22:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343624AbiASVsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 16:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbiASVsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 16:48:06 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77806C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 13:48:06 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q25so3498455pfl.8
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 13:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EMENBjWp7iNfgH0nxks35fDCugSoYoFe4zHcGyraZv8=;
        b=SsHIuD75dcLx7Wjw7DWOzWipRSMUcv9KpCY+O0qBy552e7AWnk3DsNoplyMlVUp+FY
         whTUFnMiKX60PhSqJvwexdxEI3Ti/p3Sw8BlWofiGrH8Hs760KHqfRWS510/yQtju8jA
         vyykjeHlOWMprJtBSYTnpaEZam1ZwJLbPzWpLzwT4R4ZQW/x7XZBTsqbGYzIS6W26IZ1
         9UsNtqVTFWUQ55JeebsKEFZdMTtOdsTPYEDP/HmCkLW+TC9rZTo4UhpZyhHMm6+v2gkF
         A9cBX4afoZLm4AbFynXTJhmM/W2z+B7vkzJcNg81zyWdVj4No/FZpaQY1k+y4ORlYw3v
         8nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EMENBjWp7iNfgH0nxks35fDCugSoYoFe4zHcGyraZv8=;
        b=sWjqhi3JtAwVJNQqwLPnGZWZMwzfA78dGCchlNSkFLaBfDkGL07aTxYcQJLtBQvEYb
         2lYJd5s3ykNyARwc6C55zRLdoKFjjPeLbqFLi03Jh4/Fi85kvZOGHAsXk/VSaHhHCnmc
         kDuGexFp2FlLskv6hM3aN6Aa4RUs+QOhmlvsveqSlAIWlGqD/mA2ONsnmYOfHnYr/jNS
         rpZohw3ZAx/Eu6tpfv+Gbbw99Isd49hXJQCMy46b+qyJunKqDYfGhPINdmM2C44TBmVY
         oYkxUTkbe7vklsUnDKfxTxwJ3t3IkpbvsOFHptU/XdFhzU2xfPrGgPUosvfIBui4ANKp
         O36A==
X-Gm-Message-State: AOAM531/eZweNrX0Hlc5ptkUdByq2hduEab52e+q3qLzo+M3a6wQD86q
        fY2Ln0hqiSXuvbX3FwqcJpbH1IoMKN6a9RJU
X-Google-Smtp-Source: ABdhPJz++idX7A1mNR9IEaEs+Y1kwkZ8hOfi6SnfiZ/P0c49eVNBJSNEYjX9MfkovkbuPHHm+c/3rQ==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr29137102pgj.331.1642628885758;
        Wed, 19 Jan 2022 13:48:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm531743pfg.162.2022.01.19.13.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 13:48:05 -0800 (PST)
Message-ID: <61e88715.1c69fb81.6653f.23e1@mx.google.com>
Date:   Wed, 19 Jan 2022 13:48:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-21-g6c094b6e2450
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 148 runs,
 2 regressions (v4.19.225-21-g6c094b6e2450)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 148 runs, 2 regressions (v4.19.225-21-g6c094=
b6e2450)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-21-g6c094b6e2450/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-21-g6c094b6e2450
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c094b6e24508e42d8123e66513f761514b049c2 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e84f12985138f4a3abbd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g6c094b6e2450/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g6c094b6e2450/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e84f12985138f4a3abb=
d1b
        new failure (last pass: v4.19.225-21-g66dcf5aa64a7) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e85271bbc8d721c2abbd57

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g6c094b6e2450/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-21-g6c094b6e2450/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e85271bbc8d72=
1c2abbd5d
        failing since 7 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-19T18:03:12.961927  <8>[   21.576660] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-19T18:03:13.006641  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-01-19T18:03:13.015750  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
