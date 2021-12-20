Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29347A7CE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhLTKj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhLTKj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 05:39:27 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9F4C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:39:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso10776559pjc.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 02:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QujpN/q5yQkWRYfMlZqrchcJU9suOofwP7TICDUq4LE=;
        b=YCLyG9/2Ffak5hiItoDUvsB4NTOGGYUzGo8yC74y3yCm04mSeD+r7rfunQ56IxHHvR
         vVPDTgLMH09uZVVGqryqY2UYe1U9+Jvxw9ftktMnSLN/D0DvG+sALBfRb+YTg+nqgybh
         zjU916WKAj440I5EtIrSXpCQdFkn+AU7pu28wFO03Q1/aBqwWppvJP02EYXKrRQV5HK5
         Xcf+JSoJA4/GUkb8ItAZEoVKvUuGyxDEBpsZlGGAXyXWIkhJX4eBJ5IvtH+TThsSZsF/
         /M4o4ubfZVRHgnyYhb+byihJn7mPaef8SKU4/ClsfWa//gVB+T9aXF1PANrDNeTzid1H
         YRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QujpN/q5yQkWRYfMlZqrchcJU9suOofwP7TICDUq4LE=;
        b=R7ObIHN/thuBvRIkMd26zv6DUckfsb/dJ8114Vg1GLhqL/pbTbfCPHzKEIy9I6Jc97
         wftakmeX/wyfzOr5GkZHWl2Q3gPONLHNpnxKPkudjxxmJ3xKu/zCbRA0kkVx+1SmEk4q
         FS2RCuABebfUlBeHCg7R3sbZzLsBdD9VRB/fJnKK2vQJkhCM5xzjZTyN1C2OLuCbVN2G
         RnWP4//dpuRnJOTYLBtoMD8c78G5UHn4sjcp/hbxe3x18I9/Ly7u7prTJDoSz/pq9J+4
         tNNpCzonMdbO2fmKuJ6ZHf+jAEViUmtZg7HfXwUfIjNN17Pl9DOQUCO0YrENE97ew2+O
         Fzxw==
X-Gm-Message-State: AOAM533w0qgcmkdS8keji/2xqp5tmEfquDaDMTGZeMqrTEl0N6E/o5dg
        JcuwV+vp0Chu0sHbjujS9Ec4gLP63OaVs7MF
X-Google-Smtp-Source: ABdhPJySRYve9A2yyODpONU20f4/0Bv3+hlQmegwg0hfwjnCAYTrRsx1p5F4ME5mKYHQHA69hmDx9A==
X-Received: by 2002:a17:90a:28c4:: with SMTP id f62mr19156800pjd.207.1639996766877;
        Mon, 20 Dec 2021 02:39:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm5682043pjs.9.2021.12.20.02.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 02:39:26 -0800 (PST)
Message-ID: <61c05d5e.1c69fb81.4e4f8.f900@mx.google.com>
Date:   Mon, 20 Dec 2021 02:39:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-15-g3fbbbaf0d213
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.293-15-g3fbbbaf0d213)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.293-15-g3fbbbaf=
0d213)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-15-g3fbbbaf0d213/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-15-g3fbbbaf0d213
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fbbbaf0d213fd1ae62e8c7dd54110cc0427e7c5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c023f77a21466339397126

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
5-g3fbbbaf0d213/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
5-g3fbbbaf0d213/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c023f77a21466=
339397129
        failing since 3 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-20T06:34:13.976547  [   20.230133] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-20T06:34:14.019852  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-12-20T06:34:14.029323  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
