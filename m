Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB72B5CE0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgKQKaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:30:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42867 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727526AbgKQKaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 05:30:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AA0675C01D0;
        Tue, 17 Nov 2020 05:30:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 05:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=tCuw9zcg12zTXUBNgAzYS3Wshzo
        8HbuHApVfwjw/JQc=; b=hywniebZKfaVEiA/zgOQLpBYpHFLaVL+XnCqJXMpDBv
        PxTP36H9gXcRZr85AWnW2RfgZ8UQtuLprh+R9S5Y47kb0DQtCu0iLLqv1tfFLlav
        1rzaH0zrsOd3Epwr4SvcbEx1x23aqYXS4/RqzOFU/rs9gRxlF/fyoZVUvFdzBExI
        15BBTdDNuIlQ8Qgat0IQxHM7b20Wyx5QXGIocsIJhMQO0660iwffvX2JnJS3ndR9
        GVKNV8Xb7BIZMYKpB8TBNQEPnMnmubWRSOLlCKD9M7Uyyu/haEYY8++7PILiaLVI
        TBkzkpS3aZkqe8b97bx39LFw9gcM4YPcsCm6OHEXARw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tCuw9z
        cg12zTXUBNgAzYS3Wshzo8HbuHApVfwjw/JQc=; b=qSDNxMEe4dB7hcNSPT61ig
        Wm1Yl94v0nvzRZ1+/3DY0erpEpiYfCH3yB/Apxh0GjNkKP23Bctfqc4aknJnsvCe
        4pSjbh3D/ZyToZmRr/yYWW4SNzgV6YElA5Vz/Z6CEPBAWi74P/Le9CJ04yWPYCBo
        UB3blPp0BhwcqDtT7CCmqVVZaIAdKLjb17KMyFOB8Md/z+SF7acQyv+buq1sO60t
        zqlLdgAZAc1EV4YKLlvssy+b0ZaBtgawAEMV6y8yku2IJE+UM95PqXBL1lEIhGEW
        nujAOQxiPawGrC2xWnbKNM/KNyKybTmcc5NVoZUmR9pogv1y6Lmr37mdnvx5IU/g
        ==
X-ME-Sender: <xms:L6azX7yb6PFJ64569VXOpwhTb7ipsBY30TWcKxy_nvRD0ocAsgM4pg>
    <xme:L6azXzRTO93fFpeZYOjwefQB5-AdpITrTkSpGibVrTsI-8EsjrTDx5qnv3I9TQBDw
    lCeZih6p7WLfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:L6azX1V9U0K5f5vVZtGYWZUWi2jFWuLZEziJayfiBclvVSJss966hA>
    <xmx:L6azX1gnZsVX9VVlroIjPOKTxFoWGGpo-hIxmc01wFZAATAmqKoQBA>
    <xmx:L6azX9CUO6WkryCLk2VlkQN5hzLheKJD2AvuCEzmT5ksLjdHmSl0SQ>
    <xmx:L6azXwNs9rwYpYQtcBC-E964k7ve9lS9hCiS_Cy4sNfw3yVzac7r5Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBABF3064AB8;
        Tue, 17 Nov 2020 05:30:06 -0500 (EST)
Date:   Tue, 17 Nov 2020 11:30:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand K Mistry <amistry@google.com>
Cc:     stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/speculation: Allow IBPB to be conditionally enabled
 on CPUs with always-on STIBP
Message-ID: <X7OmYJZX21Xfq/CW@kroah.com>
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
> 
> ---
> The one conflict is a newline in a comment which was removed in upstream
> commit a5ce9f2bb665, but was not merged into the stable trees.
> 
> This patch applies cleanly on the stable trees 5.4, 4.19, 4.14, 4.9, and
> 4.4, which are affected by this bug.

Now queued up, thanks.

greg k-h
