Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97A25AB934
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 22:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIBUOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 16:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIBUOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 16:14:02 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B145CED008
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 13:14:01 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q63so2845183pga.9
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 13:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=p1x9ag6apC15y+GqYJuTFZuYNVn7LRISK0G2zz+Appo=;
        b=WYEO52HW+Eu2BhP/goDxOt5rf63j8PCW/RoMSbxTVTaev23qJvmCNPuqc8ZOF3xIm1
         rudCAadv6VRcKAHua0bw21my/87zxuDSConhPLHqginjw35cEeKxlbC7cA27hiuGEfbB
         iUBWLmN8EuZqjfGVykpgliloU2lw4pFtLU57wc2t9nSErr9NDlaOUR1CccYnz46k0gNH
         5L5bCPNvLA8UoSO+ULf1kBJ/xK8iJyWVL/3shr4Emki4IN+AQ+YfAEnl7PytuznY0uh9
         ODeVaKj4eIBHhJMEeZuHF6avtr7Vjma30pWa39VN1X7/A0qaLSIt1SwslAW1o8HjwkBe
         d+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=p1x9ag6apC15y+GqYJuTFZuYNVn7LRISK0G2zz+Appo=;
        b=4JHUN7XBEoLp/bFQdyY600j6qM3sA/JfAUqfGGc9LIZStpJillLQgLsNkt2OoHpa0N
         u4LX+dhLCgH1kjBpRV+AYUhR7yMyZZv4MSi4xujUO8a2chkdVmOUzHL+CuAABUfY1uIX
         K9f106D4lFDHtT0QwQZbC0/b9mxF2myLPTlgkCN7xRj3ROE6wt1i4qYsWQJ2VVrL1aam
         uAiOcEhWRgWQ+MV5vajaxq1fUC2vbt6MS4zKxAsTvZRhbwmQwpW/ZSZMGPj4B93x+MIc
         0vWUV8oTXu4kBbkMvqLfOaoQC7SXiF/HZY2kwnQ6AAFRvgEWhrrJkz8uPlu8NvjuBJPZ
         GUWw==
X-Gm-Message-State: ACgBeo3j8pTtb2tGJ5y3a3yQJPnRd10FyLCWNIne1dvshf0qeayw9iO8
        WfCv0Ry6OESFzALIb/IWPi24PD1Xbthn6MseDCw=
X-Google-Smtp-Source: AA6agR46THt5z6avssQWkQxuldjtPbQnanj9YdxnfF00l1rJNwKIuHCf82FKyQ+aTY8CvpHRbuefvg==
X-Received: by 2002:a05:6a00:c96:b0:537:1537:988f with SMTP id a22-20020a056a000c9600b005371537988fmr39084911pfv.2.1662149641081;
        Fri, 02 Sep 2022 13:14:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn20-20020a17090b189400b001fd674057d2sm1905850pjb.48.2022.09.02.13.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 13:14:00 -0700 (PDT)
Message-ID: <63126408.170a0220.1235a.33ab@mx.google.com>
Date:   Fri, 02 Sep 2022 13:14:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-210-g93995b1e3aa0
Subject: stable-rc/queue/5.15 baseline: 119 runs,
 1 regressions (v5.15.63-210-g93995b1e3aa0)
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

stable-rc/queue/5.15 baseline: 119 runs, 1 regressions (v5.15.63-210-g93995=
b1e3aa0)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.63-210-g93995b1e3aa0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.63-210-g93995b1e3aa0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      93995b1e3aa0c999985baabf05004af5979ddfd5 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/631236154fb72981ef355691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
210-g93995b1e3aa0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
210-g93995b1e3aa0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631236164fb72981ef355=
692
        failing since 155 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
