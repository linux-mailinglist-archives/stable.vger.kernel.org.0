Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E18446BF28
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhLGPX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbhLGPX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:23:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4847C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 07:19:55 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id m24so9638286pls.10
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 07:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sLV3MVxUSGjhO2gtvSn72Cjixh5/nDT+bPyCc+oAg9I=;
        b=Q8BfS1fJPuQPoUv616XBLyyvd+6gSSYLkv+S3ZMhth7lI6ZULlsjvX1lTu7caLH/Qh
         RUF4gW4lTUt2kLKTbrZZPu3r3WOUfHl7FIBFi9vPzQoVWen2j74HjfprZ7hx94CH8z76
         HlEK6fadV0NBzx6Qvl7DdTqFQwsNyFKbnboAvzPo9ccKzRBpuTO/C9b7dlrpqaVyuZKb
         BY9PIBg5QyndY4h8Ttd1jq8CD1/6hRbSMmtZlfurSXngiuQf24swu1Z2RajwSepEe0ju
         B8agzRlZl7isiACSKtZWbDf26rYeldYAziXyJ2EViVbp8NjC+LbKR2Ju4LaLQdaIN0f1
         gyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sLV3MVxUSGjhO2gtvSn72Cjixh5/nDT+bPyCc+oAg9I=;
        b=QO3W6noC2I8C0+hX/mgVTCe2W+wiw8QoE9g0FHTqUbCB8XRoB69zjVqt8N0y5rhfdc
         jBTJWRm1ZSfk4l63aTA67PA7SR63tnGNzUr9fQ1etixsaS7MmyiBEIsetZe3/wl90lyM
         S6BGX65BPw7c+0h4ZOc0efZXnPUGHoMexXrnRO6jme3rhbOHt09/TcrJgK4ufhqURMuO
         0AMwgAWxgu6P2eVhZqHX8XBK60TCK5GqmVUoTx+T745f6DS5KFAzKRyFojCZy585K0jV
         6o50flcrDWFe5XehmopttpcIoyMGxwy4I+K271tE+nZkf0wI34aBfBkHz6rLYbzxf0xi
         J/oA==
X-Gm-Message-State: AOAM532RtvNQ5jV4GkVqLi64a9weE1KnooGJKUM1x5W2r+QQ/zdYPpue
        Ne0b13tlHZ9ze0mKLjFzgdEfx026fBNxJyFu
X-Google-Smtp-Source: ABdhPJxUHSSkGDGtmKeMKsMkjkJ3InEcZs18L5b0ylzPJmNzv48nmfbnJYkiYfBxIky0j3jMhd6bDw==
X-Received: by 2002:a17:90a:983:: with SMTP id 3mr7349805pjo.70.1638890394168;
        Tue, 07 Dec 2021 07:19:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n16sm3230378pja.46.2021.12.07.07.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 07:19:53 -0800 (PST)
Message-ID: <61af7b99.1c69fb81.86917.9105@mx.google.com>
Date:   Tue, 07 Dec 2021 07:19:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-52-g43d995ef586d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 95 runs,
 1 regressions (v4.4.293-52-g43d995ef586d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 95 runs, 1 regressions (v4.4.293-52-g43d995ef=
586d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-52-g43d995ef586d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-52-g43d995ef586d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43d995ef586d135a2e76fd3eea2d19e87f8a692f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61af46107a13d6ff871a94a6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g43d995ef586d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-5=
2-g43d995ef586d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61af46107a13d6f=
f871a94a9
        new failure (last pass: v4.4.293-52-g4bb83d906425)
        2 lines

    2021-12-07T11:31:08.234887  [   19.141723] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-07T11:31:08.284554  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2021-12-07T11:31:08.293956  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-07T11:31:08.313851  [   19.221618] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
