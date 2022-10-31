Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C668612F79
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJaEdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaEds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:33:48 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E1A9582;
        Sun, 30 Oct 2022 21:33:48 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4D64E320034E;
        Mon, 31 Oct 2022 00:33:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 31 Oct 2022 00:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1667190825; x=1667277225; bh=oF
        7QaoNaC3BVriizpHFYP5Gr1KWbQCkEuGc7WVWpAsA=; b=KDb0W4sZCCoB8m55Gk
        v9SGYht6oOISermCdc6VbqMg8trtmknUfk11vKDbcy20c8brEtLt3QJbbYMoIokU
        NjRLDx5vHNILi5CzBkThjDY1SMFoBk2Wbfij4pQLOtrJj4Yg+ZFmM5pxYMVbcQBe
        4c2rB7nYVhI0zEsMW0UqJesRRwOml0lWNqlRyX56LG2CVuhc9yEMtLpxl+O7KNZ2
        tlDmvdEjoW3ymRfWwHVzqmNMtsDF1IiAeFjE5ahVwX3Y7Y5sUZ7haZYl7KVNeAb3
        ojGV2/ixqycbe30Zf95Z0zeiqs2NbrYrqrGE5/ahi1921m1h+0ubnbnPzJosQr2u
        g+pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667190825; x=1667277225; bh=oF7QaoNaC3BVriizpHFYP5Gr1KWb
        QCkEuGc7WVWpAsA=; b=gEh2oOg9drka0PzqY41OsrXaF6tFaGES2SujwbngDd2g
        YWagHESxcRuMMQcm+oqcVXRAb4s+Z2BUKaNsGg3fzl0ZPSbuwOTtYR3bJAX9pFZQ
        fxsEhwhufuLZ4xDK3bn2PFbx0Hw5Fxd9l2nEM3KlMgKOCkWwVq2Tm2LFz7u9U2p2
        VAWCN3m3i9FV4uZRJh5OZiZVZJCP0kRh/MCIo0j2t1EUQn0N7GYxb1WRW1VEUaHt
        Yy80dgrgbmLpp7oRHZlzmmzOGgKZlZXdTiXf72w1Ae1T2SJg0wWmZHabeYSgoB8P
        VXH01m8v6IB2gT+4se7DpgdCnrbsYgxxRt5wIhFIwA==
X-ME-Sender: <xms:KFBfY8HUg0SI-u1dUbjBCZg5kcksnpzJb8vIPsH9VREJjqbMWsWFVA>
    <xme:KFBfY1UYKWUhpOe8wUvrStGaOMx9Pom9X5-Pp2cNTTQUNfOd5LgE6a-roUot-RCZ4
    0QfZhhPVAlHFKN-vLM>
X-ME-Received: <xmr:KFBfY2ISGBr-3Zwk1nV9IcC5BVVS91lOX0fYSUGjyP8MF-PS6_KK7hc9dL58WiglntXF8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedruddugdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhephfeigefhtdefhedtfedthefghedutddvueehtedt
    tdehjeeukeejgeeuiedvkedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:KFBfY-FL_-8Aij81femwb2cwP5ZA8ryDZIqHnwVTs4_wscvpf_kRCw>
    <xmx:KFBfYyU5j9sHR0khCjE0ojSyqZ3S4FOhQM9jSsopXCdjE7k-0QI7Dg>
    <xmx:KFBfYxMvVW4UpmPqG1OsPoYfyZViLmldzzq9OQlm3qpHnMAVkjsC7Q>
    <xmx:KVBfYwb7BVjxGB6hhGJr97KgTC1uBPPWpZ_Wh1-I1xEOgLfQo_tVJQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Oct 2022 00:33:44 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 8EA2E109579; Mon, 31 Oct 2022 07:33:42 +0300 (+03)
Date:   Mon, 31 Oct 2022 07:33:42 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Guorui Yu <GuoRui.Yu@linux.alibaba.com>
Cc:     kirill.shutemov@linux.intel.com, ak@linux.intel.com, bp@alien8.de,
        dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com,
        elena.reshetova@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com,
        peterz@infradead.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        seanjc@google.com, stable@vger.kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86/tdx: Do not allow #VE due to EPT violation on
 the private memory
Message-ID: <20221031043342.di5wtvi2x4mfbkko@box.shutemov.name>
References: <20221028141220.29217-3-kirill.shutemov@linux.intel.com>
 <b5d04a6c-79b4-bbdc-b613-6958d9f75d53@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5d04a6c-79b4-bbdc-b613-6958d9f75d53@linux.alibaba.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 12:07:45PM +0800, Guorui Yu wrote:
> The core of this vulnerability is not directly related to the
> ATTR_SEPT_VE_DISABLE, but the MMIO processing logic in #VE.
> 
> We have encountered similar problems on SEV-ES, here are their fixes on
> Kernel [1] and OVMF[2].
> 
> Instead of enforcing the ATTR_SEPT_VE_DISABLE in TDX guest kernel, I think
> the fix should also include necessary check on the MMIO path of the #VE
> routine.

Missing SEPT_VE_DISABLE exposes to more security problems than confused
handle_mmio(). Rogue #VE that is rightly timed can be used to escalate
privileges and more. Just adding check there would solve only some
potential attacks.

> static int handle_mmio(struct pt_regs *regs, struct ve_info *ve)
> {
> 	unsigned long *reg, val, vaddr;
> 	char buffer[MAX_INSN_SIZE];
> 	struct insn insn = {};
> 	enum mmio_type mmio;
> 	int size, extend_size;
> 	u8 extend_val = 0;
> 
> 	// Some addtional security check about ve->gpa should be introduced here.
> 
> 	/* Only in-kernel MMIO is supported */
> 	if (WARN_ON_ONCE(user_mode(regs)))
> 		return -EFAULT;
> 
> 	// ...
> }
> 
> If we don't fix the problem at the point where we found, but rely on
> complicated composite logic and long comments in the kernel, I'm confident
> we'll fall back into the same pit in the near future :).

The plan is to add the check there along with relaxing SEPT_VE_DISABLE for
debug TD. It is required to debug guest kernel effectively. Otherwise
access to unaccepted memory would terminate TD with zero info on why.

But it is not the urgent fix. It can be submitted separately.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
