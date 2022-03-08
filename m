Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912D34D0CAC
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 01:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244021AbiCHANc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 19:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239529AbiCHAN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 19:13:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA4DEE1
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 16:12:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso786394pjq.1
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 16:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vVWOVkjDBjqJ/xkY0vwKkVqRD1ob5PvsQLpgICRDM00=;
        b=taKKRketPiX8D8kKX55NyCdvB67M8z7yIbPl1HVvdnieBBM/ji5sKasB343Jg4ppbL
         EVLF1EtC/BSLIIWwJ4ak6RdWRmm5sTQondR/snE1p7uDM37NSXDg1kCs0q7TXlVOptD2
         Tq3G0KgmS5kMiauKPaGfNWjkyBCzOZAfHHA3jz8e1rjhdLNdE5e/EZf4HA3mzGPSfoqL
         U02jyS072zIZD0hu1Gq4VMzujnjcoHKRlu8E2le7NhMGkIiUwtjsy+dSuNG5LACG83b5
         mxaCx2eFoWurgDIX33JU2McMTZEs1W4GT8RQlaEwXka32DVOiX8N84psuPFeA/oiEhje
         R0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vVWOVkjDBjqJ/xkY0vwKkVqRD1ob5PvsQLpgICRDM00=;
        b=GSzt882yppW7s6SrYKDrYgF51Ybkp7vYiiQT+AxgiSTQDJmOXBpsIxMdrsOGLR2mGu
         7KnphJAbYXYh0/daDHOttEMcO6savN2vU2i8fNxZ5uvgs0pMDKpJ346Rl2+kPhYNsd+z
         /r54QDZgCp/lAEW1fQf15SeyY2q44YdXa3pssg67F1/noYHNAbTO59AR9sJNu1yRJAXI
         jCFpro2HP3XXChtg4l3eOXo00x8l/M1gDL4M26QNDetLrloNvEcmQh/sV05GLP8gG4as
         l9vegy6JYJgOUWsm91kHvQqO+S3njWLr2MIrNpUIRqZ5TgX3umehnjkap2WaMN01IrhA
         rSSw==
X-Gm-Message-State: AOAM532+RwWb0CYBFxKfSwo/kWqKaHQsgIUmFEwP5y0vu6iCzxKfZzt2
        Kw3+06IxkgnhJc4CB0cex+wJVxKivs2U1IwwuL4=
X-Google-Smtp-Source: ABdhPJznEbbkIT0HlJEeyq02tdCShV6vFpJ5JF2uV5vWMs9sUdYi2lEZAEdor5Nq2lhSQZUdrOBodQ==
X-Received: by 2002:a17:90b:33cb:b0:1bf:844b:44b4 with SMTP id lk11-20020a17090b33cb00b001bf844b44b4mr1653536pjb.153.1646698349935;
        Mon, 07 Mar 2022 16:12:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090a474200b001bf65332d29sm467036pjg.48.2022.03.07.16.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:12:29 -0800 (PST)
Message-ID: <62269f6d.1c69fb81.ca554.1b41@mx.google.com>
Date:   Mon, 07 Mar 2022 16:12:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.103-106-g79bd6348914c
Subject: stable-rc/linux-5.10.y baseline: 130 runs,
 2 regressions (v5.10.103-106-g79bd6348914c)
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

stable-rc/linux-5.10.y baseline: 130 runs, 2 regressions (v5.10.103-106-g79=
bd6348914c)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.103-106-g79bd6348914c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.103-106-g79bd6348914c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      79bd6348914c7f6f715fb706a7dde1de833e6fef =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62266d9ebd8d55406cc629a6

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
03-106-g79bd6348914c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
03-106-g79bd6348914c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62266d9ebd8d55406cc629cc
        new failure (last pass: v5.10.103)

    2022-03-07T20:39:52.088819  /lava-5831090/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/622666fa1ec13e925ac62976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
03-106-g79bd6348914c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
03-106-g79bd6348914c/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622666fa1ec13e925ac62=
977
        new failure (last pass: v5.10.103-95-g552e594da6e8) =

 =20
