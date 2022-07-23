Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1663657EA89
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 02:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiGWAFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 20:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGWAFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 20:05:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CFBE7
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:05:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b9so5674695pfp.10
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P0YjGhrmRCEEfgivQwnNga6fC++hRDeYCl+ARVwJGcs=;
        b=dhTi+zAuE9hiS0z6MVf+hKu0nXhAxzNGVxoGDNQfG5vD3mvo91KePqgeG0yLvjsV2V
         pErb0r2LGSQaf1ydljO1n03n1dnQ0yjX2r+QbE8ZZGXysSuRLOHqtGIUN60qdP6PxJKQ
         rNS9iwjYzDqb1VFkfoJ/yYEz/2HvRBf6TmYyzwTqjCUwwU4dj6fPWzEBHEJjWHzXPqCV
         vr6VAcW204KdXDzgOb2dBAMhXS4zMF3+4Jo90RJKg/XuNoAv1thwHvJTvCbfA072lTot
         WIjHoxYk1mAsy1XQpZ++J+hyy9y33KhI82jC2zwIy+lxFPJiOqeHILp+COVpuFuu5pSw
         eo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P0YjGhrmRCEEfgivQwnNga6fC++hRDeYCl+ARVwJGcs=;
        b=YeGlko+ToSbInpfwdEfEf7VSJ+zoIhsm9TcnzOM6o6vC7eLe5naCYW0NjeCDAQRj4h
         yKbQTuDv0gYFmTIH2/2QOcY/5grJDD9kvWbSos4zIiCTuGnK0JmqYbuo7fMw31ASTQtF
         hsEi7Y3sMey6V4ChnXWm2oTbnHsDKhLuEHcqIe6fTFyI5h9xC3Xw994bNfaYSTThYw0/
         sA4CbEdLSoyre2DPtrnea1SLwQ8mTLFdl9htCn9fWF3oLRd4jstf5DJdrpIxnzohUtMg
         eoKsb62hmYRykncUUuhFdxEf3ibm1deSV6fsrC7+pXhOsnzaMmIvt+GSqNGHgUBcSxcD
         t64g==
X-Gm-Message-State: AJIora++JCxQJAl0CxhBXx1Iz61EthvptboK+IMNmWRsXtm5sLzu51o8
        Lrha3gP/LCDqenC2hdJ1CR2gLSt8pTKJQfGm
X-Google-Smtp-Source: AGRyM1vrBHMN9xFuuSBQKSnJN+IxvhHft5phqWCyErM4nx+GMy0wuyYq/oiOCTgHEPxAeFSgUicZ9w==
X-Received: by 2002:a05:6a00:148d:b0:52b:946:67d2 with SMTP id v13-20020a056a00148d00b0052b094667d2mr2217235pfu.31.1658534706253;
        Fri, 22 Jul 2022 17:05:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902680700b0016cae5f04e6sm4258346plk.135.2022.07.22.17.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:05:05 -0700 (PDT)
Message-ID: <62db3b31.1c69fb81.f8137.7880@mx.google.com>
Date:   Fri, 22 Jul 2022 17:05:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.13-70-gda34acf4b345
Subject: stable-rc/queue/5.18 baseline: 172 runs,
 1 regressions (v5.18.13-70-gda34acf4b345)
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

stable-rc/queue/5.18 baseline: 172 runs, 1 regressions (v5.18.13-70-gda34ac=
f4b345)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.13-70-gda34acf4b345/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.13-70-gda34acf4b345
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da34acf4b3456c2f4f44b8ac144a4fa9b6d86d2b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62db28aa77eb6ea8fddaf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-gda34acf4b345/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-gda34acf4b345/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db28aa77eb6ea8fddaf=
063
        failing since 17 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
