Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913772A20CA
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 19:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgKASfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 13:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgKASfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 13:35:43 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08AAC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 10:35:41 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s35so1275744pjd.1
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 10:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o+lZ+JFFFhCBqrOGW7clWidNNriUl4H4az/YgUk9wCI=;
        b=sMkcD1ZlxkSTv6ByJXIQlojQe6f8m2ULIQU9//dn3FyrVSRkuL499CJ4pOCmscMNHg
         KSNp9mJaWgLeH22GooJP1I3nWHdbCjIwtXu834bxqwsw85leRxSewTT/whOFyJEJn9K+
         5gI02eXfO7q5gAr9jibBP6l5K563wV4lvoZcu4SYFGEwv1QEVSMI863DmpMa+02wgify
         OHEBCTaf8godjWNG6pj+mRGLWOG4JwDP5U0/F8IyPcdWT3RF8vK4viF2lHR1vD3n8yh7
         56Y0N5wl1dS+YiyYHq7ctsQj9huhOwh6F5i6vbLlVMn3Z+btgslp7ygL3fBPuduNU76G
         Guxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o+lZ+JFFFhCBqrOGW7clWidNNriUl4H4az/YgUk9wCI=;
        b=LBsOuS3/xjPwozz2dI6SNS3BByAZOlC+BICzt3WGLa52xV+HVunhiyN0K2clA9+3Rd
         FDyUGichy+I3nhgbPFjaNqXqwY1yohKFAjn/vXBTixOvSY5aP8DqwJ8dwhUHBgXChF3D
         9bsUqxJqg/4J0m4jxn2quBWmc1p5T9l/7JKD4eI+bzfe1tjgz0lWWszyN/pRxKK0rQ3C
         Mxi29TlXuHzJ9/fTj66tPL19P8ryBfQ6zXVfyE83NNAKlZEwZLpmW67uFSkboNtSZnOM
         n4QcMtnJ2SkfixPbOuLRZm0MIXItV9DU4xk/RirLTP5/JyBZSIgoJTmNXnvqrhiy6750
         Gz4w==
X-Gm-Message-State: AOAM532MLdgVhV9gdlrsc3/L0BONhdW8Ni8I4qFIGKiVKt1ZK9CJclBL
        2B1cd4DsE9KeewOeNapkoioUmDba8k8QKQ==
X-Google-Smtp-Source: ABdhPJz7Ph4akrl7J+j4h798IuqKkoIFlfPRSEI1cYobN6ucwpSdX5txyFeg6Q/gA/lvoxnB4pZ5gQ==
X-Received: by 2002:a17:902:9347:b029:d3:b2c6:1500 with SMTP id g7-20020a1709029347b02900d3b2c61500mr18473264plp.5.1604255740611;
        Sun, 01 Nov 2020 10:35:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm12276788pfj.90.2020.11.01.10.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 10:35:39 -0800 (PST)
Message-ID: <5f9efffb.1c69fb81.3c47d.0ce5@mx.google.com>
Date:   Sun, 01 Nov 2020 10:35:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 132 runs, 7 regressions (v4.4.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 132 runs, 7 regressions (v4.4.241)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =

panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8dfc31cb1f532f20ae71ca049a84c40226f30753 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/5f9b4382de644be978381032

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9b4382de644be9=
78381037
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        1 lines

    2020-11-01 14:32:39.875000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-01 14:32:39.875000+00:00  (user:khilman) is already connected
    2020-11-01 14:32:51.146000+00:00  =00
    2020-11-01 14:32:51.152000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-01 14:32:51.156000+00:00  Trying to boot from MMC1
    2020-11-01 14:32:51.346000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-01 14:32:51.586000+00:00  =

    2020-11-01 14:32:51.587000+00:00  =

    2020-11-01 14:32:51.593000+00:00  U-Boot 2018.09-rc2-00001-ge6aa9785acb=
2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-01 14:32:51.593000+00:00   =

    ... (446 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b4382de644be=
978381039
        new failure (last pass: v4.4.240-19-ge3d3be91473e)
        28 lines

    2020-11-01 14:34:25.244000+00:00  kern  :emerg : Stack: (0xcb945d10 to =
0xcb946000)
    2020-11-01 14:34:25.252000+00:00  kern  :emerg : 5d00:                 =
                    bf0328fc bf017b84 cb97aa10 bf032988
    2020-11-01 14:34:25.260000+00:00  kern  :emerg : 5d20: cb97aa10 bf2230a=
8 00000002 cb83a010 cb97aa10 bf247b54 cbcd16f0 cbcd16f0
    2020-11-01 14:34:25.269000+00:00  kern  :emerg : 5d40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-11-01 14:34:25.277000+00:00  kern  :emerg : 5d60: ce228930 cbcd16f=
0 cbcd17b0 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-11-01 14:34:25.285000+00:00  kern  :emerg : 5d80: ffffffed bf24bff=
4 fffffdfb 00000021 00000001 c00ce2f4 bf24c188 c04070c8
    2020-11-01 14:34:25.293000+00:00  kern  :emerg : 5da0: c09612c0 c120da3=
0 bf24bff4 00000000 00000021 c040559c c09612c0 c09612f4
    2020-11-01 14:34:25.301000+00:00  kern  :emerg : 5dc0: bf24bff4 0000000=
0 00000000 c0405744 00000000 bf24bff4 c04056b8 c0403a68
    2020-11-01 14:34:25.310000+00:00  kern  :emerg : 5de0: ce0b08a4 ce22191=
0 bf24bff4 cbbea6c0 c09dd3a8 c0404bb4 bf24ab6c c095e460
    2020-11-01 14:34:25.318000+00:00  kern  :emerg : 5e00: cbbb9e40 bf24bff=
4 c095e460 cbbb9e40 bf24f000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b4382478fe3e587381036

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b4382478fe3e=
58738103d
        new failure (last pass: v4.4.241-9-gc264933bf666)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b431e36c853af6a381014

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b431e36c853af6a381=
015
        new failure (last pass: v4.4.241-9-gc264933bf666) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b431f413e950cea381019

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b431f413e950cea381=
01a
        new failure (last pass: v4.4.240-113-gb3d9b0c29dc8) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b43d2292a2d8a90381015

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b43d2292a2d8a90381=
016
        new failure (last pass: v4.4.241-9-gc264933bf666) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b43d3d0e76d23df381050

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b43d3d0e76d23df381=
051
        failing since 1 day (last pass: v4.4.241, first fail: v4.4.241-9-gc=
264933bf666) =

 =20
