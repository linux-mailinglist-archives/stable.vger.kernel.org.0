Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0915EACFC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiIZQr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiIZQrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B4F1C928
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x1so6588671plv.5
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=1+axSqtYNGRV8KFA1GlGv1xwKzp0rhlZmxqDtd1XGcs=;
        b=NdmcLmF5lkSLc6rKNTondwbrzaXdQqepshofgEZgaGrQxhkn5Ir/Ah3e+jRsdRnXjB
         ri/gGCHTT2GwgnanM4Ic93u4I2F4qTeoJxGAufbPsZmB6zOsTYCApNYpD1ci7AaqSyWI
         kREyzh/SyoiCqhWuY6rDeiu9UxSXsZOLpfhOf4CFioJ6OQIvr9QvHMQKqy1055jvXvIj
         9UlYaIHpuwkbMISGsCJlbhUwly1UIkluiodHm4aN2JlYAZeaeAZ1vZISQYvI9GBcpry+
         l1EUOn4XokM8qfUzMhuITMZ9qc4Wd2zO7Ayk5tJdJCzctBZDfHDUOUE5lEI4T1bMzqKz
         cVLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=1+axSqtYNGRV8KFA1GlGv1xwKzp0rhlZmxqDtd1XGcs=;
        b=a5vc8muUF5NXTLfS9IsVHLFGJh6AEmmjChf8umLpzcgAGmCeGKpOiHukWE1iftmuAs
         xwAJPrL4KHxofSTKj/ze/3TY4nehXzMYKuhEJuXtDdJxR0Otp5RC6vO4lkfL9C0pKUPr
         EKyGvuU2eeaM9GwfuPbzF0D4rOglxtZafCsrSL+H2o15YdmlC9YoIQm7ZcWuTwG97uIp
         PKLxmwnM06/5DgEQ5Yei6S3WPXlCbWl7CFe4TxbAXy7ocJQKHzRwF/xK/RBnSxCADAsv
         0yEV2AczE6fhPjTGXlCtP9rEow65PS6c3StKiWg+S0SuokKzQQqQ7TFE6z2284z1VxOy
         p7pQ==
X-Gm-Message-State: ACrzQf0re+6uDoKiTro8+QwUHCvWOob4ZxTkiCjOJQfl3D/v2v4JQL0M
        xtrDzl558VAXKWwerHpgUhJd3i0UNzAiKsk+
X-Google-Smtp-Source: AMsMyM6wn/JdzIGo2rN0KPxO+KCTUkBb4Lo4Nr3qedZF3YhG4bt4biCDI0qtIz7fyDb1QrRef9zwiQ==
X-Received: by 2002:a17:902:8301:b0:178:7a61:c01e with SMTP id bd1-20020a170902830100b001787a61c01emr23145391plb.90.1664206780338;
        Mon, 26 Sep 2022 08:39:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15-20020a1709027e0f00b0017854cee6ebsm11398990plm.72.2022.09.26.08.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:39:37 -0700 (PDT)
Message-ID: <6331c7b9.170a0220.1b12d.4c61@mx.google.com>
Date:   Mon, 26 Sep 2022 08:39:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.214-120-g752560fee8d8
Subject: stable-rc/queue/5.4 build: 140 builds: 3 failed,
 137 passed (v5.4.214-120-g752560fee8d8)
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

stable-rc/queue/5.4 build: 140 builds: 3 failed, 137 passed (v5.4.214-120-g=
752560fee8d8)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.214-120-g752560fee8d8/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.214-120-g752560fee8d8
Git Commit: 752560fee8d8520e8a7e6bbc75e43ca1d8d4cf12
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    ixp4xx_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
