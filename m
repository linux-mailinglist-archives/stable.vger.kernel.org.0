Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92E31DBF4
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 16:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhBQPMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 10:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhBQPEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 10:04:47 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89454C061786
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:04:03 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c11so8560966pfp.10
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 07:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0jtyPT+P1eZjcPy5Xqe7Ts9bIohb8N7QDR5Qh+bSWG0=;
        b=MZorBnujb/g3YhUfge8zjaB7qJNF1mQ/GbZcNZO1eycnsvqNFovhM8WJBaEFaX6YWT
         cRk86k0VmATrVzWLy9T+hyDoNw4D0OAAoXV/FoJHley9fRjiQ3pDqcUJhOJz0h3x25I+
         8qJCL5XObB4Fj+HoaOGqMBL/tTtTpRSM/on+QClV9dQWtLhzcqDrIlOvp9qKp0QYJZxw
         3HOut+BBJm/cMD6lR996AOB8hfc5h+3FBKN7gKd+1BbuT2/cxsUo+oWEiPX9FcolkRef
         t3X8RTz37S86Mjol/cEtyee8bHrLw67fwvzgF2saaE0lpRxCxHgMebfVu5bsgUZpnQs/
         LKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0jtyPT+P1eZjcPy5Xqe7Ts9bIohb8N7QDR5Qh+bSWG0=;
        b=KUYngdfHLpbUEgwwXaGsvZSF2za8rzNOqR3MMxVN8UdzAzM4TFfnrkSBsk6e2QwaAu
         jush99TxQ64AhqaKdz5r4upw6WhTSVu4LWtE5PmWBtz/zk5vczI9mHiekXjDLj0lLETK
         Jjs4HVnzliGjxDPr3IpzWL7US2UJv7zUClO/a1YprYyOC36qvVsPzDWIJlC8E6IL8+eH
         5OtStVnVw73TeMRuulJDSmjczk58BxaJ0ThwU7hjdxTAB+SoxQZonO7bNPez3RZYYrPP
         NnqnfCSGKsdC9lEMXO194unobdLaSDbaox1yBs1ncgcxvFnvBXAsjJ5UCEugb36C/9gF
         ImZw==
X-Gm-Message-State: AOAM531NuD7JY4dH5rRTf2e+SFRpXagdCUq8OBLUR8NbeZ4N3sx9JjVi
        MBOlUWukf0fr3sDwHwNRmlO75+smVtIcew==
X-Google-Smtp-Source: ABdhPJwhVwVS+35fy4qGkJtRwzIn1VvPyBu0mttbnhM0X1c9UMgt3BpyvOzFzFVPvGMUldAjf1XCeA==
X-Received: by 2002:a63:c10:: with SMTP id b16mr25022173pgl.326.1613574242680;
        Wed, 17 Feb 2021 07:04:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x20sm2785353pfi.115.2021.02.17.07.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 07:04:02 -0800 (PST)
Message-ID: <602d3062.1c69fb81.ba40b.5a97@mx.google.com>
Date:   Wed, 17 Feb 2021 07:04:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-g99b2feb86d78c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 85 runs,
 4 regressions (v4.19.176-37-g99b2feb86d78c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 85 runs, 4 regressions (v4.19.176-37-g99b2fe=
b86d78c)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig             |=
 regressions
---------------+-------+---------------+----------+-----------------------+=
------------
da850-lcdk     | arm   | lab-baylibre  | gcc-8    | davinci_all_defconfig |=
 2          =

meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig             |=
 1          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig   |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-37-g99b2feb86d78c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-37-g99b2feb86d78c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99b2feb86d78c273200e5095cd08dcb26feac5e3 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig             |=
 regressions
---------------+-------+---------------+----------+-----------------------+=
------------
da850-lcdk     | arm   | lab-baylibre  | gcc-8    | davinci_all_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/602cf6021120a7c325addcc1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/602cf6021120a7c=
325addcc5
        new failure (last pass: v4.19.176-37-ga630db879c87e)
        3 lines

    2021-02-17 10:54:51.629000+00:00  kern  :alert : raw: 00000000 00000100=
 00000200 00000000 00000004 0000000a ffffff7f 00000000
    2021-02-17 10:54:51.629000+00:00  kern  :alert : page dumped because: n=
onzero mapcount
    2021-02-17 10:54:51.689000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602cf6021120a7c=
325addcc6
        new failure (last pass: v4.19.176-37-ga630db879c87e)
        2 lines

    2021-02-17 10:54:51.830000+00:00  kern  :emerg : flags: 0x0()
    2021-02-17 10:54:51.914000+00:00  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-02-17 10:54:51.914000+00:00  + set +x
    2021-02-17 10:54:51.915000+00:00  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 733541=
_1.5.2.4.1>
    2021-02-17 10:54:52.021000+00:00  #   =

 =



platform       | arch  | lab           | compiler | defconfig             |=
 regressions
---------------+-------+---------------+----------+-----------------------+=
------------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig             |=
 1          =


  Details:     https://kernelci.org/test/plan/id/602cf5ee85a09cba44addce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602cf5ee85a09cba44add=
cea
        new failure (last pass: v4.19.176-36-gb2b94a71682a) =

 =



platform       | arch  | lab           | compiler | defconfig             |=
 regressions
---------------+-------+---------------+----------+-----------------------+=
------------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/602cf667ee84bdd65baddcbb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g99b2feb86d78c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602cf667ee84bdd=
65baddcc0
        new failure (last pass: v4.19.176-37-ga630db879c87e)
        2 lines

    2021-02-17 10:56:35.065000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
