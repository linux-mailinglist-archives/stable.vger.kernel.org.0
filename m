Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74794B3683
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 17:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbiBLQhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 11:37:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiBLQhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 11:37:17 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7DE216
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:37:13 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 59B22402C4
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644683832;
        bh=15hMJzU1fmathDo+CvBtL4KOBTGHiJyQDvhqhMcjvDg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=Y7W2mMsV9ij6Vtq8SNjvdXrExl4B2t1a8UKyzYYEBn1iEZaZ6DQRrHeoGMHMEsmJG
         W0Py8ZGhsxfq9eRtIw1EeVNDTO8AVl+h2c8zoHyQWK4u6uDc3ZK/KwncwoYImHpyGc
         A5LUGC04kNbSk1j7dfPbY7e/MKrQutODOUBTdN4eCU476P6o7bW1fF/ttHzg5d33uz
         STrpE8gY/F/UFxyZ2HN4MA0ldC7MAT2fd2zVmr8ibQ6fo4Qu7lNL3xliE6FpPkzkW2
         pvWFzzbvDoTsxrLKos/L4T+2/Z47V5zEX9yjl5TbSH8l/MUx+iSiFNpabbiE96qTRC
         oCX81aESHCLEg==
Received: by mail-ed1-f71.google.com with SMTP id f6-20020a0564021e8600b0040f662b99ffso7330779edf.7
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 08:37:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=15hMJzU1fmathDo+CvBtL4KOBTGHiJyQDvhqhMcjvDg=;
        b=f2EBdkRcBZqxE/K3CuddUHgNQ7MpvE8+7dgxj4R8+pkTGwkYOoGtYCxUDPeyQl7df8
         DgvuITJXAVqU2Y/RA8tSp3ZOVjoXjINIrcWjvL9k5ypFDt0T14822FV447pprVjrW7qG
         ZWUnW5t+bDxKNqOIBxdLUHAhB/YgXKlQpIGy+b6WhfERTOh+hYsnjTVJSo6Fy804cijw
         MyMwikeuKd//wAPG9ynmFXwRRiGyLAKUxSIGfO6g1f0uYhO0T+kdqR9OcQ27yyTvviTK
         zGto+etDqVGA06YVpnXke4EV/OG5Su6HbMJBhLBd4FDrGY7+vjSPlyCg0MLT0sX7MDZV
         jlWA==
X-Gm-Message-State: AOAM5335X0JI94PQSYx7LmhjebaZSbAq4vEqKNT5GDa2geG96Wwu8lGh
        iiXGTHmzOx4NNkSyemePZKENkeNv/Zh6se2JNEDNni6nhZW8BPPzM+2bp4TN7X99eG5znHfyc4z
        26gBXtAcJ3K0KORtDT6QdrKTyFpYDuTJn7Q==
X-Received: by 2002:a50:9dca:: with SMTP id l10mr7054304edk.311.1644683831487;
        Sat, 12 Feb 2022 08:37:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKd2PgvPfnFZh8rSZyPq0B14QPo5js//TUm4+syJvIQzZKlxeHGKY7MDAVXnpzjoJMBxl36w==
X-Received: by 2002:a50:9dca:: with SMTP id l10mr7054288edk.311.1644683831272;
        Sat, 12 Feb 2022 08:37:11 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id x10sm2494443edd.20.2022.02.12.08.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 08:37:10 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        dri-devel@lists.freedesktop.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        devicetree@vger.kernel.org, linux-phy@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     stable@vger.kernel.org, Sylwester Nawrocki <snawrocki@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: (subset) [PATCH 02/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5420
Date:   Sat, 12 Feb 2022 17:37:04 +0100
Message-Id: <164468382250.54495.17613053424810805341.b4-ty@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208171823.226211-3-krzysztof.kozlowski@canonical.com>
References: <20220208171823.226211-1-krzysztof.kozlowski@canonical.com> <20220208171823.226211-3-krzysztof.kozlowski@canonical.com>
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

On Tue, 8 Feb 2022 18:18:15 +0100, Krzysztof Kozlowski wrote:
> Add required VDD supplies to HDMI block on SMDK5420.  Without them, the
> HDMI driver won't probe.  Because of lack of schematics, use same
> supplies as on Arndale Octa and Odroid XU3 boards (voltage matches).
> 
> 

Applied, thanks!

[02/10] ARM: dts: exynos: add missing HDMI supplies on SMDK5420
        commit: 453a24ded415f7fce0499c6b0a2c7b28f84911f2

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
