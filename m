Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66D7490BCD
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiAQPy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 10:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiAQPy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 10:54:27 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71407C061574
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 07:54:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id i8so11245377pgt.13
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 07:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qcLq7FzPCYFl2/Qqo+Iv1fp6xyBYtlaRnCCjGkeo2Rg=;
        b=EtMlGhPMB14jHOVnxnX4vjLMS5R0spcSr/ViFfx6tSrtwjwBoiWNUjnLGvUSlfKWy8
         5T7NBgTLOfoslydXhMv4pnVTCB8bDZn2Fo/arZxEmX/2+cRPuahtv/fxDL74m2/Iiy/j
         mdykaFyI8qQpVkWLNHsqH2pzZR7pu5A7APHTb/6MwSfk10Ji8lFr9eDTmHCjOCVYYNiP
         J5xDk/u/2qx0csPxKsjWqtUMuD6U5NxmHnwbIJ6ZlXcR8kRMco2OEPOxLnVIwvFnGI/M
         CvtbeyhZ7FEN1/aw5yR1gwDed+UuICBYcP1f9uEJgs9UbiWlCUOcVwy+Wm7c39k7evha
         JfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qcLq7FzPCYFl2/Qqo+Iv1fp6xyBYtlaRnCCjGkeo2Rg=;
        b=xzX+4dLpgMnZQ9v2eN4xZXdOCOu5hDyM44NtfvF/XlYeiJxkIiV7ydE9qqAxmb82lE
         oUfrzAcKUD+7K7PPiabTcO4nVwJY3DIoZTifISyYhTc5XTgilBM00htRU2WzDjrxCmfI
         9ceU4VqgDTqQ8Z9JkZqR9KuI27iX4XhTfI83Haaz//26xYV1Mx5I5nuocT6DchRrHi2i
         3bDRTr75FNkILNp36ih92I8KdegrrBn/xDjfgWajybFqimJn6+ICUYTDXEaJGmTz9Dkl
         US0HW+1QDV22Dhtq4sw3lwNGDTjjqOYrJpgHBk+mw1FUJ1/+MO5GYCAD6pKsgRFRScnh
         xvGA==
X-Gm-Message-State: AOAM531rI+6r0+mJMnDyJs3LaQQEWtU1ihdVLATFcay4bRbW1BbyDfdy
        x+c2jAGOREs07dXQKhqkSuBJh6MNBHSafj9b
X-Google-Smtp-Source: ABdhPJzr83VJWHImutfMDPYMP1CIoV5voGSEq4WjQozlbLJGlWpM4iHnWKtWu7XUAUJE9n3zXY9Y2Q==
X-Received: by 2002:a05:6a00:148c:b0:4c2:6f06:8c70 with SMTP id v12-20020a056a00148c00b004c26f068c70mr17450015pfu.48.1642434866817;
        Mon, 17 Jan 2022 07:54:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22sm10730987pfu.160.2022.01.17.07.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 07:54:26 -0800 (PST)
Message-ID: <61e59132.1c69fb81.dc22.c518@mx.google.com>
Date:   Mon, 17 Jan 2022 07:54:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-7-g72022535721d
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 125 runs,
 1 regressions (v4.4.299-7-g72022535721d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 125 runs, 1 regressions (v4.4.299-7-g72022535=
721d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-7-g72022535721d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-7-g72022535721d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72022535721d9fe6c926b82d9451bfc5c187cab3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e55e52df73196a8fef6745

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g72022535721d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g72022535721d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e55e52df73196=
a8fef6748
        failing since 27 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-17T12:16:59.409039  [   19.040985] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-17T12:16:59.454679  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2022-01-17T12:16:59.463960  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
