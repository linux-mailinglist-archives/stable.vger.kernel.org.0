Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1F45C811
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350950AbhKXO4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350927AbhKXO4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:56:50 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240FCC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:53:41 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b13so2066342plg.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 06:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gRDWikNNLDvfEfzR+w48ZAck9AKGtTe6I06FB0YBbgs=;
        b=qyLNfE59wgXVGwAo7n24yxGRvEKxP8I4gZj7HkMLqnLvjRi9oYNx64n3Df3L3v4ecl
         CJaamYGAn/wg+S6lkaasDnHJ2/Xitsbb7WzT4sj4e93lCwhvrR1T+griN1tEYtU/t2sS
         54zkoKkoqCYYAL5DGKomPDnqpDRWdvqmKEQ0ITYsGIzyWiPlSVfZlYnWuWIVJ0QbjJp2
         bq23sSfYU8rGSBq8IxJ6QtbDRFaSgMrpdG6Agq4TiH4FyeopYoe0vK210LYsOO/bgWeO
         yvxXocr7HwlGVaRZEmHqslzHUAACtqNgGo+Ed0Wb9IvS5nKZY5wLCD4cAgApdS0ZL4+B
         bf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gRDWikNNLDvfEfzR+w48ZAck9AKGtTe6I06FB0YBbgs=;
        b=c8tzWrwZ3hmd0AGR3UzikocAtmiBlKrW4RC99Imii+Ti70po1arXKFppfd+aB3swBh
         u8gWCF9hICWMtPiLY8mBSpW0t8W9lRcPERXgrwOaCf0qHC2GyHX2uW4CXV9iGkb7Fqda
         E0N+F5e0m0MS9i5qZYvqYoIkq2E5XASmDjncPo1Loy2Cw30B5ERlSnX6Oa1QYGWOpeuB
         rOYGkKeph8c2DVrOq5KAqjezLGgVsH2qxOGfV6aRW1/Teyum3fQ27DyUHW9RcTWstynu
         yE4m0m4GibexzIR4LECZ67TejSLszTeAzyOeNICsA9vr8E66b7FP6C/rPSX4Va/qdk6n
         7O3w==
X-Gm-Message-State: AOAM533RRfVEM9edVVUoB8EF4K0lAWMTrJtGZ2gGdjvilc0IvEE07Jon
        bDGDvk/mbt+6EEP6l3PzVQb2ZVai7uhQYqYs
X-Google-Smtp-Source: ABdhPJxzdjkOZBOcXRcNbCX4iIdgEenHfQbGxx5GPoShQFPaM88KGL7B0+j3K9XtjaTlGZcQplKJgw==
X-Received: by 2002:a17:90b:1c06:: with SMTP id oc6mr16042999pjb.126.1637765620542;
        Wed, 24 Nov 2021 06:53:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fw21sm4797537pjb.25.2021.11.24.06.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 06:53:40 -0800 (PST)
Message-ID: <619e51f4.1c69fb81.59388.b326@mx.google.com>
Date:   Wed, 24 Nov 2021 06:53:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.81-156-g7f9de6888cf8a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 74 runs,
 1 regressions (v5.10.81-156-g7f9de6888cf8a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 74 runs, 1 regressions (v5.10.81-156-g7f9d=
e6888cf8a)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.81-156-g7f9de6888cf8a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.81-156-g7f9de6888cf8a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f9de6888cf8aeb1cc2a6f25c670bce87279fbba =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/619e297885207cce94f2efac

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
1-156-g7f9de6888cf8a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
1-156-g7f9de6888cf8a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e297885207cc=
e94f2efaf
        new failure (last pass: v5.10.81-147-gbad6572223b92)
        1 lines

    2021-11-24T12:00:47.123566  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2021-11-24T12:00:47.133710  <8>[   11.037518] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
