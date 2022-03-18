Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970FD4DDDB7
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbiCRQHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238522AbiCRQHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:15 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136AC2F5104
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so7755045pjb.3
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UJ00Q6434qjFlqA3EFUngxapSCQdJekLAViclTCtsu8=;
        b=ua9SzG/2IM1mxGYPulOn6CkGoS099AGGpkRCSU+IYBxDhQS9y3IW8yQ3rSQ+YoO0Sx
         cuF635OGqblCKV65VjA+q5PzPe9MMzygJ3KEZoZbQTnIefkc49EY7+5p4ecICO6ljcht
         UFo+st1gwHyBpiOYFXHs4tC7xlETL7ua64rHq9OdFG4Ub4SdDa4lNKjnsPYMJ/6uo+mk
         k98kiCHFkPsP0l8es/t/UV/qMFwYnnJUqQfkzyNxtwlfzPMtzJ1De1OIsi1GFz+2SnAv
         G32AJ/o2kUOCe8hT4yD3FlBw6GwTEd5XiesDNoIvnPRVwQkMcBKK83Kxxx2urbh/6fKe
         x53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UJ00Q6434qjFlqA3EFUngxapSCQdJekLAViclTCtsu8=;
        b=OCcQ9lcdq+vr/KyphAcAhVHY+FSg2KCR83k60Dox2Me8+hxTjJE7tycTa83Z9FRxS3
         L7u9ruvRpO8N5eputLMXugK0DPeObhyDhpjE9UYKeoNTKQd/PFgSwtGCNsNbBHLWMuWE
         o0U7kyZFd1kjyKZR9ppMDhuGwlEycaPwanHYOvZ0nrxkiRaUvpJjqW/3Nr1BRDrk7xjT
         2Bn7UhGgcXnT3u5Kofijp0nAmkYIngW6C3JcRt+IlftpsmeuWSt9MPkiUevSKggeAFkf
         X9Icc0CtaMpjIQAuD84sDfNBr664h2EYtq/FmfNybXhH1n1obn4LT1xECQanm/hFDzdD
         vfjA==
X-Gm-Message-State: AOAM5314Dam28oK1SSHHWRyFL1xj84TgQgbOepEsbGMCCmoijO/u9vie
        9+FwA/2i2XECh0ad2i/XGvsOTdsWrUZaJY4ImHE=
X-Google-Smtp-Source: ABdhPJwu4E32PiOTNV2yzxOPpCV0mMhvIzc/LKdroizvfNCySZX2LGUNCzbfxghIGZsw8W7ZcK3n/g==
X-Received: by 2002:a17:903:2cb:b0:14f:4fb6:2fb0 with SMTP id s11-20020a17090302cb00b0014f4fb62fb0mr129848plk.172.1647619504923;
        Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020a056a001d8b00b004f74f8268cbsm8542482pfw.85.2022.03.18.09.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Message-ID: <6234adb0.1c69fb81.47150.86ec@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.19.235-23-g57e593a4ee92
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 196 builds: 6 failed,
 190 passed (v4.19.235-23-g57e593a4ee92)
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

stable-rc/linux-4.19.y build: 196 builds: 6 failed, 190 passed (v4.19.235-2=
3-g57e593a4ee92)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.235-23-g57e593a4ee92/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.235-23-g57e593a4ee92
Git Commit: 57e593a4ee92b5fddbab3367340e9cb0300cc241
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
