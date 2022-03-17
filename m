Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50D4DBBA7
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 01:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbiCQA1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 20:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiCQA13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 20:27:29 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C1B1C930
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:26:14 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d19so5461589pfv.7
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VjE09LIxJr4NmJg/B8wAgm1/LiMLigrzhEpUqqXvAAo=;
        b=7pXLqIgmFPQImSNKrDG2JYe1ANyPNj/aj9A7UDl19wkTjSMaeI8qy0LnHEqo7Ss7b5
         AorFev9Eo1NVzccFODeeGsIyVB3NeugoEit2b9T3QY3twoRzIpKaFakpCkSNC5HDiO9z
         2ORE90hLSBmdqMDDGAX5NW8hsq/y7WlX5bUL4YaGr2ALCg4FJPeFMqHhIewZCTiDqwDA
         NYM2ogF8h9a6/Yt4+8zjaBugV5WEFxpIlXbLHbfaIvteqUa8jBIt23EnCDMPEz23DgXK
         OI8+f+puQkB1NYFYyricGNe1kE+C4+n78XE60fW31ZtvAsGVQfZpFK72IEJcNIJP5w6G
         Gagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VjE09LIxJr4NmJg/B8wAgm1/LiMLigrzhEpUqqXvAAo=;
        b=P1qkFmZD/EEoIzp4U9QGDVK6Yo2cYMiEzOUJxMGin9DrN78LRQrK9gNFjW35BYdPzh
         PCtThwnqv2wfcHlqEYzKaQmU9LD3Vbe8tohq+ZdO/tyu2yzaHYnS+L8W7qmXkT2OsBsL
         OIErUpYLwewAPr+Zz8cGOj8M0D4WYPOL9qnXSIf3IxmvFLlUNRMu1wRQfNSrPceLuNpP
         BKYevTDmHfaKOil9YsTU35P8Y2x/sCdmMRx0InPKLp6Smvv6IV5xxcMkElL7eG+1HWoW
         6z1gkd0R/pHb9ZB4SmWmjcPKJSZSY9IQZ30yCbOhfEFSQllUvaNPPA6Yfr9VafS4Hn0i
         BvSQ==
X-Gm-Message-State: AOAM530hsmuBbLftQhBIAJZ7VSkvvsijJiYl6iW+AY1xKTZsdqV3ekhX
        uAUz9pAR7Y8x3w568N3GEoVJ+wWajpNlY9vxPMo=
X-Google-Smtp-Source: ABdhPJwHq+OscFo1SwTyLhKpuKpcXjO3YM5w1VBYDnfL8AB3c8E8U0ZtCoYiHQUJDnOreIZ7iBizrw==
X-Received: by 2002:a63:6a87:0:b0:37c:917a:9ce8 with SMTP id f129-20020a636a87000000b0037c917a9ce8mr1562130pgc.373.1647476773988;
        Wed, 16 Mar 2022 17:26:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1-20020a056a00134100b004f78df32666sm4710631pfu.198.2022.03.16.17.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:26:13 -0700 (PDT)
Message-ID: <62328025.1c69fb81.7cd4.c741@mx.google.com>
Date:   Wed, 16 Mar 2022 17:26:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.272-14-gbf9142cb348f
Subject: stable-rc/queue/4.14 baseline: 38 runs,
 1 regressions (v4.14.272-14-gbf9142cb348f)
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

stable-rc/queue/4.14 baseline: 38 runs, 1 regressions (v4.14.272-14-gbf9142=
cb348f)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.272-14-gbf9142cb348f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.272-14-gbf9142cb348f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf9142cb348f21bf520b1ffe9bc0a64a4e7b74fa =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/623249592b43c8911ec629a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-14-gbf9142cb348f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-14-gbf9142cb348f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623249592b43c8911ec62=
9a8
        failing since 31 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
