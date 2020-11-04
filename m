Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EEE2A6EA9
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 21:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgKDUXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 15:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgKDUXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 15:23:08 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC37C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 12:23:06 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o129so18270054pfb.1
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 12:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K54fGc6yxzxQTKIxCj3++9MPiq4707GD/NRgA6eW+Xo=;
        b=IQVz16w6MKEYfCVOCbMQZZa1UnvFWukzsFexV45SoPDKlyzS4TjL821prMkYhZR1S/
         JQhppDGMeNd3IzHBs2eMigR6m89bRRtotsvdD6V2s9IzanS97TzVOhpQ0wt/6pWUPRD3
         9bgC4/X5crmVn3OxLs3GWALAJoMeXBVqPqWcYRwQFnt79eY9qSGnOvsJKXVOSLFoIHVS
         7p5SCTReINPQwoX0uJXb+m7xRgsFh2duRsYXmUT9JdeTsMwxyqZW3bSiahhMZ9MhGELN
         kuhbC8QPpI8/uJTcFMCiI8nfSr+uZQQuZzTGpYWCc8/IqdJnjWuMjMFesmbfRJZSc0gx
         IPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K54fGc6yxzxQTKIxCj3++9MPiq4707GD/NRgA6eW+Xo=;
        b=UlvXMg7Pn0DS25nPt7uIbfW74iRgHcfn8P9R1JXGyrCL6qXiDi6X5SlrhyQInPnUc3
         FopOBlfg9XWDREJ3kkKyT9Kn/ASg0trMv0f2x/YIotqZWlnbPOSBULO76hTnjiH89PQ4
         mqEw3Dt4Eq5WoiqCTxm3kRoa+z5b1Za11Quj+U9iSaYSitdCKVNpiuOnUc3lvabFTCBS
         OLLaLD+Q/2Yivc/ZKAG3Vf5s/+f7VsQaMlX0kU9MF9nXz0sfAhZw7omiA+1+lGMEjwKE
         LLKB8Xt460Bpp2/cZXaq29OCokTfrB+EKrdi+QhPLmHcMyWhMdwz7PTI2aERe40o/Pjx
         xoYg==
X-Gm-Message-State: AOAM532fNRinpeUIl1KleVuA/kheejw3ZPoyLG7gMP7O3ISwTazo9CYi
        wzGVK4+nntNs4i6SLKjgrmt1RNgaO/R2gw==
X-Google-Smtp-Source: ABdhPJxpjz0DfiEDE2qaI/ma8XBudsYB/g0CCKFA45SgFCYPBD8vcyjZ9jIg0q7W1CvferiKYhwEEQ==
X-Received: by 2002:a62:ed0d:0:b029:18b:78d:626 with SMTP id u13-20020a62ed0d0000b029018b078d0626mr14370798pfh.15.1604521385982;
        Wed, 04 Nov 2020 12:23:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a23sm3104129pgv.35.2020.11.04.12.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 12:23:05 -0800 (PST)
Message-ID: <5fa30da9.1c69fb81.716ec.720d@mx.google.com>
Date:   Wed, 04 Nov 2020 12:23:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-91-g387309f11ff9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 151 runs,
 2 regressions (v4.9.241-91-g387309f11ff9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 151 runs, 2 regressions (v4.9.241-91-g387309f=
11ff9)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-91-g387309f11ff9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-91-g387309f11ff9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      387309f11ff9ea1b48d9a54709e1bc32ac46ef8b =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2da64e61e9e4488fb5318

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g387309f11ff9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g387309f11ff9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2da65e61e9e4488fb5=
319
        failing since 6 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2d9a5704ddecee5fb5341

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g387309f11ff9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g387309f11ff9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa2d9a5704ddec=
ee5fb5348
        new failure (last pass: v4.9.241-91-g303dfca2bd68)
        2 lines =

 =20
