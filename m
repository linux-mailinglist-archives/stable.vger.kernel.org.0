Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2C557F08D
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 19:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbiGWRLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 13:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGWRLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 13:11:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264D613FAC
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:11:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c6so2903082plc.5
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ykdFhvKV4EGi213j16ohpXCzxZKVxMkF+gC/NaifJuY=;
        b=6rZYnyR1IHRou52CKMInagPnsEQwyl0JNZuu4vl+v2guQxnUKiG8JEDXBcOBYAs0qs
         RQGEvc9iwhh9GdC+IqoNMoyc82gm/3S+lGmHj9P/6DJI0JZKkXwtnC+XNge+nJwF1PHr
         iuJRCchV2HatIGN2A6dLtKCB/BbDYaLQLyTwHkFKBKtJ6/Pb4au3//AS9pIZnfJ9YO5J
         k9BQSyKwCps9hZTzaLIKw6hytZegmO2RF54apyaNtm1c1gzC7ydUeyJq+WV8Y6kH3kmN
         cx44e711ehkgAML/DXy9qeWppRjALxC3WUpW1tH6XmtUM0cMcWNBzvh2//TxCcwkAg0U
         2nVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ykdFhvKV4EGi213j16ohpXCzxZKVxMkF+gC/NaifJuY=;
        b=cD7muwxJplo4aH77zHzvI1aICPblC0tkYgqUnxUjBa6X3swamfR9a81/0j7G6wGngh
         8PwAbFCeKVGy6iwsWhKuI67z4vxFsYtz7OR2u4Zj4uX/x01QkscNCFrxi0Uxrskivc46
         cKk0aCzBvaGiFKf9sjCC+J9exs9DPpqIqBfxWADJm+SHJYZSWJ0/GKuAGvp2sUJjbaYS
         TStoCyLLKgbLBRuEpMgIeQclxR9OWZ8a9dQWzPp80amCKpGrZt8FStDRP1UbFLB+YYVQ
         uhrDi6WR5uN8pH+EaIwZFwm+Gaeg75YM4osOHCBzCwTl3ob4DsFyQPL493ZtHQBojmyf
         fiXw==
X-Gm-Message-State: AJIora/ocxgwetrTTus/NxQWFnu8Jl9+A/4n+ZW5IqiVyBNIFGzxoynS
        pPPB5WR/jOXv+hbLQ3/RdVH7rA0yKu5CiWJQ
X-Google-Smtp-Source: AGRyM1sVH+C4FqtbCcBqQxBYYx/vTHvWjpn3o975crdjZ2sahm1A6hIunTgZ2OC1djyO+3fXt5iCCQ==
X-Received: by 2002:a17:90a:7343:b0:1f2:4a49:dd96 with SMTP id j3-20020a17090a734300b001f24a49dd96mr9913287pjs.173.1658596264303;
        Sat, 23 Jul 2022 10:11:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8-20020aa79848000000b005289627ae6asm6166658pfq.187.2022.07.23.10.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 10:11:03 -0700 (PDT)
Message-ID: <62dc2ba7.1c69fb81.3423c.9f33@mx.google.com>
Date:   Sat, 23 Jul 2022 10:11:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14
Subject: stable/linux-5.18.y baseline: 150 runs, 2 regressions (v5.18.14)
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

stable/linux-5.18.y baseline: 150 runs, 2 regressions (v5.18.14)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

kontron-bl-imx8mm  | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.14/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9aa5a042881d4a99657f82c774e9e15353ebeb2d =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbfc7a03b835a9cadaf0bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.14/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.14/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbfc7a03b835a9cadaf=
0be
        failing since 8 days (last pass: v5.18.11, first fail: v5.18.12) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
kontron-bl-imx8mm  | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbfc6703b835a9cadaf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.14/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx8mm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.14/a=
rm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbfc6703b835a9cadaf=
07a
        new failure (last pass: v5.18.13) =

 =20
