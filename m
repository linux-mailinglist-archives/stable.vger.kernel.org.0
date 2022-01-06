Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5474860B5
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 07:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiAFGr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 01:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiAFGr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 01:47:56 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0474C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 22:47:56 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so1845233plg.12
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 22:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6j+OTNWUoA7um21W1ns7NMkiXi5jBkys6NsZuaFgqic=;
        b=HCEqKubALeM2JyBaqWW6VDFdvbQjkPk0VRitlmhJAEWrm3HBGFY00yWP7UTZNZ25BC
         tX9YUWFagUsB7tstirVlFeUBdjrGHGUTTwrVhNnvZv6eAHZ04apXvh/yqypbWf6IVjw8
         hY2mpbv2lVGoVtF4fB57F6rHJu94EFsKJ8ry5BY8b8o7lqT5EKwGamRLBnXXAl8uhMar
         i+2isiKPJ/+HhJECExRHeEz1x/7GEqngUvkWwFvpj6dNyQma+uWV5Mqizt/oZNS/WdQr
         FWROcXlMpogU/19bTz+PuDTuzBWeDKB8NQIkuatj58aVEKAOM1yqDkNmeBNm/qzXEAyy
         fGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6j+OTNWUoA7um21W1ns7NMkiXi5jBkys6NsZuaFgqic=;
        b=Psoz0pUUaAeXlhNJVueokfiL4YFRzrkpWNYvL/Rv+aDfI3JsjNWLAKL9ezvHCiSOnz
         Iujb3RycnMoTAtZPdB1hgcX/ww3i++30a41SgFQsWnvz46S2IgnxTZwkyb64cmij0vFT
         40Diwe+3/Jrc6tu4pLNyiF/Ih6nYZMfCahHF6ZIAe72N4dlaRlA89Y9cTE9KkIz8dN/i
         CsQyovrAl7kWYVDEW5/eq2hP8e9mHpLAcARiiUDUvB0AV6cRCtgMfPX1PdIBvlVd1+Bz
         xGD6S732JyrtwR++ZchdgnmsHJ2GNOuNv94mQNLtr9fo9z76yb/gMaa03HP5ubrZ80SQ
         sKWA==
X-Gm-Message-State: AOAM532MWKfMGSkv2tgUQTDWSgy5iKWNYPJuGuv4zB78vdSOU0OxCWjd
        4GJXqrIZMRLMFZmBZZ1O/vs97Z8KYq7g1OUA
X-Google-Smtp-Source: ABdhPJzTE7b6Y/aQoNPTNiUNyvIqWw+eXA28B6jM5kuUDWO4p1QrO0N0jipZxszbNqdke5iEBsj5Mg==
X-Received: by 2002:a17:90a:680a:: with SMTP id p10mr8363559pjj.144.1641451675978;
        Wed, 05 Jan 2022 22:47:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9sm929964pgc.20.2022.01.05.22.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 22:47:55 -0800 (PST)
Message-ID: <61d6909b.1c69fb81.d1cd8.2e45@mx.google.com>
Date:   Wed, 05 Jan 2022 22:47:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 141 runs, 1 regressions (v4.4.298)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 141 runs, 1 regressions (v4.4.298)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.298/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.298
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0dc4b955f01eae10c6923c86234ef9768137797f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d65f3634d09f4cf1ef675c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.298=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d65f3634d09f4=
cf1ef675f
        failing since 6 days (last pass: v4.4.296-18-gea28db322a98, first f=
ail: v4.4.297)
        2 lines

    2022-01-06T03:16:42.411148  [   19.610443] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-06T03:16:42.456839  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2022-01-06T03:16:42.466192  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
