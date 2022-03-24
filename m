Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5F4E68FB
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 20:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348003AbiCXTDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 15:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiCXTDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 15:03:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B9B823C
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:01:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so6017560pjf.1
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=96XzCXaZVs17jEhlxpsw3AFbXbvfjvv6Fal+LApA7Sk=;
        b=NSI1BAlbX4zaA8Gs0tM2Sf+lpSROWqYxEPkz/9yD35T6/HH0Gb01VA9/G8EC2TNfYE
         Nbex3es4t5IJvm44w6jevdehM10nCZR+lo1OLonmcRC+mDi1O/VHhovh/uKyFlsN6kC+
         LR8GFMSe4bnlinpL1evI/OCEAFMnazA25V7PkvMnOltLi1Q4W0xUCnbFppRYWID2wpM4
         9kasIK2agbaevedXfHUoEgVFw0GtwsijENdgCZRrs10StRuuDIVYP/IB8GDHEEm5lf0D
         AYqehIA3JLY/w+ki37WhPuBSAXqgK6mCo/63h7/nC3le2RhZCNfFrB/pAql9FyOrqpP4
         viow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=96XzCXaZVs17jEhlxpsw3AFbXbvfjvv6Fal+LApA7Sk=;
        b=ACYB4ytSZk+9hVXCf3Gj2wj4yy5QTHiLvgdHAVHAEwBrkxzZrrqwuqziJz9onTWa03
         qJHPzqBfMhQZ9AiXoGDdmhKuYXdIWgHXwuWAf7vuQDcXu/MqtFfzyBdq3xzQOtyBKx7W
         70XDgUS6cM/norwKMnr1NcckLUJKQoF1bXrbJVaZxe+syNiGAHqyKH2HyfglafMAgbYW
         2LkfdyS+M9Wa3A1hJFiDao1IRiDWRg8A/CTdOw9uS2WAfn/U0yjQHLpj0AAVKBhB8cEQ
         AIh2Gf4KArXLpFiPO2x12jX/m0H3+6A0oJscM3wL6KDwZhuPcZkJtqJngPoOwO2Z+GPE
         KSIA==
X-Gm-Message-State: AOAM533C9tvzAOeIz5Lyz6SpoI/MFBqsYLe8RAGhH7OdSZbxmFy8trQg
        CnU5mjaO4HoZ/jr8KO3dhG3xRK0bPtu1ihtbA6k=
X-Google-Smtp-Source: ABdhPJxgUje/OHG72IBAoSnarNClbj5q0NxJEaGVPBOlEJPqUMm7+O2O7dQzxz4DdWxUa3homCrKfw==
X-Received: by 2002:a17:90b:1e4e:b0:1c7:3507:30db with SMTP id pi14-20020a17090b1e4e00b001c7350730dbmr7890666pjb.39.1648148493347;
        Thu, 24 Mar 2022 12:01:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s11-20020a056a0008cb00b004fa2a3b989dsm4261006pfu.157.2022.03.24.12.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 12:01:33 -0700 (PDT)
Message-ID: <623cc00d.1c69fb81.81fe1.bde9@mx.google.com>
Date:   Thu, 24 Mar 2022 12:01:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.273-3-ga96dba3e4103
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 1 regressions (v4.14.273-3-ga96dba3e4103)
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

stable-rc/queue/4.14 baseline: 64 runs, 1 regressions (v4.14.273-3-ga96dba3=
e4103)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.273-3-ga96dba3e4103/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.273-3-ga96dba3e4103
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a96dba3e41035a16534e6569c1e39af9c2775c65 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/623c8fd254584a784d772537

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.273=
-3-ga96dba3e4103/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.273=
-3-ga96dba3e4103/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623c8fd254584a784d772=
538
        failing since 39 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
