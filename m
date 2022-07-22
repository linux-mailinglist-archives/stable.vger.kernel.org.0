Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090CF57EA83
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 01:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiGVX4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 19:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVX4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 19:56:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41E227CCA
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 16:56:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq7so5596728pjb.1
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 16:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6WGiEYxW1jNhOFXTrAGdXHhpks2rQjg+RCcivKUiPkA=;
        b=jUekySmE1sXWy8VPL9xkdVLNSjW/dBDVlLT7BBT/Cgc4ujcgHfseh6mITexPfPQkQe
         42AcC0WwpJ5Gqkc/96TQdN0a600kSteNdIxSGSj2FabguHsCz4gwjUJvmAEBSeyn677V
         aymQnewM8JX96xdixQBVTjs9I44gsobGjRG36N8BIoW+Usi8SyioMglO5fh/HPyK/IeS
         QDbsshxdM0BD9O3ViAiuStEAhMj87HfghhVu/0rA+u5Fet+ZMi/EcYiJVoH+WSsaWfz1
         Bf5+yVOmDsKFTmY0zTlnEOSAhV8lteMIhW7mclY9F4V0iZgje8InAhk9XBdZzANHUTcl
         42Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6WGiEYxW1jNhOFXTrAGdXHhpks2rQjg+RCcivKUiPkA=;
        b=7LHY40Pr5CEY8r5E1bRr0Xgc95OWShssxe60QpDOHIjis9rUnrMALTj4GsdCM5Tl04
         GsHaS/Fs+jG3NE5tjZG/0FjJiFfoa6073twEJI9Gn3cAZoxZLcum4wfTDNl0kU+3Zgvo
         hlf+2jRvw4r4UPVy2yrp5lbqoOA7AjujIpcQqgieXq6V5fKhiFA2H4TI2TZxAJFj9vBh
         kx/rnc9Rr1OdpEyLSAGc7VGiQbucnpXCU10vyHjqxVzE8CuSSRxJC3AseKnu85Cx+29U
         piDWGscjxyfm/0GFzZr5OfyXUB/h3XWHiMGtSxPn5dJUgil1WP1clljSz07zccexgEeK
         8Okg==
X-Gm-Message-State: AJIora+sYX0Hj7IGoL23/FSi1zP7jEB4mS6SzHaEP/T3JfBpEL1OAXs7
        xqLUPhIwKTd24a/xTvR2G1t921LrPZbVHije
X-Google-Smtp-Source: AGRyM1uexZ4jsF0NbEtBnK5OV9hWumO+QiTYSvJAMKaOqftmJqEEvMVC4ZhtxnEVskfl2bGYmuq8pA==
X-Received: by 2002:a17:903:192:b0:16d:1bdc:109a with SMTP id z18-20020a170903019200b0016d1bdc109amr1811331plg.172.1658534180096;
        Fri, 22 Jul 2022 16:56:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2-20020a17090a024200b001efff0a4ca4sm3985258pje.51.2022.07.22.16.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 16:56:19 -0700 (PDT)
Message-ID: <62db3923.1c69fb81.7155a.5fe9@mx.google.com>
Date:   Fri, 22 Jul 2022 16:56:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.13-71-g4142b06492bc8
Subject: stable-rc/linux-5.18.y baseline: 125 runs,
 1 regressions (v5.18.13-71-g4142b06492bc8)
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

stable-rc/linux-5.18.y baseline: 125 runs, 1 regressions (v5.18.13-71-g4142=
b06492bc8)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.13-71-g4142b06492bc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.13-71-g4142b06492bc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4142b06492bc82bde362db55d6f29b0e2e509091 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62db249af0ce253ff8daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
3-71-g4142b06492bc8/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
3-71-g4142b06492bc8/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db249af0ce253ff8daf=
060
        failing since 21 days (last pass: v5.18.8, first fail: v5.18.8-7-g2=
c9a64b3a872) =

 =20
