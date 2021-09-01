Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F52D3FE56A
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhIAWX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 18:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244397AbhIAWX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 18:23:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47272C061757
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 15:23:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so87368pjt.0
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 15:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6VzH0lO4ziiFwLXwDDA7Idk0B9h2jAHGfPCN4MY2guU=;
        b=SjjxbN4KhcwjsgKV2U16wPTu5r4cAALwWH7MmsV7Gua7abPYapTjdRYKas5R4Z1BB3
         qAE3URDSGRvbpVKWjCBRZ831tscbgUMZL1+gZsVgNcFGZITapuA8+dLeOkCt3p4voG0S
         eemapIXKFsxer8aW7vlznqKYsTMxv7MOd9sVk1uaO9zNUZ5OIbaAbTIb/ArGesrseP+m
         3wNSk9j/UR6pvrD6Gf+J8qCUPQzFXApKvpPSVKY4D1ZpNi4Oc18TN7fI5nG/AmgFaMsS
         dtPuBBMb6QKX/2QvMUJUKX4V5UQtu5U1kC3y1LfJnBufLvk9G/U09EVc8YlKoTZols5O
         4goA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6VzH0lO4ziiFwLXwDDA7Idk0B9h2jAHGfPCN4MY2guU=;
        b=YPDEKQgcXbw/BM4gDoMTXembRhsRGfuHulbNMxdm21OgtHEzcY4AN+v1m3w3ScNmbe
         w1rIfU89MC8nFHCDvJo177dqjtUQAsdOAhp3NHnth+dnO8swdlzfopTtRPQ9vH+UUbTT
         Lq+3ps8QCUPzfauDU1yafh/6V4rl043qj2BTSc3mg/gihJnk8uJ9Vyu33qWpgZ+SAoxs
         7+Ln4dRxolg1pLI5G5fM4tWJfdTMTto7B9WGAoYnZ3z7DGFjkkxw5cJaeVX3aA1KUT/h
         WbF4vlSAJQcz6e9Ut2vJwezKIvsTqu/vddAv21fNJydLWV/w8N+p4R64dvDPPXfZWcBz
         04cg==
X-Gm-Message-State: AOAM531jR3ndwBhm+a4LSEXJStGFNmteqRo7vZ1e9uEHmQeODSKmEerJ
        40ZMECELUypuBIguD2uvlFbdB2Ct1eYhj5JoIr4=
X-Google-Smtp-Source: ABdhPJy88wvN2n1DV+tHlOcK8/JwL0J1pw0kvN6UjqHzHeTxBXCgstnsMTJlNjLNiS8fcuQy+Lvy0A==
X-Received: by 2002:a17:903:2442:b0:138:8fdf:cf79 with SMTP id l2-20020a170903244200b001388fdfcf79mr1561870pls.75.1630534979512;
        Wed, 01 Sep 2021 15:22:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm11778pfj.65.2021.09.01.15.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:22:59 -0700 (PDT)
Message-ID: <612ffd43.1c69fb81.49969.00dd@mx.google.com>
Date:   Wed, 01 Sep 2021 15:22:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.13-114-g5315cdf77073
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 192 runs,
 3 regressions (v5.13.13-114-g5315cdf77073)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 192 runs, 3 regressions (v5.13.13-114-g5315c=
df77073)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =

beagle-xm        | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =

imx6ul-14x14-evk | arm  | lab-nxp      | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-114-g5315cdf77073/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-114-g5315cdf77073
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5315cdf77073a2a34a80589fac69c7a677c78f4e =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612fc83963a157a5abd59670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc83963a157a5abd59=
671
        failing since 1 day (last pass: v5.13.13-73-g193ded4206f9, first fa=
il: v5.13.13-97-g4abdf2bb4e76) =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612fc6597383db208ed59780

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc6597383db208ed59=
781
        failing since 35 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
imx6ul-14x14-evk | arm  | lab-nxp      | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/612fcb9263cc5cfe36d596a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-g5315cdf77073/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fcb9263cc5cfe36d59=
6a5
        new failure (last pass: v5.13.13-102-gb80430d7822b) =

 =20
