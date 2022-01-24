Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A5249A3B7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368754AbiAXX77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846504AbiAXXQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:09 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F896C0617AE
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:25:09 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 187so16328740pga.10
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g+ZnSlq2ev2PX8swPL0Ya9Ji7MTUOVd1lIGk4NIeklw=;
        b=cXD8rk/Jm/fcxxKNavBxxlSv7WYRXOVDEWnslHhGgZUji07jYzeY5OXom7uKR7KiKj
         hUn3vH4789fxR4o0/UGiT9uvJbM3WwVW4GcQjC67vcxVdlCIw9LvTJEoh/0TH6WeHscs
         2guOUp/MkVOEdZ5FSMOMr/JaUNtakGC/VDi3Sbnd07M29lgJ7ewENv4cc2rG3B22Y9+i
         Bm4749RG4o204EtTRFt43qFlmDuDDQVGVVADtP+aUEqJevt9uy+D8w3YdKVOUt5q+Niw
         iAWLvFJhDmT5KEgxdgmDCBmH8B0HODguxI53ZNbXY2jNixIxqL/4i0hABRvcPh334yJc
         vCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g+ZnSlq2ev2PX8swPL0Ya9Ji7MTUOVd1lIGk4NIeklw=;
        b=l0gmCihAZRa6i3GPySz6NTsRIKJW40y0Zs4wAhUCBSZppA+52kaIdS4sd+WmNpADXQ
         2rHdGxlJS4lc24JmKIuAWTH/GGdgtSznJAVskwvaNPMtRQu17gwdcQo4Jwr+O8uBu3gp
         oxEITPH0KuNTnVPgS0Z2w0uNxrQNxtjKdaCnvADOdTBaaK7ZZZWR1Z90Be+L40geGW2y
         cPEszVRm6eU34b35grOCObxtrR8CBzw3EmENUulwZHsS6X058FNrybey63h7VeBTM3Y+
         YkwFgD4HjFqJNpRzBLRoaIilEeWCG9/0uXBbGl/obfL4SPYbbFugobf5d/klZButCf6H
         U2Kg==
X-Gm-Message-State: AOAM5300Zpzf2EWqal58SVTKjIgN/pAFpF2GTZBHG9BMZhjX2fMiA+yw
        LGJjJgnETZu8E3s09MpgywG1HK45yu1O2qpW
X-Google-Smtp-Source: ABdhPJyTQu/1FCob3mS5hgnda/0ikm2dgLHX/DOvJ61m9gq2RbATTg1XXCh2IKthKqQ8CIOlp9J/AQ==
X-Received: by 2002:a05:6a00:8cc:b0:4a8:262:49e1 with SMTP id s12-20020a056a0008cc00b004a8026249e1mr15303995pfu.28.1643059508250;
        Mon, 24 Jan 2022 13:25:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a62sm17040451pfb.197.2022.01.24.13.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 13:25:07 -0800 (PST)
Message-ID: <61ef1933.1c69fb81.95cbb.e390@mx.google.com>
Date:   Mon, 24 Jan 2022 13:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16-848-g7d6af35208d3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 109 runs,
 1 regressions (v5.15.16-848-g7d6af35208d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 109 runs, 1 regressions (v5.15.16-848-g7d6=
af35208d3)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.16-848-g7d6af35208d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.16-848-g7d6af35208d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d6af35208d3bdd9d33f4f1d1987d82710418746 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eee83af08b79607fabbd40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-848-g7d6af35208d3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-848-g7d6af35208d3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eee83af08b79607fabb=
d41
        failing since 4 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first f=
ail: v5.15.16) =

 =20
