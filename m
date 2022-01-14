Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C116948EB35
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbiANOHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 09:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiANOHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 09:07:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50712C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 06:07:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso1923774pjh.3
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 06:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LwAgSNpTp3WdgKLA39NVW304/WKLLg/Bekb2IpmyuRY=;
        b=lc0T6X/zMY+U8wjLqQhNiHMgmel/HeYQ1zfDEwxRDL2lFO1TJ/BCokSzdisvJ1TLij
         1MfS0q7REoIBkA8jGeAgxhtP1odozjZFBLU3nTQ9D3oi/9MapECM3hpSBuzcuPGV8+sx
         4f6ULz9yC3dytAuScy9XkbioMuGCQmb4Kv0u5QTRlI3iiDRWba/DLB2r55IqJdZydYoe
         RVHtifimc2GwPUQc4l4KvwzqVzKju4qYAo6/+Ygv7A2Dy48INPL8ettp2foqR3HAFF9p
         20mssSZRHMvHrRtDTqzyNm3r7oUB0XFGGs2486m5eCFByNBVdIZuzi6ERaIoefI2fd5u
         4++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LwAgSNpTp3WdgKLA39NVW304/WKLLg/Bekb2IpmyuRY=;
        b=pzx2HIF8N/WjevdySjd0fJe1rkvizCZo7g/OKFcu3X8lWQcNjG2nrviqkugCai/fDP
         1NzNinvmevEK//cMMaYOcg/pv0JuULb1cPz+SZl3rlg84E16tRGgTLP6iCilFzAsF/U+
         X1QpVlk2zR5izVXTqibCTJsZFN2ShRJgm9yyT1/C0ZzjMIa2BOxv2UvliK7jKhfCxjtz
         Ytlo6whe/w5WZ35o4GsW8ZnN3tHsAjLib2FJGJqaMQKaMtj6UXpuOxBpQhhZuRU5K27p
         UHp0rFbkvy35Pd1A5EDtXYSBB5y+EjzjpgjhlSLinKibd8lqTt/pNJ2SwEONIZqWPE0i
         yllA==
X-Gm-Message-State: AOAM5334xJmJHi5f7bc4FdmLoH74lgQC2L6EJMncn9ElUXxgB5m28E+Z
        1UdRHzwasHOZBpirs8yjNufvcFjXhNUvR6Bn
X-Google-Smtp-Source: ABdhPJxYI51pofx8wAb0zb1OOrHgePqRe2UN27toU/MYD6p4j67yNKwG6sTWuzLQrgS8O6qGtZ/BXg==
X-Received: by 2002:a17:90b:3810:: with SMTP id mq16mr20140390pjb.190.1642169234542;
        Fri, 14 Jan 2022 06:07:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11sm4879249pgh.23.2022.01.14.06.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 06:07:14 -0800 (PST)
Message-ID: <61e18392.1c69fb81.1599a.dc71@mx.google.com>
Date:   Fri, 14 Jan 2022 06:07:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-8-g889b69835136
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 117 runs,
 2 regressions (v4.4.299-8-g889b69835136)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 117 runs, 2 regressions (v4.4.299-8-g889b69=
835136)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-8-g889b69835136/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-8-g889b69835136
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      889b69835136ea269d1bfae23112c0037255186e =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-cip       | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e152c2aa57488402ef6776

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-8-g889b69835136/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-8-g889b69835136/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e152c2aa57488402ef6=
777
        new failure (last pass: v4.4.299-7-g11683a1637bc) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61e1512013c7e607e1ef67df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-8-g889b69835136/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-8-g889b69835136/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1512013c7e60=
7e1ef67e2
        failing since 15 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-14T10:31:42.717701  [   19.098937] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T10:31:42.762708  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/95
    2022-01-14T10:31:42.772081  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
