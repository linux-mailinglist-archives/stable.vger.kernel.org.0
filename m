Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15794DDDC1
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbiCRQHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbiCRQHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4572F5114
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a5so9862778pfv.2
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=01SA6tnEtX6CjkRmPYVJJG6owThqcDce4u9PFm4596E=;
        b=iHtXmNk1jP1sOF04yG03LXWAzIL1wZh6ro2VYDnrVTdmBcu/42Y629/DMZCpwALDQO
         emQtYbroI2V0XDhEtTYHIha8Op/7zj2GSiXAN2xisM6qEstm4ICIgyxZ8dX7rs/7ElpP
         5XY8m8vGq8p6FXxgn1UNyeii5Is5dEIITw1UX8K8cbIGzboduv9TkL9Xi+M3fCQSUIzV
         iKOE7EKgkyiRctLjoBHFCL6UJSbggL/dx0pnr/I5XUDhiK08E39+xSnbHPe/UvdzTuAc
         UG5eySdqa+11KS0MEFH3qzX4aEcF+nPsejJDyS1P1pG1ljK8jSpPj7YQxvuIC567mJ6p
         SoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=01SA6tnEtX6CjkRmPYVJJG6owThqcDce4u9PFm4596E=;
        b=WRcoLnyK7cxe7K5gSegfAPXxgiPbvTzmtXYm/u8zidaIvpW4/16VasjfmMH3e20kP8
         wVLsnkgCTn1NjAAVJAsr3pUNOANTeXf3jxxg52D8uMpcTz4LwMpkxGVTrIRIGGycI29G
         8wGpGmkfFBpAkpUdv2NRneeOWxO1jbWEgCov6+i+J/zOzlFJY0JJpC6q0UEdXsGzP3X+
         9tKsPJCuX4LcSEpxuY9iVJMYYdoZSpPT5pQqnsfeUPeHApvUr1Y8qfDqMt0CtaomeBYu
         Em5BGs7gjFTvJ7X60/xegg7CyV4jrt8wVzxQVTIV+fdR7ZuuRoUfuSclWpNRnqGqI/Up
         yayQ==
X-Gm-Message-State: AOAM533Xdqzl6VydZrEMhMHNuoR8Wu0wwhBXpbQ1G3sxnIEh81eJp2DC
        9mJ/9mvgHswyHlEcKi43HPdAU49maDTCS5Mj/FA=
X-Google-Smtp-Source: ABdhPJyww74rKIUd5hsCGPwWwLN5l11NiJl1uEpJ/e3F9g1mefUlqJc6Z1WoGFkPBsFFFS5vMgUDZQ==
X-Received: by 2002:a62:7e8f:0:b0:4fa:2ffb:810b with SMTP id z137-20020a627e8f000000b004fa2ffb810bmr10844470pfc.19.1647619508963;
        Fri, 18 Mar 2022 09:05:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14-20020a056a00134e00b004f83f05608esm10340550pfu.31.2022.03.18.09.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:08 -0700 (PDT)
Message-ID: <6234adb4.1c69fb81.418c3.c523@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.29-25-g24c12ba5bbae
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 build: 179 builds: 4 failed,
 175 passed (v5.15.29-25-g24c12ba5bbae)
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

stable-rc/queue/5.15 build: 179 builds: 4 failed, 175 passed (v5.15.29-25-g=
24c12ba5bbae)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.29-25-g24c12ba5bbae/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.29-25-g24c12ba5bbae
Git Commit: 24c12ba5bbae8b4cb642d79b8f31305292b9ee84
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
