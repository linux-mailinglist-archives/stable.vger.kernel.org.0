Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048DB5EAD1C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiIZQs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiIZQrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AAC80BC9
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 129so5473642pgc.5
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=1kvJgdT54GY2HcGbrtiViGErbs3ssMsxGEHkAI1hvrs=;
        b=AsLt1ty7k7sUK89DosXt9mG6aReHldcCpu9+TMLAE9vi6Z4ptOI722siy1tfShFYrf
         0iclDlSgj7BHzyEqNkBSijVh/jKieX9HmT2zKE3P+1OqhE+1WZhWFpBxwKBClPQy0pO7
         LmTdF+Lc8mEGxsP1/0FjkoGvSMXILekD4jH8ZXrfT4SZc53GXInFGh/DcITUlw0rOIN8
         5rACM83eDBVIFqqskI8dtyTEnMy4Y1MZDQs/EVW8cZ11Y0d0OScjfiXeAW5FnZV5pe+s
         QF9JBm4SEQth7VRsxjgvAoGBAD0l7mDXCEYZKKpciWKDXQgvfQeUG7bVRxZgYYT7EPlj
         bDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=1kvJgdT54GY2HcGbrtiViGErbs3ssMsxGEHkAI1hvrs=;
        b=cz0aIC/7tWOTUaGDOUf8rnh0DtO7uvSnMgn4ipqQS8t6AcLCF8VW/ni9nA54Vq6xis
         P4epGlBnpWYFJvtO5OQKxkfpD9QuFHgcTu0r0DnyTWoWOESWLvQIkeNYcdY+AGsuh5FG
         zS/np55I32f77C3j/Iq1wkvBs6U0lcDq2mIikOBetWWf8GuzVGdp6ozyGoDtV3kQwj+m
         qUPkLFWgqcDnT59nrYwoe0l+RMvt5NMnm10Tn+l0b8H2yicimbi/6KmwZZSqSbOc7AuL
         /VVF1at9Jbnq2G85RsNk70Xh3KFFCYeW4IA0yFW/TGmXO/pr1VhG6c9C0PTnkOYVYAp1
         YeSQ==
X-Gm-Message-State: ACrzQf3zRrnCg8lH7qVhBI0gxH3fwqz9JvH9Ez+fEyhi0fLVagC5tjTs
        7od1F7JzkkT3fUucCC8hgo5wJ9AjU8AC8rHi
X-Google-Smtp-Source: AMsMyM7fquUhf2CTW6jb3jIMUfzmxOgFkGUBr8Cq8qGVFojm0g/ku/Bqxe7KtDjMWh5oWL065iClZw==
X-Received: by 2002:a63:982:0:b0:43b:e67b:988c with SMTP id 124-20020a630982000000b0043be67b988cmr20722558pgj.35.1664206859548;
        Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b00178b070416asm11378174plg.36.2022.09.26.08.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Message-ID: <6331c80b.170a0220.a95f0.562f@mx.google.com>
Date:   Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.259-59-g380dcd7a66234
Subject: stable-rc/linux-4.19.y build: 181 builds: 6 failed,
 175 passed (v4.19.259-59-g380dcd7a66234)
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

stable-rc/linux-4.19.y build: 181 builds: 6 failed, 175 passed (v4.19.259-5=
9-g380dcd7a66234)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.259-59-g380dcd7a66234/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.259-59-g380dcd7a66234
Git Commit: 380dcd7a66234bfd8277cdd8a5d1396113ab12f1
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
