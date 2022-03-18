Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C1C4DDDB5
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiCRQHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238563AbiCRQHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:07:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A60010783D
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v4so7770037pjh.2
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 09:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U1UQFab5xlWJXhY1+IHq7C5Hos8jVdX4w6EAg6QCobo=;
        b=z1BA5vo7uuqvRnZcjmkrFD21OqeboPte6QzjY7S1rJg0jXV8H2yqbHdzHWzHrmKOwl
         nGEmD6YT6354amD1S0ZC583E2OWJuJq2laZcP/cHU1teIxjreYi232+dCHQKbZ3HOYmy
         y+qt6ab7fu2DhTM547omb4/2uopBm/OvUl0cfc1XyKpRFSU3fCzN38mmnGBovedMRkhy
         dTJmBQHXSJTH0HuRZFb1uy7A5HPlqfNwzoCK826tEPlo2v9V1IgC2w7XSx8Hlqic/fx0
         TUegqFVbdM8YtjdilswmxpcbbFJ/U/G0++q/8w7MCWp7sr9wcf7OG4apg6MeVOaMzumT
         LnDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U1UQFab5xlWJXhY1+IHq7C5Hos8jVdX4w6EAg6QCobo=;
        b=iJuJdyCX5vQd40kmJZB6so2BZ4nzYnSbr3JYaOyottN0XIQAC/HdXU6CCMJ2x7Xisl
         rN2KwH8xuimb4BMJNQYqgYTW++x9v4MkNJLIhQsrMuTWuCepZlrDIwKtjrJkYXinhiHK
         V9Dr/0VJc8a73aPQvp0KKB02+KPUYTHG1T9NbZjavIePJPhLJd3spu/Tjw7i7/qlDsRA
         klvWzirn7n3CTjkI9sa/gZM2QwIfi6KqqLp9uWpXyQnTwr5zw/73G6/u8w14Zp38yy30
         bfxAJsjWkctQzfIZP3nkXLYThStML65NNm4swMj0qPoYeyIrihWjqKZex+AwZ2FOPPYe
         nbkA==
X-Gm-Message-State: AOAM533OHybjGhjaOxGQxo4J2Fs7xMKY7qohnsNkQCZjwAjLRz1DnkIm
        WiDDhg5D9TAb42QTBTeAuvdpYs/XKE1/GTX9G3c=
X-Google-Smtp-Source: ABdhPJzp+aqe59gp6kz1uy80wNJ37Oadt3VRfb1WoN32Knr8fmCLcugd+5yI62fHglNm8jU2pDDatg==
X-Received: by 2002:a17:902:e302:b0:151:bfe9:da34 with SMTP id q2-20020a170902e30200b00151bfe9da34mr147846plc.100.1647619524604;
        Fri, 18 Mar 2022 09:05:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm9887054pfc.3.2022.03.18.09.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:05:24 -0700 (PDT)
Message-ID: <6234adc4.1c69fb81.64832.b23f@mx.google.com>
Date:   Fri, 18 Mar 2022 09:05:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.4.185-44-ge52a2b0f299b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y build: 143 builds: 2 failed,
 141 passed (v5.4.185-44-ge52a2b0f299b)
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

stable-rc/linux-5.4.y build: 143 builds: 2 failed, 141 passed (v5.4.185-44-=
ge52a2b0f299b)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.185-44-ge52a2b0f299b/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.185-44-ge52a2b0f299b
Git Commit: e52a2b0f299b226fb96e4f911af2296f7643f210
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
