Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43388429764
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhJKTQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 15:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhJKTQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:16:18 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B93C061745
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:14:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y4so2393plb.0
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wBIPw+Xy5gmU5lIn5fPlAXEWQQYw99GFGkAtyDTaPZQ=;
        b=JqMeeB9EPfkOBgVlK9VA3uXnY8WNXtMxFqQmoc5KW1Q9hxRBJisz0g2Azq17PN238Z
         G6roply9MClkEKvClzvOWsvHuwkTu2/u56jq1RqKa1FW4qoYfZDlwr7go8SCTi0RydoN
         4W/BQDNGP1zEyzSXIjH6Iwx+aARHTFVvp1xBiTzH6OReSGRB7hkTr8shfdf67njwNfW2
         VkDxXwRPwYtMcmriVxlFa6unt2e5gdFDIeR+fcyUig3EGgBum0DToj2+mBlDvhFmU6h/
         9NE1D12hgrlcS7GO+6arw/Osw5eLmSyeObO4fOTnbh4GbPESpGK3zHZwL1uLboEJScSV
         o5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wBIPw+Xy5gmU5lIn5fPlAXEWQQYw99GFGkAtyDTaPZQ=;
        b=gK45GQdZA51YQQnk1OwTNtL+DNB4sSebU/+AoTimOgG9VPjE/bjvCOVbUf2znXHRyc
         AX8QUnBVOL6vgeBUnr9Iswdif0r7l12p3d/2cfXp7yhT/MrUS8DcDEShgyhxTTV/a+om
         vEyGHGfcGyRO8v+op9LS1h/BGrAuC9rDgn7/mJKNJrIgpsZrLaj0az3cwpBcnfOKU0F9
         /tqezYZcN/3aLeVo9iiMt/lg8sWUziX1Eh6T0csZF1zgAYd+P6ZxH5tU6D0KXMP5WWd4
         AyktoLV43HrJWHmc9A53UPPOPa36quIgu+k/3KoI0/44SW8u2C+177T3R96zRsLHozg/
         WIAQ==
X-Gm-Message-State: AOAM531FBNu4RcBAFYXWBaMtYznFk5wPUtV5HInvOT3zNRK92T26fL7o
        7CF9K/3VPDQx8rnqbrNMV/ejNNyoiRTGznIE
X-Google-Smtp-Source: ABdhPJxWFPESu56Mj8v2AcoyoYFpl6wBAB38PFwXl0L/ullOJA+S6Or5HI0/axCq0cRVA267LJm9Sg==
X-Received: by 2002:a17:902:be0f:b0:13a:19b6:6870 with SMTP id r15-20020a170902be0f00b0013a19b66870mr26500322pls.64.1633979657581;
        Mon, 11 Oct 2021 12:14:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm203359pjp.50.2021.10.11.12.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:14:17 -0700 (PDT)
Message-ID: <61648d09.1c69fb81.aa4f8.113f@mx.google.com>
Date:   Mon, 11 Oct 2021 12:14:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-11-g7a2651cfbc81
Subject: stable-rc/linux-4.4.y baseline: 64 runs,
 3 regressions (v4.4.288-11-g7a2651cfbc81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 64 runs, 3 regressions (v4.4.288-11-g7a2651=
cfbc81)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.288-11-g7a2651cfbc81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.288-11-g7a2651cfbc81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a2651cfbc81b8a2c855a063eea3e275cab08df3 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/616445043ec452548d90dc8d

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-11-g7a2651cfbc81/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-11-g7a2651cfbc81/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/616445043ec45254=
8d90dc90
        failing since 1 day (last pass: v4.4.287-8-gc9a8123a0640, first fai=
l: v4.4.288)
        1 lines

    2021-10-11T14:06:47.311255  /
    2021-10-11T14:06:47.414513   # #
    2021-10-11T14:06:47.415312  =

    2021-10-11T14:06:47.516981  / # #export SHELL=3D/bin/sh
    2021-10-11T14:06:47.517437  =

    2021-10-11T14:06:47.618557  / # export SHELL=3D/bin/sh. /lava-936452/en=
vironment
    2021-10-11T14:06:47.618898  =

    2021-10-11T14:06:47.720105  / # . /lava-936452/environment/lava-936452/=
bin/lava-test-runner /lava-936452/0
    2021-10-11T14:06:47.721253  =

    2021-10-11T14:06:47.722464  / # /lava-936452/bin/lava-test-runner /lava=
-936452/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616445043ec4525=
48d90dc92
        failing since 1 day (last pass: v4.4.287-8-gc9a8123a0640, first fai=
l: v4.4.288)
        28 lines

    2021-10-11T14:06:48.184605  [   50.029602] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-11T14:06:48.237961  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-11T14:06:48.243750  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb90a218)
    2021-10-11T14:06:48.248261  kern  :emerg : Stack: (0xcb90bd10 to 0xcb90=
c000)
    2021-10-11T14:06:48.256628  kern  :emerg : bd00:                       =
              bf03283c bf017b84 cb970610 bf0328c8
    2021-10-11T14:06:48.269583  kern  :emerg : bd20: cb970610 bf21e0a8 0000=
0002 cb[   50.111907] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/616444e869496ff6a990dcb5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-11-g7a2651cfbc81/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-11-g7a2651cfbc81/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616444e869496ff=
6a990dcb8
        new failure (last pass: v4.4.288)
        2 lines

    2021-10-11T14:06:19.393492  [   19.460205] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-11T14:06:19.445079  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-10-11T14:06:19.454305  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
