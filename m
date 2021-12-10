Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8652470996
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245704AbhLJTBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 14:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbhLJTBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 14:01:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6018DC0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:58:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z6so6861828plk.6
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 10:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nu33UQUb5ossgNtu9QA9jLFP5ssclSr3nztOaSU3/x8=;
        b=qJsDQghg5+dqTLp5OrqyxdTs4HnCjn07T61Pk+ODlTaZtFrc5mztjsD1urz+PFYpFa
         TfbSfQSLWlOmikVnEciVWBIGExJpAwemt5GhTmqgRKA2NY7QxEpjCb8MM+ttq4tBSbOa
         X4KAGr2D1uRvEBZK6vOwexWrcCX++No+W+s1126mCeSbpUvOk3AL6g+pMJCM7N85epzT
         ylm3oluEZO8FbO0X6bMbpv+Ro39FcFMuVPcWNazRziniUA7SOYrvFLBmyKtNrJUX8N+W
         lyKvxfCnFhV98ZaqP/Yj9dlEUO1rVFAUA5seIVI3FNt5b2W0FgDgL/HYZa/etUZEdl6q
         8DCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nu33UQUb5ossgNtu9QA9jLFP5ssclSr3nztOaSU3/x8=;
        b=TEljsw36o6eaj3JDlTMqth2bbgF0sostbUb845Le+w+8JlWimVgjKoKYFiHVIfGDHV
         W02GtPga+nf+/5/eXpybv0qW4VTuuK3K0WHh1N+mSFom/hAa0i62M18KGg2rm4fWXmT7
         dL/e3Z4a34wWlW6dcks1trrPJtYEFlPUacmVia8pehMu26NTwQFfLixb10xPTX+5NoFm
         X5Fhfo+gBGJLHanVWsyDSDLIpnYL7dZ3xsTrTuOM3mulT7G/oiOqyYym+76L5tUSvOO9
         cUfj0Q+8Lj9UEkabfwd3l3uNd/EsaRrzl+oIfiNnlhoTKcqppIeLWAcfLPTKxJOXo6Vh
         GJgg==
X-Gm-Message-State: AOAM532jTNxyYlO5F4Qfgbxf0DeZu9kaPUBNpoedh1T/VWh7VQf+zrC2
        l1eDZJQ/fgAxGeEmep3gaDVHBT75KmNa1XYa
X-Google-Smtp-Source: ABdhPJx1T188Js5TH/wvA9A5g6i8+qZ/JOYVDyVe6Lys0qDXIvvNdgXq28SIbvzE+3Bk2ov64WNppw==
X-Received: by 2002:a17:90a:e613:: with SMTP id j19mr26364994pjy.182.1639162686800;
        Fri, 10 Dec 2021 10:58:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm12954191pjz.43.2021.12.10.10.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:58:06 -0800 (PST)
Message-ID: <61b3a33e.1c69fb81.9c5a.526e@mx.google.com>
Date:   Fri, 10 Dec 2021 10:58:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-7-gb7688924d160
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 1 regressions (v4.14.257-7-gb7688924d160)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 1 regressions (v4.14.257-7-gb76889=
24d160)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.257-7-gb7688924d160/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.257-7-gb7688924d160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7688924d160a5d0009d44f22c1edb3ee63fe026 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b36d54400346ee92397143

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-7-gb7688924d160/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-7-gb7688924d160/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b36d54400346e=
e92397146
        new failure (last pass: v4.14.256-106-g42fb555ea765)
        2 lines

    2021-12-10T15:07:53.672809  [   20.102569] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T15:07:53.712891  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-10T15:07:53.722325  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
