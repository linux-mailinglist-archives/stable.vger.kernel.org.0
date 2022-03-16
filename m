Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF794DB907
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 20:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbiCPTvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbiCPTvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 15:51:04 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3245AEFC
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:49:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m22so3103727pja.0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 12:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5nnYALfzzVWmqmSyRhIaB5UWqOP1Tuq/HU4SJRlT1Tg=;
        b=EH1Zvd2TCOUJ3KLlpu1Zims7lM+lnb+Z3aTQXb1/hgWl21i+3J8kpvaS9AavadW+cx
         z2KKoZ8YWFLY386Wk0CzuWO1fPayratiibWQwWdf4LE03TiFGmSGT1rG3BK3aX3mISAy
         PUGwtLv3nRWnIE/AfPMhLgMw64Xp74c47f5OnbJueEMxRPEJUliZavyCG8AkfqiDZiiS
         YE09pQJdn5KswVTdkKAefc98fnVehGHzBshd7Tp3flQ78vSrmDf0MZZkKXyZVbi0xJeE
         LTykcn7f0RLuKfnQS4UoD2e2s5DA5EnEZPyMOK/besXXth8iRkdI0UwSGSVY5EHEooZs
         uV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5nnYALfzzVWmqmSyRhIaB5UWqOP1Tuq/HU4SJRlT1Tg=;
        b=bBF4H202rPfkfOdrA1QdZA54r71CbDR9sCcf+Q4A1KrqLbsM/EAvqA6M8D0F3p4Kny
         zn2cbkUWqfphCawjhAlC4jIuw9ikG6ccborH1XbI74v2Crf5fzX2QgSHERperDVldR/q
         Fc/O2H45ZShkYHYgzXDYg42iMtwEeXoj0DOo3XpGiAZpCWpG4uGZvvSybsrn3vZayhvW
         kLn7AXPGkapgHcMdDCHaTqtYWkeLK9SVhZwdLLh1fciCDrts2HGU5Lh8dVzY3Oq77HtH
         TAEXs+iUDpgDtKVJCGKn1ia1orXsYNF17Ls/aw5r5NyHUabe/IqlBx+2ZBImdKpETc1Q
         RMrA==
X-Gm-Message-State: AOAM533FmYDVQ1B0R554Mqo3GWNnAwEgN4VCk2zVBssZcjtuWgfsbHLv
        H6BcHptaOAakjaC+7TYNEZHZfAGGHXzbWI5fwe8=
X-Google-Smtp-Source: ABdhPJwT0ojojOFLEmwDO5OLYaJFb4DzMmlsgEJLj2EMnGuCF+ne3ha7U4t1NaaXmYBjY0gePIK0Yg==
X-Received: by 2002:a17:903:228c:b0:153:e056:f119 with SMTP id b12-20020a170903228c00b00153e056f119mr740392plh.132.1647460188990;
        Wed, 16 Mar 2022 12:49:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w12-20020a056a0014cc00b004f790cdbf9dsm4562993pfu.183.2022.03.16.12.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 12:49:48 -0700 (PDT)
Message-ID: <62323f5c.1c69fb81.b50dc.b15a@mx.google.com>
Date:   Wed, 16 Mar 2022 12:49:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.271-25-g9836ffa88c20
Subject: stable-rc/queue/4.14 baseline: 60 runs,
 1 regressions (v4.14.271-25-g9836ffa88c20)
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

stable-rc/queue/4.14 baseline: 60 runs, 1 regressions (v4.14.271-25-g9836ff=
a88c20)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.271-25-g9836ffa88c20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.271-25-g9836ffa88c20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9836ffa88c20417030e9dd1071c2657dacc0d79a =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62320e119ed85190f4c6297c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-25-g9836ffa88c20/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-25-g9836ffa88c20/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62320e119ed85190f4c62=
97d
        failing since 31 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
