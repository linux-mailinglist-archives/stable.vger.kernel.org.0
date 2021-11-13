Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F183244F0A5
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhKMBqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 20:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhKMBqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 20:46:00 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC90C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 17:43:08 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 136so4807412pgc.0
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 17:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PT375v63PFtAv4YAZLxQSJy5Od3Cd7/6h5nybyrJHPQ=;
        b=He4jitpfF8GCuuu8B1lrW6xsPW9XF6pes1IsW2nDSeCEsV5c8SgpFHiRgyRF7zPQ9I
         TuUAO3JYPoMqvU4SbbfqOjiOUzHRcnwKUtF9nRQJZhr1i0P8zj9GG4G9uWwDm37outS8
         w0nGe5h4rJob7XdHOTJgONxdDRl/G0hISXUdfF79QL6mzZa1joyfXPppMM5131zafWGK
         1JIao5COtzUAzW5M06NJWe723QvOuB5uo+jfkMtUKA6JboHu/dXImyP5K+CtuIfk+x5n
         LlGrSptTD8Aln5Py6JuDX9WM9KrcqqY1t4DWUEV2v2AhZXjMkUXZ3ZxBct0F/JP3/TLJ
         DxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PT375v63PFtAv4YAZLxQSJy5Od3Cd7/6h5nybyrJHPQ=;
        b=3ROQVgy97GDxX5G8V3wP2rdHKKpL9WfPOHvZ5vxHzPeHYXx4+EU7SF7aGuI/fZ+/at
         nZWCiwMARX7ylZKIzc0bTZFuXtvqx4LXLcFEg41CgMOEuVuZ2ENPMLXs43ujXyCFF/nb
         NywIWbH5Mm/Wkw/+0V4q3zWssgA5pys2bc0Svj+qc6F+5wAB/Ifr8jKAhDVVL2VOtxok
         j984o6U4OLZKwoHWwF6zHXl+rP28EtmA9SrdMcp3tXT6SS+zQcqufMqx4HB005SoXWRd
         YXXBDp0Pnv5ssbrUKOz5RchHS6Va1HaMkIbsXuCNJJggTEfnBN9L+80RJtfo36p3DFEU
         inCQ==
X-Gm-Message-State: AOAM533WlaA7JXzOCOmdM/ZenhA6Rl2IinvRuuiJIZX2NNdZKzJOas3m
        hUDynfrJPvdum6FLGYnTuLUMt5BLzVC7FLH9
X-Google-Smtp-Source: ABdhPJw7An7AtzXf0EQ84MexvCdjfg3HnYUSFAYV2F5oVrpFo2Q7qsQQuP5ugnrX3Lmpl5griswyYw==
X-Received: by 2002:a05:6a00:22c2:b0:4a0:2526:e728 with SMTP id f2-20020a056a0022c200b004a02526e728mr17740511pfj.1.1636767787869;
        Fri, 12 Nov 2021 17:43:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id rj6sm13604812pjb.0.2021.11.12.17.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 17:43:07 -0800 (PST)
Message-ID: <618f182b.1c69fb81.d8caa.8748@mx.google.com>
Date:   Fri, 12 Nov 2021 17:43:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-26-ga0450cbaedd6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 146 runs,
 1 regressions (v4.9.289-26-ga0450cbaedd6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 146 runs, 1 regressions (v4.9.289-26-ga0450cb=
aedd6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-26-ga0450cbaedd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-26-ga0450cbaedd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0450cbaedd689516837558932deba437d04cbb1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618ee0be77713b363b3358e7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-2=
6-ga0450cbaedd6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-2=
6-ga0450cbaedd6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618ee0be77713b3=
63b3358ea
        new failure (last pass: v4.9.289-22-g296b3dc5af4f)
        2 lines

    2021-11-12T21:46:20.901889  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-12T21:46:20.911751  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-12T21:46:20.926735  [   20.172698] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
