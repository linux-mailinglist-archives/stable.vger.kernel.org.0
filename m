Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E58490D26
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbiAQRBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241412AbiAQRA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:26 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B2C06175B
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:00:26 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id x83so11424461pgx.4
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PBcAfg8FxWBi3OkFAN51ts8yeLTbcNZ/HtupT1ip2HY=;
        b=soBf/di1KR+2tDe0BYzPKA07CKh5mTb7jYKb3F0GQZVvOTnMta00u2AC2osqfrBTvy
         pQk2WN7P+UgNggqunc26R36H7hhwXvM1WrfC4EZcOGEYUW26nkO8fg9Us4U1lLCPC0IZ
         flWDiLSQC4IPrAupIYbl9wtujdcs7yLkFMyF1V10va3g0iGWofXSevPCCFJmg/cP0ldo
         N4kKiCNybPZT3VttyyOrCxfa3Ew64RAth0C83BeSDk2fTQYf8fSfYaV3axB7f7bVYJA/
         SOmt8IeA2lUpxI2Ov0j9cfrpIfqXxLWN4tuwiFtuNRQb5jC/9r0OWYL0iBY53/S1lbyd
         VrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PBcAfg8FxWBi3OkFAN51ts8yeLTbcNZ/HtupT1ip2HY=;
        b=Qqhc5jxPQASg55UAfvWTbAgvAy9e858EWpAUD5HsmlBkLHc9rv/kluiEDTPVery4h6
         tb0IpsQ9fSdXm0L39T8TzRMOuuCeWEkv9j7h0pERZpG9HrBmZxDGcyVCVSWZSpH97VJ4
         it0yU3eaC3ubbhZZxr1UZ1tVePiNs17aEUnzKuDWt48Q3M2/uxwDOxUu2EqYnLkklmeM
         cfBCiSYE8N9Y/ohNA/2NrWfTVLMA6OnuKeFHcryLLPppd61WpymgLNm/k0ulKrkCsK/w
         /UDHC5MoMPtLwaUNWhBYMdcLoc0KkHZCeouJvdQr6tVsEKJ8YDqk//5SYVrtjNXEfFtj
         i+pA==
X-Gm-Message-State: AOAM53345fsjxby/12nDYCgmodrVj0VggbPRitlNePUzmU8+sQkTHf3z
        sZ9qwe1BUeXFf8Bu57B1DxED3jGCVxiW/J68
X-Google-Smtp-Source: ABdhPJwuS3ERQqm9hWQ/wtNJBLLx+y97fHgIirWJ9w5hnQ91SnoTZskRVo8md/krWrKGeH+ejsCzLg==
X-Received: by 2002:aa7:8a03:0:b0:4c1:3001:bc03 with SMTP id m3-20020aa78a03000000b004c13001bc03mr21711556pfa.14.1642438825944;
        Mon, 17 Jan 2022 09:00:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s24sm13878709pfm.100.2022.01.17.09.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:00:25 -0800 (PST)
Message-ID: <61e5a0a9.1c69fb81.41b3.5af7@mx.google.com>
Date:   Mon, 17 Jan 2022 09:00:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225-13-g4c4a0baf218b
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 167 runs,
 1 regressions (v4.19.225-13-g4c4a0baf218b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 167 runs, 1 regressions (v4.19.225-13-g4c4a0=
baf218b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-13-g4c4a0baf218b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-13-g4c4a0baf218b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c4a0baf218bcd87b69d5069ca5c3a92e136c5fb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e56e448d6c1b7edfef6747

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-g4c4a0baf218b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-13-g4c4a0baf218b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e56e458d6c1b7=
edfef674a
        failing since 4 days (last pass: v4.19.224-21-gaa8492ba4fad, first =
fail: v4.19.225)
        2 lines

    2022-01-17T13:25:07.797070  <8>[   21.194763] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-17T13:25:07.804794  <6>[   21.207092] [drm] Cannot find any crt=
c or sizes
    2022-01-17T13:25:07.848483  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-17T13:25:07.857893  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
