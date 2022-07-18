Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13885578217
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 14:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiGRMUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 08:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiGRMUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 08:20:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B4511A3A;
        Mon, 18 Jul 2022 05:20:41 -0700 (PDT)
Received: from zn.tnic (p200300ea972976d7329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:76d7:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC8681EC04F0;
        Mon, 18 Jul 2022 14:20:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658146836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YUsHaSIKv5mhVert20B83ArzxD5bMsOqQGQm2WfFNQY=;
        b=Ga6lTw52ypWNCa7ANAt/KfjkmVyY188H+6CK9mutryTo0MlTHD49tBVIAgvT3rAxlb5hBH
        x//kdGxXjpUKs4jyHamB06xu9+kdpmUNNZGYHG5m8FEI0HMZ9vzqjGmulqnxN1BfUIp9QQ
        dKivWsgLjUwBv94Pm38Ha6t5kSXbj9s=
Date:   Mon, 18 Jul 2022 14:20:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, brchuckz@netscape.net,
        jbeulich@suse.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: move some code out of arch/x86/kernel/cpu/mtrr
Message-ID: <YtVQEIuHa6qGXFxs@zn.tnic>
References: <20220715142549.25223-1-jgross@suse.com>
 <20220715142549.25223-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220715142549.25223-2-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 04:25:47PM +0200, Juergen Gross wrote:
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 736262a76a12..e43322f8a4ef 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c

I guess the move's ok but not into cpu/common.c pls. That thing is
huuuge and is a dumping ground for everything.

arch/x86/kernel/cpu/cacheinfo.c looks like a more viable candidate for
all things cache.

Rest looks trivial.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
