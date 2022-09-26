Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4B35EAD0F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiIZQsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiIZQrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287C780E99
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:01 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d11so6584268pll.8
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=DG9FLCqKpPIUKVJEE+ybYwXQKtYR57FctxLE7bb35uQ=;
        b=CWt5C9PCM2HJSap2fXeFOKSha094d+gkg0KifACb2NSbyfuLyG6KJNYxcGAhPb5rOG
         nw20E3XdiGyCwjJtX0YIs7AKjjvYUZgru/+6WTLKxRGb+q5nrhAOkDxDl02+DZ8dAH76
         aQ7ZSZAT37yTXdvaSUtx7gSukUXpxzp6YsuMVVj8L6OkBtHR2nUtuvAZSJD5zUrH8YEH
         SNw1UOYNqb1gGJhB4IgQFuVr4GhMiWwst2vqi/w65rgGX1U3YrfEdmCT8d5GBvs7GkT5
         eOhue3tDu7EPljyg1LlFo8jtKazgENQFIYZ6Zf5POzEmrNRroVHOSgm2AA9SVtfTJMhC
         nE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=DG9FLCqKpPIUKVJEE+ybYwXQKtYR57FctxLE7bb35uQ=;
        b=mwlP2AktMvh0g4rmWfWm+zSQwzOfyhGDLoPl0rh5Tp9NYLXR222B1BHlk4O8GgOB1O
         +KC3Cx5x5xuHJMKxtmVBVgsiCAuyCAg0T9TNfiKUwXgst7WOI/PXQARerJUW0S7fw5XA
         73YhMnznJX5yOvcanJCs8HCB/THAIzlLyAnvkgugffL/vjw/LDk/Gbe8Rxtmu3fp3AZY
         AkYLuURviOv742WMUyH8z8Q4BPHh2I1Js3/QGcVN3iFiDS/+5M28MHJPdYaagA6Qjgz5
         SZeazWPqyrv/nwbQ/gjkWZzy+SYXsA3lbAtno5gkHWaKD8WW+CMdiYT3kOGwfp4JxoHX
         ISJg==
X-Gm-Message-State: ACrzQf2cWHHPKLK4rzgTlaWDf8ALa78yr64rGJNof2Qu275xMzML1w2s
        VsO73ANhHx/cytlYW0jwPsgOMGUchk8o6zTY
X-Google-Smtp-Source: AMsMyM5HxK6hARZl6Na2lty90BNcLtaZYlDZx8B4bCPGbcq8oKU9rX8dAW2uRQtd5V1e1bDHrDcbeQ==
X-Received: by 2002:a17:902:e782:b0:179:da9d:6b8 with SMTP id cp2-20020a170902e78200b00179da9d06b8mr6008812plb.50.1664206860526;
        Mon, 26 Sep 2022 08:41:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090adb4600b002029e3d5cb8sm6707098pjx.34.2022.09.26.08.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Message-ID: <6331c80b.170a0220.f2b59.b400@mx.google.com>
Date:   Mon, 26 Sep 2022 08:40:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Kernel: v5.19.11-208-gf962b265cecbb
Subject: stable-rc/linux-5.19.y build: 151 builds: 2 failed,
 149 passed (v5.19.11-208-gf962b265cecbb)
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

stable-rc/linux-5.19.y build: 151 builds: 2 failed, 149 passed (v5.19.11-20=
8-gf962b265cecbb)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.19.=
y/kernel/v5.19.11-208-gf962b265cecbb/

Tree: stable-rc
Branch: linux-5.19.y
Git Describe: v5.19.11-208-gf962b265cecbb
Git Commit: f962b265cecbbf1ee2711de3379cbbe66eb921a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
