Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC13C44235F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 23:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhKAW3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhKAW3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 18:29:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E344AC061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 15:26:31 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q187so18462792pgq.2
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 15:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HO0BurhAh7fBK5eWfjsNajfSIbe8lVDQIZ4dic9rX0M=;
        b=aWhKW4IxoIpcIIX1ar7q9iSTWvdHNYzDvaMW5JtDGEJE5Qz7ZUh77mnV3p+ewh0W2O
         X6UQzjDjBtR1x/xtGNTZD5qGHlI+Pc8eFewabu3+PDkPYMLi1xktZEKDJZvGjMu3ocvl
         EDpp8sVZQPOxljcYT/xblVktZBOOS+B6fSucYo225ppU1WSvlJvSmMDj6WVYX2zIs/he
         Z4Q7rHJAyGesSROX+Z2xu/PIXQaXBehT6tLydAXBoKLSWkBFtJHlTn1fb1YurnLw1URG
         v1u5Xmt6YFor1IMJXgyH3A46d9Dc8d0/CmjfWWtw/JFnJ2GoZegkqLocqGSfNA5fhRh9
         P4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HO0BurhAh7fBK5eWfjsNajfSIbe8lVDQIZ4dic9rX0M=;
        b=Ai/HQQSHKQi8aKwPhB9r3GQ/nDG1HpJU46ir5ScPkFmGvlQ/KwSDdpgQUS2ii+LqBA
         aG4Os8SWeHDLedCR3PPC4dSJWsJOYfLgQzbQnByDh9CBb3jsmzgBDdPRlVgR1pU0pa2D
         VsYyLFnruWwPT3cY7FyrYkPH+5MYjJGsZPjQ2/cN4H8ZnAMOqyb17daXA91HCTmmArIv
         ItXbb84rvCzPRHwCcTzOnfoxXvECqcoWve4D9bp9DRh//RafOpIj6XODXg87SQIebWZn
         Memhy28KDGnovqtevr2iVssv1ByN3lj0QwNah3tNzjM5aQp5xsaabxS+QacVMNhM5ifh
         cqnA==
X-Gm-Message-State: AOAM531JbU51SI3yMJneGl7BmRtwzWpif+bNcOxjYSKZukZ2gIhguazo
        4AFdftJkoxFNPLPRf8ZYXf35WqPRFdJQogjR
X-Google-Smtp-Source: ABdhPJzrE5IbhJcYIieroyuFaP2R6vF6pmjjhV8SkVf3xXAa1TvkPTWVNWvrcdzKxixmpV17UzTLqA==
X-Received: by 2002:a62:1b8e:0:b0:44c:9318:f6e1 with SMTP id b136-20020a621b8e000000b0044c9318f6e1mr32215207pfb.84.1635805591228;
        Mon, 01 Nov 2021 15:26:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f28sm335760pfk.157.2021.11.01.15.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:26:30 -0700 (PDT)
Message-ID: <61806996.1c69fb81.8eeeb.1932@mx.google.com>
Date:   Mon, 01 Nov 2021 15:26:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-125-ged21b4a65dd9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 142 runs,
 1 regressions (v5.14.15-125-ged21b4a65dd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 142 runs, 1 regressions (v5.14.15-125-ged21b=
4a65dd9)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-125-ged21b4a65dd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-125-ged21b4a65dd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed21b4a65dd9e1a30cdc5940df26d7bb22ef4ed7 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618038e075ff1eb9fc3358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
125-ged21b4a65dd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
125-ged21b4a65dd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618038e075ff1eb9fc335=
8ff
        failing since 8 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
