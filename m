Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2634DDDBC
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiCRQIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbiCRQIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49AF2DF9
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g19so9807636pfc.9
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PAN09UJJmMafgvIyhM1EVT9/VJnwFv+U6uGheJIR9cQ=;
        b=iD29tdqOQCsGeKSUZErweDSmeN7qVEv9JbjaZbmb4YjtyM/wox0xk2hxiBf0xx/U9m
         vpc0UVZQqnvNPiNpSWYmqL6jytUxRj7zPf8q1iVShKZnOcYgGRg6lyKoBiJIDnR9cHmJ
         dEqtTZuYAFJkM/J8hfNM+Pis5pEwStvizRN28VyjcAqDEz+T2g3tU2A+yqN88skVc1+4
         4UTEr/jjI7Uwuupy0z8RWg05baIATdVMMjP3MhDla2WTja599X//YBgei1tYjSPx37N2
         RsISfOE1KR2FQr6KQ9ArOiUqQIIje82K9u29azgJGu4qGbwVRO6bmYx/StyIqKlDBkbj
         TlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PAN09UJJmMafgvIyhM1EVT9/VJnwFv+U6uGheJIR9cQ=;
        b=z9Daegq7JJuANgjWSTGcEdE6igz79mobR8tzvIODXuJ84m3Au0Bp8kPgkD78pZ2Jxt
         Kirr9D/U0rdEgW7oEj+acIE4MtoQCjzUAGJ23Bn7KuBudvluq4q7jGYC0KVYyV45QyfF
         gNX+vTa7fJft2dzFMbHItd7ZFSN3JPr9VFlHhQ/uk3i4XH57YgnCZ96Q1XewihFsaEyW
         Cshj8K2CwuFWYYocM/WMfxARFzCfhAQKSwm4RXReQ1ciOOOlFXOztcazCz04A0J9rqKV
         e7bVagp1AnazrVHZnXqdu0Xv4VTAa6WcLFyB0k9vnyJl9YxXJ+/FMWCp6Yt87+CjafiM
         QhWA==
X-Gm-Message-State: AOAM532Xh5TsqnqoSXvt12ZeiI9TYA+RmUBfB3Pf+QWWWxi4Jz/HWF6a
        ySzGCIowQ5VLwg68G6d7w66xvr4TzsMU6SSi3aw=
X-Google-Smtp-Source: ABdhPJz/PBKxetaBKL9sg2jeWgMCndjPGwCGBhRM1flRtfu+L/kfqTWtIsVKnw6D1o0/BDJv4itF4Q==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id l14-20020a637c4e000000b003808ae9c975mr8561443pgn.25.1647619633120;
        Fri, 18 Mar 2022 09:07:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm8610432pji.18.2022.03.18.09.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:07:12 -0700 (PDT)
Message-ID: <6234ae30.1c69fb81.28f97.81cb@mx.google.com>
Date:   Fri, 18 Mar 2022 09:07:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.16.15-28-g8e8af655e8f9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 build: 145 builds: 5 failed,
 140 passed (v5.16.15-28-g8e8af655e8f9)
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

stable-rc/queue/5.16 build: 145 builds: 5 failed, 140 passed (v5.16.15-28-g=
8e8af655e8f9)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
6/kernel/v5.16.15-28-g8e8af655e8f9/

Tree: stable-rc
Branch: queue/5.16
Git Describe: v5.16.15-28-g8e8af655e8f9
Git Commit: 8e8af655e8f950a5cbb7298d672be7d9435dfe93
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    qcom_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
