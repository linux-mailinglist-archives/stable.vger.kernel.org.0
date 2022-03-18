Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3B4DDDC9
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiCRQJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbiCRQIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:08:00 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114497307F
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s8so9780947pfk.12
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hUZOHrb7QYJ6t2mpn11kJvJ8mII8S0lr5TxGZ5xBMCI=;
        b=m8QllEtTNMeUui+XrVdL4qSNSwrjhKuKxgIfxV6pM5WLkhyMg2SkGrzW4lWPKLcad3
         Sqrd9voD+0daIqrmeRxCxhJdCh31BpqNkS605wLjOVU86/qgTVlP4syHqk8aTtSEWFkH
         K6dFxlNoItEZY7fUCV2hmo6OlE40hI0IzAwzu5U8YmtFqRXYr5Xgi230ju6Sxk8lyCRv
         rzox14UzMXkC+l+zpapW4kawxk5gd3HyDXAEG6DZrPwgbWrdrqat1eonE5/FUv1+rlg/
         IrKeptM8mkiu+O0dc4Soy3CBfLecBSylYE/48IxryCYfv75tM2JykBzf+qQBcS4WOSLu
         8gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hUZOHrb7QYJ6t2mpn11kJvJ8mII8S0lr5TxGZ5xBMCI=;
        b=NJgeXt9+t4DR5tmpgEfp+LupVUi2d+RZnCoesQx/dcDV+vdDlp5LWxHEZwk688z8vK
         suao4AIi7c2qzb1/es/puL6B0AspQn+qKf85+kwsQ6vsCqY1q2+bZqzusENgwzzKUXoH
         aFNtjk/s9yEaz7q2LsLs9VkfalXA6a7cIJpuj0maUeFYhmC18MoH6YhEHDIdKnfzsvSJ
         D5xwGPZC5Vlp6r/DZ742nxoFtq1DWzM556r7pUmEPqZ3ax5/uUnm5SBUXU/KqxOgVA1x
         N2Jqbrsfusu3fXH2Cj38BLcWdf0fj0v4kqJjVG7TfV3D6plPGYUofStIRiQYmOvraAq8
         djDg==
X-Gm-Message-State: AOAM530G6qSlWGfafIuTh8zRZj/cBOAP8QD0a/AAbmz+fQItI7n8LNt9
        l8AMdIxD9RmWbCN0dL7Ew8IipR4rEwCUFPhAfaM=
X-Google-Smtp-Source: ABdhPJy1dM9PPXC6gmV+8zlKdgMXBOC6TwXY1/onDEkWKYXditihpA9SWlF8SNqjNW48b453S+KDlg==
X-Received: by 2002:a63:2049:0:b0:381:31b6:a317 with SMTP id r9-20020a632049000000b0038131b6a317mr8455603pgm.356.1647619597368;
        Fri, 18 Mar 2022 09:06:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8-20020a056a00098800b004f702473553sm9831250pfg.6.2022.03.18.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:06:37 -0700 (PDT)
Message-ID: <6234ae0d.1c69fb81.af4d.bd77@mx.google.com>
Date:   Fri, 18 Mar 2022 09:06:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.307-11-gb2c5ef60cbee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 build: 171 builds: 2 failed,
 169 passed (v4.9.307-11-gb2c5ef60cbee)
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

stable-rc/queue/4.9 build: 171 builds: 2 failed, 169 passed (v4.9.307-11-gb=
2c5ef60cbee)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.9=
/kernel/v4.9.307-11-gb2c5ef60cbee/

Tree: stable-rc
Branch: queue/4.9
Git Describe: v4.9.307-11-gb2c5ef60cbee
Git Commit: b2c5ef60cbeedbc43d946b9ff08ab4d8449dd9ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
