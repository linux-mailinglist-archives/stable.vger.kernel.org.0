Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C8531EFAB
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhBRTVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbhBRS1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 13:27:51 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7FFC061756
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 10:27:10 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c11so1857603pfp.10
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 10:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e71lA7aAP5lgoXTeIu1vtUouAm/H6yr/7Fq8kXfwBf8=;
        b=OO4kWIp2jAACgNBzcVrF/M5Y9tF/2l/Kl0oCKGSoVtDqrA6A1fqSuNIseGhvyussBI
         aJEARhciPj+oHAcEmtw6+/P8ii8FNDR4YcHF+zYrRvU+W6QVY9VWgZkW5r15tsnzDG85
         1lJ1U8V18kwI53wpnVVQsiNDuf6SNivic8ejYF+hxcFsMa8UzOUEbYrbagRtZVehH9m8
         5ShaDRydaCrb4L0Glt5JbfWnz+IOxvQEew4Yzm5Uotp7jDPEtHi8tv6K2ii//xZUyWTE
         kn5jzTCG2hIHaeJSuCUxBAlDN7OnSmOvKUSrYSm1FLMqfIiUE4ubiruQi/B1Q3jMUnRP
         Kb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e71lA7aAP5lgoXTeIu1vtUouAm/H6yr/7Fq8kXfwBf8=;
        b=lT+Gn0/zmkWHVxUMeO2RqLdtid+V45Y73J8hYNIGuEBPsQeCpnD8dFwje0br7JfpPW
         I6ZsWAZLyDTGQg6Yw1oXf4dB+AjI1l0svbGeRY3yC98PMMvc8QEPZbHCKa/Y3euXDkd0
         4vT0aRks+BOHBDTWmLmel0uQmje4mhnenSCCzCC757Bx7EiOALH+Hl0v39UvtIjGrU6r
         fmst/RWK40xMkHB1XxyzFs/VVcfnc5sX72sWcmX95h4MsP/8ABCg3GkSkhofio0UALyI
         Fr1a8fC3S8vjTKkGVqdiI6+vgojhM/dX+ULkLHT4wsklzkRNnNdtI+BI0ZrxrsGbMoGx
         Nk4g==
X-Gm-Message-State: AOAM532r360qt/tWq5wOO9fVG4LYv7azbFXduHbRBU3qjtRVZ1Sck6QB
        2rD75CoXfvfEOFwmaD5kmo+qjB0XZikEAw==
X-Google-Smtp-Source: ABdhPJyzONKZHHecBb86WeTmy/Gjsvrck9tm/sce/Qi7XLZqGk3Nao4C28OCSsyX39Hfx3Bip3xumA==
X-Received: by 2002:a63:f549:: with SMTP id e9mr5101815pgk.114.1613672829734;
        Thu, 18 Feb 2021 10:27:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k24sm6586153pfg.40.2021.02.18.10.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:27:09 -0800 (PST)
Message-ID: <602eb17d.1c69fb81.7309e.e223@mx.google.com>
Date:   Thu, 18 Feb 2021 10:27:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-g9bea34ee9511
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 95 runs,
 1 regressions (v4.19.176-37-g9bea34ee9511)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 95 runs, 1 regressions (v4.19.176-37-g9bea34=
ee9511)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-37-g9bea34ee9511/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-37-g9bea34ee9511
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bea34ee95114bc3411ce692d8b9f59d389b3983 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602e7e1f209ce37f6baddccd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g9bea34ee9511/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g9bea34ee9511/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e7e1f209ce37=
f6baddcd2
        failing since 1 day (last pass: v4.19.176-37-ga630db879c87e, first =
fail: v4.19.176-37-g99b2feb86d78c)
        2 lines

    2021-02-18 14:47:54.890000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
