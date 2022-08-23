Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D92B59CEB6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 04:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiHWChP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 22:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbiHWChP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 22:37:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683085B78A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:37:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c13-20020a17090a4d0d00b001fb6921b42aso31995pjg.2
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 19:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=uaYGTlagDQW2aBOtlqr7Vlgkc+nLCOAc6KC6s76Ps1k=;
        b=18z+RRThrjuDIG5tchek6imbEjrpQjNvPn2le/L7KgyGoPmw9KccmoqJEr0Oco+DXO
         GON7TVMN+1UcZFoWyeApQUuNwUR98OynO7Spr/L4+6Sc6/wJL6nmWp3yQD3xITh81NXb
         EEImNPEay9OUnHNDbkICdXa5qLnzWrpw97pApxt2txzfNPwOc/2RcWF0B4sUGNrU9ML9
         Bp94IBBPgoRkX2OrMGhzoXd3JJqkmUtM1gd7YRsp5cy84mXODXVJF960rtsQwIZnWnq+
         ne6WoaM3cKUdvoX+56b2KQxUjM1aVD0nkgdaqqX8RIYO3v2kyh3FZzDxqPBWWW1GP0oS
         svvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=uaYGTlagDQW2aBOtlqr7Vlgkc+nLCOAc6KC6s76Ps1k=;
        b=T5ttTVvwJcmCkeqrTaBIKE8wILC4ss1GCmJqSVSwAwwKjA4VUwL6H+wmcXXCr4jUAC
         0Y/f4hMO/Yz28QbTpdreDz8Vt4gsYsRB56y0aTQrxGRsvDexKbdNUfVefJn8IEJq35c9
         mgCtjsMlNRZ+tP9st4CXyno6kWpjw46Ggo4pCprGZ0VSxpxIghHHM6Gdy2C3YhFBjdoG
         MDWquDYLBh3A+lCOTsmZCysobcB8dkXUeYi+fxtOwhS9iVspYdp6KVArmT2VjlmFGyEP
         lA6EuWPH8ptjxHZz0d5Kqufq0ZyUFbDnKAr6+242/HCq7mZitV2i/5J865f2+4q06dHr
         gkGA==
X-Gm-Message-State: ACgBeo30R6weGc/iYI5w1U4IXTjrOj+nGSfLMCnty5s9jGrMpWTpW+F8
        aWqhQUbIZIWn9kAfkAdcIg7jgY1EQxCFCiGC
X-Google-Smtp-Source: AA6agR7aUEa6jqpeYwK5MYA4Uywtn104PVhoh1cvaW1NSsf+Zxwl4MjR5CTYDFbHE7SW+IrEAh55Hw==
X-Received: by 2002:a17:90a:930b:b0:1ed:5441:1fff with SMTP id p11-20020a17090a930b00b001ed54411fffmr1209972pjo.238.1661222233798;
        Mon, 22 Aug 2022 19:37:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1-20020a17090a688100b001fa9739d951sm10607758pjd.33.2022.08.22.19.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 19:37:13 -0700 (PDT)
Message-ID: <63043d59.170a0220.793fb.2a86@mx.google.com>
Date:   Mon, 22 Aug 2022 19:37:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.62
Subject: stable-rc/linux-5.15.y baseline: 133 runs, 2 regressions (v5.15.62)
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

stable-rc/linux-5.15.y baseline: 133 runs, 2 regressions (v5.15.62)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig          | re=
gressions
----------------+------+---------------+----------+--------------------+---=
---------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig  | 1 =
         =

panda           | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0a7e0b2b8b22901945ea2aef1b65871d718accf =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig          | re=
gressions
----------------+------+---------------+----------+--------------------+---=
---------
bcm2836-rpi-2-b | arm  | lab-collabora | gcc-10   | bcm2835_defconfig  | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/63041ee789587ccf82355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63041ee789587ccf82355=
644
        failing since 7 days (last pass: v5.15.59-31-g9c5eacc2ad1f6, first =
fail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform        | arch | lab           | compiler | defconfig          | re=
gressions
----------------+------+---------------+----------+--------------------+---=
---------
panda           | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/630437e95aa51f6144355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630437e95aa51f6144355=
659
        failing since 7 days (last pass: v5.15.59, first fail: v5.15.60-780=
-ge0aee0aca52e6) =

 =20
