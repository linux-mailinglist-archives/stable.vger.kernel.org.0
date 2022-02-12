Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDECC4B340F
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 10:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiBLJbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 04:31:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiBLJa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 04:30:59 -0500
X-Greylist: delayed 578 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 01:30:56 PST
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A972C2655A
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 01:30:56 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 2422F3200E90;
        Sat, 12 Feb 2022 04:21:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 12 Feb 2022 04:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=BkNlwPKjJIrQmoH+uWUDKaBGuYFGUgEW1NkPtR
        4iyAc=; b=G1i0K0jRVls4elDnNj/CNuxx6ah5YmUtCGLl0RoZV1BYy4O5gJTV9C
        rkU6SGXf9dPDr5Q8yMIOSb3Je1r8TQEmXjPDoyL5capEDtmNGxwrcAPdPihWHh/G
        D6kIJT8+cPKSbTLS7vsc2HJneWPwfwOI0Fk2ETeg1ZqqJLLtkiHpSk6idXNZe/mN
        Eg2GhgvAio83twFiW91gNgmZApXhaYqM4SsJwVoFeBgN0KoHsr+9ulYMrIF85X10
        bR1sqAi9QL30x+t8PU5IyovYI6U8p7vh76FV9kLQ0Oo58iGXoykcCwj4buz9jcTe
        GFgfO0D0MvNtTH4OhzX3+20TN1+9azVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BkNlwPKjJIrQmoH+u
        WUDKaBGuYFGUgEW1NkPtR4iyAc=; b=JSZwGV7LAMHOyxQxI1Rmw4LwoV81M6hYz
        0NxoqtTDTbiSGADx075e/2mxVjIAR2II0onbC4BBmuZ5p/wdljs8K11PIEhRpoyX
        t0/qaBcKvGvz29FnDUHs2dH2wyrlkbQkR03GJkdXp0iGZK1l2nrdOGdQYqFMOObS
        FWmfR+RgNidi2gVDeG0/o4ZHK/pgGnCEZTCLw1g013piwe0OHuMjeJabp8qGdom/
        gXtQlxMsIxnU/ZsiPDvHzq8y7BWYgJJ8ABsLY62FhYcaMNoSCBgHFXYH/kLz+hj7
        6YEOdqKpBqRuGCrHXArbLIyp8XKbi+qwcJU+++iljGkAAhj0I9JZw==
X-ME-Sender: <xms:CnwHYl03Na6IhtaVxzPWE1wdmNZmVjdUD5QbP3td0E6Vg64gkuqMjg>
    <xme:CnwHYsE8GPTXr-LE7ebym_nUhhWgbTu6uotcMbQRHd5Uti3vO8cXbc8bzvPC4NCK8
    YkreZ8bvg9Y2g>
X-ME-Received: <xmr:CnwHYl6cMwz7A0FgDEUZH6_3h4gk7vGC3lSYGGsdApee_wtq4D1cwEfFgmugOaNO5y4z0vwHoW6qdSDcccuJVLO4W0Nz-BEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrieehgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CnwHYi10AYCoqsN1QJvZq6YLbUyuCkI87UpSKLyk3eDeG35XlVyYcw>
    <xmx:CnwHYoGpvipIWPXFX9XlFuYjy6-nI55VYI_WK_xhhiH-dtFE5MW_Cg>
    <xmx:CnwHYj-uSiE2FjLQ5dVT00v3ZOACe7aPqfoZvOmuAM98aYmOoAM1TQ>
    <xmx:CnwHYt4tg0f8FeJ2yPnMwbd8x665RyUIT9SaM4oCl2dlCmxPGsHIHg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Feb 2022 04:21:13 -0500 (EST)
Date:   Sat, 12 Feb 2022 10:21:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.4] bpf: Add kconfig knob for disabling unpriv bpf by
 default
Message-ID: <Ygd8B/eL267g8taF@kroah.com>
References: <20220211174704.25586-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211174704.25586-1-fllinden@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 11, 2022 at 05:47:04PM +0000, Frank van der Linden wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> commit 08389d888287c3823f80b0216766b71e17f0aba5 upstream.
> 
> Add a kconfig knob which allows for unprivileged bpf to be disabled by default.
> If set, the knob sets /proc/sys/kernel/unprivileged_bpf_disabled to value of 2.
> 
> This still allows a transition of 2 -> {0,1} through an admin. Similarly,
> this also still keeps 1 -> {1} behavior intact, so that once set to permanently
> disabled, it cannot be undone aside from a reboot.
> 
> We've also added extra2 with max of 2 for the procfs handler, so that an admin
> still has a chance to toggle between 0 <-> 2.
> 
> Either way, as an additional alternative, applications can make use of CAP_BPF
> that we added a while ago.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net
> [fllinden@amazon.com: backported to 5.4]
> Signed-off-by: Frank van der Linden <fllinden@amazon.com>

Thanks for the backports, all now queued up.

greg k-h
