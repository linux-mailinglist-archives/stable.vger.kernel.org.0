Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6E96C0A54
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 07:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCTGED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 02:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCTGEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 02:04:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FE41E9D4;
        Sun, 19 Mar 2023 23:04:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z18so5941253pgj.13;
        Sun, 19 Mar 2023 23:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679292241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IuwnoMqAsWhnxVCOd51m4+hT6nyTEazJ2k59/NDO1H8=;
        b=HmJPumVNlJeHpimmhn0dnuhlLhWXNm3SZz13OYW4FYowV/mGplgLlSOZzE/C+yP8aF
         p78zpr43qFXBNPGFaFvTJGxh1ttlc+nehnwnP1IzStmfGZmiKtIWIaU46fwt0DoX5hl4
         bwzNS2p1Y0a+7H8ka2fphHRkeijCuqo3NSK6QXEgzGX9M2ucGS/0clHyZKnu/REim9jE
         Dgc3Cz9MCbC5YqurA3qdimPg3mziiVS2b6nI60lNOtQdTPwHKwsVBAqY18DDGLRZaN38
         QL8b+1nYLjrc6IdSJANw1TsaHSQXF8icSBXbpRPP83aYNpzyNoAZ15H/nxRudSzDRVLO
         U7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679292241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuwnoMqAsWhnxVCOd51m4+hT6nyTEazJ2k59/NDO1H8=;
        b=AHr8l/DR8VClW1IIvN8bOuUjmg283GHLxvjwlLr+Ji4Ciwk2VcdcOjzI8hdECcBMzR
         DiHPSWpCOQyHb/BZJpRir9RZFkXKJ3sMPsLdyOxFDoSOu8g/u+UoM4HJlUZAyHjMC2sk
         r0zKa8mF945I4wF7vsUgp5dXdruvwzAIDoY6XFXa6y0w/kijSfA5pF3+ykYebOw3Vre0
         BVlDBtjqdlgZWWpxtA9CCjZIX0LR2EtKlJoTS6EiZ6B36DiOcgy0kBWy7BxcGzOh22Ut
         hvZz8nchfHW+Rs+qnmdCFQOa8njdJEomPTysTBfDr0hlShQ3qd8S0R9XV+PW69FXhglI
         dvUg==
X-Gm-Message-State: AO0yUKWYuUNhNpULk83IOKJZvQSBqSJlQIvz4iKFZHF8EYeEmqB6FPtg
        RRrMCRee+VeI7WBP0BMTI0r+C+SBwDA=
X-Google-Smtp-Source: AK7set/mhYuyr+Z3epuustCisHMkZ/ZPHjinAc84+NXI0jJGjqm5h3z7aFEv9k5MPnHhH1WYoAaxeg==
X-Received: by 2002:a62:798f:0:b0:627:deeb:af96 with SMTP id u137-20020a62798f000000b00627deebaf96mr8893900pfc.11.1679292240967;
        Sun, 19 Mar 2023 23:04:00 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:687c:5175:b0b1:a145])
        by smtp.gmail.com with ESMTPSA id z10-20020aa791ca000000b005921c46cbadsm5567179pfa.99.2023.03.19.23.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 23:04:00 -0700 (PDT)
Date:   Sun, 19 Mar 2023 23:03:57 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     msizanoen1 <msizanoen@qtmlabs.xyz>
Cc:     hdegoede@redhat.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] input: alps: fix compatibility with -funsigned-char
Message-ID: <ZBf3TalDJffrxEPB@google.com>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
 <20230320045228.182259-1-msizanoen@qtmlabs.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320045228.182259-1-msizanoen@qtmlabs.xyz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 05:52:29AM +0100, msizanoen1 wrote:
> From: msizanoen <msizanoen@qtmlabs.xyz>
> 
> The AlpsPS/2 code previously relied on the assumption that `char` is a
> signed type, which was true on x86 platforms (the only place where this
> driver is used) before kernel 6.2. However, on 6.2 and later, this
> assumption is broken due to the introduction of -funsigned-char as a new
> global compiler flag.
> 
> Fix this by explicitly specifying the signedness of `char` when sign
> extending the values received from the device.
> 
> v2:
> 	Add explicit signedness to more places
> 
> v3:
> 	Use `s8` instead of `signed char`
> 
> Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
> Cc: stable@vger.kernel.org
> Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>

Applied, thank you.

-- 
Dmitry
