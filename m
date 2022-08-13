Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49583591B47
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiHMPPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 11:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiHMPPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 11:15:09 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F1F13CE6
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 08:15:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id jm11so828788plb.13
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=vwxalJH+ndRf+bBzogMjYnidPOMM37xfKrMNw+FCuBE=;
        b=hsGRKDpzHrA7jzdMMNbEyCmuN4gqq0eJOSD9D4bBkJlWTstzH7MwRKmopvtnBVBVj9
         BaL27KqVvlFVnchpWuTaHU0J7F5TzRB/EWJWQiIFRCx6kCuWy9skdF8LtDnXnNN3WPMJ
         l0wVKjRns/Esak6PBseDy6Iw3EdjOSQva+fhgZum7J1qgYPAM6Jg8QENAId0T+UEnupb
         Q2uJQrhdcR2dvxkXYg6ruyI4ceDIYmi/zSlKArBgxn8zaVY6KGKQsaMmIKB5jVQRVQkB
         pTs5E9aag+fbbb6EVyPoiwDVXG6WphEcqz+Y0TV0i88GsUhsWbjAYmvBGsIXllH6oyxI
         7wBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=vwxalJH+ndRf+bBzogMjYnidPOMM37xfKrMNw+FCuBE=;
        b=IC3QvUIPJQjfvgZ2zLqI135+sHrAGPYuJeMdXR/4Itgc0CIappq2MAzy9evrtLXzvG
         bLcWfy9wMeyzhR+nq1pR777aWJdBALAvjPVNvdmQp+RWRmxnUnI0oG0FB9wUgvE/JwH+
         R7jTH/PPLUjhilL8z8N96pjizRwmnQDHIhGjeF/nguze4G2JfG+riHSjf1XORtYkhma2
         uuAJgFJeCLi0bXrMyKvitSyosrM1oLOWpl0zY1TL7Cr1R4GIL2X2EBaa/uOboSEJXSeC
         iQxFpQsbgpbRKtBGx3d1R+Ma8PtBdsM8Qtk5iSJ5jD3GddYP9QuZJBxjm6gjicpikHsF
         aKvQ==
X-Gm-Message-State: ACgBeo1aWVaI5oK+x0PB0zKo82whox8ccTOQuiPqGx4TU7musYUoFU/3
        V81cprGiQ+pouUmmnQvo6cWGT3G+xVRnFu+l
X-Google-Smtp-Source: AA6agR7+WwPfgLeuvyH+iVjkXnkDrGMXw96UATqATNh8Ce5m0V+tOL92aIfXWdUi312kydg8pYJCXw==
X-Received: by 2002:a17:90b:1804:b0:1f5:946:6b6f with SMTP id lw4-20020a17090b180400b001f509466b6fmr9720997pjb.160.1660403707857;
        Sat, 13 Aug 2022 08:15:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i17-20020aa796f1000000b0052d46b43006sm3672315pfq.156.2022.08.13.08.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 08:15:07 -0700 (PDT)
Message-ID: <62f7bffb.a70a0220.fa877.62a6@mx.google.com>
Date:   Sat, 13 Aug 2022 08:15:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-48-g789367af88749
Subject: stable-rc/queue/5.15 baseline: 191 runs,
 1 regressions (v5.15.60-48-g789367af88749)
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

stable-rc/queue/5.15 baseline: 191 runs, 1 regressions (v5.15.60-48-g789367=
af88749)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-48-g789367af88749/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-48-g789367af88749
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      789367af88749bdf67368a0864c64ed9f82d8701 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62f78f2213826e5999daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
48-g789367af88749/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
48-g789367af88749/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f78f2213826e5999daf=
07b
        failing since 135 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
