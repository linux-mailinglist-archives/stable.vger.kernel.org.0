Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C115EACFA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIZQrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiIZQrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:47:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A350619C34
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r62so3065144pgr.12
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=8ran2fwlzNO7rDlu2tzhdQ9tR0QQe2NPobAZFH+R/MY=;
        b=xg149hxkEJ7yikY0TvgC7r1D+GgABz6//YeaPPS8sV8s1Z7R0uFWKpVGIw9/1Vkl19
         CpGs7EnEfSNSv07i7Xp2R/UkCEzGeyr1/JIJBcS1Fnju9VgFCiov5ba3eiAVZIBlHQFY
         L7l0whUArBC+7SGNDJU53npb1cuocYEfcBZdtbi4nhKF8vil6C877fyRpxUAU4J7r+29
         O5mlax0Vp9NWTGkF3m0Ld5wPCgDxwdbOBnFDRPnwsV9TGeGv/yCZ6JYoavcmMR0intpx
         5EGBZXbw+fd9CVgh6RsiUuePoQgPDE4NEjOUyZJEeRz0RVmhMGV3jyI8+DxUG/P229RM
         aEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=8ran2fwlzNO7rDlu2tzhdQ9tR0QQe2NPobAZFH+R/MY=;
        b=T7ePUnzKMc/v7dN62OX837q5yLy2nmN743qmEMSEzW2ccNezWzY8hNGBW5/DhBgElv
         Y3W8X3mrJBMoC+z8AvVdv5BhfLstuX+ApCORjcriJhcaouzKgwQBnvVXzBXDnz3e6MqV
         QwkcmNJWg2y5EklZwwPhTNxY1kpQshrRJH320ETa7LVucc3hAbi72z+V3F9Km2iuSjVk
         4/XBk4GqS1rrRrgesMM5wJNHMel+bnmuo3JqX86dmVLeHts9Z3CtZpNrxaNZUVHELgxC
         LKkysmvkKxChp76JqE1Bm+GeHTPIS0pK045aWaDvk572Ak6/tGGVLbkCjp8sJy4xYdUK
         NAiQ==
X-Gm-Message-State: ACrzQf16+9z0BZjUak+dZcYPu15uh/vdITas9gBiZ/jcKfGW8flFHyok
        uOc/YUsTuerMwvEKLn02Xv2ZFbpMVbpKTSqy
X-Google-Smtp-Source: AMsMyM6fWx4DcJm+bsR3OiVQLB8K1vlLvWRQwXW9x/KHXoWpjyRc4UgSxJj2yDZrBOg/BfEuI0ZdvA==
X-Received: by 2002:a63:1945:0:b0:439:d86c:3343 with SMTP id 5-20020a631945000000b00439d86c3343mr20589145pgz.402.1664206778667;
        Mon, 26 Sep 2022 08:39:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q7-20020aa78427000000b0053e3a6f7da4sm12727848pfn.12.2022.09.26.08.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:39:37 -0700 (PDT)
Message-ID: <6331c7b9.a70a0220.fe639.76bc@mx.google.com>
Date:   Mon, 26 Sep 2022 08:39:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.329-30-g3b0489145be2
Subject: stable-rc/queue/4.9 build: 143 builds: 3 failed,
 140 passed (v4.9.329-30-g3b0489145be2)
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

stable-rc/queue/4.9 build: 143 builds: 3 failed, 140 passed (v4.9.329-30-g3=
b0489145be2)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.329-30-g3b0489145be2/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.329-30-g3b0489145be2
Git Commit: 3b0489145be2a7dbd4a897de371815c30c946718
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
