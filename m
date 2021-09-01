Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C664E3FD8C4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 13:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbhIALbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 07:31:39 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:33867 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238369AbhIALbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 07:31:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5D804580BFF;
        Wed,  1 Sep 2021 07:30:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 01 Sep 2021 07:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=G
        PssD/uNZz84wcIk7cs83jegUsWzfmRSjClnkDPIgT4=; b=rhLMtQtIuPNPno+aR
        q8BW/JT4rJxJ4DpiYa/9bgd+ku1hdTL3Ipup847P5J6zOBgsXwjXqTO8YpPVOuov
        6/UirwgYJ9LLE30QPYrOtQpSTjyVYO2r0OqdCQ6R6pSZBZ7AiGuKrd2NTMSi3E0g
        nhxSpZc/ZDgGa0QhjDcutq4w26DWWaGZelibSvuoSGMPUVM7KwF0pYfPisIG+sMR
        S5j0WwYibX/dKohT7axK6FmpuJY+PWOECq5lU2UYro5iynVn3YPGXUjzN8Pvg5uW
        rbqBMdMcMXKQ8kNv6pMnQyWqMo8K5xX/f6zQ8yE2U5ccUEtGYN162H/pFsVyY+EA
        5P6HA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=GPssD/uNZz84wcIk7cs83jegUsWzfmRSjClnkDPIg
        T4=; b=Yp0slgk16ydWOUxchwYVNjj8806MGQkrBo1mgpSgSw9YjZ27tQMVN9jcV
        ndc+jGsERnLBJnWLQfAA/DDN4TSzVvrR1aEtH+BVVetMZT9BVgaEviPmnDD7kT5H
        REHmMRT9MSLOiwt+MmZl9c26ez7Qg2lEZit1FaNWGYjTQfphjqFzWLB+Pn32vCgg
        BqUT4ZPGtjuFpvL5WuGuOTBA/8c0DL99t57ohE1i3imy7dQg5aFvRzm4qFqfzSEq
        vUI0KsnVPuJwOwoukk3+NfRkey16WLMedd50J+Lm4zg2xM09vdtRQ3w/v0jeNoEQ
        /1rE305G7v4vsLbtsfQxUUHU29Dtw==
X-ME-Sender: <xms:YGQvYYIWkXLk4QaLJQVr5sKMq5HTwZBNthN2nY3dPuX9QjB4guxZUQ>
    <xme:YGQvYYJ9zeWCnUqo-4rIsvLEXPEVG-0i289zieQKUR1cYHNpoliUPnFZfV1KFzfpP
    FS3nHyQmQ5zCQ>
X-ME-Received: <xmr:YGQvYYuUed4mfpFgm0msiUbbqjjgEQeSpRSyk2m4O8h_zsrseHdcljRpfgt6A_yi0aB7uKN-O5D_vgL2WvhOXypue-p4i1Eu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:YGQvYVaNQLQte4Uzg5HypTNd6SatHM5GibQixsJZMhpsJ1GQ76ZQ7w>
    <xmx:YGQvYfY1A9pBoyy1qE3Y7gOTQrbpgENtqwOI6Q1v2SMJpswztecMrA>
    <xmx:YGQvYRCah0mdyDcEFR5L8BrmkppTqUeT2O9rW3W_A7ufOdEliNuGVQ>
    <xmx:YmQvYTTMXzy1QJ23DGh_7wNNzfPrYWDuFPPrbKnX3T55WZXNE4rWdg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 07:30:40 -0400 (EDT)
Date:   Wed, 1 Sep 2021 13:30:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 4.14 1/4] bpf: Do not use ax register in interpreter on
 div/mod
Message-ID: <YS9kXabJPWScxiHi@kroah.com>
References: <20210830183211.339054-1-cascardo@canonical.com>
 <20210830183211.339054-2-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210830183211.339054-2-cascardo@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 03:32:08PM -0300, Thadeu Lima de Souza Cascardo wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> Partially undo old commit 144cd91c4c2b ("bpf: move tmp variable into ax
> register in interpreter"). The reason we need this here is because ax
> register will be used for holding temporary state for div/mod instruction
> which otherwise interpreter would corrupt. This will cause a small +8 byte
> stack increase for interpreter, but with the gain that we can use it from
> verifier rewrites as scratch register.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> [cascardo: This partial revert is needed in order to support using AX for
> the following two commits, as there is no JMP32 on 4.19.y]
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  kernel/bpf/core.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index e7211b0fa27c..30d871be9974 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -616,9 +616,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
>  	 * below.
>  	 *
>  	 * Constant blinding is only used by JITs, not in the interpreter.
> -	 * The interpreter uses AX in some occasions as a local temporary
> -	 * register e.g. in DIV or MOD instructions.
> -	 *
>  	 * In restricted circumstances, the verifier can also use the AX
>  	 * register for rewrites as long as they do not interfere with
>  	 * the above cases!
> @@ -951,6 +948,7 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
>  	u32 tail_call_cnt = 0;
>  	void *ptr;
>  	int off;
> +	u64 tmp;
>  
>  #define CONT	 ({ insn++; goto select_insn; })
>  #define CONT_JMP ({ insn++; goto select_insn; })
> @@ -1013,22 +1011,22 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
>  	ALU64_MOD_X:
>  		if (unlikely(SRC == 0))
>  			return 0;
> -		div64_u64_rem(DST, SRC, &AX);
> -		DST = AX;
> +		div64_u64_rem(DST, SRC, &tmp);
> +		DST = tmp;
>  		CONT;
>  	ALU_MOD_X:
>  		if (unlikely((u32)SRC == 0))
>  			return 0;
> -		AX = (u32) DST;
> -		DST = do_div(AX, (u32) SRC);
> +		tmp = (u32) DST;
> +		DST = do_div(tmp, (u32) SRC);
>  		CONT;
>  	ALU64_MOD_K:
> -		div64_u64_rem(DST, IMM, &AX);
> -		DST = AX;
> +		div64_u64_rem(DST, IMM, &tmp);
> +		DST = tmp;
>  		CONT;
>  	ALU_MOD_K:
> -		AX = (u32) DST;
> -		DST = do_div(AX, (u32) IMM);
> +		tmp = (u32) DST;
> +		DST = do_div(tmp, (u32) IMM);
>  		CONT;
>  	ALU64_DIV_X:
>  		if (unlikely(SRC == 0))
> @@ -1038,17 +1036,17 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
>  	ALU_DIV_X:
>  		if (unlikely((u32)SRC == 0))
>  			return 0;
> -		AX = (u32) DST;
> -		do_div(AX, (u32) SRC);
> -		DST = (u32) AX;
> +		tmp = (u32) DST;
> +		do_div(tmp, (u32) SRC);
> +		DST = (u32) tmp;
>  		CONT;
>  	ALU64_DIV_K:
>  		DST = div64_u64(DST, IMM);
>  		CONT;
>  	ALU_DIV_K:
> -		AX = (u32) DST;
> -		do_div(AX, (u32) IMM);
> -		DST = (u32) AX;
> +		tmp = (u32) DST;
> +		do_div(tmp, (u32) IMM);
> +		DST = (u32) tmp;
>  		CONT;
>  	ALU_END_TO_BE:
>  		switch (IMM) {
> -- 
> 2.30.2
> 

Oops, no, this patch causes build errors:

kernel/bpf/core.c: In function ‘___bpf_prog_run’:
kernel/bpf/core.c:951:13: error: redeclaration of ‘tmp’ with no linkage
  951 |         u64 tmp;
      |             ^~~
kernel/bpf/core.c:839:13: note: previous declaration of ‘tmp’ with type ‘u64’ {aka ‘long long unsigned int’}
  839 |         u64 tmp;
      |             ^~~
make[2]: *** [scripts/Makefile.build:329: kernel/bpf/core.o] Error 1


Please fix up and resend the whole series, as I will go drop these 3
patches from the 4.14.y queue now.

greg k-h
