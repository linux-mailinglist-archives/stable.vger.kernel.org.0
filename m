Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2ED603A55
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJSHHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJSHHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:07:20 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B3E7675D
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:07:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso16195587pjk.1
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EvzWN3fulxUTT42Zid+lfDlFWN9IW1sxQRs0JDSSaPs=;
        b=1oa534Fmx+C99nnI0Mu2xOinanTDtPVmsOqQaOWUPU9tWWOZux9A92dlCOiQYhjZNJ
         8fyJhqYb40QpDqauxUfTdUaWiPtFWwVinHXD4e23a8qQhaDHl26vZo8o5sxagIL/RZTT
         n4tHBpjrW4TfpX+5qWnsVC74TqpfvQkKmBboVrF7mfuzj9KGuaytH0DSPHvlEidBW89U
         CuLMjfbNSf9UpE9SxEC/6rGlTJj9Tu1HCx7VscHpI7jz6bgYZCu8oP7RbDhfop+KRgrP
         pFPk5VksgS9dJl/BMZtwUXAMbdP6ZlZ+u58qEO9NNXeJpo5OlkGbYfvHX6MgzX3yRg7w
         Rg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvzWN3fulxUTT42Zid+lfDlFWN9IW1sxQRs0JDSSaPs=;
        b=GHDRPeH9Wp1cHszR+cm5TIZoPxPuxBbiQmuEEAzhYk1vlAGheyIkSTymqWI49hJ3k/
         gKbG5So9ozzaQLlbwLgBMdeUAxjr+rlaYxas7xeADl2VudJ8zd9FLh4FXkMdygDw3H6M
         WFd1CmhxTTbK1zFrQh/CHtEuZa7SyRR/Cyq9VgjaDbhwzej62vubqVCQzwkH8Cfq1RAG
         L2hTHexdcpm2Olhu6G16wAL4VODEjETe1rDS8HTWxlR18VG30ztMChJA2q1UwNcw0TNL
         s0bPudBZ4oMYmXxz3J9RKtUSXMh3in2zpZafesH1CCn/wcXHusVIsoNDaXa2fYlYPpz3
         w6Sw==
X-Gm-Message-State: ACrzQf2xwvd8EQ7Lh2Q/rwmm2FfmlXmYUVOyy9YyJanJRlcqIvztakIB
        c7UWDv4VxW93eKs/DtRt/QfH083Y2NLbZHWX
X-Google-Smtp-Source: AMsMyM4iWUZgwzcdV4Ch4pp03yEutHWRHs4ioQ9ar3IoHMH0r9UbtmoAmmvN4QDLmZ3zBBXLB9rmfg==
X-Received: by 2002:a17:90b:1c8b:b0:203:dcf1:128a with SMTP id oo11-20020a17090b1c8b00b00203dcf1128amr42114773pjb.182.1666163236565;
        Wed, 19 Oct 2022 00:07:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id px18-20020a17090b271200b002001c9bf22esm9178320pjb.8.2022.10.19.00.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 00:07:16 -0700 (PDT)
Message-ID: <634fa224.170a0220.c089.0f62@mx.google.com>
Date:   Wed, 19 Oct 2022 00:07:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.4.219-266-g5eb28a6c7901
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 build: 189 builds: 3 failed,
 186 passed (v5.4.219-266-g5eb28a6c7901)
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

stable-rc/queue/5.4 build: 189 builds: 3 failed, 186 passed (v5.4.219-266-g=
5eb28a6c7901)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.219-266-g5eb28a6c7901/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.219-266-g5eb28a6c7901
Git Commit: 5eb28a6c79012965385f3cac7adfc03fe7021108
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
