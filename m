Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD64767E4
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 03:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhLPCXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 21:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhLPCXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 21:23:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9388CC061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:23:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so1007153pjc.1
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/g2BsuEQMAXUaMKjGAJOhlfS8qXIPw95X8eBSd1tgB0=;
        b=XCgWhUV+iycDkqP9DQd64U8Wq8ggG9jNjzqoaURNPW3Ozmq2rAYTzBlGOYTdXWHFJJ
         rIzfP4S0LVRVHkaeZ9p/Qi22mSgtoRj/ZO7JMleOJjkaR9wMgJJXWR8inFowLSXVpIkP
         nCIkM6K+8NJuhHPWUAC3fMHHL6hF+uilWvM1P1jlMRFG46laS0G5kxuHmFyN82A6rvUv
         3H/O+1BLrb+99aPO1as4CSzJtuihPq7LKnu5PaIXRRHniZYKEkB2G8+6dP3j/zC9NrSa
         xyM6dFk44bRSkIza48mLaFMrVlVwYyywqoYtFazhciB9OTql9nKq2a4UV6PLeqGz62Wh
         WEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/g2BsuEQMAXUaMKjGAJOhlfS8qXIPw95X8eBSd1tgB0=;
        b=w4aPFWgP7vGx1l4gLgAt2tfmUYUrrkT0absKEcMpkdxW5VOWCc43Qh3zY2yPCURnH8
         Jdubws4AF3Jehuy5REHTugYe17E79S4rxZyoRcFa9TavomOPKH0j7DV0YvRHcvOxc+F3
         PSsyKYMk6KxrO7dnS6m+H7xFu2aSc6sNor/CKSoss/GgB10ioX72blhS+s9TWTgT4VRL
         x99GfHrwpv0EDOaHwUDW8L/PBYAUIDkg9YfkrvsMhrRVadMI0YRbOhw4L562vrphqUvy
         yruPmqRVM9Y3hP4rrOhdKqFGXCXGkLE04BFOMghNDO4iJGrANhH1LRZENcm0MKLcNW4v
         XiVw==
X-Gm-Message-State: AOAM5307izNrrf85Qnb366Gy7Ylf+mdZnmSWykZ6uI7VCt02MrZ3VG83
        hbMMVPTdcHRSjQdK+2n5MOcW1yvQUGVf2Jt/
X-Google-Smtp-Source: ABdhPJxKO//IPXrnZ6ESUMzh+P6Z0JlLahqXXCbtp4vUXezX2cMFGwDBZKS2KBntcuPUnGWxQj3vzQ==
X-Received: by 2002:a17:902:e548:b0:141:f4ae:d2bd with SMTP id n8-20020a170902e54800b00141f4aed2bdmr13782058plf.41.1639621421969;
        Wed, 15 Dec 2021 18:23:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe2sm3438818pjb.42.2021.12.15.18.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 18:23:41 -0800 (PST)
Message-ID: <61baa32d.1c69fb81.3311d.a1ef@mx.google.com>
Date:   Wed, 15 Dec 2021 18:23:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-9-g4265725c985e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 139 runs,
 1 regressions (v4.14.258-9-g4265725c985e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 139 runs, 1 regressions (v4.14.258-9-g426572=
5c985e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-9-g4265725c985e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-9-g4265725c985e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4265725c985e5ec1fbf57b650e2a1bb464b37d67 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ba6db7edcf0f4724397142

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g4265725c985e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g4265725c985e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ba6db7edcf0f4=
724397145
        failing since 2 days (last pass: v4.14.257-33-gcf9830f3ce18, first =
fail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-15T22:35:18.661227  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-12-15T22:35:18.669371  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-15T22:35:18.684412  [   20.114105] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
