Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81754567D5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhKSCHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbhKSCHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:07:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA363C06173E
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:04:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b11so6894522pld.12
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=meV5sh0FoRCWsH7BipuD99BmjoHOLlsFF8rB+9YXKgI=;
        b=3rqHaqs8MxXKwbVYUYUL0tgHqiT6XBHGTXEanp6oXoBNsGWh4Eq1vVl84WWfPpUZWl
         TFoK08RP/66yesO6ubxRCpxnPTRA4XqMtqbWav8mBG+/9fYNJurcc8eOeNa6KjqVn7we
         TUpRHusSWZmE6xL88M4UclOmkoSHgcRPUtjEprL5bDOgRmDPlkBy0b38tMk3EfMaOHTy
         SKteEatGvpRsOuk9gFSP/Yzd68hbQGrA8HwqlCCckQOsLcw+gdENai/fmen1gH0LY3Zt
         l6FYgFPG+dpf4C2KJh15iHo9kHzjriNZtgMss3BmBif9netSVXDCxQ+Encv6Pbxr/7NL
         5UGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=meV5sh0FoRCWsH7BipuD99BmjoHOLlsFF8rB+9YXKgI=;
        b=S20EJLCRFPxAOWukV50Qx0/dY4Fexi115bo4knuyjp7Iq9lNWc6wx5wJ8HizfBKYEa
         2Jgvcd5XS94dG/Bu7SS03az5Z3nJzplzUGLsr9GINuQL7z+j5w7RD8tl/VRtFemc2nUI
         XSFVfHYCW3sEjkGPygh+eMm9ZYo3ONRwYgLj7V68y1decdL8l4ea58w2kGltZ2yyF4CF
         nNpXu8eQVCvw5tYbarFte8wP7sK6aBDFlNoHRe+8kxFsPUyk8OwA1dEdSZ7j/JqZ6I2K
         L4YUiIhkW2USJnS0G7+YQ0YU/iQhObqF8zQyPv+4Q9A5QUaHmitrpCsGOKZSiaSGqNv6
         LLxg==
X-Gm-Message-State: AOAM533gzZaXUlmXoBCjab8q8ZV8mZ0tQOH6H5uDNx7SFHgIsPSOdD1m
        KjMSHvdcALE+1UfEyufwu9BylbjM9y74WQgs
X-Google-Smtp-Source: ABdhPJyIuAMCDjhlxAEvVnx5XiwRbSUbd3WYtiMhj9JX0pYc+7yzy/smWoF6jNVQKz8JyN7qVEGDvw==
X-Received: by 2002:a17:902:e8d4:b0:143:88c2:e2c9 with SMTP id v20-20020a170902e8d400b0014388c2e2c9mr72563052plg.12.1637287492312;
        Thu, 18 Nov 2021 18:04:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o134sm852712pfg.1.2021.11.18.18.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:04:52 -0800 (PST)
Message-ID: <61970644.1c69fb81.2f0c.442e@mx.google.com>
Date:   Thu, 18 Nov 2021 18:04:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 194 runs, 1 regressions (v4.19.217)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 194 runs, 1 regressions (v4.19.217)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd8250304dd51bc2c8674af65c102dd8463ee88b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618fb259091576e1613358ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618fb259091576e=
1613358ef
        new failure (last pass: v4.19.216-17-gf1ca790424bd)
        2 lines

    2021-11-18T22:01:07.671403  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-18T22:01:07.680842  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-18T22:01:07.700174  <8>[   21.523101] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
