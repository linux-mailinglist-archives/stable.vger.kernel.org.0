Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D4445CA5
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhKDXdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 19:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhKDXdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 19:33:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACADCC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 16:30:24 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f8so9814719plo.12
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 16:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mqsrok/OpvQVDzzH0WGW1RzsAEWotQbXPhtR+9vQPl0=;
        b=B+MMZqwbQnK1HB5SPHek9lNtsFmP2XkVUcVs07X7knnx2U/INUz54CnZXcYBNTty18
         PQN8MG4ynEaBo7Ph0T5gEmIAW16odeiSKDYEE2cOj1JMBrsVrlEchrD2qCkN6riEF6CG
         yjK1WeV0B8ztsICd25Wvub1b/ViLSpE3ejbQYkdOuvdksOOTVwA23bNbY9n0N6NCujDq
         stlcPKVN/bZ035VpSZVHrcjbsxxF/+UjuAAtgPBpZ4/oUPZiy1/QU3Y1pODKr9CsQhwz
         U1PluTbxtPZ+9yCYF3UmQOKtu8uWj1PBL0TD3nHAnzDdLG6UPkTCbHgrc6pcMKbk9Dlt
         OWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mqsrok/OpvQVDzzH0WGW1RzsAEWotQbXPhtR+9vQPl0=;
        b=UZVbkNRmuNHkpND3RkwI12o0gqTXbEDBtNnNo2FdPeIVRp0ODlIXKnrEiUpzaOX53j
         h9MxnBEFy2HY2oXKnMxDbKCw//b3hqmInMe3DZuWoAhiFDG5hou8jIpG+k4AbVIj41F3
         jWAfPvj6/md4/ochI/kCtKAHerwRb6bdJ7zjwinMyQ37LabGrkJSE++XIaA4xPzyZgpC
         O7Qwzy2h8hTeEB/F0w+iYAVAb2nBJMGLbwQwFyEgQO98inB/yoSfl0irqCW18wf0Ykfm
         Yq7EFJ9q/Fc2cZak3CaEHc8djlPCMWCZi1G9JxFT/EXFttTWoJQJPUIovSPNMpI7lTeO
         l9NA==
X-Gm-Message-State: AOAM533RyGomMvu6we6Yn+YM9NJTTbflJZIe39oVRtthZDUMSuo6Fo9b
        yjn/nZhQRYEl6tDXvcUGM/kCrYyqSe0DPBNj
X-Google-Smtp-Source: ABdhPJxukgJm+0BqmoszOWOYLFi5ShedJyXpg1lALBlvCR0p94bAjjxyl2Bx8re6sK8aSDgDkvewow==
X-Received: by 2002:a17:902:f283:b0:141:f719:c434 with SMTP id k3-20020a170902f28300b00141f719c434mr24941187plc.79.1636068624117;
        Thu, 04 Nov 2021 16:30:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s30sm6308954pfg.17.2021.11.04.16.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:30:23 -0700 (PDT)
Message-ID: <61846d0f.1c69fb81.5f29a.5060@mx.google.com>
Date:   Thu, 04 Nov 2021 16:30:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-2-g35ceb288988f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 100 runs,
 1 regressions (v4.4.291-2-g35ceb288988f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 100 runs, 1 regressions (v4.4.291-2-g35ceb288=
988f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-2-g35ceb288988f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-2-g35ceb288988f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35ceb288988fda599002ba30d40810a76df2a25e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618439477ade5536bd3358f4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g35ceb288988f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-g35ceb288988f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618439477ade553=
6bd3358f7
        failing since 0 day (last pass: v4.4.291-1-g1f67e88441a0, first fai=
l: v4.4.291-2-gade48a790ccd)
        2 lines

    2021-11-04T19:49:06.137819  [   18.926147] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T19:49:06.187933  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-04T19:49:06.197085  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
