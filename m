Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F0C2A5D40
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 04:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgKDD7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 22:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKDD7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 22:59:53 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB23AC061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 19:59:53 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r186so15441780pgr.0
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 19:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5bmqRRvnG63binAVSxpQwSCn0QDVUc4aUeQEjbEZkyc=;
        b=C9GSG0F9pZzlEmecZBlc7MWZa2MK0lxEqsJq7XEB7V7TogguKzpxVg/er9EGqQsvKn
         D1BT74hnp+oh0cdYjl4rXXd0n1XU3fdr06kJwp2EEmF7CLN8fh7UYHT1bp5ETEcMS2zX
         wcNT44T+pKaIawPSc6vocwCbaGA39N755ndVPgIXd1TqjYFQLGn6yzkIeY6H3EEZvDNn
         8z6+p0MO9TiIi6EuSC64WSebM7h0tpkd8bnAsxVTNiAr4/Gu38ACnGq4cY4Cr2tIlV9O
         jv4aQyuJFUSsa81Aj8DjBIaLtrdX50yRDGZ3DIMZnt3YJ5D6YBMT/1wXm8GutxX/7OMh
         D9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5bmqRRvnG63binAVSxpQwSCn0QDVUc4aUeQEjbEZkyc=;
        b=m+3PW2htMyQx+cAsQ5q6JZZwf0qDoNGQs5RUdGX5twcFjFmkwmqAnLNuC3BSQRkN71
         T3uxa5UZlBD1FOP85LMP6O4m5b5bvwqTxfXX0TO+/ZmSELaiiGOJNAY/kSLP/fHyS9hu
         9G5fEvecfgdpxN9Z7iGufj0ZL4OW1Q94XYYD7awKPw5W6K+y+KTcDELEyx0lskvszt0d
         6hfJb+GZUTPGEPrS/pUK1vtJfxjtnsRufMfmZhONcxBgJRdUZ9C+k9vCBr24p4DFhp9a
         nddxUSe0ilO7l8QCd/DEoj/SEIfNo1cLh78qCZ86IAOSiDi1J0H3Qg6OQVNsx63DcCvx
         MoBQ==
X-Gm-Message-State: AOAM5336CGNglJwZUP789syeSVr19d6lDPRxzBbVlGWSM61GlCagfZOg
        E1unslIruk09Y75BSiyICiXl1qAbaWArlA==
X-Google-Smtp-Source: ABdhPJzAFziRq1zPw6EG8063KT53smytqWO99CCN9dU1fOAaFYePfaWRjQfeW1HOmGhqU2kF9LMWOg==
X-Received: by 2002:a17:90a:fd08:: with SMTP id cv8mr2382123pjb.203.1604462392709;
        Tue, 03 Nov 2020 19:59:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j1sm617090pfa.96.2020.11.03.19.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:59:52 -0800 (PST)
Message-ID: <5fa22738.1c69fb81.6faf7.26f3@mx.google.com>
Date:   Tue, 03 Nov 2020 19:59:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-67-g3cac5345fb08
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 88 runs,
 4 regressions (v4.4.241-67-g3cac5345fb08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 88 runs, 4 regressions (v4.4.241-67-g3cac53=
45fb08)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =

qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1   =
       =

qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.241-67-g3cac5345fb08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.241-67-g3cac5345fb08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3cac5345fb086a4a754cfd9dca9f0fac3b8cc0d5 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
beagle-xm   | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig | 2   =
       =


  Details:     https://kernelci.org/test/plan/id/5fa1f67af7327a2a92fb5319

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa1f67af7327a2a=
92fb531e
        failing since 5 days (last pass: v4.4.240-19-ge3d3be91473e, first f=
ail: v4.4.241)
        1 lines

    2020-11-04 00:30:03.568000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-04 00:30:03.568000+00:00  (user:) is already connected
    2020-11-04 00:30:03.568000+00:00  (user:khilman) is already connected
    2020-11-04 00:30:14.994000+00:00  =00
    2020-11-04 00:30:15+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 (=
Aug 15 2018 - 09:41:52 -0700)
    2020-11-04 00:30:15.004000+00:00  Trying to boot from MMC1
    2020-11-04 00:30:15.193000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-04 00:30:15.434000+00:00  =

    2020-11-04 00:30:15.435000+00:00  =

    2020-11-04 00:30:15.440000+00:00  U-Boot 2018.09-rc2-00001-ge6aa9785acb=
2 (Aug 15 2018 - 09:41:52 -0700) =

    ... (448 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa1f67af7327a2=
a92fb5320
        failing since 5 days (last pass: v4.4.240-19-ge3d3be91473e, first f=
ail: v4.4.241)
        28 lines

    2020-11-04 00:31:50.129000+00:00  kern  :emerg : Stack: (0xcb98fd10 to =
0xcb990000)
    2020-11-04 00:31:50.137000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cb99fa10 bf02b988
    2020-11-04 00:31:50.145000+00:00  kern  :emerg : fd20: cb99fa10 bf2190a=
8 00000002 cb8fb010 cb99fa10 bf246b54 cbc9cc30 cbc9cc30
    2020-11-04 00:31:50.153000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0857e94 00000001
    2020-11-04 00:31:50.162000+00:00  kern  :emerg : fd60: ce226930 cbc9cc3=
0 cbc9ccf0 00000000 ce226930 c0857e94 00000001 c09612c0
    2020-11-04 00:31:50.170000+00:00  kern  :emerg : fd80: ffffffed bf24aff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf24b188 c0407054
    2020-11-04 00:31:50.178000+00:00  kern  :emerg : fda0: c09612c0 c120da3=
0 bf24aff4 00000000 00000027 c0405528 c09612c0 c09612f4
    2020-11-04 00:31:50.186000+00:00  kern  :emerg : fdc0: bf24aff4 0000000=
0 00000000 c04056d0 00000000 bf24aff4 c0405644 c04039f4
    2020-11-04 00:31:50.195000+00:00  kern  :emerg : fde0: ce0c38a4 ce22091=
0 bf24aff4 cbcc66c0 c09dd3a8 c0404b40 bf249b6c c095e460
    2020-11-04 00:31:50.203000+00:00  kern  :emerg : fe00: cbcd2100 bf24aff=
4 c095e460 cbcd2100 bf24e000 c0406108 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
qemu_i386   | i386   | lab-baylibre | gcc-8    | i386_defconfig      | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5fa1f3fa57d8e759cdfb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f3fa57d8e759cdfb5=
309
        failing since 2 days (last pass: v4.4.241-9-gc264933bf666, first fa=
il: v4.4.241) =

 =



platform    | arch   | lab          | compiler | defconfig           | regr=
essions
------------+--------+--------------+----------+---------------------+-----=
-------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5fa1f64699b743e5f1fb530d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.241=
-67-g3cac5345fb08/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f64699b743e5f1fb5=
30e
        failing since 2 days (last pass: v4.4.241-9-gc264933bf666, first fa=
il: v4.4.241) =

 =20
