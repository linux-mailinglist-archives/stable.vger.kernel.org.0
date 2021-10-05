Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB9423287
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 22:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhJEVBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 17:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhJEVA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 17:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669D66138F;
        Tue,  5 Oct 2021 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633467548;
        bh=bsjXpRYx2mjsrpqtJvNuzokSpYL8w21ACNuobJf3GCk=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=fdZH7LQeLuFJ7jCyJmZcvtita6gTE2s7ey7YadkHhkIcSfrkh10KQw1aDkr4RgbiD
         pWwi9/Ub/GAZEeTQoEMYx/eZ3VmZS/oj4PBH0tNKEv42933srip+bDCkz6tHp0Th9O
         vEo6SYJkOMtEfPhYkB5/bexeXsJvGBmmhmZVe/H6l5I54qykL5c2MavNazHq4yU3Dv
         rF73bFINNy2AYx+SePT+e5DMKWjQ1brYWM5B7bjXOJpkU0FNz/81284UY2cdk3K8Mf
         BxTB8N+8RqfnEVGRTnGIz9X8hU0BpIy1mL8hSbr+bSeOeDiYMnaVEnYztCYoj0GSsu
         La4X1/z8K+G4Q==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 7EDF227C0054;
        Tue,  5 Oct 2021 16:59:06 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Tue, 05 Oct 2021 16:59:06 -0400
X-ME-Sender: <xms:mbxcYViRZR8BPdNg1PyyX86JYgdT-_7pebX0cN49MJYdqFZwIWRCeA>
    <xme:mbxcYaAO6jOGgjACnzdMm-xuYv1HIGvtnsNwexK6N9igN72TQ-SNWeKrenCed09LR
    O0QPXEny0iC6HiWLOE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelgedgudehhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnheptdfhheettddvtedvtedugfeuuefhtddugedvleevleefvdetleff
    gfefvdekgeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:mbxcYVFSrJa-HZ1YF90w5JV_Xt-0QI4PpbpaU11iqFBTsh7CdLTQSA>
    <xmx:mbxcYaQ-416-rHtbVhw_w_8JNw-NnqpX60tVj2B5xnBDLplYgK7w8w>
    <xmx:mbxcYSzIfMSEnSLTHFOboImCObm0NVGDvm46na4tWWLWZn4BSXZ8Bg>
    <xmx:mrxcYXJ-bG2J-J5892RzO-e4MScnq6BXsonE6lErEDIzYEreo9cxywkSgXw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6051721E0063; Tue,  5 Oct 2021 16:59:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1322-g921842b88a-fm-20210929.001-g921842b8
Mime-Version: 1.0
Message-Id: <1166eaec-f655-4f77-bf3f-b04dcb62d4fe@www.fastmail.com>
In-Reply-To: <20211001133349.9825-1-jane.malalane@citrix.com>
References: <20211001133349.9825-1-jane.malalane@citrix.com>
Date:   Tue, 05 Oct 2021 13:58:45 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Jane Malalane" <jane.malalane@citrix.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "Pu Wen" <puwen@hygon.cn>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Yazen Ghannam" <Yazen.Ghannam@amd.com>,
        "Brijesh Singh" <brijesh.singh@amd.com>,
        "Huang Rui" <ray.huang@amd.com>,
        "Kim Phillips" <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, Oct 1, 2021, at 6:33 AM, Jane Malalane wrote:

> -static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
> +void detect_null_seg_behavior(struct cpuinfo_x86 *c)

__init, please 
