Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE74DDDBA
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiCRQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbiCRQHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875842F510D
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h2so9830729pfh.6
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8A+xjJaxdxbRDOOAFnhxjgFy4g0aJPcKMM5sO0v/z1w=;
        b=AB1LwW0UWBxkEccDvHRSTljtBp+czSUr8lZO2IUFTc+6po3Vfaa8UF31cLVEjHCF5s
         He1mNkodAcAaFdJ8Br0/JtB+lECY7mZrn32bbDvCxpCqvMu99DBzFxwPcqu+QSJBlE67
         AInkW5Rvs1nd6yQNsTxj+42UBfsccGHXX8ouJfXQZiHEEpoejXjRDopjInFG1egGgjdY
         kDaZtMpBCkiNcTHgccodgOm13g1WiI9gQ4V+F5qdBpqersdG7tt8eNfcSbnn0cLOzDFr
         GpVs1Orql8IhV3UlurkoYJbfzdhq3A0ID8TQzP0KsefjH8VqPveSxZgaxFbQHnJN0K0z
         RESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8A+xjJaxdxbRDOOAFnhxjgFy4g0aJPcKMM5sO0v/z1w=;
        b=fA0yHilBmeGMTHmOATGToqwjtv3ssdyxSGpIZTNR4fftK3ZqGtR2TT13V1ZsmG+oKX
         1MzWrTXL4xtLRVtW1HG0LYH9DMeOFe0bMZHqGiN7mufE3/C6JemqLRFoEKmCx9UI+bU4
         YXq3t7l5J9EsHHQ+i3z97wbifuJ0o10HbYKD0q62i8xlAYzU6vb0J/36ZeaqbLfY332f
         bnbiSqfYdbaBXUThXUvqFcCNXmMmLjxztmdGLuGxlFyy5YSWzb9cmiNRdO/qfyzDZSrZ
         snkYWmXOBhCyY2rigY34n3Fecc1pE5lnvZDzTVu2i7AT9F5GD9ZGijQMdbYgxdKBdicP
         mqMA==
X-Gm-Message-State: AOAM533iGEXGPxQYTs5bVdnmM1NZdBoEYfcabOslJXqjaXbQWC23Y7gy
        Cf3vMoSLp3RfkXW44f9O+K9FJ9G6BpRBDleb8WQ=
X-Google-Smtp-Source: ABdhPJwr3f9TE49Qwu+dxLougYzio1OXtykbovu6cc2pTywfJLM1Kj1X9IEt019uSCKxbRbV1k2Byw==
X-Received: by 2002:a65:6b93:0:b0:380:afc8:fa83 with SMTP id d19-20020a656b93000000b00380afc8fa83mr8441362pgw.279.1647619504715;
        Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0010cb00b004e1b76b09c0sm10120990pfu.74.2022.03.18.09.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Message-ID: <6234adb0.1c69fb81.224f3.b309@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.4.185-43-g6c27769e1413
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 build: 150 builds: 2 failed,
 148 passed (v5.4.185-43-g6c27769e1413)
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

stable-rc/queue/5.4 build: 150 builds: 2 failed, 148 passed (v5.4.185-43-g6=
c27769e1413)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.185-43-g6c27769e1413/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.185-43-g6c27769e1413
Git Commit: 6c27769e1413d0dc612dc1347f79d80adf6b2e37
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
