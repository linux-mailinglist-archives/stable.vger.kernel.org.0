Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942FC5810FC
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 12:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbiGZKSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 06:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiGZKSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 06:18:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB862F669
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 03:18:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b10so13025431pjq.5
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 03:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MKsyn0Ue9WZKGeW75wQyzeD5Bf7h7LLMHHF7FeQVKno=;
        b=wWkXsPqyIV8b+1jl5gZ+5DcecfVvxqpoOkPuNU5kRcuydCv5a9dGzbRxkuBJt3JDMt
         uPfVMNTmJCzjp02bdWRROhFwZJ8lFiLR5uiUgNiB2oVvHjpKFvWx4LhzKJ7t+o9BkLOQ
         +R9VboKKoLcXjXmW9aN4kbQeZXKR3bgKbEUDQbiMIzWMubsk3MoeWH7bPe1WJVUiAJHA
         FWeofjheR96JeuWHb3adLeILjcY6qkzFSu3BdnxaBP98fjeidVqZIbHg3pr60/CyJDok
         vnSglVc/3UAw2VMJipzjcVim2cHPHO+DMiS1LrVsIejUJ3dJIzoHTPvibDoviXlgLaSA
         7aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MKsyn0Ue9WZKGeW75wQyzeD5Bf7h7LLMHHF7FeQVKno=;
        b=NPE0Dh7ZRJtpTZTkqK0Lgr4uB+h+Y7tqOaHHeRON6WVLRsxXwECBd9Ae8tL1imXnsc
         qNEJa6cYRV6eweFKyxk/FWXijk/+vgsd0yVzbTF/06hdSDXl3Yxz2FQiUGkH87Nx/o8Z
         Ku8DDY0YUnI0smY2hFMaLiw1wZ6UykqGBC2Kogf/FjyRByvJPttDOsiRzBzKU2ZEmxTl
         nDTzmVb5CsirL4wnfa0lvT8UH8EU+1KCpwQnq9I/USy//A7jDTfBcirSjxPs1LQwrgzE
         1TVF6EBg4ciSBnO1lrZucDv+9AblUvOxSzXP6tz+T9HMkKlUM2BoBJB66QVuQZp6esUl
         JQzw==
X-Gm-Message-State: AJIora8vFvpzVNdxqz0sEvgKl/SRIVAF5XLjGiLnvDk4RBaWQWuf9Qbc
        7vvuJKjcXqVCnNuPUrgf23qZv4EbXRZfnTkG
X-Google-Smtp-Source: AGRyM1vp8nfHKMWGxWRnZLkF6lwzFzCG4RKyl5NxtPaTmhB/LsOKAxdhz5FCTEWWuA1ZkJwPbGiZIg==
X-Received: by 2002:a17:903:41d0:b0:16d:4841:214e with SMTP id u16-20020a17090341d000b0016d4841214emr15764323ple.13.1658830712129;
        Tue, 26 Jul 2022 03:18:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b0016be24e3668sm10982328plk.291.2022.07.26.03.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 03:18:31 -0700 (PDT)
Message-ID: <62dfbf77.1c69fb81.3debe.199b@mx.google.com>
Date:   Tue, 26 Jul 2022 03:18:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-176-gda50e215b6b1a
Subject: stable-rc/queue/5.15 baseline: 149 runs,
 2 regressions (v5.15.57-176-gda50e215b6b1a)
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

stable-rc/queue/5.15 baseline: 149 runs, 2 regressions (v5.15.57-176-gda50e=
215b6b1a)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =

imx6sll-evk   | arm  | lab-nxp     | gcc-10   | multi_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-176-gda50e215b6b1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-176-gda50e215b6b1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da50e215b6b1a70e2b251ce5d6e37068c880340a =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62df89c847d1c5c767daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-gda50e215b6b1a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-gda50e215b6b1a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df89c847d1c5c767daf=
064
        new failure (last pass: v5.15.57-176-g9780829ed8d15) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
imx6sll-evk   | arm  | lab-nxp     | gcc-10   | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62df8c95d4c37f0510daf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-gda50e215b6b1a/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sll-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
176-gda50e215b6b1a/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sll-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62df8c95d4c37f0510daf=
068
        new failure (last pass: v5.15.8-42-g0a07fadfda6d) =

 =20
