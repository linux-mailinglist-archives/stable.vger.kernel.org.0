Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA4D53F893
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiFGItG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 04:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiFGIr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 04:47:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738E136E2B
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 01:47:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id q15so5769384wmj.2
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 01:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=jjmBM+YMjlFXX/04Mn3ryco/8ft8+MfHf2RJCrUmmQ8=;
        b=Jf7tzLBY2bb+zqaoEiK/swoJNQLmchY76ynfLRhcxm4Qpg+M/JNb4GhP2+jhUJy3e1
         3q9LgMpNzhIpLO/zyeAGEQB38Xxo+0T3b2aAYPUYy5ufmHHrAUfRl6mCIytEeA/PuWEU
         oupX3EUDZBPRbKUytSgEAGy4Z257W9BcXEVYfDqY5soDTddjyLOJNiw6dgG6vG2aIlo6
         cxB530wJMEEWvSFN2IQRbqdv8cCtWXcQgxwhCCO2pOpfT9rarIS6gYVUmqbuQnh2ZDz5
         +vuoz54/yb0HDRuUZShIX6qdCCQrWpY1xLRJJsv5v/6sGgQXCOaMPKRpOqEJ/H+K0XMr
         d5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jjmBM+YMjlFXX/04Mn3ryco/8ft8+MfHf2RJCrUmmQ8=;
        b=tU3uIo7vOYIohUpPC6/CIjLtvkagh2HQmvZHqzISLckNiBchD2DIMwrLwypIaFtOVQ
         LBdifeWW+4sRgXkcst8mCcs0vOHpXmvHCreQrh/irA7mUtY8WaILjzg2Lm8BhlquNFrl
         wZXNusYR3v5tn6ICps8+p2BPmgUyTfsTJCqXTH1iNgQc3FSRndcMj1OCCqlMCQCx0289
         CTg/HcS6mvngIg0i8WCWA277glyaRZxiCveuKhyWqcqCkwJrhV1hYDZrmfqjRvHWl0O8
         dTnlDnG3MLF58Hsv4sekkXPBSq5v4ks73FRY4/jiLETisYTUH3fVq0AcVMNS07p5bINz
         vwdw==
X-Gm-Message-State: AOAM5318/OLxQb6axflivdKBTQaC0JPfxOZyHrBea4a84lC1Fyn0gEIQ
        qpDCeEdfTvozB5JVg0D6teOxWg==
X-Google-Smtp-Source: ABdhPJzQFrRVwZXM+3X7x3RVfdP9cmEK8h31xXjn2sWR9mgeaooO0qDx38Q+p1ithlO14RLe5G23Sw==
X-Received: by 2002:a05:600c:4fd5:b0:39c:4d02:29f9 with SMTP id o21-20020a05600c4fd500b0039c4d0229f9mr11616818wmq.142.1654591651287;
        Tue, 07 Jun 2022 01:47:31 -0700 (PDT)
Received: from ?IPV6:2a00:1098:3142:14:901f:dbcb:c1e4:e4b8? ([2a00:1098:3142:14:901f:dbcb:c1e4:e4b8])
        by smtp.gmail.com with ESMTPSA id d12-20020adff2cc000000b00215859413f3sm10821043wrp.107.2022.06.07.01.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 01:47:30 -0700 (PDT)
Message-ID: <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
Date:   Tue, 7 Jun 2022 09:47:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
From:   Phil Elwell <phil@raspberrypi.com>
In-Reply-To: <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On 07/06/2022 09:30, Jason A. Donenfeld wrote:
> Hi Phil,
> 
> Thanks for testing this. Can you let me know if v1 of this works?
> 
> https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/
> 
> (I'll also fashion a revert for this part of stable.)
> 
> Jason

Thanks for the quick response, but that doesn't work for me either. Let me say 
again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a 
universal problem, but merging either of these fixing patches would be fatal for us.

Phil
