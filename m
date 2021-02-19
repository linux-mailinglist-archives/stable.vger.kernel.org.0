Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7F131F48F
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 06:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBSFB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 00:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhBSFB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 00:01:58 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B33C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 21:01:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c11so3068259pfp.10
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 21:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+gLZMQ13lWEOAnP7LhJkgbiKAIWHRht8bCPoo2OmvS0=;
        b=zLc8W5lI0pWG1ZCdXbc7UFpltJxoLy19UTl5nnHfp9YIlhIjRzzY/swJ6xcH5qiOzG
         jG9Aqpb6+/UoGcHZxQEmBJ007F0kXQvw0nbEPQJ8EMZ6IoqeBoDcw6pvDV4GDC4Ia5l/
         a/6ayh0D+kCYLoz1XXSHEJYijBSG7Y48bJA4CtlilYQs7o01y0CDhkOHQrnTJUIuSolF
         UGo/7Qwxk91hAGZQvvTFEeM3az3iwzMgNY94zTDhdLzoCneKPtec/ekLmKRbfsrdwjcB
         Aot950K23JBcFwPgxnlXH2lSQ5OqQUf2WzpnVhOPMEGwHiCrvsa8FmQbkrsQ6QZD5LiF
         li/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+gLZMQ13lWEOAnP7LhJkgbiKAIWHRht8bCPoo2OmvS0=;
        b=DQFFhPWAB24uuTrqqkCGu+rXQlAVRpG3SOZo264IWbnRfBHTCGjUYGbY16eQ83J4DW
         vGTyhES6C3URnnSNC0XF5oRnLfhgn3Q33Y14hUny/vQS9Y8yYoCBeCmSjPRp2PEoH86x
         MZLWp/m96r7+opMrIXKoYhjvGsB+ZncPRAq7M+XqlJGJTnj6eBkQPSqApi4mq7yWkARY
         u9tSuOR1YICbgEG51HwFFiWYYPBnzBFp3gGM5yVNI1oQwSqnDb4pHRLYV1Tn9ckJfUDo
         5k4ZcYGCkHsPyLNhgpu/vuHA59ExZOh/SatI9JGGRMNsx3TLZtPTP5Tk3OPf+dRsru44
         raIw==
X-Gm-Message-State: AOAM530f5pM7bPliqdUJhqz3LilqgtwtiLZGfaJdNx6sr8Mwao4mZbIJ
        NzKjchxMNCPbeXXCLI4iru5teOXVKr2K1g==
X-Google-Smtp-Source: ABdhPJx1ZxEW8rXi2b3bzFkjIlsh/oSlZ5gyVKZ1w/fhGRiSNr97VTQURfcDgGOUUOfh5D9mJ4IdXQ==
X-Received: by 2002:a63:1f10:: with SMTP id f16mr6865787pgf.111.1613710876936;
        Thu, 18 Feb 2021 21:01:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm7428272pjy.36.2021.02.18.21.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 21:01:16 -0800 (PST)
Message-ID: <602f461c.1c69fb81.e805f.113b@mx.google.com>
Date:   Thu, 18 Feb 2021 21:01:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-38-gb9ca1d941eac
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 94 runs,
 2 regressions (v4.19.176-38-gb9ca1d941eac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 94 runs, 2 regressions (v4.19.176-38-gb9ca1d=
941eac)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-38-gb9ca1d941eac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-38-gb9ca1d941eac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9ca1d941eac74bb856297f6195f9ed7189f002f =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602f1487eb6575bcebaddcbb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-38-gb9ca1d941eac/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-38-gb9ca1d941eac/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602f1487eb6575bc=
ebaddcbe
        new failure (last pass: v4.19.176-37-g9bea34ee9511)
        1 lines

    2021-02-19 01:27:50.712000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-19 01:27:50.712000+00:00  (user:khilman) is already connected
    2021-02-19 01:28:06.764000+00:00  =00
    2021-02-19 01:28:06.764000+00:00  =

    2021-02-19 01:28:06.764000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-19 01:28:06.764000+00:00  =

    2021-02-19 01:28:06.764000+00:00  DRAM:  948 MiB
    2021-02-19 01:28:06.784000+00:00  RPI 3 Model B (0xa02082)
    2021-02-19 01:28:06.864000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-19 01:28:06.896000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (367 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/602f131069156f10dfaddcc3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-38-gb9ca1d941eac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-38-gb9ca1d941eac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602f131069156f1=
0dfaddcc8
        failing since 1 day (last pass: v4.19.176-37-ga630db879c87e, first =
fail: v4.19.176-37-g99b2feb86d78c)
        2 lines

    2021-02-19 01:23:23.906000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
