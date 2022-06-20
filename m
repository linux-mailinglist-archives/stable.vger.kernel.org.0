Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA70755284A
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 01:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbiFTX01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 19:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347625AbiFTX0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 19:26:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E72FD
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 16:25:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso11641058pja.2
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 16:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=spPplaXBDQ+3nmFoHm/NkXm66IvPctb3ie9mTsXd/iY=;
        b=OOgOjhnnUIcwyVh0cPFnDRpNg/HQoYbrK1h6UdYKTZlCNaBBZVZPimjtFJjnfBhoUE
         d8UOpo+3HK71gMrJ2gnBV54k7tOxm2uvNmSamUNQbVLtIdZ+IWced1GknKFGLw9NwsAK
         pT/fCONyIxIRI5XaALKIWj2GbIYE2pbdj/UKZANJaziRhNdtdTX5ov4HbIbu2V0UwWJV
         iwjw4qr4PdAnxVfod9MmnjX5JUtxXN4Cpud5UKT6F9TSO3gzqOT4gv5ojIzz9Djpr2uA
         cNZxKHDBWaTQFdCCyuRqq4zcmjH2SC4JD4J0419YcZD1tsEolKVNI/GPx2895SiMedRj
         zeqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=spPplaXBDQ+3nmFoHm/NkXm66IvPctb3ie9mTsXd/iY=;
        b=RImw+xuC2UJf+zPkURCKwVr4QrAd8jcsg9Y5oA0NpwWF1nU1TxjmH6sv+IFoer0jxo
         iBSf3EtFmgpYqd6DUganI58Oqnp7b08vOk9psCsJ1jSEqB5y8TlVEIJq1msHOLM5YS20
         j9QBS/MLcqGC7bZtkSCLfJ6URR0yD9F9g2C3XkRytKTzYqR4w3GR6mgQU3tKNpNtYBxL
         LqTYw1ZICmkUhncdyV94ditThnAEVntKNt2YMlBuYJazQMmR+uRIBHCcKrBj7LPlSNgr
         KNioa6dXvOolVZ4dqhvKtN7LbpFnYvjbGv7Z9Cp15G4nhQHhzekvfJ5waudq6AqaV2P2
         UftA==
X-Gm-Message-State: AJIora89GbN3tDiMLHZFm6eSd6sWQHjAMGp9xovrTcMt9otmC0FnO33M
        HyacQWoJ9EamEvck+Riean5ZnPrVrPbldRRMTrQ=
X-Google-Smtp-Source: AGRyM1uvoXKAdmtMNGIo3getlDWO/yT4jN/NrIanhHii921cv0GXhjJeptLwYFRc42L4+GLGNOpvww==
X-Received: by 2002:a17:90b:1e46:b0:1e6:826e:73ea with SMTP id pi6-20020a17090b1e4600b001e6826e73eamr41125243pjb.68.1655767549584;
        Mon, 20 Jun 2022 16:25:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902a38c00b0015e8d4eb2e0sm9223708pla.298.2022.06.20.16.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 16:25:49 -0700 (PDT)
Message-ID: <62b101fd.1c69fb81.e8141.cee0@mx.google.com>
Date:   Mon, 20 Jun 2022 16:25:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.319-251-g5de156af25f62
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 3 runs,
 1 regressions (v4.9.319-251-g5de156af25f62)
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

stable-rc/linux-4.9.y baseline: 3 runs, 1 regressions (v4.9.319-251-g5de156=
af25f62)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.319-251-g5de156af25f62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.319-251-g5de156af25f62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5de156af25f623579095d35be536b5bc3632791f =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62b096c9b211407f53a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.319=
-251-g5de156af25f62/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.319=
-251-g5de156af25f62/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b096c9b211407f53a39=
bd6
        new failure (last pass: v4.9.319) =

 =20
