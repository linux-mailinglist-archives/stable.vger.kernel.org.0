Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7167B603A54
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJSHHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJSHHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:07:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9203B760D2
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:07:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b2so16084271plc.7
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jUWo5RSlVK6JcLHNIsMFESbE+8PjIJu/0TmER89Ejbk=;
        b=0o1p+gEVFm6Ql1KC+puNUyGyFyeR0UYZmUAOmHW9DGrqjKBoISQx6WlICoeqJX9PwV
         u4J8kPTRIH98/G9SkM7aAMYRwE8zFBd7F9YQnGh21BXvFFO/fN3yP+WArQ+ILGjjPzzY
         jpQlQmrjz8hVx2OjF/Rlw8i6tRRRJyTxBaxMfn7M/Aqkk1VYQpBIUaQlNNcpDPbau0Pj
         ZVc2pHF6DidPjy6AtLWPH2G8BeQJ7n5IaiP+/PT4pqCXudE3X8ySR3ki2KSyPdH1u1XB
         A003HL8H8ekePHSKVtmDau5Vy9xgJUQIghEptvSNO9pe4DLlATJQbt1OntcaCeoc6HAP
         uk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUWo5RSlVK6JcLHNIsMFESbE+8PjIJu/0TmER89Ejbk=;
        b=04fUS3fQQ4AKu/SEPmJES9lWaPK1tO+tGTf8RQUGdb5G0/5RP/+Nat3c/7FEik5+Qr
         DZ5xGYJpHY3yTCRCJBmglRIaXb2qanq4iq41Cgz0OhwWHj2Vh4dFkajwm12lUDlhSdjS
         OWHYeEz5oMq9ayQ24cfuIOO2TYMbvydmZPE/ECrMhpY0tyC0hJ4WZZ773QPeZRroUVR0
         UsWGk9mA0U2yNsa+JqFPWLTGYih9CDgzonITUOmvt9hPHpAg4y31MEBM4exoxXc4jKoR
         EuVISaYsMEegq/nrNO94NtU0BDIidyPTlBMdWtuawxdeK5UO3G455C/ziS/9mMmXrWF3
         PkKw==
X-Gm-Message-State: ACrzQf2PlUTza0noE/seqiISX0nviE6ZA5RE7sBOrx8nWfkVe9u0qDbG
        k7BU7Z26NvXD5N9z33k4dLSp+25kjKzrUtIS
X-Google-Smtp-Source: AMsMyM4Fe/9DBNtPPnu45UaHaEViKy77enaXz/ehcFvotrXxSJ8eIOzNukZAH+fh10QvQYX3SKjYFg==
X-Received: by 2002:a17:902:b717:b0:184:4a5c:c74a with SMTP id d23-20020a170902b71700b001844a5cc74amr7250820pls.0.1666163236287;
        Wed, 19 Oct 2022 00:07:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e80300b00184360e5d68sm10078819plg.268.2022.10.19.00.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 00:07:15 -0700 (PDT)
Message-ID: <634fa223.170a0220.d844e.2cd5@mx.google.com>
Date:   Wed, 19 Oct 2022 00:07:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.295-212-g929277279603e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 build: 195 builds: 3 failed,
 192 passed (v4.14.295-212-g929277279603e)
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

stable-rc/queue/4.14 build: 195 builds: 3 failed, 192 passed (v4.14.295-212=
-g929277279603e)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.295-212-g929277279603e/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.295-212-g929277279603e
Git Commit: 929277279603e1de121e0f6da111054069a58421
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
