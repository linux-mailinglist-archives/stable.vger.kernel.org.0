Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFC3467AA1
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 16:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381892AbhLCPzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 10:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbhLCPzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 10:55:45 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10FCC061751
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 07:52:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np3so2634591pjb.4
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 07:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BDE/u8OvsxtPTwlas23lkZLoXUD8Gx8pAalEYIs5Kb8=;
        b=FCCqHyTBeAIOMKu5gFHCBRwjmmGuvWDaAXX1RvEaPyNnr4/QQtS1TKwf/TFbxu6xwP
         hUEpxPGlqTT4NE7xzLq6HgL/FvQ917AObP0wT3UAF14K5vxDYuYwOf2tNgK65uva5viE
         J8Xg6jh0+LeKztnX/VwMuuQsEI4vKyVAh60mHBscNr5038SMTPxT1sQ62ueme7U3OAX6
         muqVzja5sODBqJPmuFZ6JWuyWLCsZYtPWkuwROYU9NeuROjoIS7E4+i0k3LicdUVj8y8
         9SNBT/qbgE5fNhFNFqNdhxpw0hSKSIHl9GQdtM70sz4fUKVvdANG0zA5jNOWHHGL+mN4
         R2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BDE/u8OvsxtPTwlas23lkZLoXUD8Gx8pAalEYIs5Kb8=;
        b=od+6fC/rlcttAS+yPuFP5BAbKIJV8D99oSsjLZ1gmylDyMMWq9AO2DjI4XAnY50sVz
         lCc429ppbEAqLAr3esjznbCLCOcd12qfbJB4UMOQEx7NooAKqQN7DxjJDhmBeFP0vGIx
         9Z0ndHupQhUNuGtLE5aBxk3wosRdHjQv29/Y2pmTalXxwGP/CRQureKWn3rtcpTQxqp2
         nr6LvVDwp7RNIHJMz8K6/pXFq/QZIyVY2iHEgxJoVJQmi0JuyN8l6/u5gbeykGHHgRj6
         zGacP0b4HWbLFd/TVwAuKr9kV+wxxVcSV/6gOoF6bNZzD56wAgEohHZk7dwRMvpb6M2r
         ojnA==
X-Gm-Message-State: AOAM532DmwUqZ39+kQmWFkpjG3722AEnVVtcqVlO12NtPdA7Nd1TGlx3
        w9g+uu3iDdq6qzNl7mQeeRbu2AlEEtgO0jN2
X-Google-Smtp-Source: ABdhPJyH4IyJpOZd0oF+02RBLlx0ufuN2ECa5yZiFySn0eMK6IAcOhIe+Pm1cWUed5s6NlVhhSTOgw==
X-Received: by 2002:a17:902:e8d7:b0:143:a088:7937 with SMTP id v23-20020a170902e8d700b00143a0887937mr23359284plg.63.1638546740952;
        Fri, 03 Dec 2021 07:52:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s38sm4142833pfg.17.2021.12.03.07.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 07:52:20 -0800 (PST)
Message-ID: <61aa3d34.1c69fb81.f17a6.be71@mx.google.com>
Date:   Fri, 03 Dec 2021 07:52:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-34-g00012cc3b7090
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 91 runs,
 1 regressions (v4.4.293-34-g00012cc3b7090)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 91 runs, 1 regressions (v4.4.293-34-g00012cc3=
b7090)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-34-g00012cc3b7090/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-34-g00012cc3b7090
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00012cc3b7090345801a90a45b7f838e91c44a1d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61aa05ba004f2e439d1a94d0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
4-g00012cc3b7090/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
4-g00012cc3b7090/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61aa05ba004f2e4=
39d1a94d3
        failing since 2 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-03T11:55:22.070083  [   19.414459] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-03T11:55:22.118922  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-03T11:55:22.128419  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
