Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CA6CCECD
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjC2AcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC2Ab7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:31:59 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61795187
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:31:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o2so13365703plg.4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680049917;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hlm2w/Qxmz3TQ2Q3BSpD3FvmQXHfTbIGAdEUiXYz8Pw=;
        b=YfiqLRNMrze/MzT+FIH9PpTe6cKH3ndGGMv2QwYGbEQt66/jRZeEWZfFtnz+WOyAgU
         kif4WR5+Mixatb3T9Bn/g5ztco7aYkXchzY1BBha/Ywpps2NL/TIE4oNYaF+dTIR2skC
         RjfUJWq/u4cthzxArtBbQJ6q9UjVOPOESWfXs2sEZItKUbB6mOONIdSh6g7e62XT+Aqa
         S00UWwYG43WxnVurecJ/vVQ7fzKG9JZ+ssRAQ45NOpab/041sOFCj81nBMvey1MyqtuI
         gVCiPBTJLId6EIbeRHmJ4Zo3vkYm7KyXpvbW4GSc4q2lJUvTLsXY3iBR01HhvMMS9gJT
         J5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049917;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlm2w/Qxmz3TQ2Q3BSpD3FvmQXHfTbIGAdEUiXYz8Pw=;
        b=kb/fy6cdpS2YxQIyI00uwcEL2yyEFnvQlsFYbOMkSY5b8bmRR3oTyCjtr8G8e/mzQ6
         9RrWzSAkUhkp780FqOjNv20UxA3ABqPk5fCNLBBtmJaopNuMep1kERs6p7ef92Z7lpsc
         cfiSHgPz/jYUIM+8yBUzLl7nw0SQEkQtvCVHxORYlJY8aRG1/C5HdU1zCJGJw0zuNVfW
         R5mcDncV2O4qdy6ZuDpMYRjOCCkZ0w6R2WH8OzfMeJiPzmcIqOHwgv9HauYDW2FAFuMh
         Hx6Mxn9fnlO+91iEkKadymn84S1ZOR1ZSqci2SvoN9BnU0w+n+VjHS8VuiU/t4Gb6zns
         tcEw==
X-Gm-Message-State: AO0yUKX/yOdPMI+ivK5qJc0KRfxGIoU9HRANPpdxSaY5ZvLa4QcRRjG3
        exgzVzPEmgy1zjsBIGpLQMTvx9Lbut3vwJGyZvyS9w==
X-Google-Smtp-Source: AKy350Z3VPS/RpengY9TBPRknEfw6+Ced9A3SHz1IvPibDaLJKg8fWsilvFA2tf99cfTzYp/UUROxQ==
X-Received: by 2002:a17:90b:4d88:b0:232:fa13:4453 with SMTP id oj8-20020a17090b4d8800b00232fa134453mr19582918pjb.13.1680049917581;
        Tue, 28 Mar 2023 17:31:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090ac24400b0023a9564763bsm142000pjx.29.2023.03.28.17.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 17:31:57 -0700 (PDT)
Message-ID: <642386fd.170a0220.c083a.0653@mx.google.com>
Date:   Tue, 28 Mar 2023 17:31:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.311-43-g88e481d604e9
Subject: stable-rc/linux-4.14.y baseline: 89 runs,
 1 regressions (v4.14.311-43-g88e481d604e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 89 runs, 1 regressions (v4.14.311-43-g88e4=
81d604e9)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.311-43-g88e481d604e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.311-43-g88e481d604e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88e481d604e9ca0b5f8d202438c30aac6142a778 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/64234f7761021a30b262f775

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
11-43-g88e481d604e9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
11-43-g88e481d604e9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64234f7761021a30b262f=
776
        failing since 407 days (last pass: v4.14.266, first fail: v4.14.266=
-45-gce409501ca5f) =

 =20
