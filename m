Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928995975F4
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbiHQSsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbiHQSsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:48:09 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424B5A3461
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:48:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u133so12768831pfc.10
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=jeeUTUGAwLkQGnhwVvsgoEFIdcR0raKNKGM01A+4Mlo=;
        b=ICu3ZLLcrp6rJ6g6uftHiywdY2rvqBVRxPC7Mee50q8SEo1TSRBaHHKEQOYsdMZ8Qi
         uBGtlxln5IMepI2cYu1NWYyQL0WW8AiS1bFYnh0Fu3YvWucU/mIZhivbXNa2zry5HH9a
         BL1bAMJwsvB2oOy5f1mMfZj7V1yIfzQrlBv6RW2yGIHTzP9hRoz1LqYtrfDJ1r9jmc6s
         qepBzc1SP/d5HOQEqnhj5AaFBr1aZmI2/tZ9Q+VvXfwhK8zeXN8bg9G3CXTVH9QTq2fj
         XWAohaM48yNh00dvmr03mCj2Y648G6ocM8h8htnBgQs+CdBFCjMIHmjB/rM/mmT0/BzD
         uYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=jeeUTUGAwLkQGnhwVvsgoEFIdcR0raKNKGM01A+4Mlo=;
        b=upR7b1eWfV1gOr9FkWqQubj3IjazbxRI4DVJYmeJTqjBgWVPEV178fslquybJGx2ew
         LjXtVO3LxiPgQxp8errw/ZdrtZJxRuerQe6zvXlmuzYfJjR4NxCQaCj75tVBFR+T+J/T
         T0N7UxhN09wJi1l6yq164aP8CXDN40Gy1P3mqlm+gcH4oHSHYJ4jGLBwu7XJ05mLB4P7
         aBoeu4QUHjcHbICxtvuj1N+dANlvDzMI2HU5R+f/Im0BwhcbYc8km3TfK1PJXfjj76h0
         lBPeSGuP3+le1Vqk73O1G8WDwUltaw9QND9YndabskNJ7JWPwkD4rX3DZwdSwHOOPkeP
         pimA==
X-Gm-Message-State: ACgBeo1EFaq+bFLYydF9smq2py26pEIH8AA2Wn1XhqFldxfjx1gUDUp8
        o25XItH/FiUwtndMOO/PCOpBZpv5JO+8CAZz
X-Google-Smtp-Source: AA6agR69gYhchYrjKhDZNuh2CqdVJ5rwDhyZgiOlJS5fWaBriXTrhfTAZWIaOMv5Z+QI7Z5b4i2YGQ==
X-Received: by 2002:a05:6a00:1a44:b0:52a:ecd5:bbef with SMTP id h4-20020a056a001a4400b0052aecd5bbefmr26451091pfv.28.1660762081075;
        Wed, 17 Aug 2022 11:48:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14-20020a1709027e4e00b0016d10267927sm240961pln.203.2022.08.17.11.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:48:00 -0700 (PDT)
Message-ID: <62fd37e0.170a0220.e37a0.0eba@mx.google.com>
Date:   Wed, 17 Aug 2022 11:48:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.18
Subject: stable/linux-5.18.y baseline: 145 runs, 1 regressions (v5.18.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.18.y baseline: 145 runs, 1 regressions (v5.18.18)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig          | regressions
---------+------+--------------+----------+--------------------+------------
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.18/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      07e0b709cab7dc987b5071443789865e20481119 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig          | regressions
---------+------+--------------+----------+--------------------+------------
panda    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd077fe4c7593814355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.18/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.18/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd077fe4c7593814355=
656
        new failure (last pass: v5.18.17) =

 =20
