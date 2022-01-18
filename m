Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068F5492575
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbiARMJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiARMJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:09:28 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E26BC06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 04:09:28 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id w204so12869265pfc.7
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 04:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1kfA6C3eithFLa7GHRAWq20OJQFzhBPjdyYUvW+38JY=;
        b=57eOBuhJl0bJTnvjL8NZPqviz2HXQTRgoTN4VePZbs29YMfC2QJdCVRV/TNTXDMdwD
         3A2ZyfhNZ/86byWoljDfYKS9t4H4D9R+d1GOE1vY6/BzDsdCSvOPmgfOYe7SSbqvFJfU
         R9o+K97q9SBHtKJS5ExZrMHBkTV054v/ebRsDDHW4jJSIHx7JxdhSX2436wiiJ8LCyLh
         3DQm+RxdZ5Icr/08UgoBmRp4rC5OBMdangu8I3P9uICLQ30oAjR3XsC2JYGVWJr12qfZ
         du0a05xIDSXEputP5BH+2oZc5HsxjXxCRJoa1kfFTsjV5IbVA9dGwFYsyJrIGo5xBKUx
         20pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1kfA6C3eithFLa7GHRAWq20OJQFzhBPjdyYUvW+38JY=;
        b=q2vJtk+NJCGBjkWgpBpgpc6SFdPK6Pfq4o9yg3Ja2W71cJLHeWLadiZO7cifjnwhN+
         aBdZWY6qknvi9PL1zQTLginDLWFBZX1stABCVQ2TDS5BTSj8luymCG0FVrj6IjbismeS
         MLa0m+hblFznvaDsVm6EeANDv42psvPVTVOxUIcOSFr+W+WKrjS3PJsxpzWQOksU6ggK
         WFMwph+MFP1CR6IJVl5xF3W3KTB/uyrRVjf42XuGPtpO5gNhqVyVO0AQaWi4CUM2Vnjk
         eituTNoUyKpAU6DyPtTt0nlJEwMwZtTpeUUnCsoptkeM15yHU7DreFgd15fyLkC1oeP0
         w72g==
X-Gm-Message-State: AOAM531VXn5UC0FCskYcPEcd+q/VIknC8fjWrq63Mw5oxUnpBdrdiKbt
        RIV47KulcvoGO2S1D5e9XPUVpQqQlmHeBFoy
X-Google-Smtp-Source: ABdhPJxjiFtma6WvT8SPxRsp7x9HHjlVA19tIbMlpJH23PAiMmI7P0mY3I4d3ivkpANePIppbtho7A==
X-Received: by 2002:a63:350e:: with SMTP id c14mr8684607pga.377.1642507767359;
        Tue, 18 Jan 2022 04:09:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f30sm2558023pjk.38.2022.01.18.04.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 04:09:27 -0800 (PST)
Message-ID: <61e6adf7.1c69fb81.18342.6577@mx.google.com>
Date:   Tue, 18 Jan 2022 04:09:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-7-g2f072f5d07f5
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 121 runs,
 1 regressions (v4.4.299-7-g2f072f5d07f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 121 runs, 1 regressions (v4.4.299-7-g2f072f5d=
07f5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-7-g2f072f5d07f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-7-g2f072f5d07f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f072f5d07f513c17668a494b0bac95807d812be =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e67dbd291e46df14ef6760

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g2f072f5d07f5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-7=
-g2f072f5d07f5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e67dbd291e46d=
f14ef6763
        failing since 28 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-18T08:43:24.108234  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2022-01-18T08:43:24.117928  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
