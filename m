Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DCE526E64
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiENC7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 22:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiENC7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 22:59:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920372D9B7A
        for <stable@vger.kernel.org>; Fri, 13 May 2022 18:37:00 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i17so9489767pla.10
        for <stable@vger.kernel.org>; Fri, 13 May 2022 18:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P3qdO3hUdichlFO4KKoHz6pDo3nLo1b51ie4Tjc9u8o=;
        b=bG8ws8u3ZeaVJ538tkFRiR5ygUWEJ0jB8v0043rGbFrRbMAfzDupnUnmeP3BjLuBfZ
         vEpMEvHrY8F18DUlQKH6SmH2mziXil27ydqwtKK/NrbbwJlD6wAwzszoHkjnBdXYVAGr
         OtqTPJ8G35FoYP6mD8pwyhEtflOp7H26aTBmlcdQTHccLktRmVPdvOLvrfofhA8Wnjqi
         sK8XeUNJuUJ0SM3SNKpNgr1tocz45eUeh8SnntQPC1P8ENrWvY3+YKyawNPgdrsdOk4P
         Q4gqg7dDbau6r5GKBJf81TMbv3ziCbqDEZbt6uHgDuc/xWA8UT/8My0p0rQ5r0dSQLOl
         L1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P3qdO3hUdichlFO4KKoHz6pDo3nLo1b51ie4Tjc9u8o=;
        b=KsuNumYC48ngKgoz4f4Sjgd/CCgDSejnXlZifSTSQQ3TxgG/4xpaU2p6ae8QLC7R62
         OfNZ0/39xd8tbCeFqh4oqT/ceEdDHhAThF+A6Z+NqKy493XMN8KqkzUW7k/KHMsjFWsd
         23BmNxlxGGG72dsQy00zlgQ6dl6rFS2TEffLscQxA85d+nG/h1txAKCKU4rQL4zH03WN
         2zEDLBY5TG4qHDjAnJJoiRQcHxtPW7huq3tXVXGI62dkKnbUWqSuNA/x5GGWSGVnQw8l
         2l54DwImAwK07A5kO5Y4eYoJeBfDI5Eta+wcjzOwma/FzSVrmh2X3b9Ij4U94Plmlp8f
         5leA==
X-Gm-Message-State: AOAM532K3qczk7/A0YgvHq+qgeiwmDxFsAdSpgPw1HtT+whwGQsN/L4q
        CkisWJwAFnk1r90M9Y1gpsyM14pDLXxsC8Rpjr4=
X-Google-Smtp-Source: ABdhPJwcwey1PI8nieuaEjPKgFDagu+7pZTtq5TyPOfZemlpjM9juzoBhqQTBCzsE9jSdGK3UOMV+A==
X-Received: by 2002:a17:902:d716:b0:15f:179c:9817 with SMTP id w22-20020a170902d71600b0015f179c9817mr7038334ply.150.1652492219837;
        Fri, 13 May 2022 18:36:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b0015e8d4eb1bcsm2649267plh.6.2022.05.13.18.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 18:36:59 -0700 (PDT)
Message-ID: <627f07bb.1c69fb81.7e728.72fc@mx.google.com>
Date:   Fri, 13 May 2022 18:36:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.39-21-g8fbe504de79e
Subject: stable-rc/queue/5.15 baseline: 162 runs,
 1 regressions (v5.15.39-21-g8fbe504de79e)
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

stable-rc/queue/5.15 baseline: 162 runs, 1 regressions (v5.15.39-21-g8fbe50=
4de79e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.39-21-g8fbe504de79e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.39-21-g8fbe504de79e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8fbe504de79ee9a74d12e6233611a7e5b8767d4f =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/627ed5369bbff3476d8f5751

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
21-g8fbe504de79e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
21-g8fbe504de79e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ed5369bbff3476d8f5=
752
        failing since 44 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
