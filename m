Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB945B3B2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 05:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhKXFC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 00:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhKXFC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 00:02:28 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23409C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:59:19 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c4so1525412pfj.2
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ODK5z1J5OlQKG5sLu1H+w81EAkO1DpPsYoR4cjQppQ0=;
        b=M+rWLcXy34Rzwrfzjb3RQSecyEykaqXvp16VjAtPVE+tPsMJwRv3HDik8s29WTUJRk
         IdLpn34/MkwDNGnyzwFhMdGp2riuIvhpMvFFvvHnSTJmXreO5rlyQMBIHy09LLA7RhIu
         5LU9zbkruvWus3JtJNrOuj56+sTfa/j4zyCX1eTubDyTiL2Xf63H3banqMbULJ186Cfd
         wsrxCxmYUkDJLi58rgKS1Lt734DEfe85UqNAswAD8oYO6VWJgGb31BwspbFI+h4oOfXE
         U7h7WiddPi9z42eCQ00Qioj5v73m9ILYZw7lMVT2inkjgf4JSM4ZtLBVIj/6Qf+dBgvd
         leOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ODK5z1J5OlQKG5sLu1H+w81EAkO1DpPsYoR4cjQppQ0=;
        b=jRDdAVL8v1t8yUV8olcfVubU+AGcn6ouSCEFzvk3rAAX2Db+yFbiOWB9X+txqtbLqW
         guEfxUogGHBq7O1TBLdNPQTv7Bbqkl3awS42whX48Mi+5DnVGGWM0ptYTFxaKythne6d
         DJgpBhC9mSsUw+Sl951H8WCj/8AJHJtZiN4jFknMm7I8n+THxb9iiDr+FEgmgY1UTuN4
         LYIrW3U5D8Hx/lCgbbLSxdorcGfqF5HKnrIY2dgThMXEC2Mtr3a3s2IjYPGK6rSncbS5
         3Xf8GygeeH4mvGcrX3jDkxvTME8MAC8CB0zHjHZFZrr4biQGlN0FUkBS+AcflEdVSKTQ
         ChtQ==
X-Gm-Message-State: AOAM533KwJZzfTLDVMbkQLrwAPYKuNJ3mhL/ba0XXZ65Zi5PvhoTcxlW
        sfUQzgAIBVqKt59dzyuIQzj42xOa9HqItQY+
X-Google-Smtp-Source: ABdhPJzY4po5XBk6MpEqgmks/wEVtHUY+VhWSG4MzGPMNGTl8B1HVaZlmjUgWqKP88BPw8fqbFAYHQ==
X-Received: by 2002:a62:1cc4:0:b0:49f:99b6:3507 with SMTP id c187-20020a621cc4000000b0049f99b63507mr3039076pfc.76.1637729958240;
        Tue, 23 Nov 2021 20:59:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co4sm2944912pjb.2.2021.11.23.20.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 20:59:18 -0800 (PST)
Message-ID: <619dc6a6.1c69fb81.c2a28.7b69@mx.google.com>
Date:   Tue, 23 Nov 2021 20:59:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-320-g3675fbb7a6c84
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 134 runs,
 1 regressions (v4.19.217-320-g3675fbb7a6c84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 134 runs, 1 regressions (v4.19.217-320-g36=
75fbb7a6c84)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-320-g3675fbb7a6c84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-320-g3675fbb7a6c84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3675fbb7a6c84d9ccb8f28e91f99d3f2e9e8c417 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d8c197c77dbcae4f2efa2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-320-g3675fbb7a6c84/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline=
-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-320-g3675fbb7a6c84/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline=
-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d8c197c77dbc=
ae4f2efa5
        failing since 10 days (last pass: v4.19.216-17-gf1ca790424bd, first=
 fail: v4.19.217)
        2 lines

    2021-11-24T00:49:11.072206  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-24T00:49:11.082141  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-24T00:49:11.096115  <8>[   21.272277] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
