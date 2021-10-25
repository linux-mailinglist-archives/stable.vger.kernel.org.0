Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF884390CB
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 10:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhJYIHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 04:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhJYIHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 04:07:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85391C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:04:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso10767335pjm.4
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 01:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/uWN14G8R2uyPX3x7tnpk5DVKm88gZKUlcvRm0Fo3Dw=;
        b=LA6EiBoSYLrm1WwUlVILtXdbsAVxl39wNhUG4M8D6kisYDOkYlLA+OC8ESuCnva1+Q
         oAuCHIIzEfbhoS5qtoom5tC1xC4S11g68CiRYpXDS+xohdKOsyKlhwPeDepcNDmu3Zsb
         rFX5g3UTg3alEurGuLIPVByIq5yEK/1/kM9XEH5wfbBzsItXX/XOwEMWdh9kXOZodvuJ
         4hVy42FbRkihvDeneG/lAkPh+8SX+RYMqfou5kPeWSJoBmBnk4FEqK5EouRMo0XaF9OY
         jccspl6RgAyn5/PLPWssGCC8JPUYElC2YJoe0p+K/0FngGYs8ILx7W2FUiqd6nRSaBAy
         mKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/uWN14G8R2uyPX3x7tnpk5DVKm88gZKUlcvRm0Fo3Dw=;
        b=tFbRaE6GTZMsmBaWjrarErhWj/K1R5cgaP1cnkg80ecO06IaykJo2Y8HGVMqw+Nb8c
         fPBd8gzOcLGi4nikY1gzv7dj3HWNJfBWhrDkIF/gMdbd57oBd+4SQhzg9RFnIpBQhM9c
         IRP7XJJYxFhUc5qHi0GG3P2kA61O565bAfyxAww1gjQyK1S+zSvTnM9Rmt7VnNyA2Ky4
         +h3CIEE71sdDIXu9Mgyp3a704q+wDvjE+9wpHmuwyU1YdI87rIdac0MPBmNxud3ILNoZ
         YhJGJyDk7QOF2q4V5AtXG9hn0ww4+w67bnWzNeZKRwNZMTQFgU37z2rZyUHNmTy2bp+d
         W8cA==
X-Gm-Message-State: AOAM530bbmnUOEKUVW7EDNvtPdaxydVC35kXjfLdWyfeAQv2LRVsrI0v
        eYGn5OmcoOZXkhKlZ00OcdFbQLq6y1E9MRKN
X-Google-Smtp-Source: ABdhPJxu2kK9CLN227xxOBWZKDp2ekBu/lCFlEu0JX9gbnku3YpqS+jtthyN+AFotAQGbv+Wu8wi+w==
X-Received: by 2002:a17:90b:3e87:: with SMTP id rj7mr34038584pjb.88.1635149077920;
        Mon, 25 Oct 2021 01:04:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 141sm4505613pge.23.2021.10.25.01.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:04:37 -0700 (PDT)
Message-ID: <61766515.1c69fb81.233ad.b1ea@mx.google.com>
Date:   Mon, 25 Oct 2021 01:04:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.213-32-g94e226c62a68
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.213-32-g94e226c62a68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.213-32-g94e22=
6c62a68)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.213-32-g94e226c62a68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.213-32-g94e226c62a68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94e226c62a68cec69092dcbfc3853dc471a5503d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61762f5f0cc60ae26b3358fb

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-32-g94e226c62a68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-32-g94e226c62a68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61762f5f0cc60ae=
26b3358fe
        new failure (last pass: v4.19.213-32-gb53d26df8c1e)
        2 lines

    2021-10-25T04:15:17.717544  <8>[   21.642272] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T04:15:17.764703  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-10-25T04:15:17.774462  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
