Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E207F4DDDB8
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbiCRQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiCRQHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A11A10CF03
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:40 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso4575196pjb.5
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9lVOy6DZKYrDGisjN04pIJ0+P5KXPE8UIIC11Fz1udo=;
        b=B32VPyhzscQ9ZBdZyDOKlA+vppFYbvbucRXw/LFdd84IWerugquOdRtyn/WzuKaPkl
         3h9s92ZlIrKGVqx4UQdhQQQy2Cng7yRJhjuSJCJg4OPvyZfa0+K0hyQR7ooa2sgxmBD5
         1rA1BKyyFEZHXCB88O03wDkvn4q+odsfcZudLBX1FYaFDY2Ql6DLNKoCsdogjN9Wgsvt
         uUCivRZb6zPr8BIChqEdIloOQTJXORFJWrFCjH64KCKrrZIQSfa5qLGGz8+lCyx6gq+L
         RXcu9fP1WJYWuBZopZLYaNz6gE2oH0KRwTE1WOwYdbWtIxzUE1ku+eeVPQOsHhuQHvPN
         zLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9lVOy6DZKYrDGisjN04pIJ0+P5KXPE8UIIC11Fz1udo=;
        b=IvTk7aaO0mNTd0oqzVcHY28V3DK/ukJ+nDv6CPWFG2CRj6nVqE9ZA2yHFWITgZOM3k
         k3ElnB+YlsjQVV/yHQUi7+MIDiSoVmXOp//BjpIk5vaGfLU128snjXGrQKlvGxq6GsA7
         tYHgftnwYxGdtjAlGf+8SyQMbKuYUUDQplRRcjnZebt721QegfHKq+gZ5rbSaJH8jXEA
         O0Nc0wmtYkNcBtwhqS6HEnWsxk1ioRZtVOhcLSENvlPS5fiLPKPbpknxI+hhJRhbk3Px
         twUaNvrjIJKh02x6iG+XK8S6LuNJuZeB+y06dB4MWBXxb1iHXov7kJSlMNF2OYScLBJJ
         nBFQ==
X-Gm-Message-State: AOAM533UUh5q0OVmedlFinXQZKxLnNKkSnY5FCLoU6BzJatfTSyS1sJP
        OETozS17TE/UAwudTscrCbWqWiEDLE3C7F/DIzM=
X-Google-Smtp-Source: ABdhPJyBMFOSmyn/R1d2HMCv6K3ewt1hz5aIuVV0CvkwMsOawHNYRdHg02C4ayCYFK0h+AjuvaAbwA==
X-Received: by 2002:a17:90b:4c87:b0:1bf:7ff7:4f39 with SMTP id my7-20020a17090b4c8700b001bf7ff74f39mr22498072pjb.163.1647619539834;
        Fri, 18 Mar 2022 09:05:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a056a00188f00b004f7675962d5sm11135134pfh.175.2022.03.18.09.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:39 -0700 (PDT)
Message-ID: <6234add3.1c69fb81.135b7.dedc@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.10.106-24-g0bacaadb448b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y build: 167 builds: 2 failed,
 165 passed (v5.10.106-24-g0bacaadb448b)
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

stable-rc/linux-5.10.y build: 167 builds: 2 failed, 165 passed (v5.10.106-2=
4-g0bacaadb448b)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.10.=
y/kernel/v5.10.106-24-g0bacaadb448b/

Tree: stable-rc
Branch: linux-5.10.y
Git Describe: v5.10.106-24-g0bacaadb448b
Git Commit: 0bacaadb448bb6e89b0d77369d3b7b7c09d8a776
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
