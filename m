Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28F824E1C1
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHUUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgHUUCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:02:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D04C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:02:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 17so1581399pfw.9
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2Ww8xh4vjzI7T2JePZ4OGb9dJA8VDxg6HHuBdhs+SwA=;
        b=Y8t1TWcmgYnCks/KA/nSeJzEA2A1CDN87I5BtVrsPBOjy5MLYt2+gdHZXRbbxXuGKT
         rRHheApldfX2o62pz5kd+V07W4uWO00XNnXcM2f0/UwC4KIKmtYmtx0b6t5a7zMyA/xX
         uPFR4RKzQ8y1eRUKsc59yzk9de5To3FHWr2Sp1dhOIt3U39pLkPg6PiAdojv5LLfdTk1
         7t4bI4dW3QEnMIAx2XlptP0KNo9CwM/xH0FAyp/CaeFlylLhn8t2NEpZ1fsvqSCd2vd8
         ILQMRslenPoLOSoOP5Ex5vdm6nIA4Kb+ZqoS26BpG9sJu5FrXHfFc/Q9utN5Rboc8Woj
         jt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2Ww8xh4vjzI7T2JePZ4OGb9dJA8VDxg6HHuBdhs+SwA=;
        b=ukR7Da/dAKi2ZM0Bmo8FRegRjKke9xoTxFJqNYlcpHfB9glAT4z/0br60ZPfRcVWpt
         /v3kNAnWCG40AeSK9CxIMZrilAkr2jyJ6mImgDI1nDuhjr1gR+YVsdnjRzA9YCcPmYYg
         syVN6wjQ6zdw6M9SnnYdeX5iWf8lNdydEUJa1cRHVFaOQ6+ED5/DXtevOsprAY8eHojq
         RxQ9+SbTgW8tJNXXBVXAUJoJT1RjQFPm7P1ohXqWUIeTBesHbtkQsp9rBpMDdvZtV60P
         mx3uV87lAP90zDnDSmVdNUxTsNvLVbNSRR04w8bdZ5CwxJrnTOW1ldAC31cQv/Tn3AF6
         fa1A==
X-Gm-Message-State: AOAM531eLH9ba7gQ03Zfs9KWE1yQQCDOdL55Z6D16eu199y9pDtnmHai
        h0VD+lxJ9HQgGiCICSp+g/of0Q7jWf/1Nw==
X-Google-Smtp-Source: ABdhPJxUHOQf/u9fyV5z4Odu9tOPa9/AFNeHQl7oBTQ7NA2A87TT8qljogIqxqkoy+zIP/Ag+pmmow==
X-Received: by 2002:a62:86ca:: with SMTP id x193mr3705645pfd.152.1598040140203;
        Fri, 21 Aug 2020 13:02:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 12sm3311647pfn.173.2020.08.21.13.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:02:19 -0700 (PDT)
Message-ID: <5f40284b.1c69fb81.13d6c.a2a1@mx.google.com>
Date:   Fri, 21 Aug 2020 13:02:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.60
Subject: stable-rc/linux-5.4.y baseline: 182 runs, 3 regressions (v5.4.60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 182 runs, 3 regressions (v5.4.60)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
 | 0/1    =

bcm2837-rpi-3-b       | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig=
 | 3/4    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
 | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77fcb48939fc863d9ba9d808fac9000959e937d3 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3ffc993abcc447df9fb433

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3ffc993abcc447df9fb=
434
      failing since 131 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
bcm2837-rpi-3-b       | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig=
 | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f3fefc2c733e03c4c9fb42c

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f3fefc2c733e03=
c4c9fb432
      new failure (last pass: v5.4.59-153-g6793ee834d88)
      84 lines

    2020-08-21 16:00:54.021000  kern  :emerg : Stack: (0xeaeabdf8 to 0xeaea=
c000)
    2020-08-21 16:00:54.022000  kern  :emerg : bde0:                       =
                                eaeabea8 eae8fcc0
    2020-08-21 16:00:54.022000  kern  :emerg : be00: eaeabf58 00000001 ffff=
ff9c eaeaa000 eaeabea4 eaeabe20 c024b494 c0249be8
    2020-08-21 16:00:54.023000  kern  :emerg : be20: 00000001 c0d586fc c0d0=
e880 c057d164 00000000 c0d0e418 00000000 c0902bc0
    2020-08-21 16:00:54.063000  kern  :emerg : be40: eaeabe74 00000041 c014=
6cc0 c057d170 eaeabf58 c057d170 ec4f9fb0 c013b970
    2020-08-21 16:00:54.064000  kern  :emerg : be60: ffffffff 00000000 eaea=
be9c eaeabe78 c013b970 33b60051 ec50e018 0000000c
    2020-08-21 16:00:54.065000  kern  :emerg : be80: c0d04248 eaeabf58 0000=
0001 ffffff9c eaeaa000 00000142 eaeabf54 eaeabea8
    2020-08-21 16:00:54.066000  kern  :emerg : bea0: c024bec0 c024b2e4 0000=
0000 00000000 00000cc0 c022f80c eaeabedc eaeabec8
    2020-08-21 16:00:54.066000  kern  :emerg : bec0: 00000000 c0258b58 0000=
0000 00001051 eaeabf14 0000004c 00000001 00000000
    2020-08-21 16:00:54.107000  kern  :emerg : bee0: 00000000 eaeabee8 eaea=
bf0c eaeabef8 c0257e68 c0257d9c 0000000c eae9c0d4
    ... (72 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig        =
 | results
----------------------+-------+--------------+----------+------------------=
-+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
 | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f3fed41b13b7aa5729fb447

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3fed41b13b7aa5=
729fb44b
      failing since 1 day (last pass: v5.4.59-75-gbdc7345fed30, first fail:=
 v5.4.59-153-g6793ee834d88)
      1 lines

    2020-08-21 15:48:25.471000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-21 15:48:25.471000  (user:khilman) is already connected
    2020-08-21 15:48:41.115000  =00
    2020-08-21 15:48:41.136000  =

    2020-08-21 15:48:41.136000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-21 15:48:41.137000  =

    2020-08-21 15:48:41.137000  DRAM:  948 MiB
    2020-08-21 15:48:41.152000  RPI 3 Model B (0xa02082)
    2020-08-21 15:48:41.239000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-21 15:48:41.271000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =20
