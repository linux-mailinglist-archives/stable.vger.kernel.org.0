Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157F554921F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355280AbiFMLqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355590AbiFMLmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:42:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AAC2DD6D
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 03:50:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f65so5184848pgc.7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 03:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fFYEx2/rxkerbvpzWPkbZ9+jvJ1vJ8/qooJQl6luUFg=;
        b=mfiausT6G/u24BJ4Ocda2cHCASoGYkUYqBcgeuUZnXGuzsmF4Uef46Ah7/EgBSCzxZ
         9WVSixiTX3k2FqxiyLIk/EA0yzq5JMJq6YbIvE7gn1CY5UEix+xnmG34k3M6q8whfck3
         uNFvje7XvB+SrBqUR5j+SWetWuRBsBDmSRpWwps5Y/Y+cGhtDS4p8h7Dsmw5sIZGqpS3
         DBfsaqaOqtCDJkEVWnxnxNQgVYAilG4JdQrQGtFhVC/ynwUZhfsjkwn/RG8FL2s0J9oq
         UWfhMD0cBCDq3ibrfAn02fRseS25oKudt/PqJBf8Jcgvy57ITAmC6JJ+STT4GH8FSgZ9
         xScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fFYEx2/rxkerbvpzWPkbZ9+jvJ1vJ8/qooJQl6luUFg=;
        b=jCZWp1GmUd/2SJOHUykynhKFLyMCvGqmWfsw3Aqcp9I6OYgwKAVqsEh0Hv70ZFCjND
         dGCS65jPZZ+b/88DN0vrLbt4TUzN+wlvJH2gARL5V6Bcz6tclgAG2yXK4Ze+hOwAmoQG
         ciPIC3FJEBu6R9uDHNU9rRKfNPVbeeNvrqlCpC2B+FRQ4dHRyD2VnBUivjiVZdcc2RLM
         ObgzjY8n0y0CkIAetp/nDfsKNOSNIq9jUcNoDi9EYVjfXVlRM+CTCri5aFqS6kpue2Vb
         MZSaTtUsvBhYysJv96xsnPB6he6LRJp7wGfwDSkFKQXPLXWArT+/NQBH1DfyIzw/DB4H
         lsJA==
X-Gm-Message-State: AOAM531dc0twtrf6tVB2W2OrdG6NLeo4qguq1KCPAPxpQ6Yy68o0gxAI
        1dOx3sxSYPtNXxSCcbrrP0NQw95QZytwVc4SqKg=
X-Google-Smtp-Source: ABdhPJzbviG6/+f5Hc+gioS4xhPSpSetW+VMaJ8jieJ6BBGEt/6TEijjjdeg+DQJu+93AsgQbyIB8g==
X-Received: by 2002:a63:fe42:0:b0:3fd:f49f:20a5 with SMTP id x2-20020a63fe42000000b003fdf49f20a5mr29683039pgj.210.1655117410456;
        Mon, 13 Jun 2022 03:50:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l16-20020a17090a599000b001e88c4bb3dcsm7086496pji.25.2022.06.13.03.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:50:10 -0700 (PDT)
Message-ID: <62a71662.1c69fb81.9ff0a.8989@mx.google.com>
Date:   Mon, 13 Jun 2022 03:50:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2-1173-g45fe14d45d6c3
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 161 runs,
 1 regressions (v5.18.2-1173-g45fe14d45d6c3)
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

stable-rc/queue/5.18 baseline: 161 runs, 1 regressions (v5.18.2-1173-g45fe1=
4d45d6c3)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.2-1173-g45fe14d45d6c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.2-1173-g45fe14d45d6c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45fe14d45d6c394194f3e262ed5988da2478118e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62a6e2c03da472c7baa39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.2-1=
173-g45fe14d45d6c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.2-1=
173-g45fe14d45d6c3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6e2c03da472c7baa39=
bd6
        failing since 2 days (last pass: v5.18.2-866-g0f77def0f4d00, first =
fail: v5.18.2-1057-gd2f82031e36a5) =

 =20
