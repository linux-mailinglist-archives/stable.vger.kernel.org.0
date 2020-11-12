Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18912AFFD7
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 07:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgKLGrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 01:47:11 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45769 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgKLGrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 01:47:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 35D285C01E2;
        Thu, 12 Nov 2020 01:47:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 12 Nov 2020 01:47:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=L/VcdorDp9JE+pqeZaPOyqZZAuh
        HDIcmdpu8X5mEc6E=; b=Gq7Yv3apjBkIvWYD337ESJfweP8TCtTP2ZHRA10KeDY
        ci//M1M7OMmph4UPK5m8n0lwAers67+njrEc5SICe7iJgPdMxd3/0Q0FhP0gODiu
        mLr1eq+6GH2hf9Hw92zxWiYXPe+Q7ydgOZTo5OMe/pU5LVqRbSqN6qi9lAw8y0Ao
        fLxg0WVQAAoLa1sLvdI6QwzHg9uVci6OwbnnYqmTUaJx4Glo80lz6z+vaYawVstV
        +2ilncktdbs1tLPgw1LlF94cn4MT6ktun44FbsoiVGkUnzNIjXufaU0e83kQX8JJ
        So4OOw0f6V/xUudcnID2t+WuTO8E87PgMLk+yK+hoSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L/Vcdo
        rDp9JE+pqeZaPOyqZZAuhHDIcmdpu8X5mEc6E=; b=N5FaYZBV4VkvImvDh0hxVN
        +cuHemH0y25tCytoIO6aHblUT94MoX1u8KWJbn3Q1eFm3gl376XMBFQaLjGcpdV5
        UECnDP/QmYfgA/vg9wHbp97tApLUXPhmLRBSMvpWohzgqWsCFc/Uu0h6jjMVCJcV
        YAvVvRgWHvRdymrZjCXrsm6KCucsZVhWbKahs6SvXzanUcSEgkySnYokkvrrXyTi
        f41iYoLT47+yW/KD5d1XoAAPYHlsMLmIs6qkEAscEasErHME+N1SRj7/UqOYOSLr
        drduQz9Pdvg86LS1EVjKTb0w+9Ven10SgwHa4v1KgCug11CZsEnC7WTxzkHXteVg
        ==
X-ME-Sender: <xms:bNqsX5oCdjmqpLZOJs9d4v0UlQSOwvgs2-wOe2iL-fFjJxsU_dy44Q>
    <xme:bNqsX7qTg7fR1e0Vmh0qUXT2thN_rQHjJ_7_R9g3fj6hQjsLuL6a0a7tuqfsngkU-
    -CkLtcdKrQFQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvuddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:bNqsX2Nal8xqcdNVUQvAVvseB3pNvr12R0Fr9Xb2akk_yK32bXX-EQ>
    <xmx:bNqsX07azYnxuaD9DCoQwUskE_DoXemXaGTqGJqas1hhpII6QrFHsA>
    <xmx:bNqsX47L877nFlSN9qUx4Cni_qDF9nFCUuqopyYhb1u2WRnOFTrkRg>
    <xmx:bdqsX4F8K2MmazA-U20q8yDwbni4jhbjWlgto-e6Qo4nrkpv7N7lSQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 686E03065269;
        Thu, 12 Nov 2020 01:47:08 -0500 (EST)
Date:   Thu, 12 Nov 2020 07:48:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand K Mistry <amistry@google.com>
Cc:     stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/speculation: Allow IBPB to be conditionally enabled
 on CPUs with always-on STIBP
Message-ID: <X6zap9Qlz5Po/MOK@kroah.com>
References: <20201112001535.2960453-1-amistry@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112001535.2960453-1-amistry@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 11:15:34AM +1100, Anand K Mistry wrote:
> commit 1978b3a53a74e3230cd46932b149c6e62e832e9a upstream.
> 
> On AMD CPUs which have the feature X86_FEATURE_AMD_STIBP_ALWAYS_ON,
> STIBP is set to on and
> 
>   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED
> 
> At the same time, IBPB can be set to conditional.
> 
> However, this leads to the case where it's impossible to turn on IBPB
> for a process because in the PR_SPEC_DISABLE case in ib_prctl_set() the
> 
>   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED
> 
> condition leads to a return before the task flag is set. Similarly,
> ib_prctl_get() will return PR_SPEC_DISABLE even though IBPB is set to
> conditional.
> 
> More generally, the following cases are possible:
> 
> 1. STIBP = conditional && IBPB = on for spectre_v2_user=seccomp,ibpb
> 2. STIBP = on && IBPB = conditional for AMD CPUs with
>    X86_FEATURE_AMD_STIBP_ALWAYS_ON
> 
> The first case functions correctly today, but only because
> spectre_v2_user_ibpb isn't updated to reflect the IBPB mode.
> 
> At a high level, this change does one thing. If either STIBP or IBPB
> is set to conditional, allow the prctl to change the task flag.
> Also, reflect that capability when querying the state. This isn't
> perfect since it doesn't take into account if only STIBP or IBPB is
> unconditionally on. But it allows the conditional feature to work as
> expected, without affecting the unconditional one.
> 
>  [ bp: Massage commit message and comment; space out statements for
>    better readability. ]
> 
> Fixes: 21998a351512 ("x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.")
> Signed-off-by: Anand K Mistry <amistry@google.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> Link: https://lkml.kernel.org/r/20201105163246.v2.1.Ifd7243cd3e2c2206a893ad0a5b9a4f19549e22c6@changeid
> 
> Conflicts:
> 	arch/x86/kernel/cpu/bugs.c
> 
> Superfluous newline which was removed in upstream commit a5ce9f2bb665

In the future, No need for the conflicts or this line in the changelog
text, that just requires me to edit it out :(

thanks,

greg k-h
