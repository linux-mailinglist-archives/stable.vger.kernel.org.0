Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB44783E5
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 05:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhLQENU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 23:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhLQENU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 23:13:20 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE369C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 20:13:19 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id k4so942769pgb.8
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 20:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TSdZtf3hWGOAORJ//t9bMY/ps/jTfZy0oYET3X8ohUk=;
        b=soyExTq7OOmOlb5iEHyIK7zG/eid3scIa49DPN4/2faE701mdt3bY5MB3q/W759tfc
         +Vy7AZxITYElcDMAy3sqbFz2rt7N96A+FvtuZU/lX1fnmpOFWweC1C+MgYlirvRgFIrm
         pFVhYQJaowwMZQSrVG7y2X9zy1S3RndZVBxpgFB7K4UugsFmklYLSrFi6WWYT0CkOlUD
         R16T/MslBDpxjL2Zjgqcp8AW/QgUQKn2u3UxpWMnevwpd8o+FakcsEsiRv+DKckSbPrF
         MsxFnzLwTisZeHL21EHsXABR9RMf+ModQX/iA5fADLbX2+33QpZfyGPNVijGN3YOSDPA
         vzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TSdZtf3hWGOAORJ//t9bMY/ps/jTfZy0oYET3X8ohUk=;
        b=Xo71FJGD5M7JiV8/HWCxq6gEKce24qtX2hyd4KLVmOR8A9PsB6JK7ETVWVfaNhM78b
         xo+kv0q+3i+JFnOddGd+6u7k97Jtmw0S1LU66q+/0ST3VLN8COb8jwFv7xGVfZfk16gH
         Ka0d0FBd08wPEBKYOkrncyWOrtQDPZb6ANnPz4qTVpmqb7oObLPgnAO281Zn8BJRX8W9
         GA4jQ9aukChUCFl17p3aE0qKH5m2fv6gSt5Obkb6mmz/xfndi1Vyhrfd/cFH550MVTcV
         2OkQ11GRqrUnpBjGjWZuH0Ui2uREQTqSa/mRv59qH8HBCJQLmUtuYyBXJFIkUEvBsjMI
         o5zQ==
X-Gm-Message-State: AOAM531i1xwtcGuowM/Pjh3YodV2IICnaD/lrnHdbyygNhVIBOSl3Tkd
        gmZT1gA4FpE9/rZhSinHZsWAFyJki2/L35qW
X-Google-Smtp-Source: ABdhPJy8j8IVS+26Wj9Jl1YpUjHuL918mk3N5P/tJHCxW82I8EH20bC3/vt4JGBJ86FgXj4GzAytWw==
X-Received: by 2002:a63:1726:: with SMTP id x38mr1279389pgl.518.1639714399339;
        Thu, 16 Dec 2021 20:13:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm2846673pjt.25.2021.12.16.20.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 20:13:19 -0800 (PST)
Message-ID: <61bc0e5f.1c69fb81.409e8.8414@mx.google.com>
Date:   Thu, 16 Dec 2021 20:13:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-7-g534f383585ec
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 1 regressions (v4.9.293-7-g534f383585ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 1 regressions (v4.9.293-7-g534f3835=
85ec)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-7-g534f383585ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-7-g534f383585ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      534f383585ecfe86e702f65a35046db051c08f2c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bbd2eab956ced68a397162

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g534f383585ec/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g534f383585ec/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bbd2eab956ced=
68a397165
        new failure (last pass: v4.9.293-7-gd89b8545a1fa)
        2 lines

    2021-12-16T23:59:14.994965  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-12-16T23:59:15.004207  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-16T23:59:15.018491  [   20.348266] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
