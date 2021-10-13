Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D6842B6F8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 08:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbhJMGVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 02:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbhJMGV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 02:21:29 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E87C061746
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 23:19:26 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f5so1292427pgc.12
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 23:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WwT18MK2RyyhIPr0IBiYePoqw1Fe4egUzc5Lid8v4es=;
        b=jtH1gu33k8306xjzqNCO2J1JV4KuBGfTQ+Wv0CK7wE9OU12yeYjl2D/ds9Dvjp/dRz
         2XZhGapHEhBx05TPTTwEdk/NOgbVtJ5zbmHXMXkPWDAxPQ/AVdLI8jX4qcIdIy3qntNd
         1UY1Bp/Ro/MxfZYc21n0KI6DRD+mincJ59Ix3095oquNes0jYSipVNkek4C/rkYwOLHK
         kVaUaxD5PXAp7GyaRviBytcww5Qlqw3mMHnuU7du3wswYScospe3NDNG4bdP1fwnl4co
         f36bmuYVpaW5/QRaCBbtcGUhla6eEewFrRhtxp4F+iuyIeUpshy+HP64PXbjjdJc4QyT
         +pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WwT18MK2RyyhIPr0IBiYePoqw1Fe4egUzc5Lid8v4es=;
        b=MItK+8HKgN6tH0j4aOJ8DwmIfGv0Uh7Wmj3ek6XIRsI2x9aVDEN8AGtaatTbFYQx9o
         LLieSJELBPSIbkxLHA2WCaSqlUnp8QHVBNuPtNe58pEWxdf70Bm5OamZVnjp/o+jLNSU
         fy+Vd0gcbhGdQkQr4JNO6032Ym1g1vNDUKnJrDDPsRMLlitw+9zwsmtBuE0bKpb1XWRl
         IB9oRRQZyocNGmu7A20n6vAsuTe7t345jfwmpdR0n2WJmLlhGqK+HuKS4pkBAYaKcU+p
         uv4fOuceEGu7MKoJagru8Jhb83S2DIQ8EwAhrmEEC3hzIRhSwUBxmTv9IHtOQWqSKFkg
         ss+w==
X-Gm-Message-State: AOAM5310Veyz5NJZ3q2+2Kt7oH5ddUc30GzQu65y5LHDDH4KLQtJY5Hc
        /2D2Pj07urce6LFP5N2Rd5UM8Z1zZ9LxgbYR
X-Google-Smtp-Source: ABdhPJyhNBrPDsiyQowZqiAINAtgCxN60qUwg3Y+PD1I4j4+d5KBG9WaD1e5cf5b2AOEKYJX6x7X4w==
X-Received: by 2002:a63:b94d:: with SMTP id v13mr26611621pgo.361.1634105966019;
        Tue, 12 Oct 2021 23:19:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm4705145pjg.54.2021.10.12.23.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:19:25 -0700 (PDT)
Message-ID: <61667a6d.1c69fb81.f8fd4.e69a@mx.google.com>
Date:   Tue, 12 Oct 2021 23:19:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.250-23-g671034283a62
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 1 regressions (v4.14.250-23-g671034283a62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 1 regressions (v4.14.250-23-g671034=
283a62)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.250-23-g671034283a62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.250-23-g671034283a62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      671034283a6256d80c1a5cd336c4778644c7ab17 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61663dfbd6b5f9c24308facd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-23-g671034283a62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-23-g671034283a62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61663dfbd6b5f9c=
24308fad0
        failing since 0 day (last pass: v4.14.250-10-g360a25ea0f96, first f=
ail: v4.14.250-24-g0c04723a59cf)
        2 lines

    2021-10-13T02:01:12.562817  [   20.554138] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-13T02:01:12.606793  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-10-13T02:01:12.615696  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
