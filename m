Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA149E64C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbiA0PkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiA0PkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:40:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DDEC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:40:02 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so7898985pju.2
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T5fl3DIZysKGwdGdi5SUy8+PhFEw22AXKIpWNdh7IQo=;
        b=GrJ1ebdU3/VeRJpGAvxqpOFPgThYVANhqv8CGalNTkjCact4vsVBbWWVDk8fX9G9Cs
         cu2D50lFmFxYNuUxUw+O1qwar45SdQQV0IWgvq7hEELNgDuYl+sHSKRq4f4wrqur4XBg
         9SnKMkb9sfSkeCqI8UeXDWvh+1+JS4829JF4s+kKB0s+VtcNdf8zby0eppke82er/n2q
         W5gL2TtrKTxvYQXlVAj+E9Hok11K/B9qY/1u1uiBWz7pbvrlzkpletJXLy4odYBJoFDa
         WmyMeCM30ROesW8QTowXYWrCAgslfCYtGLbbmntIIHuN8lJ8CEZJNV1wuWWx6EdDiu75
         hVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T5fl3DIZysKGwdGdi5SUy8+PhFEw22AXKIpWNdh7IQo=;
        b=dckv9vIpcBb/Py/JLwL89rdVlaI7dkUc9+w6VkqRWwvzgIDHZjM4as5OvEllEvXeUc
         5cwpICZ4TcirWc2ArPR3L0sXniVi91SEWxsgBvIDp+GDxeCGkQ0kkyPxjPPzKDT25nmb
         eRR2R3n0iqgbmkvXaGBtcIOCyItAIQ//ohdJ9cEL1eBVRwHjMhkkyXMo9J1AQsozro5a
         zfIG2uXY3E2ylPRxPq3igP6aynl0Iqet9XUxlK/42SkfNgE5GBLfkHz3pcUiodlkWb1T
         F6mpVDQhpMyyellhsjprYV0DSGvW6qYsLbb//DydlKc32NsCnLSwQS/gibLgIgufRN3u
         Fwqg==
X-Gm-Message-State: AOAM5309fTinp441slrbyT2lUXputu7K1WEJdgNiZEduZIkAkK4n1Q3T
        T5CecA1dwjdNne03disj8Ptn2GYxWhzeb7TxWNg=
X-Google-Smtp-Source: ABdhPJwgAvcqqDqrl/IGb843ywxmOY1lrVW/UxeUQZf5xmGnZ9jVR2fezeoxan333Fw9LZXGb5MgOQ==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr4154441plr.93.1643298002059;
        Thu, 27 Jan 2022 07:40:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm4000540pfu.127.2022.01.27.07.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:40:01 -0800 (PST)
Message-ID: <61f2bcd1.1c69fb81.cf151.aaad@mx.google.com>
Date:   Thu, 27 Jan 2022 07:40:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-154-ga1ec7e699381
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 1 regressions (v4.9.297-154-ga1ec7e699381)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 1 regressions (v4.9.297-154-ga1ec7e=
699381)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-154-ga1ec7e699381/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-154-ga1ec7e699381
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1ec7e699381ad0c9a81a8bcb926eb3a780a2abe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f2846a3df10dd3a5abbd12

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
54-ga1ec7e699381/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
54-ga1ec7e699381/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f2846a3df10dd=
3a5abbd18
        failing since 2 days (last pass: v4.9.297-124-g1de5c6722df5, first =
fail: v4.9.297-150-g86d4516a7d68)
        2 lines

    2022-01-27T11:39:16.567279  [   20.079559] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T11:39:16.610247  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-27T11:39:16.619242  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
