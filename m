Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C7946F8CF
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 02:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhLJB5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 20:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhLJB5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 20:57:05 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A9C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 17:53:31 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id j11so6759962pgs.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 17:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dbIOj/pz4Wy/O/sx+LP9oedCT4MuORys3KtZSBplFos=;
        b=NT3C/1BXLOSyDsMiT18YYmwM3eiJvw/72NVYQhtvjFdPm6hgnAaJ4fw3QAEmsS49k9
         +PQiYN/mzbiFDVaLpXkh7/cabFACrn3/UzXwRfIgTbDIvyth+jN7AxC2WO86KSmZu4p6
         v2RZYP/0ATYWsUAfWmsmdDDczwyGk+4cLUkL8oiCF8zH4tyJ8alXXpgWbi54lX8wwF/g
         GaycNE5NAX3R4VLVvFSrisTmRk6BrVQ2fPoW8n3eCySKJlMqY4hAIQCPQHEnrmR4ot2I
         ++orMnTzpGmf5Lj4yB8nL0COj935E5iTl4UoNIzmMI+7EJnjGLoXCpCiayEO1LBYzJOp
         fMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dbIOj/pz4Wy/O/sx+LP9oedCT4MuORys3KtZSBplFos=;
        b=Lx8n4JvEz/bOhHbuQSujkeBOLXUNjHZbMt2SdOpsOnO7MprRZrOlWD1PF1NGh9x7Xq
         h1o50MUoe38d0MUa14VImky6RV1/6bGkTPhJ5nVTkzluSk5jKPmcB9jVWr7BhC0iR2zX
         bgBWR/wEk1MK8VsiPdyhAmX9mS0MLXk+ASkDikfQeFBGJahS1vKJwHkGNYPEBeLcrqeX
         KidQk2ZP4UqqOxMWgyUuumgESAdx0MeHqT0/kSwVZZSh7MzNHkRPiye8va8zGUzN4BlS
         N0Qv0jwSVcda6bRivKkiToboRwuv5QVjlemClyw4iLh2LFMFLUp5giTvrzNXQtjJi6El
         W+sQ==
X-Gm-Message-State: AOAM5335wH+Oswgt0fbKUppOZHgLbaQ21DKxIF5ibhXIPd2YlE11AUeo
        pfR6sELEkBSXNhDdzZpvMXc/fAnQReduXy34nNE=
X-Google-Smtp-Source: ABdhPJx2PNBeMLLdGkJqGU2M/xIWhN1oIEJjQmTyf68jzJdVKcq/jRK+EcKRyuEsefMlpXrXi8qS3g==
X-Received: by 2002:a65:648b:: with SMTP id e11mr36651187pgv.138.1639101211188;
        Thu, 09 Dec 2021 17:53:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i185sm959512pfg.80.2021.12.09.17.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 17:53:30 -0800 (PST)
Message-ID: <61b2b31a.1c69fb81.2c738.4a4d@mx.google.com>
Date:   Thu, 09 Dec 2021 17:53:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.293-60-g41e24375b1d1
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 131 runs,
 1 regressions (v4.4.293-60-g41e24375b1d1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 131 runs, 1 regressions (v4.4.293-60-g41e2437=
5b1d1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-60-g41e24375b1d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-60-g41e24375b1d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41e24375b1d1f7f7ec5e3fa5f4d93d735b86009d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b27ba54906d1dd70397140

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-6=
0-g41e24375b1d1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-6=
0-g41e24375b1d1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b27ba54906d1d=
d70397143
        failing since 2 days (last pass: v4.4.293-52-g4bb83d906425, first f=
ail: v4.4.293-52-g43d995ef586d)
        2 lines

    2021-12-09T21:56:31.265482  [   19.325958] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-09T21:56:31.305816  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-12-09T21:56:31.314560  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
