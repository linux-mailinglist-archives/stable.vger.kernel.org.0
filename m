Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B5A495474
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 19:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377354AbiATSwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377366AbiATSwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 13:52:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BD1C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 10:52:20 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n16-20020a17090a091000b001b46196d572so6599132pjn.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 10:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N4urqusaf6dJgTCeFi60mKe7ZRXdUBE9tQuoAyCNKK0=;
        b=CydqbYRU6h+wCTdDGUhy/ku0xbn80JdYZZM7vU1Ih4RVj+lV/lNJEwiLUagM7P9FIh
         irgQTx7WtYsiOZbEzclyaIFp64dqZBWGSMf+VsoJm0Js/nBPNSUw4t/PSqKYDxilgxD+
         7IY1saGw51lHiF5bxJegylFNLdqxShx8OPygXauvxh0vDp5tUbFp45TyqEV4yIQOsM/t
         Gtug8Jj1W2Ygz11yZuUSFXcQPglGT2mKCvFFC4GPwVidO1JQoT9MBkz0t07FydP7u7Kg
         zd0QsJWMmaAKUEiSJldQqaiWSFyXgUInS3FXgxU1qNBoP5Fgq9Dv6Y83Y50UYK+xEAU+
         594Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N4urqusaf6dJgTCeFi60mKe7ZRXdUBE9tQuoAyCNKK0=;
        b=PoFL9fXvvPwbSkOkV4oWO5XsimNG1klvwv6B6oPmGOj9xh+y4WL0oRQLYj/NSeMzIG
         5HWALrUOkwo/GQ8EjxlrmIGljFXMEItaJq2tL6BbojLJr9RckK07QDPlh8k8vpZaFDFZ
         qhb9PPEbtsAWRqYCmbWsDITWc+It2dFYwk8XSlwJ7XlqGn8Pw448382cdPrf0uIASMYx
         LFVfs4IFOJo+XuG7WSKbq0XPDhVsz9HKhUjiZOpCNf52Wa1mG4CSAsPXnAVVAC2hPzv+
         ckkNiQC6q7McBbLXjfEJrJg/C+eRwV6QxnDxjDkv+AkpImE4nE/WBNVDLOHZeQxEQNpr
         LMNA==
X-Gm-Message-State: AOAM531M/pHMPXiCf9p85EDSNzJpYPXggpbvd2sJB7IEjM5K2O91d/ij
        kjbom3gby+JrrCrniTRkcib40dkO6sRj8QlH
X-Google-Smtp-Source: ABdhPJyAGlzV66Eduv2X+xpFtg4gC/UNnAOzoHtOstTtA1i5UzRB0Gay6FHbPMzn8olQ4SeFyCvdJw==
X-Received: by 2002:a17:902:9a4c:b0:149:7da0:b7ac with SMTP id x12-20020a1709029a4c00b001497da0b7acmr100211plv.28.1642704739839;
        Thu, 20 Jan 2022 10:52:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm4186028pfu.35.2022.01.20.10.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 10:52:19 -0800 (PST)
Message-ID: <61e9af63.1c69fb81.5fbd1.b882@mx.google.com>
Date:   Thu, 20 Jan 2022 10:52:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-15-g95d2af570ac0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 131 runs,
 1 regressions (v4.14.262-15-g95d2af570ac0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 131 runs, 1 regressions (v4.14.262-15-g95d2a=
f570ac0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-15-g95d2af570ac0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-15-g95d2af570ac0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95d2af570ac0d46b15efca61e24e6fcd8a0b6bda =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e97c564b09d03bb9abbd3c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-g95d2af570ac0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-g95d2af570ac0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e97c564b09d03=
bb9abbd42
        failing since 2 days (last pass: v4.14.262-10-g93d10bded874, first =
fail: v4.14.262-13-g01f6e3343a5a)
        2 lines

    2022-01-20T15:14:13.049419  [   20.019165] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-20T15:14:13.090765  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-20T15:14:13.100450  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
