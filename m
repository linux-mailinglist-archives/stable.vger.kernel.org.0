Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD45FBB68
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJKTip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 15:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiJKTip (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 15:38:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5538168C
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 12:38:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l1so14152263pld.13
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 12:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oOWB58DNKN0+Jw64hozs7hKDWV56HD6D6Hq0JcipJ5A=;
        b=lHF3meDilxPqMNBFlBB+qS8G2v3rKeSUQBc3SiC9KyD7RDc/GuCB3x4YyGyPduvwiL
         PkZAzIXn+hSZqeB8u2pI0mQqgmCnoLgJdUBqFn7gMG0TtJXxmDcnK2Po00hj8Kf8iJVW
         O7quIN4aSY0786X86LKHB3d9GeBuOrboAdofFIroMARTHPLuRRkh9cIqq6FpOSj1DiNb
         JeQnsHYBRJpZ8FWqVCKD0ona40FQlx8m2Hl9+xq1XD4vvRfxayb6p3LFXSQBX75h/6tA
         3F5Ltpu5aOutD2t0Uba8DFas58T6ebhEEDULbs5niq16yB78Ir5LT6g85HZr7OExPMf5
         CLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oOWB58DNKN0+Jw64hozs7hKDWV56HD6D6Hq0JcipJ5A=;
        b=CsNplc3VwS6xRePl56U2LiQqqyEyMmeFZ3qpUoieryzCs7wYR5VsU37yuw+s1jsxZi
         J1PPXkkNFLDDcIYJtpZR2BqxxtV3bO/519ueKwf8u80iwaAcWc7ROnyQLSZlJdB8vATv
         wta3DjhgAtHcMFrO4yE9ebGouylyY9FPWRzdGIB/6VrY5HYik5W+4p4eHtk0vq9BCGLd
         Wc81OUl8UBlRns+vWQqKMFeVkFJFdiiRrE2z8weLP5aG4TRFN7bI/lR9nZFoJymRPQGm
         UK/2eIPMPe3P4cyBd5LjoXwda3iA0LRUpq84/En2l05Y68mJ78O8vtSoIlKxew6sTZLC
         q6Fw==
X-Gm-Message-State: ACrzQf0IcZ7JxV6Ar7ohLgkla28Gk0UnUBVSqnK1ZEFV/iBFJQwrDWPu
        E4FT+1odiAln6Co46FDms46yOq0+J4CBTmoc1S8=
X-Google-Smtp-Source: AMsMyM791cb4aPEXGwh2VzJMCqTsSsb5oioiS0PlHsBOkNf4HPEsDKh7IhKBVlVojsSexv5YUsLKqA==
X-Received: by 2002:a17:902:6b81:b0:182:df88:e6ce with SMTP id p1-20020a1709026b8100b00182df88e6cemr9645009plk.173.1665517122428;
        Tue, 11 Oct 2022 12:38:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b0018099c9618esm7384117plb.231.2022.10.11.12.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:38:42 -0700 (PDT)
Message-ID: <6345c642.170a0220.7f355.c952@mx.google.com>
Date:   Tue, 11 Oct 2022 12:38:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.295-36-g4f2582cd013d9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 104 runs,
 1 regressions (v4.14.295-36-g4f2582cd013d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 104 runs, 1 regressions (v4.14.295-36-g4f258=
2cd013d9)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.295-36-g4f2582cd013d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.295-36-g4f2582cd013d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f2582cd013d90e97937be69a10ce7c7df1fb9ad =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6343f015faee501561cab63b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-36-g4f2582cd013d9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-36-g4f2582cd013d9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343f015faee501561cab=
63c
        failing since 239 days (last pass: v4.14.266-18-g18b83990eba9, firs=
t fail: v4.14.266-28-g7d44cfe0255d) =

 =20
