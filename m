Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190453FD8C7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 13:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbhIALcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 07:32:23 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42585 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238369AbhIALcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 07:32:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 571FC5802DF;
        Wed,  1 Sep 2021 07:31:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 07:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=S
        1RVPrc/JniTsOu3BXowJ2wtLOesVnuNoMJ1MWL5+Lc=; b=yOfRhLvj3kho2weuO
        7r+/zecodQnKYEo0U2s+PaKKrq4GXfZE1bOEJARXZXU+Qmd5kYXbxFiKWVT+vFJ5
        LrZOsJ1gvELb1u1nXqjRNeUNby3pN2QW8HFzgiX1LPmza0iH4naxdxpdzMwvrF46
        4olrClCssrBePfJ6zEVNJCecpvgPp3ynaUmEUOgZkvsAqjbMUJVXei/aD05BFIbC
        ujfu7Z6K+Wx/3wqojERCvH49WBDCMG1Nzf1DXWLdsdlaR+7ms2SxK2hzW9kb2nvD
        PkeBjcVivSfXHXstJ2A67ELhke4srjNOWnc78oCQs56gnF77V+Ms1hxW6m7IQSGf
        EWl/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=S1RVPrc/JniTsOu3BXowJ2wtLOesVnuNoMJ1MWL5+
        Lc=; b=BKPg07tJE1cUKlzd0dxkj3cOA43c5XguC+N0ICtkb1OR0f6CqiOJzFQYF
        BgDvBrUt8GO7MVSGDzbyNWP9vCHmsqhSf9i0zhowk802oA+0vHnfFqTZKPlBt9uA
        LlWpt1PSOhjIlvD2PV42NdQZWueoYAVVTqmlmomQQFvQNNbn6TuMK5OawSe6HLx9
        /RkjIjzpwwv/alU9L3dG3X53njGmwaIDTAnwq8uoYCydJcMQg6F8BGu5gIFtnhWt
        HQuw2MgWGI2avjWC0n5BRfLjrC28UsoKZ65xg4MbZcjvEr/onYuuwoEeXi7npn2E
        MecJIb4jvxydo9jK4DcFYjMuSIaJw==
X-ME-Sender: <xms:iWQvYWMtTDEWQNE3R7Iu4k96vaxr9fPtNSX8bhj-TQJ_p2DJUJYIcg>
    <xme:iWQvYU9hcGfv0TzZBIoq_GiQ9LQ74xdjuCAZ8TN4IooLjwUtZiEMYTwxUk2iM3qqu
    WulOv9h9hQEEw>
X-ME-Received: <xmr:iWQvYdTAejDkL6E0A5B8f39ZSUkjskltcaaqrI1s2RiCkkB9f8qEgJ0HnLT2LKMaIhn-L0PTycbfHFfPM03n0QfmE5XrSsKl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:iWQvYWv-1c2F5Oy3S1sn6-9WkxIZuJms131P-QG0fCOKEcLOtdqK3A>
    <xmx:iWQvYec5mXdVZUXt50l3IoAPy0txr8n1zLAciTvFWqe6upelrR8_VQ>
    <xmx:iWQvYa3NHcoX0PDcUFa38dwXFJ5N43X3fl6IewxXLq7olJM77PBLuA>
    <xmx:imQvYU18lPm-QR-Hfht_VmtGA6tRb9KAeS5i0XsGny7XA89DfDNRyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 07:31:20 -0400 (EDT)
Date:   Wed, 1 Sep 2021 13:31:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 4.14 1/4] bpf: Do not use ax register in interpreter on
 div/mod
Message-ID: <YS9khsCFrPQ4PZDm@kroah.com>
References: <20210830183211.339054-1-cascardo@canonical.com>
 <20210830183211.339054-2-cascardo@canonical.com>
 <YS9kXabJPWScxiHi@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YS9kXabJPWScxiHi@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 01:30:37PM +0200, Greg KH wrote:
> On Mon, Aug 30, 2021 at 03:32:08PM -0300, Thadeu Lima de Souza Cascardo wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
> > register in interpreter"). The reason we need this here is because ax
> > register will be used for holding temporary state for div/mod instruction
> > which otherwise interpreter would corrupt. This will cause a small +8 byte
> > stack increase for interpreter, but with the gain that we can use it from
> > verifier rewrites as scratch register.
> > 
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> > [cascardo: This partial revert is needed in order to support using AX for
> > the following two commits, as there is no JMP32 on 4.19.y]
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
> >  kernel/bpf/core.c | 32 +++++++++++++++-----------------
> >  1 file changed, 15 insertions(+), 17 deletions(-)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index e7211b0fa27c..30d871be9974 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -616,9 +616,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
> >  	 * below.
> >  	 *
> >  	 * Constant blinding is only used by JITs, not in the interpreter.
> > -	 * The interpreter uses AX in some occasions as a local temporary
> > -	 * register e.g. in DIV or MOD instructions.
> > -	 *
> >  	 * In restricted circumstances, the verifier can also use the AX
> >  	 * register for rewrites as long as they do not interfere with
> >  	 * the above cases!
> > @@ -951,6 +948,7 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> >  	u32 tail_call_cnt = 0;
> >  	void *ptr;
> >  	int off;
> > +	u64 tmp;
> >  
> >  #define CONT	 ({ insn++; goto select_insn; })
> >  #define CONT_JMP ({ insn++; goto select_insn; })
> > @@ -1013,22 +1011,22 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> >  	ALU64_MOD_X:
> >  		if (unlikely(SRC == 0))
> >  			return 0;
> > -		div64_u64_rem(DST, SRC, &AX);
> > -		DST = AX;
> > +		div64_u64_rem(DST, SRC, &tmp);
> > +		DST = tmp;
> >  		CONT;
> >  	ALU_MOD_X:
> >  		if (unlikely((u32)SRC == 0))
> >  			return 0;
> > -		AX = (u32) DST;
> > -		DST = do_div(AX, (u32) SRC);
> > +		tmp = (u32) DST;
> > +		DST = do_div(tmp, (u32) SRC);
> >  		CONT;
> >  	ALU64_MOD_K:
> > -		div64_u64_rem(DST, IMM, &AX);
> > -		DST = AX;
> > +		div64_u64_rem(DST, IMM, &tmp);
> > +		DST = tmp;
> >  		CONT;
> >  	ALU_MOD_K:
> > -		AX = (u32) DST;
> > -		DST = do_div(AX, (u32) IMM);
> > +		tmp = (u32) DST;
> > +		DST = do_div(tmp, (u32) IMM);
> >  		CONT;
> >  	ALU64_DIV_X:
> >  		if (unlikely(SRC == 0))
> > @@ -1038,17 +1036,17 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
> >  	ALU_DIV_X:
> >  		if (unlikely((u32)SRC == 0))
> >  			return 0;
> > -		AX = (u32) DST;
> > -		do_div(AX, (u32) SRC);
> > -		DST = (u32) AX;
> > +		tmp = (u32) DST;
> > +		do_div(tmp, (u32) SRC);
> > +		DST = (u32) tmp;
> >  		CONT;
> >  	ALU64_DIV_K:
> >  		DST = div64_u64(DST, IMM);
> >  		CONT;
> >  	ALU_DIV_K:
> > -		AX = (u32) DST;
> > -		do_div(AX, (u32) IMM);
> > -		DST = (u32) AX;
> > +		tmp = (u32) DST;
> > +		do_div(tmp, (u32) IMM);
> > +		DST = (u32) tmp;
> >  		CONT;
> >  	ALU_END_TO_BE:
> >  		switch (IMM) {
> > -- 
> > 2.30.2
> > 
> 
> Oops, no, this patch causes build errors:
> 
> kernel/bpf/core.c: In function ‘___bpf_prog_run’:
> kernel/bpf/core.c:951:13: error: redeclaration of ‘tmp’ with no linkage
>   951 |         u64 tmp;
>       |             ^~~
> kernel/bpf/core.c:839:13: note: previous declaration of ‘tmp’ with type ‘u64’ {aka ‘long long unsigned int’}
>   839 |         u64 tmp;
>       |             ^~~
> make[2]: *** [scripts/Makefile.build:329: kernel/bpf/core.o] Error 1
> 
> 
> Please fix up and resend the whole series, as I will go drop these 3
> patches from the 4.14.y queue now.

All _4_ patches I mean.  now dropped...
