Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6FD32651F
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 17:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhBZQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 11:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBZP7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 10:59:55 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3476CC06178B
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 07:58:39 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u12so6105655pjr.2
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 07:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=snb0J4CWxSxiCh0CsKF+GzsfP9ZgfmFO/RZF6ykilPI=;
        b=jWj3JMV2gLV3ZCPdiTMODFzQiWppJIz4HTGRE85MIL4kSp6mDV/cqKduvqt5sVMFtW
         Atv5+iJfZhLZ0SE/nxUcxLdzMWHjElERUIXGxToYb+TuSe5H90RbQ43692AND7V2VduN
         zqHbuYc3dgVjoO5Adyrjo7Xeim74YnMtTDpbd3M0vlOxKI9MOLlLN4u0R/ENSQHgGrQW
         rudxcA5jScZ3FkBPFx2rToJBLZ2PW495Ga84rHZ5smN3l82MHEojj3CEGpy+4kBQfKEv
         IL4WRg3gIvFHzBHHFuahwlKR8r7IY1I6EQ5w9Oyx9aB6b+6vDz0cOIeCf/Wd0uksHOKY
         VgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=snb0J4CWxSxiCh0CsKF+GzsfP9ZgfmFO/RZF6ykilPI=;
        b=AsyXXRyiutr4olFjrNmzE0OJJtP2cJknols9hp3q5zxBQbXlut8TT+wd1dHK/wolck
         5QUXo/+AjJ8KM8kAsDxvwiMMZv9QW/sOLm5iqDmhcCfxaJ1PXc6Drof70TL4AJEXxafF
         2KSSD+rpPjpHMJiUcxHRqRH4cV+Rtv8sqYEzu/gaxm+d4ZkYgCvaLMYF28zPTXS5vZ5G
         XfrCkNhpjXm9S/n3F4MH1pNJ6R1r8tutHNknKUnDjCGm0QAyZchckYwa62tcAy8tt8DR
         pCaHzkcBUcWfLf7Dh/guEGdETyzjo/Z+FEK+pM6R8tvJRHVfNJzkZCLYygLZLOj4eHX5
         Vxcg==
X-Gm-Message-State: AOAM531Y9RRnpdf9r0WTAihi0Jrqk5YFSYg8AFHULQWtiyW7wd9E1rub
        ZyGXTE9qY1vscyemNuTa5MZl/qLbago7yQ==
X-Google-Smtp-Source: ABdhPJzA2QvuHD/pHq4fUNWWVIC3dMmykP/s+T1ToKPtM/L8n9lkQPtrqFppejdvyyDnZyXHRSAXdA==
X-Received: by 2002:a17:902:e54a:b029:e3:4a72:d68c with SMTP id n10-20020a170902e54ab02900e34a72d68cmr3521093plf.23.1614355118553;
        Fri, 26 Feb 2021 07:58:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jt21sm9154317pjb.51.2021.02.26.07.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 07:58:37 -0800 (PST)
Message-ID: <60391aad.1c69fb81.c3700.433e@mx.google.com>
Date:   Fri, 26 Feb 2021 07:58:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.100-17-g8c1dfe58d628b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 71 runs,
 2 regressions (v5.4.100-17-g8c1dfe58d628b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 71 runs, 2 regressions (v5.4.100-17-g8c1dfe58=
d628b)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.100-17-g8c1dfe58d628b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.100-17-g8c1dfe58d628b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c1dfe58d628beeb5d5f4e77c35247e8384ad092 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/6038e16e547097501baddcbd

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.100-1=
7-g8c1dfe58d628b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.100-1=
7-g8c1dfe58d628b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6038e16e5470975=
01baddcc1
        new failure (last pass: v5.4.100-17-g2033955f6fbc)
        4 lines

    2021-02-26 11:53:58.870000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00<8>[   13.669440] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-02-26 11:53:58.870000+00:00  000006   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6038e16e5470975=
01baddcc2
        new failure (last pass: v5.4.100-17-g2033955f6fbc)
        25 lines

    2021-02-26 11:53:58.875000+00:00  kern  :alert : [00000006] *pgd=3D2ae9=
c835, *pte=3D00000000, *ppte=3D00000000
    2021-02-26 11:53:58.913000+00:00  kern  :emerg : Internal error: Oops: =
17 [#1] ARM
    2021-02-26 11:53:58.915000+00:00  kern  :emerg : Process udevd (pid: 92=
, stack limit =3D 0x09a418bc)
    2021-02-26 11:53:58.916000+00:00  kern<8>[   13.711623] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D25>
    2021-02-26 11:53:58.918000+00:00    :emerg : Stack: (0xeae<8>[   13.722=
288] <LAVA_SIGNAL_ENDRUN 0_dmesg 765268_1.5.2.4.1>   =

 =20
