Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DB35C321
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbhDLJ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbhDLJyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 05:54:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA5BC06138D
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:53:01 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a12so8853485pfc.7
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 02:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LdMP3LZhsw7piXptN+IhuzsGF23amBxtFplvH8QpNpo=;
        b=oUeLSG7gRoeTTUykU+uXEd73h7DEJFwesBzJdc1j5Fu532fop7YkuJmhKnheMUsqcN
         St/X8A3GQSBwKsuSOTGPn7JVmKr7qyx5zdC5hlwG/7aWKKLN34okxG6ZagCz/dT8OErj
         Rw2QxakAPdTXn/pqkFykDVftQBtlgngLSLfBzS2dU2sW+pTjw7AhpWJ8yk+1/bMkdFCa
         kGOWbHqxVEfFYCpuhze+OBktIJvrNhYZIIBTJxm0IxzbltZa/15N1q2agn7wJ5ZJpbm1
         km3+ZK5FlMUi50G4f0fUfs8LjNjPw8gKHRH+S4jYstxLbHVMSfoENs6K0UElsnU4TE7y
         guUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LdMP3LZhsw7piXptN+IhuzsGF23amBxtFplvH8QpNpo=;
        b=VAdpLOyrBlLs67DDM0A96DJIV/p1oL4WcbbGqmnmXohn9FatosJD2uTyA+pmnMTqGR
         0De7BL6HunEjT/j2tnNCplEGsz15HmoJ+pb6qpJNeHhjom3tszfUZdrg7jfjhvuoDf6d
         o59nWjp43un4w4Pi3cd9TTAkCKDfSYqW0L9xjXHRxDD4/IJjvAxXnHCBevk83aigGhqT
         qkjYCKJvdaqTnZvYCslB76iBQ7keNEK5wQBe9M8Lj72P5YnykaQFl3cOV8Jpd0CNe4II
         ij6DrKV7rv8Ijb2gqabuMT10JTSjCVXSCV4G0UEpGI8vRYGV7JO2U79JT3DvLOIskw69
         cbVw==
X-Gm-Message-State: AOAM532jtOM8Yz97Z3mh3pi+YXFkElffOz/3pPXSC14ghP9v+408s5wW
        MhhgLDvpnaFi5VDN1xcCBuKlhkhjEdu051rH
X-Google-Smtp-Source: ABdhPJy9M6yECyK6D4ZX6CU15J7YuaYPmM1O2Ex8wDSZA5J0Ek0+W7WTow+qQbQsw5A1PIVGWK/YSw==
X-Received: by 2002:a65:5289:: with SMTP id y9mr25412865pgp.447.1618221180449;
        Mon, 12 Apr 2021 02:53:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm5046504pjh.28.2021.04.12.02.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:53:00 -0700 (PDT)
Message-ID: <6074187c.1c69fb81.3c11e.b1a5@mx.google.com>
Date:   Mon, 12 Apr 2021 02:53:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-37-gbf0a382a8fae7
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 118 runs,
 1 regressions (v4.14.230-37-gbf0a382a8fae7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 118 runs, 1 regressions (v4.14.230-37-gbf0a3=
82a8fae7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-37-gbf0a382a8fae7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-37-gbf0a382a8fae7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf0a382a8fae75b1b7c5a17c925bc692c5c22e82 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6073e434df4e260baddac6ef

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-37-gbf0a382a8fae7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-37-gbf0a382a8fae7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6073e434df4e260=
baddac6f6
        failing since 1 day (last pass: v4.14.230-14-g6c412903bfb3c, first =
fail: v4.14.230-17-gc57ce7bb4982e)
        2 lines

    2021-04-12 06:09:52.735000+00:00  [   20.256805] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-04-12 06:09:52.753000+00:00  [   20.286895] smsc95xx v1.0.6
    2021-04-12 06:09:52.772000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/95
    2021-04-12 06:09:52.781000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-12 06:09:52.795000+00:00  [   20.322387] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
