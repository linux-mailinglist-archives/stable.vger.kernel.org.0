Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD8931DD41
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 17:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhBQQY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 11:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbhBQQYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 11:24:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0B9C061574
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 08:24:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d2so1952774pjs.4
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 08:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NJmXAJWOmNK/KT4C4RA1J+8Dnn5iD2fdQxjDvqbPa4w=;
        b=dBC7QEjj5mZVb/ZkryUJrm5xmc/UF5dIHB8oyO1cd9sOEMfkbcDeoeg0ARsqvNKTkE
         H31T3SKejya+MztKWtyVLlmifmBjQHm+23xFWEkEvXbu6bEi5WKGUiVGMIZGrpzGqXrw
         b1DSSQ2aKwkJ9g5U7Z8s1pfL8LSW2Jhxgo7acWFGWwMnEodl921XcTNDEelKZVXD4rJa
         RIbLEhMKNnMCJk2TwF+tH4I0/YW/7W1amRASb5rrLWTjJyQalLUDxLTwgaNQuUPsiAcn
         +8oDgCQwvgAMhMmyZ3bd2Scy01ExoVTQHXsnWE6+yxEp1wR30eM17EJUYQzYQAvzxC4+
         SKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NJmXAJWOmNK/KT4C4RA1J+8Dnn5iD2fdQxjDvqbPa4w=;
        b=QRofljhZvxcOBzCWMgMj6hSCiidFD5WMjseId44uGyCyGncyYcAfomCc3v4XbNXswG
         EqdWVwwH8CJ/wBHpT1Deis7TPKuI/G4cPiui3WT3B2uicrPqJxuYS2vX9D+Hnd6DGl/u
         JlP9Y/YHRNZph6oWBlKLJyf+Hisyh5b3f2gc18szsQ8FcRmbYDmRQEJKtKB+RewoQGAw
         fE7n2iDYKvZyAd9EOKYNZrQOfSZelXxQlVfpFGmSh2SFqShy+xe+9HSWjQ2OBAfPUpsD
         TlTrDVEyYfTvLzMdne0dkZjIog8ZY33TBlwyZ7WakpqekUPlOKoHy8haEYh9SpmvCi1P
         Eo4w==
X-Gm-Message-State: AOAM531GomkBLdVjD1eD2oIPFM5nfwpXOUyb2O2pzHuRZ7fw2BU8rfCd
        qI/TjFHM1y0bR//Cm0hteYXYQqimz7H2QQ==
X-Google-Smtp-Source: ABdhPJwwE+EpdOqit22y2hIvUhd9QfHh7DEfkfd0LOoTE0g+qxKNdgGxS9vNI54+m3xmf+HwPBgq3g==
X-Received: by 2002:a17:90a:eacd:: with SMTP id ev13mr6646949pjb.85.1613579054955;
        Wed, 17 Feb 2021 08:24:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm2741841pfv.84.2021.02.17.08.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 08:24:14 -0800 (PST)
Message-ID: <602d432e.1c69fb81.b875.5d02@mx.google.com>
Date:   Wed, 17 Feb 2021 08:24:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-38-g644bbf2efc1b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 48 runs,
 1 regressions (v4.9.257-38-g644bbf2efc1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 48 runs, 1 regressions (v4.9.257-38-g644bbf2e=
fc1b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-38-g644bbf2efc1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-38-g644bbf2efc1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      644bbf2efc1bccfec8b7292d5e3d5da760ca0eea =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602d099213e8c34b90addcb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g644bbf2efc1b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-3=
8-g644bbf2efc1b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602d099213e8c34=
b90addcbe
        new failure (last pass: v4.9.257-38-gcca93d9a8f3f)
        2 lines

    2021-02-17 12:18:22.848000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
