Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9E28C67C
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 02:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgJMAup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 20:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgJMAup (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 20:50:45 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B27C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 17:50:43 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c20so4819360pfr.8
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 17:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V8H1guCZcvYrPjCpSevzD8p74oXausvzkyNlIsC3xx8=;
        b=Ubso2DlXqsrqj3i1JL51SOy+zTeZ8ipc6cETvQ1V7egj3ma6oVzIO81FfyY4Zfexs5
         U1XNFh0L4qnToqkUClkN7udbSWu1jpvKIaZwpZFJG+MDgL2HdSjVrYEWuDy9zq/mBAb6
         KxT07SBZaB4di5F8LAINSxbRIR+Pu5F55a0QmjqrMUyhUm+cLsrpJZLEjvBWkcr7HeuA
         el5cvPIDc9dCRIiTYKEe7nKG3L4nVXukKcvm1aGl5Zg/Y15x/FI4qL6r/T/aIderIxUI
         /Azbdz7UM57GzMAGffeJOWRxkwwP2+eadSfR1/UmzOZCLywz5f+VOXjuXird6lHa5rdz
         mP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V8H1guCZcvYrPjCpSevzD8p74oXausvzkyNlIsC3xx8=;
        b=el1GWcKTpgbpaxMQqNTIJeZJNxY/IYim5TVumtflrylLZtWYSkyHHfdbBphTAObvxr
         yfU6ILVmjTW+ZA+Zx9JrQpl0DRZOinMLD5fsGazNTaZrw20jbr4cknBtOrQh1IMkePk+
         GCMD9PFIgqe6IQaeANWzpl9Fp1O7Fprob0F4Q5FlULY0K/NJErCvKDme7zMnZcs8bqJ9
         w8/WgTpDAWInKw9ioLvnG70vHCuH3QWfmPkujLigPLX/4u83Wb6mfGQDugj6qsfi0SZ6
         fhMrQX1y0qOU32h8cdNCmCPIoC23ZzHXkzDRQWADBBesTuHvAurNkc2o3yl4sBMQmc8Y
         v1TQ==
X-Gm-Message-State: AOAM5333BHKDiWFVSD8LJkiyJH7ChulygDbAOdXe7BV0iHv0gl2zumgM
        2T/bwKhS4RP927PkAdT0ANoL7V7/WLgrCA==
X-Google-Smtp-Source: ABdhPJynM83WJndTFhp+1u5PIMJRb0I/KszkDYcG+gV2ZMtoyk7NFCM5w/HrIxH4lt77hLIySs/0Vw==
X-Received: by 2002:a62:7749:0:b029:152:9d3b:c85e with SMTP id s70-20020a6277490000b02901529d3bc85emr25290623pfc.16.1602550243050;
        Mon, 12 Oct 2020 17:50:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lb13sm1454470pjb.5.2020.10.12.17.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 17:50:42 -0700 (PDT)
Message-ID: <5f84f9e2.1c69fb81.acaa0.467f@mx.google.com>
Date:   Mon, 12 Oct 2020 17:50:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-55-g132affe7fbd6
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 114 runs,
 1 regressions (v4.9.238-55-g132affe7fbd6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 114 runs, 1 regressions (v4.9.238-55-g132af=
fe7fbd6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.238-55-g132affe7fbd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.238-55-g132affe7fbd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      132affe7fbd620235ac2d7fefa7051090b58f392 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f84bed59130dfb2a34ff409

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-55-g132affe7fbd6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-55-g132affe7fbd6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84bed59130dfb=
2a34ff410
      failing since 7 days (last pass: v4.9.238, first fail: v4.9.238-23-g3=
14770acbbde)
      2 lines  =20
