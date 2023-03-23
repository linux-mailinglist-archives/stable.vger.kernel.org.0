Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625746C5E4A
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 05:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCWE6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 00:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCWE5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 00:57:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40002F077
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 21:57:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2772765pjf.0
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 21:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679547459;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JOYonWKRmBFsY/AKqkqsc/1b16vp+opQb5aQ86/d4ms=;
        b=z7e/yFJiSllyY9i2tT+yWgMMpcYmzWsmvEshUPgR8C2jumUnrQJ9RmWnw0lFj3Qxgv
         8PmpA7Y2rndn0MIShmSw+wIwSbVA5BYLN96sbhtO0c4WCETcLzFxbeZwjA74Sx++T3UB
         e/NyXmH47880vEsXjAUysjhKBM1pa8gUCMe7NgRfUXPnwSdAasY+0kwtq5AdoAOZPCEH
         VS9LLD8iX9jjJ4aMUhBR6bEF/K/Ue99Kc+FkPprh4kSxY7kX3MYNVUtAtaIyRU6bBo4E
         Vowld2KThnAi6fmKSWp9Jf1UO8wHCddJsHxGIU+vMMPy+aATB/AmJ2BrRyFBMqS8UB9B
         GMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679547459;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOYonWKRmBFsY/AKqkqsc/1b16vp+opQb5aQ86/d4ms=;
        b=vRb1pL4MaKdQAEiYA+rbYaUA+btrLRnoXlASA1oBouWy2ESGDTh/7hWMvt610y//F1
         O/7dUQ3lvUPAoy25AzJIcqtxS97Ua1Um66yhqhpcNfVML5EQIKoshlyOxM7spJ8C8WNI
         wsRgXKOFZW/FsXIh3Ru6ZUfmQpErX2DdH0mV4zr6VXrVnV/MC8CJ+ovBX21A+pR0pyyJ
         pGrxqlV4PjwIqEgvulbZNeRHhXN7+b+U758l7gqM/m/FSB0XlLUmL6nS+IOIPr7kJoG1
         9zRgl6wjiTL67vbU4piPf+GOeimYwWaO1eoBlTc6JIqBq+8UanJqx6okVSWOjzEem/Ae
         XVSg==
X-Gm-Message-State: AO0yUKVaUyvRFAdg2PBNHi27ZmQ3Py5ErAj7SV56/ewa9A4XBvWnUZTM
        /kw2C1engF7qOAOwq2gXhj4zPTZRVnGmugNgfxwx3w==
X-Google-Smtp-Source: AK7set96L9lFztmrVR8OLRzsfYYE0CV6d6qq1J3r562Nrut3UqAq8cNAp4nBrMDlo2SWrpjTnwH8Eg==
X-Received: by 2002:a17:90b:4ac7:b0:234:28ac:ec4a with SMTP id mh7-20020a17090b4ac700b0023428acec4amr5813426pjb.2.1679547458892;
        Wed, 22 Mar 2023 21:57:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020a17090acc0d00b0023d0290afbdsm414000pju.4.2023.03.22.21.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 21:57:38 -0700 (PDT)
Message-ID: <641bdc42.170a0220.48693.1189@mx.google.com>
Date:   Wed, 22 Mar 2023 21:57:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-14-g63f11815ccc27
Subject: stable-rc/queue/5.15 baseline: 122 runs,
 1 regressions (v5.15.104-14-g63f11815ccc27)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 122 runs, 1 regressions (v5.15.104-14-g63f11=
815ccc27)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-14-g63f11815ccc27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-14-g63f11815ccc27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63f11815ccc27da754b99f5819faf19077089d30 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/641bab744ec1e863779c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-14-g63f11815ccc27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-14-g63f11815ccc27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641bab744ec1e863779c950e
        failing since 64 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-23T01:29:10.871823  <8>[   10.020247] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3436630_1.5.2.4.1>
    2023-03-23T01:29:10.980468  / # #
    2023-03-23T01:29:11.081750  export SHELL=3D/bin/sh
    2023-03-23T01:29:11.082185  #
    2023-03-23T01:29:11.184367  / # export SHELL=3D/bin/sh. /lava-3436630/e=
nvironment
    2023-03-23T01:29:11.184988  =

    2023-03-23T01:29:11.287442  / # . /lava-3436630/environment/lava-343663=
0/bin/lava-test-runner /lava-3436630/1
    2023-03-23T01:29:11.288395  =

    2023-03-23T01:29:11.288622  / # /lava-3436630/bin/lava-test-runner /lav=
a-3436630/1<3>[   10.433313] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-23T01:29:11.292808   =

    ... (12 line(s) more)  =

 =20
