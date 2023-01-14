Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DDB66AA67
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjANJY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjANJY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:24:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA305BA2
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:24:56 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w14so16987450edi.5
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEc6231ZEQvM8mlpnYlaHWtK6SD5KDtou9eJepvkIuI=;
        b=Pmdv5wzqY+j6IoyfPGySEv0gEf7VRtQA6mCFGPsuIF39qsjZBJiZazaA/ml7UrWasz
         LYOODs7b6uPWPqVknsY04qdkSXepuoI430HP3/u+qocUNiWMQTv2G/8pZ9CAW4ozSZ39
         EZzKX5w74RbT+ByobyHC7GyYBBTFw23GEKwf1jmGaRQvG9OADlpinuDEPwoH8tdj2f8i
         xhid7IAQlEovjZN0N6B5pbbIVM2xZ2qhFJ1QVMFaaxG2J1Ld92i/h7K9jPpBJ0Tta716
         uJFH6y6OIsB7R72ypymVdkGVpXVTZd2xCSABRX+uuJoCPR5R6X8iEeCiE/6qQRv471cb
         G+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEc6231ZEQvM8mlpnYlaHWtK6SD5KDtou9eJepvkIuI=;
        b=vThgZVXXYIPKrSF2hb4ajuZZhQo7b7sAAvqguGu4NbZfbOax9GDkmIS4DAzVF/gpGX
         h+Lce4cMlb9bQm2sCcxPKreRd8h/ZCnkXJ2fNWMcbF+hd8DY0VAcaVZxNjoBV5H65MR2
         OUINWsI7wlvgJjqSE5THs4VfHMHYikVdUnrxN0+9Nh2VZfFB2QH/3Rg+ZNswvr9ZMxNC
         R8Z0QUGEUyXo6Y0LMZ9A94uerc/1paGc+Fb1MzFnYxOk8nq5Lk8Xk4fcIy3mw3C4daMJ
         MXtMplyuPGKMtQ/VhfZwyvZx4MGL159QcuNa4oSWUHoAxvsccmJwEmyh4KTkYGXP62j3
         12/Q==
X-Gm-Message-State: AFqh2koN5ULBKR0iDGpBk5OlxoYo8sGDkGqsPSAnc2N+6rBU+9i0vF5T
        HcIg81IpQl1I9nP/QOylVDU=
X-Google-Smtp-Source: AMrXdXtbYw7RJ4wd7kY5+mbmA9lUtvxCw+dF1mY7+1pR3gNIEabXRq/qhTVn9IXxJhiyD3CfiBiIJQ==
X-Received: by 2002:aa7:cb11:0:b0:45c:835c:1ebb with SMTP id s17-20020aa7cb11000000b0045c835c1ebbmr2747217edt.9.1673688295515;
        Sat, 14 Jan 2023 01:24:55 -0800 (PST)
Received: from gmail.com (1F2EF2EB.nat.pool.telekom.hu. [31.46.242.235])
        by smtp.gmail.com with ESMTPSA id w2-20020aa7cb42000000b0046a0096bfdfsm9141363edt.52.2023.01.14.01.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 01:24:54 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sat, 14 Jan 2023 10:24:53 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Daniel Verkamp <dverkamp@chromium.org>
Cc:     x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86: combine memmove FSRM and ERMS alternatives
Message-ID: <Y8J05QINTpERIZfe@gmail.com>
References: <20230113203427.1111689-1-dverkamp@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113203427.1111689-1-dverkamp@chromium.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Daniel Verkamp <dverkamp@chromium.org> wrote:

> The x86-64 memmove code has two ALTERNATIVE statements in a row, one to
> handle FSRM ("Fast Short REP MOVSB"), and one to handle ERMS ("Enhanced
> REP MOVSB"). If either of these features is present, the goal is to jump
> directly to a REP MOVSB; otherwise, some setup code that handles short
> lengths is executed. The first comparison of a sequence of specific
> small sizes is included in the first ALTERNATIVE, so it will be replaced
> by NOPs if FSRM is set, and then (assuming ERMS is also set) execution
> will fall through to the JMP to a REP MOVSB in the next ALTERNATIVE.
> 
> The two ALTERNATIVE invocations can be combined into a single instance
> of ALTERNATIVE_2 to simplify and slightly shorten the code. If either
> FSRM or ERMS is set, the first instruction in the memmove_begin_forward
> path will be replaced with a jump to the REP MOVSB.
> 
> This also prevents a problem when FSRM is set but ERMS is not; in this
> case, the previous code would have replaced both ALTERNATIVEs with NOPs
> and skipped the first check for sizes less than 0x20 bytes. This
> combination of CPU features is arguably a firmware bug, but this patch
> makes the function robust against this badness.
> 
> Fixes: f444a5ff95dc ("x86/cpufeatures: Add support for fast short REP; MOVSB")
> Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>

Could you please extend the changelog with the information about the guest 
and baremetal firmware tthat Jiri Slaby pointed out?

Ie. acknowledging Boris's point that these are technically invalid CPUID 
combinations, but emphasizing that the x86 memcpy routines should not 
behave in an undefined fashion while other OSs boot fine under the same 
firmware environment ...

[ Also, please Cc: lkml and don't Cc: -stable. ]

Thanks,

	Ingo
