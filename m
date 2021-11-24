Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49F545CDB5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 21:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhKXUQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 15:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244707AbhKXUQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 15:16:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F64C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:12:56 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 8so3721193pfo.4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tw6028fmY5X7UUr088wPlwO8ubAcKDGWtWwraA1NGYc=;
        b=54/L1VCIxwBNjVm6YakMQJAq8OSwEozeCqVpnwaNE9djhHzqSksPp6rihgm2yJn9wO
         ZtQWqV/FLFdYr7OqPpRoH+1OOFMPNPVwAplJ2uyW78XEIAcZp5hkFmz5wxQR25TAiBML
         ylZDTOeJ3FKx70+ZtvWAVU1rcKS8QQExizIG1f6BoRawBBKByK5LD2/9BIox3VBBSFc4
         4huyXp692DDbQOpwVj0vcu8NdrQsSiimVfA7DDQKWjRvm6zvGn6hM0kHs+0jIDl3VDSQ
         vR2NPnxPVOvIUXo5cMGXJvepFgERp6Em3S9EBqVp15Uhwbfwqg+M1VN3beSvEpaSlojI
         w6iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tw6028fmY5X7UUr088wPlwO8ubAcKDGWtWwraA1NGYc=;
        b=BjDBxp9F1QUJ5Y6XSlfdUFiRvbLLEyM/lqPDIhRLz4z9T1xT1IZAL7hG9kA5un3iNQ
         nZ6asOH+PV1cea0ZJgIhcux0IeF7INmrRPI1olNWFO3bfCwm8FbZ0PBE92PaPaSH4RP3
         wrXYFgeNTSiDLCqPwp7ucGrtWpQnbVa4a1hmSWwWBr0YwYYId2If4mZN0ZoaEzJDak4T
         HM0fRjk2oI9f+kJpmB6M3U0Or0lqNPRD/h3rwfy2+odd4lKoUgUL9deuH/vx489bpzbf
         PWL3I7nxuQOrfwE6jmNtYt4G1H4xikg366Mmk0Qh1oQt4Xfbjg+2oNtWVypxVIbGkUOD
         hj6Q==
X-Gm-Message-State: AOAM531ezqG2lyXSePTGmKWlVvBUHdpMyrv43ua2Mv3cbjpcW/SFPuG/
        7YWPHoNOTQFv4dmeqg0Tfv1E4YmcelwJp6hmaWw=
X-Google-Smtp-Source: ABdhPJyw5hHYMblO/t0IY4HIsGgKvXsgHBDJc81dKCz+gYvzH+RM6yGDWbupu08SBtA3N638lSyQzA==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr12275752pgj.272.1637784775674;
        Wed, 24 Nov 2021 12:12:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm405827pgc.33.2021.11.24.12.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:12:55 -0800 (PST)
Message-ID: <619e9cc7.1c69fb81.dc21.18d9@mx.google.com>
Date:   Wed, 24 Nov 2021 12:12:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-324-g451ddd7eb93b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 107 runs,
 1 regressions (v4.19.217-324-g451ddd7eb93b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 107 runs, 1 regressions (v4.19.217-324-g45=
1ddd7eb93b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-324-g451ddd7eb93b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-324-g451ddd7eb93b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      451ddd7eb93b3648ea9e23132bd24faedb11279b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e63538fcd6644b0f2efc3

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-324-g451ddd7eb93b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-324-g451ddd7eb93b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e63538fcd664=
4b0f2efc6
        failing since 11 days (last pass: v4.19.216-17-gf1ca790424bd, first=
 fail: v4.19.217)
        2 lines

    2021-11-24T16:07:34.219719  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-24T16:07:34.228651  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-24T16:07:34.242849  <8>[   21.292999] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
