Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807D349AC3E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244276AbiAYGSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbiAYGIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 01:08:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EDCC0424E5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 20:27:00 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so990104pjt.5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 20:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xe3LRACBXR7aYwQU7Toi+R6xz+1zfPMtyDDslKEgPDY=;
        b=IttA2ts5ltp5obeAHEaggqLPleZaQ6i2doT+ftX+kW9/BgtadIDk2JyO+zOadiTkWh
         BPYv3bjWFCaKvg6Hz+g7o5lmd8t7kktql8yUjXdK9FwBiT+ZoEPwGtD9dRjJNRlDZbe9
         hvNATlxzUGNpDOEB7rT8uORZEtiK8ChN/ug+OvjG5fP9PeuyvP57F1MqaYKYxR+R7Nvj
         gHZ7oGsp2FoYrTwmilpFoPswIRb7Q+tOIlO5Ikp1gJJvhU+KCry2V7z7cIlhI8VRLOkX
         0tQzFX0Rc6fojIwyZ7uYbK14gc3m2RYR90UQYYHXah8oFoxZru1bZmS+1E7C/d+FiqoT
         SVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xe3LRACBXR7aYwQU7Toi+R6xz+1zfPMtyDDslKEgPDY=;
        b=4CHfnXxF8oKdMO+t4OdneNo9hr6z9OlSTblkU1fyipjwZTeXpgDMq1VI24DiJYs4R/
         JXwjmQlPV0ahrpBPEDXgjCQLluoYjKxItfGSjidzDxi0GQPhAJco8kf7G7ltX1aaxT2e
         mJJ1KtMUJBfpoNeiiLQFG6hsKTphNFANzH57e9OEiGR16vrx9zMjd3JhA2NiyQFLy+C5
         foLT9deaS3iLtNVg7BbuktFu4jT5LoQUg2GNe9jg7Shi74yNnc70YM/Tpwn99wS68MRi
         ym7MJjUZ/+MDymKv18esbH1ivd8FX47UjrVVlZGDKLvUooSVhErbXjqY94Sr2UBX8Lvb
         Th7g==
X-Gm-Message-State: AOAM531L7zXGWINVJtFywc+zb6rRpgGmKwJJGdOr24HhnGrZ9aZOtFNp
        UE3fe5Dd0SH/zaSf+HXndnlDwvYXh2pknKsH
X-Google-Smtp-Source: ABdhPJzC03QjYJ/WDg8n+UxsjdnUfZl6rZOK989YiJn2xbVkRdEdDLNn5iCMkMRZNFsK7YyQcvs8tw==
X-Received: by 2002:a17:903:41cf:b0:14a:f1af:15cc with SMTP id u15-20020a17090341cf00b0014af1af15ccmr17160124ple.122.1643084819867;
        Mon, 24 Jan 2022 20:26:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe12sm865332pjb.14.2022.01.24.20.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 20:26:59 -0800 (PST)
Message-ID: <61ef7c13.1c69fb81.c6cfa.3b6e@mx.google.com>
Date:   Mon, 24 Jan 2022 20:26:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-240-gebabcfeda281
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 166 runs,
 1 regressions (v4.19.225-240-gebabcfeda281)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 166 runs, 1 regressions (v4.19.225-240-geb=
abcfeda281)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.225-240-gebabcfeda281/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.225-240-gebabcfeda281
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ebabcfeda281e1c6226b219845d71930c729dae0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef43d74373dc0c25abbd32

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-240-gebabcfeda281/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
25-240-gebabcfeda281/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef43d74373dc0=
c25abbd38
        failing since 21 days (last pass: v4.19.223, first fail: v4.19.223-=
28-g8a19682a2687)
        2 lines

    2022-01-25T00:26:47.830107  <8>[   21.556610] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-25T00:26:47.878621  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-25T00:26:47.888309  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
