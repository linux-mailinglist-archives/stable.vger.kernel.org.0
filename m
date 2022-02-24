Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E424C21B1
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 03:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiBXCVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 21:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiBXCVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 21:21:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DA64161F
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 18:20:47 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id w37so505016pga.7
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 18:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N7tVBoi2u8MJyvugWUUEDhjS3AEztTVs03hL4+/1CAw=;
        b=Y3qS3VDqgD45TbdLmyd9AB31m91PIgunH4PfQIrT/G54S1a7ouhn+xuHSKRGyaJzUx
         fBmQuOhY2PhWEXpeA4CY1S88EbYTtH/Io3JVFBKoPRPWPz7ov77GDKzAAnP+WvtopgIB
         pveDoQySBCaOdUSj3odsLuKtVrHWdgy84lt9Gi7+P87yK69S9NMSpUxHWdN+qSIBOJP2
         OhANr+QZqqCx0AdEz46MO8cP6rCxtH1l5eFZ+p0gmTzA72xzbI+09Eii2ifbNn1cRYdh
         gLDVu0fPMNtN5/jXxwSM8+KRtjDwAo7w6XhoSilku7vXfQ8Gzr3qccIP5CppFd58UvXD
         NbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N7tVBoi2u8MJyvugWUUEDhjS3AEztTVs03hL4+/1CAw=;
        b=0SPxpDFWUj706G23DqXEbd+aQyFkLuiu47V3XmTyvpV/3VyhxagR/Jlh4sC1qtmGlL
         fJyHDLdlI5byJpAArkYzjlxyuAYm6MA88pap7y+m4+Nu5KAj8zfRwJSdFXPgZnlwW2kn
         FS7p8x4PNn1SRO/oK9/+Vc/FOBZfJy4hIPUAH6RirM2BD57ykL/L2zB6I6uNdUEUWqrd
         As3LV7AfuPeBENOFgjZQr1ibt1kJN2I7kPb9xi6Mgp62LCZsgK+M/d+lxpp/dcqnbaz7
         7TCyN3EdQDntMpFISoaM8gK8E6WLlyoWRHw1vZFh3BuTaA1xyN7glrcpCwlH9rkXnisO
         D/sQ==
X-Gm-Message-State: AOAM531YY/CzJjWLZqdEUw6ye2rh+ZVQ26Z2zwoxk+to3qrxu8QCNAnq
        lsoo27s0rmExL7MuGiEQ81WCGjV/Qq5mdUvE7Ow=
X-Google-Smtp-Source: ABdhPJwS9Qsh4y/dbKVlAAa79kKlE1JYubXntgdEYMLyL1NLQ4tTEQE2EFgqQVcQ8I0ylupVSXvE4g==
X-Received: by 2002:aa7:8a4d:0:b0:4f2:6d3f:5fe3 with SMTP id n13-20020aa78a4d000000b004f26d3f5fe3mr452020pfa.48.1645669246980;
        Wed, 23 Feb 2022 18:20:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u17sm898425pfi.99.2022.02.23.18.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 18:20:46 -0800 (PST)
Message-ID: <6216eb7e.1c69fb81.adccb.3afd@mx.google.com>
Date:   Wed, 23 Feb 2022 18:20:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.231
Subject: stable-rc/linux-4.19.y baseline: 91 runs, 1 regressions (v4.19.231)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 91 runs, 1 regressions (v4.19.231)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.231/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.231
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1763074989b3fdb49c4b6e38ad7d70c69f93076e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6216b194198f25b62ac6296c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
31/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6216b194198f25b=
62ac6296f
        new failure (last pass: v4.19.230-59-g354a12b76a6c)
        2 lines

    2022-02-23T22:13:26.760588  <8>[   21.929351] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-23T22:13:26.805149  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-02-23T22:13:26.814436  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-23T22:13:26.832901  <8>[   22.002807] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
