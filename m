Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BF460EE9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 07:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhK2GuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 01:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243734AbhK2Gr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 01:47:27 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A4C061759
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:42:38 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g19so15809316pfb.8
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5npEDg5ATkBVCSFrABWqC6yBNqrvKXaPx10RPsvy5Ug=;
        b=sU7vpcmRzj6Jt+EGF59PVf2TgYyMPhA301C/oVAZ+M44zQ6DWxAMGl4bqkZN5D0HLD
         yoyeMv0LC+fpgg4bK8EnQDasExpsN3dH4v/NanxYxFRnCXjqU6GVzn5YBDDnVfPa2KsY
         sl2lbuE2/fqP0RfvmLR0J/1VxqoHWjxot5YqNsZJNZs1M4OghCg9FJO41YB4h0hgwtDb
         Voj0W3WjquG+viJeDRSBU+x6uoZI/RsNHyMFfkUU3pgjOO6S9SVVc/UUCpKl1m/TYNuJ
         AOqw+M9t3bmemcNJfiVmbCvJYQ/hxVbTuPH3+BwbgtGcBhThV8zffqu2GpXFO2qJJy/b
         4NzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5npEDg5ATkBVCSFrABWqC6yBNqrvKXaPx10RPsvy5Ug=;
        b=eD1h9F/ca/Nv/x440Et06QZxZ0vbRwxIO6cnB1t5Hs6JcAws/YF+vYiAsdCbuD3Xf0
         qvYtWClA1MxmvRtPK6R4cgvryfmP2rAfIb8/nG/MrwL0ko9TU0M/ozt+I20ulUQi+7DF
         AAmULhpbdLsvvDOMozLEkniW4RCAydH8ThDXOfP1U//NyCrV84GeOzCS8lfL04H6cOM5
         0WygeFAuBk/sM+weuvkqnh0pfcf1jCRuLao95b+xLefZ1Q/3Y9syNPrpOvLzuUlc9fcL
         AF+taVXlfS/N3hxhMtNtGA0xzE7DBJBZyGSF9WEokyF46zv+SkjTuYnNJSaEpUrYiIEE
         fAvg==
X-Gm-Message-State: AOAM5321u9koabZWkTGn7FWHRu243E0eWt0o/NUEIxOYPtVqc0S1C5eE
        FOrc1cpYr01ixOKNjX53y2QTBkv5zFCRgagG
X-Google-Smtp-Source: ABdhPJxRWajCFqbJVFg+BzphGMTVeL8SjMtC2ys9US3rez0VjNlru1pxrKmpBOrmIbsgsZas81bPqw==
X-Received: by 2002:a05:6a00:21c4:b0:4a7:ec46:34b7 with SMTP id t4-20020a056a0021c400b004a7ec4634b7mr29789975pfj.15.1638168157891;
        Sun, 28 Nov 2021 22:42:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm11113888pgk.74.2021.11.28.22.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 22:42:37 -0800 (PST)
Message-ID: <61a4765d.1c69fb81.6264b.e770@mx.google.com>
Date:   Sun, 28 Nov 2021 22:42:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-21-g2852f8cd20618
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 1 regressions (v4.9.291-21-g2852f8cd20618)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 1 regressions (v4.9.291-21-g2852f8c=
d20618)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-21-g2852f8cd20618/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-21-g2852f8cd20618
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2852f8cd206187f75c3ac5493004fae347203cea =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a43cdb7270b336e918f6f8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
1-g2852f8cd20618/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
1-g2852f8cd20618/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a43cdb7270b33=
6e918f6fe
        failing since 3 days (last pass: v4.9.290-204-g18a1d655aad4b, first=
 fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-29T02:37:04.786097  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-11-29T02:37:04.795174  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-29T02:37:04.811323  [   20.830230] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
