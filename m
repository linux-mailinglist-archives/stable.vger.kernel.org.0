Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA0651A06
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 05:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLTEmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 23:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTEmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 23:42:15 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A7D1261F
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:42:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so10950319pjm.2
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=W5wzOxWlcdy267qLhyqnMNOjKYMKlgy19rBLqOStBjc=;
        b=Sk8VFOqacjLoBcWZdY42Zv72pIe7CgCWQ9du600wAM9Cfl4x0a0kJY+coL660xdrao
         aj4mJ6+75LH1rPrHZig3cd76VRSPrZd2QKpgtA+EUF/aFlrxuy0y03eAo59PREKBPvIc
         jTefCs7VtIPtbVZk+VjADjN13ew+ssSJwnvhWbtrZGvAAJTMaLn6ob5ZxxaTMZplINNK
         0klakjtiDAYx5ibiPVsk7WdJuh0MPJbGNPv1SWGj0sSbZfyVsT1GrLc/YVzKguob/4TQ
         WSZEw47wfhcOeFDwvMIETaGdwWx4LHmyz0+q6gco0QNiy/Qnm6JTYn5WyTZVYPKmrmNa
         LUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W5wzOxWlcdy267qLhyqnMNOjKYMKlgy19rBLqOStBjc=;
        b=mKahVA+4FdKa5B9Lhv4ofhtSrjssVuYIISLEOQnLz9eESJ4GUTJTFAYB0Cl1qRUxzP
         zawG0QauY/bfZcVqES3IEUkutpQF1BU7bnXOE1mS6vFKg68KVfyeoJorFJywlQ9PMrgd
         jIvZxfoBpEkTM48r9TGpdlhK1Vbo2m1A7UEv22JrA2o8Ncv3vd1pCG0+VofgZ3u5/Y/v
         4FZAeTD3Hqw6m3VQPckCEDZJCNioaLTTiIDWRiNyFo+3RkdO1pX0t6RoFGTlq75dsXRA
         64qcQEh2cIPlVzJJviMAk8Cei6MPKeTW5v3CdV2fr4AM/+FODn78qGUAYnbYdzblT9Jw
         MfGA==
X-Gm-Message-State: ANoB5pmjyfmoXheGCPjuMrvKI6cszc5/E3Sc+DfB4nP+HoEi6wcEPU/v
        tXuGyC6IQG0Xx5lrkn5Xe8DMw3nSuJjSQaBfbO8=
X-Google-Smtp-Source: AA0mqf4Em8dH5pIeD/P5Y0kOtH0pBNkJMFssoM3/KKx5sosIzELd8pCNFbLeckUVsdpRfdmajNamCg==
X-Received: by 2002:a17:903:138a:b0:189:5f5c:da1f with SMTP id jx10-20020a170903138a00b001895f5cda1fmr47525522plb.5.1671511331479;
        Mon, 19 Dec 2022 20:42:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903120500b00186da904da0sm8061314plh.154.2022.12.19.20.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:42:11 -0800 (PST)
Message-ID: <63a13d23.170a0220.3e837.dd11@mx.google.com>
Date:   Mon, 19 Dec 2022 20:42:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.84-18-gbef75c6188c7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 151 runs,
 1 regressions (v5.15.84-18-gbef75c6188c7)
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

stable-rc/linux-5.15.y baseline: 151 runs, 1 regressions (v5.15.84-18-gbef7=
5c6188c7)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.84-18-gbef75c6188c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.84-18-gbef75c6188c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bef75c6188c78b9ddf305681393ec04bd7d2ad30 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63a10c9410c06250ba4eee44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
4-18-gbef75c6188c7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
4-18-gbef75c6188c7/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a10c9410c06250ba4ee=
e45
        failing since 221 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =20
