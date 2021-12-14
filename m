Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6053D4746DF
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhLNPxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhLNPxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 10:53:37 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16FCC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 07:53:37 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g18so18179830pfk.5
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 07:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gLwOwK4kVMJb3AMjcJMGjAlR9sb4dKZHiJhQUD+ULx0=;
        b=0pFLwhBMlV8X6wCA4Ll1mWdoQYmIN0zwtiedyprAuan6tgKRe19rfxofz0NRAwKtDu
         Kvwco8E8RQEFDM2y3TLGpn3A8TBuYWetQ0Gz8whWCKw6NoHxIy8o+1C4yVf12Jvn2AG8
         zOWEkR8gDjrtnuJzGfVAV/eWaGf/F1BjvceEDOC1uazuWDaQf2hqMVNBiiN+HOV9jaxM
         iFU9SE0TIdSleC/Ac7PDcCCY5ZgxCMwFfT//tJyBIsyt4lddURuygih9eQby4wKnynTp
         tIR9W169rYOrSzLRY/h0HntPLaqspV8MtZHuTb5oa8hqg3OQTI9va/RzOufWaxInVyIV
         PRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gLwOwK4kVMJb3AMjcJMGjAlR9sb4dKZHiJhQUD+ULx0=;
        b=XJICHtW6aE+k4AKsIJ96KGV7F+OEG52D4Rt7HU6w2X7isEkXaHlV9tNDCupSBwB9iR
         LZ0auFxA2K73edxpPdaFLI8WC7mU66FFjVoga/cIljQeSRI6Mug8ijndvY9A6ue81Yqq
         QxA0An/qr8XcMUg+qYaCQPL0WN6fMOktt8Tb5KzzUOUNM0u2/WNJwLGdew58Z34r82Ad
         c457A+SronSwKVm0mDrGGv3BFEGoSv6gt27Cef8GOCgcQK+3c3yW1Kgvty5/8qgSTJ7D
         0qmDwAX+i9ZATrqZWuLQez+QYnbaxZ+dE7d4eTJUPaNRUOs5tUZasNHz0hBKvyKKYE/E
         nr3Q==
X-Gm-Message-State: AOAM530m/JKkLdLhGLyRGW1jmf4ExOYB0pVgV4IXehvnjK4TFaWoU2jz
        v/5LT6OXd+qIw1/5YtviOZML6n+2Wq+PX7oV
X-Google-Smtp-Source: ABdhPJzifMKNO80ur0cPfsPdpC4vkDHF7bquk497Q+im1N7Ze8FUe1BvYXVfSSGJKxEDMRtes8lCxg==
X-Received: by 2002:a63:1951:: with SMTP id 17mr4357069pgz.568.1639497217191;
        Tue, 14 Dec 2021 07:53:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x33sm241126pfh.133.2021.12.14.07.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:53:37 -0800 (PST)
Message-ID: <61b8be01.1c69fb81.6784e.0b68@mx.google.com>
Date:   Tue, 14 Dec 2021 07:53:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 105 runs, 1 regressions (v4.4.295)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 105 runs, 1 regressions (v4.4.295)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.295/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.295
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      87ae08ae6ba1f4d6ca8cb134899d87737700be15 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b884d00b2386f13839712f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.295/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.295/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b884d00b2386f=
138397132
        failing since 17 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2021-12-14T11:49:10.541898  [   19.341308] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-14T11:49:10.584865  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-14T11:49:10.594885  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
