Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFAF481DFA
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 17:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbhL3QK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 11:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbhL3QK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 11:10:58 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F58DC061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 08:10:58 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso15206630pje.0
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 08:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CUSl2/dmzDcZB4a8pOeo+MOnUyhekRpk1eVhOVf0PXM=;
        b=ZyVpl64miuuAJbMPFVHEcR74uzjuWaJpU3ZayeRYqKm+8YAInC3agKP+fgRAdrSxNG
         12MYN2FI9+6ucukisie6qD2miYZNu9eGW/b8b/mvJufYeee5Qi1IJpgO5GqrLfteAlQN
         vUC6tzcmp4Hpt3BvjpaXD/FScYdepC4iSNL/2tnB2XIean+1pyjeQMfH63ohwg9rfedS
         Lp0EsweL1MJJy17gjVPasp2wyuRuRA5vAXXAwJE839ugAqkpyQrmcNFuMg35xZttcavn
         y6OfEwIQqAycsT09proC0Eg50jjp8ThLVf1FCuoWyvWkiKyJA0h+dL0wKX+psHw7dZx3
         5Spw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CUSl2/dmzDcZB4a8pOeo+MOnUyhekRpk1eVhOVf0PXM=;
        b=zQg3ANkLeE9zqCcT7byd0YjjOMA3Uysb/wXjCIw9fIOx1tJ6vYpRBMsvDp4DGCn20n
         +8i6j7jn5+OgippRvmToZBSxeCdwOdXVwai6kqTs0xkJouJG7QZ5hM/pRDIe2WNndmOd
         WrGJCXeBPOS90E2/jU/tRMt/W38rfQ2V+xucSIG6JKH70rDkl3OXOh8BTicXOG/Gwo6W
         Zrq9ol8DEvNDkCLNADlD8g6XsJUsmTJ+onwLWSYmQf8cI5hlabum/OtPKuU0BirsThkg
         dc6dSjL1+ml5ujy22vmj9jmi3KqFfKmphTyWKy2tCANBvldQ+mJzCB1WqMqpcTDkuz48
         jRaQ==
X-Gm-Message-State: AOAM533Adif0eOgeWuBLcS/eVWp3CZVKL9GfNeZdU/DcqjhrkXbtayGh
        gYfImMYlvHMdmVhNOk4WhH3RK3e9DIYHj6m+
X-Google-Smtp-Source: ABdhPJxfu3mMDYLdj4JTuZ4qqo5yb6JejEOGfCnuov+P00/RBHZvxlrqKQdyOJ38orGjJHwlpSknjQ==
X-Received: by 2002:a17:902:b218:b0:149:936b:8306 with SMTP id t24-20020a170902b21800b00149936b8306mr12455175plr.134.1640880657880;
        Thu, 30 Dec 2021 08:10:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng7sm27896509pjb.41.2021.12.30.08.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:10:57 -0800 (PST)
Message-ID: <61cdda11.1c69fb81.88515.b402@mx.google.com>
Date:   Thu, 30 Dec 2021 08:10:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-7-g7fe81a023a89
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 125 runs,
 1 regressions (v4.19.223-7-g7fe81a023a89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 125 runs, 1 regressions (v4.19.223-7-g7fe81a=
023a89)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.223-7-g7fe81a023a89/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.223-7-g7fe81a023a89
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fe81a023a894abf63adfa72cca697636f9a297c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd9fed98c473120def673d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-7-g7fe81a023a89/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.223=
-7-g7fe81a023a89/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd9fee98c4731=
20def6740
        failing since 13 days (last pass: v4.19.221-9-ge98226372348, first =
fail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-30T12:02:40.977505  <8>[   21.368865] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T12:02:41.024603  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-30T12:02:41.034381  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
