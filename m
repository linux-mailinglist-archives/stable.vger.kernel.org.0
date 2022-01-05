Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEB6485756
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 18:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiAERgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 12:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbiAERgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 12:36:03 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FECEC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 09:36:03 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b22so35788576pfb.5
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 09:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4ixj3Ik0JYZE/54/jJ2rTYc+Sc6Wis5I7cvPKoHny80=;
        b=jt5mxZVTJqNvPNHoKrfXmJxGQAsl3cTjNDEnOrB3WHRbdbbHf6a9bDn+ac42G6V7i0
         iGITpMzzoytAO0xkMT1rYz8tMs7png4I4a/gmdUFZoXZtCt5se2Pp6er8j6OibRvyZdI
         IhM0HuKgZ4hmmf40g7scq7pQKgKkQY2tEZEEij32Ylpi3Wvk2ytDu0H/qtqPG8qzwoOF
         m1nG9wwSnz2yDpeAlIVM7F5x+JV573HWHFPYIb04rCAeHbmZDsd1WKOptyGthNbkz52l
         eyguuvutfys6q00BSBYcWrT3SPU6YMv1ilmQ867yIUF8YboWVgfUR4eB24mzqEiPcaz9
         gaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4ixj3Ik0JYZE/54/jJ2rTYc+Sc6Wis5I7cvPKoHny80=;
        b=QbY3ATJRxyBz2OokK0kfHuWrAt+3X3tzpxgIG21XMTusmoo9wfbbahHVi3gr5j0g0w
         vzdWJL9CaQEYGhL8xOayBAXCM8yrp5Oi429t5y1i2Sey9h2PHm9LBJa5tme2jD7S4gDF
         Arv+BDlo+VksTr0bZjFS0MSc36aqpPmAtE5FtMqXDefj1ZUjGrnA1MjjRuMicOE4G2fd
         ggWuUnaIwaRujrUkEW+KpBj2aSAB0e8ynOiGJvjwXzVuH/ecXKI1k83qdOe0b7xX+aNt
         xfyCPZ8/KfAvDgt4k2BgntverJeJdrNO5fEIKI3/7yTQp3MBEWlFdZKk8aGTnlneDNyE
         BMsw==
X-Gm-Message-State: AOAM530GSwKhZmQV8NjKsm+nOObSyJnxDgOVAd2E+mNsNIeImY//yYHr
        c+1qagzoPDRhQ9Pxi0dcpCnOBtXzeHmnEuWS
X-Google-Smtp-Source: ABdhPJzo0bq498KY3zG34DCq7jmxVutiDJb3Sgv2gKLgCOFjwMi0zsCkpQ7xvEZWbca4yT0eQpa5zA==
X-Received: by 2002:a63:414:: with SMTP id 20mr48450056pge.178.1641404162641;
        Wed, 05 Jan 2022 09:36:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm12106866pfv.74.2022.01.05.09.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 09:36:02 -0800 (PST)
Message-ID: <61d5d702.1c69fb81.7f96.bd38@mx.google.com>
Date:   Wed, 05 Jan 2022 09:36:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.296
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 132 runs, 1 regressions (v4.9.296)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 132 runs, 1 regressions (v4.9.296)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.296/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.296
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      710bf39c7aec32641ea63f6593db1df8c3e4a4d7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d5a27d47c1a58a8cef676d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.296/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.296/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5a27d47c1a58=
a8cef6770
        failing since 22 days (last pass: v4.9.292, first fail: v4.9.293)
        2 lines

    2022-01-05T13:51:41.284165  [   19.857482] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 4e:54=
:52:57:10:6a
    2022-01-05T13:51:41.290782  [   19.858367] usbcore: registered new inte=
rface driver smsc95xx
    2022-01-05T13:51:41.340258  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-05T13:51:41.349110  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
