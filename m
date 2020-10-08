Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EF2286D69
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 05:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgJHD4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 23:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgJHD4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 23:56:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A2FC061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 20:56:35 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g29so3136013pgl.2
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 20:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CBfByNNF3huhCYfDGtZQXniUErC21nG9C+TLpmd+JdU=;
        b=T8817NO0ryYdo1u1usMy3eS/LjULi4ELyDeCNbWxOXd7nGQFXk9j7IjySoTEvQipFO
         77VQRpG86qesClxZDqPb/GcpVVggkJIfNJvPbcZpqXLC0rhfHFZDj/Hr2LFro4pv9d/b
         BLuYPsziIuzYm/jObYFVQxageIVKUETmY8TVZeLIet9qyij0LtuupMUqU/U4DjQsJKdy
         1KjtdNtKYvZPnsp1zSJ28PkrKMAfxZRD1a+APk/p2qPjd05H3Yk6vNuAh3kW3BT+E1GT
         OPJUQB27LEAC06z3zmwF9GluMHna+C/h3guuuDG2IGSyBL29rYtQuPRHsE6iepj29V1w
         dgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CBfByNNF3huhCYfDGtZQXniUErC21nG9C+TLpmd+JdU=;
        b=XJi0nxt9dS1yNpCeuYw14+9KQolX34A/cMuxhLj+oS2swYcZC+9RHilIg4/KDD6uxC
         ZLV4XgSmiuu7KRZuJwSOyavpQHoDRZ6lP4Bf6+9wfEC3BvDkhoLDRahGOuxeBaqdLPfK
         Dk8unB5j2ocR/m+qN6qHhDdRtiejoF2AvKrr5TVS3CAU1m5vdBxTmok2CM0jIFeWzxzl
         cL/G49AlFexOvPa2+WBiook7A1Mks7KiqAoRb9JOiVF916uttSLtmUSeYhquUyrsFQpG
         xTThB//nTLTO5KSGbKyLqCNfmtdx/mJSt1wfmS4IP8PFkb/XK/A4b4wn2RhHR2aZG0LP
         jBTw==
X-Gm-Message-State: AOAM5332u+NNZd0jC5MDQo/usPmq6wj3l1bvIImMnsusr2NP6FXzcSPY
        f1PizQWXJua4ivjAU57xj5SEW927WBNFhA==
X-Google-Smtp-Source: ABdhPJyP5YvZpXiy7j7cyxQ1xcS8zJvDjqM4meY6YbSmb/XHDQPRqil96JKijwBgBVpHHMJU5DK70g==
X-Received: by 2002:a65:5a0f:: with SMTP id y15mr5597358pgs.395.1602129393056;
        Wed, 07 Oct 2020 20:56:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mw11sm4188136pjb.57.2020.10.07.20.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 20:56:32 -0700 (PDT)
Message-ID: <5f7e8df0.1c69fb81.d020c.83c8@mx.google.com>
Date:   Wed, 07 Oct 2020 20:56:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-9-g08ae63af42e6
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 134 runs,
 5 regressions (v5.4.70-9-g08ae63af42e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 134 runs, 5 regressions (v5.4.70-9-g08ae63a=
f42e6)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.70-9-g08ae63af42e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.70-9-g08ae63af42e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08ae63af42e6024dd9c216d0588895ff37b4afbf =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7e4c52ee3f7e15d24ff3ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7e4c52ee3f7e15d24ff=
3eb
      failing since 179 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7e3b5d9024f60e2e4ff3e9

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7e3b5d9024f60e=
2e4ff3ed
      new failure (last pass: v5.4.69-58-g7b199c4db17f)
      3 lines

    2020-10-07 22:01:31.055000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 22:01:31.055000  (user:khilman) is already connected
    2020-10-07 22:01:46.182000  =00
    2020-10-07 22:01:46.183000  =

    2020-10-07 22:01:46.184000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 22:01:46.184000  =

    2020-10-07 22:01:46.184000  DRAM:  948 MiB
    2020-10-07 22:01:46.198000  RPI 3 Model B (0xa02082)
    2020-10-07 22:01:46.285000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 22:01:46.317000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (386 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7e3b18abd89c4b5a4ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.70-=
9-g08ae63af42e6/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7e3b19abd89c4b5a4ff3f4
      failing since 8 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-07 22:02:53.601000  <8>[   23.212509] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7e3b19abd89c4b5a4ff3f5
      failing since 8 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196) * baseline.bootrr.cros-ec-sensors-gyro0-probe=
d: https://kernelci.org/test/case/id/5f7e3b19abd89c4b5a4ff3f6
      failing since 8 days (last pass: v5.4.68-388-g8a579883a490, first fai=
l: v5.4.68-389-g256bdd45e196)

    2020-10-07 22:02:55.635000  /lava-2701995/1/../bin/lava-test-case
    2020-10-07 22:02:55.644000  <8>[   25.255790] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
