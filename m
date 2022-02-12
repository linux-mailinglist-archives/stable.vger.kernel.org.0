Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB44B3680
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 17:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiBLQhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 11:37:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiBLQhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 11:37:16 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C393F20E
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:37:12 -0800 (PST)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D3D183F1C1
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644683829;
        bh=tMqilUYIpgE4D+Oy8hol1pf8fg4uaneK2N51DubcZr4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=ZItwuzD09lFECDHyY7Jh94xxJnDEue0BlpC+AwW0hLGRumxMSw2Xen15f6RQM3FxI
         tCg2rwwbsAR2aGOkptGCEmT+lj+TZgncQJItCuye52I1ni9qt+uE9TyIThRLHc2zmg
         2uth7BfNPnzs4IY49plQHMv4YjU9NZQbeG8C8H5Ha0kXLfuYKUyTn3cf5npQYMuJZv
         Lvxf9lODEtbqCUvNZMQgyvWGYd+Nv4mvgJ29Sj7WjAHWq0iOZsismnrr55G6TkLmMF
         aNPfshGSa4pjdNwRaCXsO2goOYSelOG+crdqT9Pn9E2XP7/ZobfSiQ+YoNz2SWHOw9
         18B7JKGoE7Wuw==
Received: by mail-ed1-f72.google.com with SMTP id z8-20020a05640240c800b0041003c827edso5690610edb.0
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:37:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tMqilUYIpgE4D+Oy8hol1pf8fg4uaneK2N51DubcZr4=;
        b=8HI4UFa6b2jHJCyHvZ7dZPQv7voyGrqZ/jT/Knmb4gjmJM5djiF3NAosBr2wtEh150
         lJvAaCrUOgngv4E5tHr6GQGXhu6aQ8lImksHK+QsrvESZMpoUIDN03MTCDe8TyH+RGGN
         9NT+M3oG8FUl8OtQN8RCs5s4I8tAhUOure5jVzHcqNeb7YlUMNIKZEHCX7mm1Qf1HMYT
         W53lgHojTdIKa4QSTxxvYi+udjSgat0vNaCjOsybu+mRJKjYskOrM3IfJh+TAvlrvm0M
         3ChVm5gVfEwEJTxoiT2IykGKrNVLMVsJ/t8aBZSft4jou0RYba8JL1sAY3vRXBvpRavI
         /Dwg==
X-Gm-Message-State: AOAM531Crnj83E7TY5Rl0YQGfkiHbkDD2k9eyVB1FruR7oeDIRWUuANs
        i/KHdHhzCGwEWm/L83PWkJv4ltNUbmIoGnG+mwx5d6X/olRh47kRcnCDb4BRuHlyl0nyEGMnTfh
        e5lO6Ob5lbNEFwVEr4Wb9KmIlQthBivPCXg==
X-Received: by 2002:a17:907:c07:: with SMTP id ga7mr5546519ejc.536.1644683829509;
        Sat, 12 Feb 2022 08:37:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxD2vBUSSwJtNtb2tnnNYmZ8ce5zaQGnbpfOOmEuusMoNeqmKg6uKEeUXp4CHd4UHdvHqCobg==
X-Received: by 2002:a17:907:c07:: with SMTP id ga7mr5546511ejc.536.1644683829366;
        Sat, 12 Feb 2022 08:37:09 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id x10sm2494443edd.20.2022.02.12.08.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 08:37:08 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-phy@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        David Airlie <airlied@linux.ie>, devicetree@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sylwester Nawrocki <snawrocki@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: (subset) [PATCH 01/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5250
Date:   Sat, 12 Feb 2022 17:37:03 +0100
Message-Id: <164468382250.54495.17179167915023420156.b4-ty@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208171823.226211-2-krzysztof.kozlowski@canonical.com>
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com> <20220208171823.226211-2-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Feb 2022 18:18:14 +0100, Krzysztof Kozlowski wrote:
> Add required VDD supplies to HDMI block on SMDK5250.  Without them, the
> HDMI driver won't probe.  Because of lack of schematics, use same
> supplies as on Arndale 5250 board (voltage matches).
> 
> 

Applied, thanks!

[01/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5250
        commit: 60a9914cb2061ba612a3f14f6ad329912b486360

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
