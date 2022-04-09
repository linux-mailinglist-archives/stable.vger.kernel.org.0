Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6084FA828
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiDINVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 09:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiDINVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 09:21:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF39B7C8
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 06:18:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b2-20020a17090a010200b001cb0c78db57so8985668pjb.2
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t5c21pGxUphBX5hXj2FKysMrck5k6A1sxpZ0f6fYmbs=;
        b=RHiF6vlTUe/gA7xiChX97W2bDF6xdMcxsdANt8K7gLkZoHnJiipFz8FHcm1pw7EJCP
         iSJ8AoFVqWIe89Y2ef1G+m5gOkI1VEt1oPZybTci2rtJoQg+i40AljNEVMO5+s0f2/iq
         47O7ke5v+uHBHUJfFkI7ErqSOU3cpizsmfjvRFWpfN3Ry7YruzBovr4R7mZFmDzN3ofw
         7ELa+HWszUoFG/odUWs/yjDk2QYSUuwuONOQntJVk87QB1/Gj2TJ2nfgIVlPvsKByIut
         Bbe2gnGy4ZAWLBOhNGX8L30WbOfzQyfHcqlAFkeIrPSkqGrjA7gGI1ObChxg1kGmnCHO
         1irg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t5c21pGxUphBX5hXj2FKysMrck5k6A1sxpZ0f6fYmbs=;
        b=m3nx9Qpi8N1MeR4+BP7368N799J3VKhx03Ya2Os8Ze2PBuItbqOQ5MKTlHReT1Od7F
         +66CsQ8TwbSrFK2ZsVAUmgd/xVVN/nBALjhsVtITTLcem6IuT8N8eMoZswJxGlqwW4/D
         ywGt/j6uivOfqSZIGcsSk+Jk2AsdJVqmumcDxyIrbUwCbm5iyzCV/kAHHxhAb0VQlk8X
         laPd1+rXIC9LUACSbNaCSeoDq7I02QShFR71LCpj7Fj7K/6BN61BpVzwuWp7QGE8bkqe
         uDgW+f4XxEfLPyhRbbMT3JmmO2uK42JHJpkseWCAd9iS7XdHKGGdKkBPcPRz8gW7ZY3+
         luAQ==
X-Gm-Message-State: AOAM530TbhYlhF0V8AeEoa+1iOLZrFiuaKa9z+U7atEFgRP2ArRG+TyW
        aPdT1DjRXQEjC65IZYpPO68MvHPbh977vtF/
X-Google-Smtp-Source: ABdhPJw4jcKWq6ehTpCVgreb75soAi3yjaO79fpiAPk99XpqXVWIqrxhQTTVryJdmbUQt7tyfB2lMw==
X-Received: by 2002:a17:90b:3c12:b0:1cb:70ef:240a with SMTP id pb18-20020a17090b3c1200b001cb70ef240amr1217782pjb.217.1649510337662;
        Sat, 09 Apr 2022 06:18:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm30883199pfn.183.2022.04.09.06.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:18:57 -0700 (PDT)
Message-ID: <625187c1.1c69fb81.bcbe2.1847@mx.google.com>
Date:   Sat, 09 Apr 2022 06:18:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.33
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 113 runs, 1 regressions (v5.15.33)
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

stable/linux-5.15.y baseline: 113 runs, 1 regressions (v5.15.33)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig           | regressions
----------+------+---------+----------+---------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.33/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      06f50ca83ace219cb72213369d2be05bb0dd337e =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig           | regressions
----------+------+---------+----------+---------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6251516dc8a385a5aeae06b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.33/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.33/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6251516dc8a385a5aeae0=
6b2
        new failure (last pass: v5.15.25) =

 =20
