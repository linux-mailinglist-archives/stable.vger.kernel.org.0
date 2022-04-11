Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB14FC774
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 00:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbiDKWSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 18:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350362AbiDKWR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 18:17:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0448A2654A
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:15:39 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s10so7543891plg.9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z0uW8VvoUnoGgs4+hZ5gIGUJEXJGE6vcrDG12/itu6w=;
        b=ZCR0dRfkjSxVyMhLA3Qn5t2VDpVkG7SPsmlFUFhjTtXYGqDfcrCebyeHkdGBaZ46jl
         N5aXu1kR+MD+ZcysPvf60/5+WQ8nEfvTca9sfTBJL0QvZOX7go+o+cArXW1agbm46mpj
         eFSA3in65uLY4gDLVJ5HCIkVFXJFMGPJE7vlUYbrQCAMKwq4qI4sbe8lLDOk1ITQoLQ/
         DAcX0VGSjhToBLa4Gr7aIQoWNxaoHPCBxNFX0tKJ5kNU0qIz0s5AexQ3Kk2mOoKaZzee
         OEQVVxh5DKHh7T86j5gzHCzTVn7OuaoK6xUFAxhgv+vYWLnlDKOqdHx7tJzCVo4mehLH
         XPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z0uW8VvoUnoGgs4+hZ5gIGUJEXJGE6vcrDG12/itu6w=;
        b=MpmRrKNE7rrnHGEeaaNH4aMFfySBarJ3BWB53YR3SB5HpzqpddvOEdqSAyocuQcpEI
         dHgePOvWYiu3IWhwI9zM+2Wa63pHl42f8McdIaeG3eJokP8wsQZRWgRZZ43hNcWRIN3s
         9TynbpLEObm23IdLveWDpLq2gyv3b/68ibEcCSnuLaG+05I/qUGMtGAtwh3McVr9oHyr
         7me1mJCzOcauGUdt1AH8nmIJ6Fl7UDmT/6kaQh9/Mt938ojwchdG9FZispOInZVsEHYk
         clbKu1IsQYxFzDrXV5o2lUjUzO1dPstNaYvPtr416rkclZUsc2LfoGdQAZ5zujd7GNfm
         rfnQ==
X-Gm-Message-State: AOAM530u4aOI4pyUodzo65qEH8OLuM4ATGJlQU54kOA/lQ3DRh0T7bzT
        GDt8S9t8riN4glDKOB4MwVxSlDahNUeCpPGI
X-Google-Smtp-Source: ABdhPJzfc8OIu/Y2jwQbKk8pEsemKEOtBfxmfsGGWr5znOf2ywJXiFvCGDhLI0dbC0akfOhpAZryzw==
X-Received: by 2002:a17:90a:c302:b0:1bd:14ff:15 with SMTP id g2-20020a17090ac30200b001bd14ff0015mr1449071pjt.19.1649715338834;
        Mon, 11 Apr 2022 15:15:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23-20020a17090a091700b001cb57fd5abdsm454934pjn.40.2022.04.11.15.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:15:38 -0700 (PDT)
Message-ID: <6254a88a.1c69fb81.aeeb5.1ded@mx.google.com>
Date:   Mon, 11 Apr 2022 15:15:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.19-285-gf7a13b187d03
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 139 runs,
 1 regressions (v5.16.19-285-gf7a13b187d03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 139 runs, 1 regressions (v5.16.19-285-gf7a13=
b187d03)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.19-285-gf7a13b187d03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.19-285-gf7a13b187d03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7a13b187d039d94a8344a20b79c1622db1b907b =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/625476c5efdf49d98dae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.19-=
285-gf7a13b187d03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57x=
x-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.19-=
285-gf7a13b187d03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57x=
x-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625476c5efdf49d98dae0=
67d
        new failure (last pass: v5.16.15-27-g644f2bed149d) =

 =20
