Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90505A86FB
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiHaTvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHaTvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:51:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDAB4599C
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:51:08 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so11882167pjg.3
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 12:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=iiumcJd6gjDyokh4dBQ3FcBA0k1XyANwlWq6Aw1tk3o=;
        b=et2cbCGXzXeni5wEyITQMg1hM2ZUsW2O7DxcVoQdyMBpVpMXK/M4PbByjUsLvmyeg0
         EBAOJ6ISdTF6p/dTIMlCnxs8W7ULxqPqvkmmNZZyp8VqnxY3sSgNxle7mbr3YYDQJSLS
         fidwqZFTtAFSALpBAGnYqRNb5JcRXpzRZK6B2LcB4fwDI4YWMPdgXvjgDhdbKSp+oRPb
         JcCBXEVuiEOIVW6DcLqXUuLF2F9yIOiX/glWGbwaTsAGxCY/XfbtUjnpij1iayoLrGfS
         mDWCqPPA6tGL1hdGJwjjcyXihHwumLOpCcEkI6lCuT0squcekYAUumbsz+S5XQZ+Yc92
         YX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=iiumcJd6gjDyokh4dBQ3FcBA0k1XyANwlWq6Aw1tk3o=;
        b=PkXk9/GXA+t7AnHDOc7Ednj7x7fNgk2+1Ipco9Z0tzYxU1+v9byltVv8enNmeDaicz
         o1A75/aYIBhlu88PBpVsq3DHUysY3JU8cYhwH5N64sXE7hjV6f2YXhVqJ1jTaHf3Tw28
         lLXkOXaWIHTJtzukqa9jfVQon3nwqBKRBGITQwhm7sMt/TVCTvCE5iGQbZfzPIFQgY3b
         dKG6lASRRuLGhLYbKgid87HZ03+KqhpLFTy+6rLUwt0Ifzn2y9A+b3llV1/DW46+elAl
         zoe4ExDS3OzT9ooVEWFE2LWahwzOYm3A7bB6t1kgNwjlguPYJH4pXBV3cu89fnoZaT2e
         hNbg==
X-Gm-Message-State: ACgBeo14B2FgraTpD/xKjVyvqgDDh594sK0zq2YVVoucbPapS+YPa8VZ
        k+argyfVER+XuGD3NEbcFf5lpyZfX3scv5aQX5U=
X-Google-Smtp-Source: AA6agR6hsKwT+fk6aFDIu7mS/4bz4h2TgW63NQYDbj9fG1+imtBY1CK9B2MCXXCgrLoqaqEhgwGlDg==
X-Received: by 2002:a17:90b:3803:b0:1fa:ebea:e90e with SMTP id mq3-20020a17090b380300b001faebeae90emr4864867pjb.111.1661975467337;
        Wed, 31 Aug 2022 12:51:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902710e00b0016d150c6c6dsm11891137pll.45.2022.08.31.12.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:51:06 -0700 (PDT)
Message-ID: <630fbbaa.170a0220.8226c.556e@mx.google.com>
Date:   Wed, 31 Aug 2022 12:51:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.63-136-g13e06cfc9a76
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 1 regressions (v5.15.63-136-g13e06cfc9a76)
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

stable-rc/queue/5.15 baseline: 173 runs, 1 regressions (v5.15.63-136-g13e06=
cfc9a76)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.63-136-g13e06cfc9a76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.63-136-g13e06cfc9a76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13e06cfc9a761b792923f026d39421aa7e51dce0 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/630f9996a031435967355667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
136-g13e06cfc9a76/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.63-=
136-g13e06cfc9a76/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630f9996a031435967355=
668
        failing since 153 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
