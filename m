Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE09501FAF
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiDOAis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244493AbiDOAir (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 20:38:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFD3BF99
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:36:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t12so6002278pll.7
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rCLHlDe+yOcuazyfFmdPpLoQCRB7VGcLuQOKmwAmvUw=;
        b=m8sfx8/ICcHHiC8/np9B7Pu3rzgVS40nCs3432AUOU69e9qol00LpN3OabSK0RY3Qy
         xI3R7Kzxxu6IM7JtzrPe1d099lpYQTC0btAoS3Fu7BbsWhn48gy2jYLeEhBfmwh4BTsF
         N2vzvko0tpl9HV0ibZqDgmnjU1IewqKG6XatS+T0IAC+PTxPBAOCBBBSnB4H9TW+N8AF
         uleDQF1qAkqMBHMhOEBYcYrv6vKk/50dvqNjwl07s2mlJ2qEPy1SdjQhBAJVgIj62TM/
         4jvy4KlG3s994s3j0cMaM3XwdYZLqiGupFRaLUaBAp4GjAcHB8cIBRwM7CnFbIUxZj96
         DNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rCLHlDe+yOcuazyfFmdPpLoQCRB7VGcLuQOKmwAmvUw=;
        b=s150tgxc2mt1fgh20LdLsUQ0wV+Nv+TSmAwq/JGAAaXp7aolZTadUKHR+mqcQv9ecr
         CutnRX0dV3ipd0WLs30M4kMrtR0DQqq+yPU67dIE3bYEFy2UfTeJlYDqOUZvLWg69AQR
         xgcJQXjqTO4fUCblF89/sj6JCLeQQAthJSIQ06v+L1KJdTpes8rk/7vAfzd8mvw0mVls
         Cb1eItX3+QSvQKLSaZp440EAQGPxtf3SU4nsb4RM7JRPgG+IreO3RCYTJF8CyRMHXUNX
         dmjfmvgx/dGZyZK63uNsJqg0KX2o7QOgYJkvPrO6126A3lsOlTF7/Y1ocSg/9H2aLzKX
         QJfQ==
X-Gm-Message-State: AOAM5329VZ6D0CaiBv3voWmNclFQ+BxDGVfyB/BxpYNTz7BWfGjlbZ4y
        FZTQ3U7VsLV14mX7VE9ZBh2HlvwmKOWJii+y
X-Google-Smtp-Source: ABdhPJyVN7GK58rYFbm2OiGjfCvQJjcOO7zTU2fD+skasdDd3qb9sFiApZteD7HgSficUWnQ7CEFbQ==
X-Received: by 2002:a17:90a:5409:b0:1ca:8a21:323b with SMTP id z9-20020a17090a540900b001ca8a21323bmr1276506pjh.135.1649982980308;
        Thu, 14 Apr 2022 17:36:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16-20020a62e110000000b005061e2323bcsm953021pfh.162.2022.04.14.17.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:36:20 -0700 (PDT)
Message-ID: <6258be04.1c69fb81.7413b.3663@mx.google.com>
Date:   Thu, 14 Apr 2022 17:36:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-260-g695466583e7c4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 88 runs,
 1 regressions (v4.14.275-260-g695466583e7c4)
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

stable-rc/queue/4.14 baseline: 88 runs, 1 regressions (v4.14.275-260-g69546=
6583e7c4)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-260-g695466583e7c4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-260-g695466583e7c4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      695466583e7c4ff61e11c4c3d8c3f3d2db2e0c81 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62588c412dc4fd60bdae06df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g695466583e7c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-g695466583e7c4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62588c412dc4fd60bdae0=
6e0
        failing since 8 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =20
