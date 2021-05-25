Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2901439037D
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhEYOJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbhEYOJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:09:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3933C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 07:08:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso12615372pjq.3
        for <stable@vger.kernel.org>; Tue, 25 May 2021 07:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8NnpZ33Buzu9wml6zL74D417SyAUIAND16LYcJ0vr9k=;
        b=mrMuFnQ4TbSmSnno8rtLCGpPB/Dg2Rl4KhLMHk+O/rWvGk9zuEr9sb+DppOil7Efkb
         SVg01IWvu0EoHvmFj7paAAjVFuKYIhniDE2gSBG+oG6NE47l9sEGan1XZYuGS8X4rctB
         M2s4RlI8DAXSTAIuf0pcQohNkuMfZZeJK28cyDtVYkNbhNJ0UlOsE5KKUFM7jT9IIxP4
         5cl7ZmGtCNa7mJ8Y37ZmTpGbTVLG6iosGEiQcmzmUNbjbW03DqkoadGPagSToUzbtMHh
         ep0Jv8+n2ppzNBOj/fiPUimcqM+IiQyRI5s/Ba+CHyJ8rga/pRND6SvZuUkvfBJ2eRMw
         b28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8NnpZ33Buzu9wml6zL74D417SyAUIAND16LYcJ0vr9k=;
        b=qXwp3x6qpG+vBSuucqr0PCxk6xkFu8w+Q8YNoa85LGGsHj1cOYYDaPCFLmbyalGo3z
         akdMegO8FpVfRRbaQ6ZbtSCBPu7QSgsn0J+9YyhrjEc950CG1uLh3DaUQdWOjlZSLLO1
         k1TT+1sGL27KxFIsb9pKNCjAL8IX4GoQGxNBBeXJ/9CdfvTvmRUkbHEAh94aI6SwjGX+
         KXlWv8h5eDv1F+sjAUwDPzbuxuKKNVysNTgZHUoB5eMsIrG3eliglGCzwMlRDqP/E5xC
         F24Tg3Q3w2Dtwg6x8GgjvrT73BJoduN6aClq32XoX5Ya9NCTf43FajQHGK5Jl7zXbgtO
         wkMQ==
X-Gm-Message-State: AOAM5330hKUU0LOBPsx+dQcANs7cnQHfNM3UuFSZCha74JxSpi2LsDtT
        gUbMXK22ajRnmXT2Spj+wb08KPQyNg/q6LU+
X-Google-Smtp-Source: ABdhPJx/zVMvAAPVD9fHfimHtP77d+DtG5Osjghm+7vHckW+QjRj8nzTnA/nCq2u8L2lM7c6IfcP4w==
X-Received: by 2002:a17:90a:db02:: with SMTP id g2mr5039746pjv.2.1621951696070;
        Tue, 25 May 2021 07:08:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b65sm14231968pga.83.2021.05.25.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:08:15 -0700 (PDT)
Message-ID: <60ad04cf.1c69fb81.fd2dd.def8@mx.google.com>
Date:   Tue, 25 May 2021 07:08:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6-127-g27cc357ce5f0
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 131 runs,
 1 regressions (v5.12.6-127-g27cc357ce5f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 131 runs, 1 regressions (v5.12.6-127-g27cc35=
7ce5f0)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.6-127-g27cc357ce5f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.6-127-g27cc357ce5f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27cc357ce5f00b2bd3b5452cfb5df751926be221 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60acd0d80592e68908b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g27cc357ce5f0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g27cc357ce5f0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acd0d80592e68908b3a=
fa4
        new failure (last pass: v5.12.6-127-g65dc22920eb7) =

 =20
