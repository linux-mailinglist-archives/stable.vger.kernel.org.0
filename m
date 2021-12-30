Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90F6481BC6
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 12:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbhL3LrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 06:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbhL3LrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 06:47:07 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11771C061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 03:47:07 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q3so16885273pfs.7
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 03:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=40Me6idgKHXDUkCb2VJs6vPrTRJ2q8bfIbWeRWIkrF4=;
        b=Ot056hCbIo1KpfnBKu7/0mIjR+uFa7llqPh7sdghuZHwq4jUHzciGyjAtcSAGt+suj
         7cjBpvgYyTLAQqNzm9kY3d/zESt2+02GWnXxqc0Gzs03b0MvwFal6TJ4TjJWvz+GRf1D
         i3CtNmcO4q7+exKh6bBdYN+iFRzAnPauay2tB9mutcP7rshKsYMZugJFl5ekjJz4z5Oy
         9ZmJ88cDdy14ekbr2rBvKO7qy7jv/pwLmrWjGTjKiaotT2oDSJCRJFMgs2daljTED80u
         BpYXBIQTa6W1Vso6D9F1Jm+gOOg/bAGed6qtKI9RuyYUD3nK0dkvSfKpg+TN3aBlbp2+
         qdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=40Me6idgKHXDUkCb2VJs6vPrTRJ2q8bfIbWeRWIkrF4=;
        b=gJEEEP7mDO4iVQ7dOM6zx9V2ol5M9YiX6D2etP2UTwLZxTghwGHzTUcIPhle7qxZaT
         uGkT6J825Ni/5dqiQCW2aCF646OJW4pp61lxU/vy5QI31ZTEUHIfTdPfeQTwSkwgVPBN
         Vh7MXBpLiQzjuYSgp+jYrGa3WzXh1deuseVaykbc3gXOXA1VYvpAPgmQohrVFqbyAh8X
         sJvAid6J7NbO5RB2FoXWlkqcpGfILzSFheRTq/CJTS9MtIWudpObMpAjdVWWzrZm4iOr
         zc7mAs1GMiO4W+DkSTJY3ByHTwLwpbDIB0DEKS0Aos2r0IuM9KXHcsTFQNYdtX++uupx
         nnvQ==
X-Gm-Message-State: AOAM532Xmb7L1LWQAdTkJmw//v5CLriHu+mkpTiTphxdGDzDLxz7z6IU
        lsGzqYyq3qt4xwkziQbYNdjJhqGu1xphHQLB
X-Google-Smtp-Source: ABdhPJyRJm9Ne5vQbmAVkF1fRqJxBi2xasNFPQk/70l+3lywRAPncgOnnNi2yUQ/b1pZWm5e1qHRiA==
X-Received: by 2002:a63:5541:: with SMTP id f1mr27096018pgm.320.1640864826344;
        Thu, 30 Dec 2021 03:47:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11sm26305689pff.81.2021.12.30.03.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 03:47:06 -0800 (PST)
Message-ID: <61cd9c3a.1c69fb81.62a07.94e3@mx.google.com>
Date:   Thu, 30 Dec 2021 03:47:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 38 runs, 1 regressions (v4.4.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 38 runs, 1 regressions (v4.4.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.297/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76d42990efb4902de293be254f5e93c693058c8f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd64576a546c5c9aef6756

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd64576a546c5=
c9aef6759
        new failure (last pass: v4.4.296-18-gea28db322a98)
        2 lines

    2021-12-30T07:48:23.835639  [   19.512725] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T07:48:23.886662  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-30T07:48:23.895867  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-30T07:48:23.917387  [   19.595947] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
