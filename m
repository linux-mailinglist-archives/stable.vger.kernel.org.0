Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015E26440ED
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 11:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiLFKFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 05:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiLFKFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 05:05:00 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDE12FC23
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 01:56:16 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so4897477ejc.4
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 01:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIQk5bNR3GHzD/yaY435FsOEGul9xS5pyldcQImVpVg=;
        b=eldOSBscUEEtMkaQ6Rk7YhlUKkxbou5oSWkUxBzC+XZkJHI44ILbCq3fdpPcDcoJvH
         YwywkLNvmYMArvnSXdBfM1GCJa8DhnMoCBIpGv57awqc1GwoydhiLBI/PhuVnGo0t5M4
         Baf3mZ/7WKBMWHGIbLnXWiMtAXP2U0MM416EU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIQk5bNR3GHzD/yaY435FsOEGul9xS5pyldcQImVpVg=;
        b=uWkcKsSMHv2NA2gCpTUHDGnvv4sflyomrxweuL1vfN4k2fM0qE0pDznpTAt92xaqKD
         T4Cni7oNrD88+3TAhuah1ykFl5Hv8WGXri2qV8VvXrrtb7xcX1Vs1Y/8geRqtn8uao3U
         oTCqP9+tMag0WsPwh3lay5wk38Wlyny516GO9fBI0/XByDbRcp891YTOp/MQEOjLWykX
         WqqCyJ/EbOWxQpq5g2Ezb+Q4xvKohg/SyvDoHIrp1wyrkdJNx2POMnN5Q9yfafvCkvlv
         ebUg6EaBD4z1VmaHEiX/qeS4YC38HRcJWtYxAsX0p94Re+zRGGg+pU3EW9csQNW2IoVj
         gi9g==
X-Gm-Message-State: ANoB5pmoRTvF1WS3wWHQBFEcgFzkMZCE5OqSgyeQ3YIGboqvGfJp0QIX
        q9bI2o9WNZ3v7fDGAIBBS3Wwfg==
X-Google-Smtp-Source: AA0mqf61zS1T9m4OrzvFSair6mYfb+8FNooUG817oe1m6ka1s4ZtYIym5UjR4Iy+rJ2aKTfjFsXi+g==
X-Received: by 2002:a17:906:5213:b0:7b6:12ee:b7fc with SMTP id g19-20020a170906521300b007b612eeb7fcmr22344354ejm.265.1670320536995;
        Tue, 06 Dec 2022 01:55:36 -0800 (PST)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id dk21-20020a0564021d9500b0045723aa48ccsm763735edb.93.2022.12.06.01.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:55:36 -0800 (PST)
Message-ID: <1bef5f3c-f594-bf8d-5370-3b5a30af3f63@rasmusvillemoes.dk>
Date:   Tue, 6 Dec 2022 10:55:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH AUTOSEL 6.0 08/13] net: fec: don't reset irq coalesce
 settings to defaults on "ip link up"
Content-Language: en-US, da
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Greg Ungerer <gregungerer@westnet.com.au>
References: <20221206094916.987259-1-sashal@kernel.org>
 <20221206094916.987259-8-sashal@kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <20221206094916.987259-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/2022 10.49, Sasha Levin wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]

Well, I'm not sure this is actually -stable material, but even if it is,
it's probably better to wait until the regression which this introduced
has also been fixed in mainline:

https://lore.kernel.org/netdev/20221205204604.869853-1-linux@rasmusvillemoes.dk/

