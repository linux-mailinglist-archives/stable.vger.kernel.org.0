Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD9484292
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiADNfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiADNen (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:34:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAC6C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 05:34:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso3157056pjb.1
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 05:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lDnIKKqwMNs6b8E7+5D0+OHsVsw2VAivmBQVIyt5b64=;
        b=FajnU9XlgR/jklb2z6wnYK3RQQLGuFP6HKjQnXPC9ugvgJcNkq7iIVlJBwEu9zKzql
         0Jgg844WCiwjxn5eIXcGB57+Uu7z6UCVrqeAiE3JNAJzzNF3G6VSmOZTM73ZX2j49Vf0
         K6k345/QbtN5Gc6dVoUR+BmLGDi8zzoLv2+2fVeDjcTWb5oLddULXKEtvjb9q1rlnZCM
         e3teyY/NwOReyRikonwmM7B02tBGJTfrEi6RLLz0W65ONdIPlfp2AYV2SU682KxwILCn
         Hdg518l9VU5n2DqcAw1Vm3KkaT8S6iGpAx6RhTbyNdXu5wW6DwfmBpGExp3x8iXjkU8x
         FcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lDnIKKqwMNs6b8E7+5D0+OHsVsw2VAivmBQVIyt5b64=;
        b=5Hu6CEYkkXkcSjnqmXrbgxUX1tzgtnA/QExRDwTSN4D+nzF+dhrRMDVglZ6I8R8Fyr
         z3hKTdBg6Ghu5Y/2PdNsxMcKmKcu/UCpZt4B3dKJ/gU1cIcGQagigoMYFeOCYLS1nRe4
         kM0n0crHNQftu9HpbZwQui2aKVmpz671wE3bLP5s+DpoFl0v0euSP/BR5491rcjhAj9w
         qTfeDMJ2woxobDE48Zz/23aPxaba9uy0kRsP2vNbzmPabFDxV/L9tJjshHbboTkPRnnq
         GmHpRM4PfucLQtUreSA/Tb6xcsm3FHg0aEowTDKuEhmYUQ8rzBoLGEAwBmkq9U45v9Iz
         zMgA==
X-Gm-Message-State: AOAM531rsDncRbA5e2jHXuBkB65Jdd1h22Jpy7uY1U4wB5DIFadiGMu1
        KWuPu7BVcq4HGbbwl63sPq9di2866T8ZJp0t
X-Google-Smtp-Source: ABdhPJwDWgXFBxt2opPTsU0WiRKNmvTuwZ2bWz6x04WB58pKTUHd5Whb2MFROQSDDZFUqNVWKZB3ew==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr59655874pjb.31.1641303282032;
        Tue, 04 Jan 2022 05:34:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k70sm34615570pgd.19.2022.01.04.05.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:34:41 -0800 (PST)
Message-ID: <61d44cf1.1c69fb81.ee0e8.d6b8@mx.google.com>
Date:   Tue, 04 Jan 2022 05:34:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-11-gc6093d6e3839
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 1 regressions (v4.4.297-11-gc6093d6e3839)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 1 regressions (v4.4.297-11-gc6093d6e=
3839)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.297-11-gc6093d6e3839/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.297-11-gc6093d6e3839
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6093d6e3839dd3355319f0193d86df56db355ff =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d41bf66956b9502aef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc6093d6e3839/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc6093d6e3839/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d41bf66956b95=
02aef6740
        failing since 14 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-04T10:05:23.897934  [   19.303833] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-04T10:05:23.945144  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-04T10:05:23.954914  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
