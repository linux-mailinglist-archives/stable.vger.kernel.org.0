Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7874DDDBB
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbiCRQIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiCRQIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAFB554A0
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i11so6612338plr.1
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K9ZUNGnZA/pL8dsg7Yrljq68OIIqg7QOajz2MH5vs5I=;
        b=KBCMA7ZFKeGNhozI4u4YC1KCFld181lcmrJt/sUKyQjlOm1HxLoDh2JrvXUd9DF1Tz
         S/jsy3bRtlgSDdPSShRPbJbq94+NHnBOc/HQdsiaOKlUc4zDAr8M++XrUENW1SqGwWYi
         jUxGbP9jmYFfsid+ngqNiSFivsm7ORPPny1DNDvFoLTc1kLmEBAwwkd0gTDkNG/DKahl
         /zAvZp2t7Uu8BpEXRgFC9okZygsR/fSqYQjWYCyFLpXXs5eRDDijwUuHwTJxYL2ix3eA
         OK+lBWaktOhUilhADqyHgP4MT8BXVGOI0B+ixg+fYwJ3sfA/WUUQ1GiSQIqUJc+gVern
         fBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K9ZUNGnZA/pL8dsg7Yrljq68OIIqg7QOajz2MH5vs5I=;
        b=iliGygl3SL3OIANKHXhQFkZRWD3NNNPBy0lk3CymbUimmPTOFLH0l6cBrU9wMpbTZq
         zC6BdBakkkFRbCvcQssMmxgCLOGomCIvin943JZpZ8G8ZFjRdFttVhpEHlRB/G7D8LHd
         jh8abbyawzgQBEFwbb0iR14SOkARthofUQ7BAwFOF9l2yYqdRmku6ZfNaSAcWtcYWWYH
         Vamnx7GPfaIG7M7Iw5yUZM704x224pit2HlZv6gk4wfnNqkEVgh6THQNWJ7u/plTloPQ
         JsGXlbb4hiJ03Nfut1O0VQKkEGNstJocU6hg/+skbGnZ8csqOS0RkajQWVxVf3gH8AzQ
         8rpA==
X-Gm-Message-State: AOAM530Ru+UF2NkvvSmzmLPiMAiE60Yyqsnz2Y6jfdeG0t6B+FER3UIk
        5T4m4aAtaN/IdtZ81Rik69r7DCcL/9fh16Se1xA=
X-Google-Smtp-Source: ABdhPJzxUNzLQYnfZmhRTsa8vqMBnr43fAFe9K472lkvXW0A7DI4T6SrLAvFxOlK1Ni9DVq6NX2tOw==
X-Received: by 2002:a17:902:d2d1:b0:151:ef69:c27d with SMTP id n17-20020a170902d2d100b00151ef69c27dmr176522plc.34.1647619638582;
        Fri, 18 Mar 2022 09:07:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15-20020a056a00198f00b004f7109da1c4sm9894075pfl.205.2022.03.18.09.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:07:18 -0700 (PDT)
Message-ID: <6234ae36.1c69fb81.64384.b3a6@mx.google.com>
Date:   Fri, 18 Mar 2022 09:07:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.235-22-ge34a3fde5b20
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 build: 197 builds: 6 failed,
 191 passed (v4.19.235-22-ge34a3fde5b20)
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

stable-rc/queue/4.19 build: 197 builds: 6 failed, 191 passed (v4.19.235-22-=
ge34a3fde5b20)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
9/kernel/v4.19.235-22-ge34a3fde5b20/

Tree: stable-rc
Branch: queue/4.19
Git Describe: v4.19.235-22-ge34a3fde5b20
Git Commit: e34a3fde5b2093fb81947cdeeb4644b696a1448f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

riscv:
    allnoconfig: (gcc-10) FAIL
    defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
