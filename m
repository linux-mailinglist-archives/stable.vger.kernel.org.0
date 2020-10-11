Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11928AA22
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 22:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgJKUPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 16:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgJKUPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 16:15:42 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA22C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 13:15:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a200so11483609pfa.10
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 13:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w8pi8K5drvgTWhJ58D0uhKoS+OUh4E61uUpcs2WNO/g=;
        b=MRcjs8C0hUAvCf7FFPkdHSeDVeej6Fm06nza7eie2MsRcWBl4M7KkDQYUx+BqDZXrK
         8BnJBd+L5FkG+1wB2f/uyCGqTvdOk87DKPHtGrYHR+vcvb5J/whzTOWALpp3dMIxrJLp
         tszXKJAScaTQnSUVXCBA5eWOEIpqf08Z2eU58O5HHHTNnm5HVPaMJJ00Nib2lMAoyTWr
         uwSkJjj50LFMcxcNJsHJfj2ci5Tyx694CKdihcbt4Nl6fm7m8cOtgcUK/LCLx2Ekcmfa
         oiMBuvbJJ1K7CI2znNOqWsBP8N4CeBVRfhLuEm0/y0e7ZSE3kow8C42K/elKpKtKVGzv
         p8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w8pi8K5drvgTWhJ58D0uhKoS+OUh4E61uUpcs2WNO/g=;
        b=hC5uLnV4B6wA7sXIJLr7pxtNXbGy8vUGlSC9MjzJxGmH4uaDZNVhqbImoW7Hbn2N1k
         oFLAMZtScZNISU7/Fz8pejtdPWdUmSZGD1bDx1E2PTSNWfvh23CD+O8uJQsBr22jRY/G
         p65Hw+JU71J/sFImxmxVR8ZkvlJ2TzBYEIeMeL7zb3kg/i71NBoHgpWtp0MCJabHAZVB
         gEaEnYVxPfRw2IAj3/0hocQTqJocqmzOmWByIOYSSAB4AxdOyUNy5H/ZmZx2rZF6HRgJ
         UnHHE8z3r1ppEcN0V8YanFwBBoxb7PZI/aSaoB45slFqKY0afhFMfg87NLuhNPM0N/Jv
         WYRw==
X-Gm-Message-State: AOAM53260Ou2Q/xtFIWtLrzQmvd6yb+ErcI0N6rk3/CZMhdsNznDVxi0
        EWb4khkUoHPVZNZa9qfAaAe7V6Mmep19Lg==
X-Google-Smtp-Source: ABdhPJyJmCwOghe+847ShHKKMUir12UdvA6balilpxBtpnL7q+1XF9xjHSOZ0gOauJqeo/OVWu01ag==
X-Received: by 2002:a17:90a:1a02:: with SMTP id 2mr16843323pjk.201.1602447341152;
        Sun, 11 Oct 2020 13:15:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm3952175pjg.0.2020.10.11.13.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 13:15:40 -0700 (PDT)
Message-ID: <5f8367ec.1c69fb81.98fd6.7975@mx.google.com>
Date:   Sun, 11 Oct 2020 13:15:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-46-geff08a1fdd2e
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 153 runs,
 5 regressions (v5.4.70-46-geff08a1fdd2e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 153 runs, 5 regressions (v5.4.70-46-geff08a1f=
dd2e)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
| results
-------------------+--------+---------------+----------+-------------------=
+--------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
| 3/4    =

qemu_x86_64-uefi   | x86_64 | lab-cip       | gcc-8    | x86_64_defconfig  =
| 0/1    =

rk3399-gru-kevin   | arm64  | lab-collabora | gcc-8    | defconfig         =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-46-geff08a1fdd2e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-46-geff08a1fdd2e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eff08a1fdd2e6d075cf7d3a8bb63c494c849a4d0 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
| results
-------------------+--------+---------------+----------+-------------------=
+--------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f83227fb826d9c8c44ff3e3

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f83227fb826d9c=
8c44ff3e9
      new failure (last pass: v5.4.70-31-gf8a7c17f9bb0)
      28 lines

    2020-10-11 15:19:16.348000  kern  :emerg : Stack: (0xeae4bec0 to 0xeae4=
c000)
    2020-10-11 15:19:16.349000  kern  :emerg : bec0: 00000000 00000000 0000=
0000 eae82060 00000054 00100cc2 000000a3 b6ecf000
    2020-10-11 15:19:16.350000  kern  :emerg : bee0: eaecedb8 eaecedb8 0000=
0000 00000000 00000000 00000000 c452b318 eaf9e1fc
    2020-10-11 15:19:16.351000  kern  :emerg : bf00: 00000000 c159b707 eae4=
bfb0 b6ec6e68 eae82060 00000054 eae4df80 eaf9e1c0
    2020-10-11 15:19:16.389000  kern  :emerg : bf20: eae4bf7c eae4bf30 c011=
2fe0 c020fe00 eae4bfac eae4bf40 c0101a00 c0113290
    2020-10-11 15:19:16.391000  kern  :emerg : bf40: b6fc3b38 beffffff 0000=
0000 eaf9e1fc eae4a000 00000007 c0d0912c b6ec6e68
    2020-10-11 15:19:16.391000  kern  :emerg : bf60: eae4bfb0 10c53c7d b6f6=
d000 b6fc3f90 eae4bfac eae4bf80 c0113394 c0112e34
    2020-10-11 15:19:16.392000  kern  :emerg : bf80: eae4bfac eae4bf90 c014=
3168 c01299b4 b6ec6e68 60000010 ffffffff 10c5383d
    2020-10-11 15:19:16.393000  kern  :emerg : bfa0: 00000000 eae4bfb0 c010=
2054 c0113358 00000000 00000000 00000000 00000000
    2020-10-11 15:19:16.433000  kern  :emerg : bfc0: b6fc3b38 00000000 0000=
0000 00000078 00000000 b6f6d000 b6fc3f90 002740d0
    ... (16 line(s) more)
      =



platform           | arch   | lab           | compiler | defconfig         =
| results
-------------------+--------+---------------+----------+-------------------=
+--------
qemu_x86_64-uefi   | x86_64 | lab-cip       | gcc-8    | x86_64_defconfig  =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f83236de988780c124ff3fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f83236de988780c124ff=
3fe
      new failure (last pass: v5.4.70-31-gf8a7c17f9bb0)  =



platform           | arch   | lab           | compiler | defconfig         =
| results
-------------------+--------+---------------+----------+-------------------=
+--------
rk3399-gru-kevin   | arm64  | lab-collabora | gcc-8    | defconfig         =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8306f7d5f72c20004ff3e9

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-46=
-geff08a1fdd2e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8306f8d5f72c20004ff3fd
      failing since 11 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-11 13:21:51.476000  /lava-2712480/1/../bin/lava-test-case
    2020-10-11 13:21:51.486000  <8>[   20.615654] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8306f8d5f72c20004ff3fe
      failing since 11 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-gyro0-prob=
ed: https://kernelci.org/test/case/id/5f8306f8d5f72c20004ff3ff
      failing since 11 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-11 13:21:53.519000  /lava-2712480/1/../bin/lava-test-case
      =20
