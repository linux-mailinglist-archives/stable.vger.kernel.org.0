Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1E8522035
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346538AbiEJP6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347325AbiEJP50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:57:26 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2570929B00D;
        Tue, 10 May 2022 08:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1652197774;
        bh=jGOBs/UK7Wuf/73tooLnJSTteyWCS+jQ2JdfAa53BZI=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=SdjJ4H/hJFvsqer19yer80ICiNhhCDbdTsDks2vnoGsKMVxZVXjkkon/tGAF5ukI/
         O8LTiTB3OJtp/rSsNweIyO5iOTsdftAVGS35+88JwBJplDqm6PqXL5e827QoLXGECj
         3YdLvr27CnJbFce0zk1hc4P/Jq8GDZla1mg42xdY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.182.129]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mk0NU-1oCXSv3qKO-00kPE5; Tue, 10
 May 2022 17:49:33 +0200
Message-ID: <37d6bcac-bca4-06a6-ecab-bf83bd3468cd@gmx.de>
Date:   Tue, 10 May 2022 17:49:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH AUTOSEL 5.17 21/21] Revert "parisc: Fix patch code locking
 and flushing"
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     James.Bottomley@HansenPartnership.com, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org
References: <20220510154340.153400-1-sashal@kernel.org>
 <20220510154340.153400-21-sashal@kernel.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220510154340.153400-21-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DbkjErZqGYtxT2MmD6i3Zo6PUeOP1VMhIDXgUqyYizJoykpfmQ4
 d2PxGyVXkrbmeEuymU2QPyskc5EsBVI7MeBlBQBVkDgucQnJu5w+ByFqoMenT19x4Z0YCpd
 OfQeGDM6kmQ0jvI/CATPhcvwNeKrSEFjsj125OFeILAzrfAGKUs9niKtkB0HtgqKRhVoY0v
 gaKiTPZvm8dsvPtaC7pSA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Hs2MDU1jC1A=:8TpJZn618p2URZBBZ9GZ/g
 8sQFXgdgmx521RiPGsCqPLNYXbqtqbFrh1Ds0deT6pAn7dl6LrMZ/cwYWQgpfmrUHU0op2HqZ
 OgIDWnMlV8baftwQZ+FuV88EoThjuEJQ5ZPpkHq3KIcJ1JbwUo1MmsaVOmQpwj1hIyEHW7s4U
 08btqIwgIrWXhP1c+KKFeszp8UxF9iEr7dGKQnPQJyGFtaauoAnmY2u8ZUdeXENto4Z5PxdQN
 wetQ3RiIBl9HB9V9MjOhe3d58xfwUSRlj6EiobtZ6hhwwuHrQ2uyyZIlvp6socqmI/xvMfd6o
 sFzHTXsW8Ix338wk+SwOpGug4xdnnjeqaONcpMS2w7/bLdY+RIr2peqTottdfetQKbSEx3OK3
 +p9p1ITLV5X3WFTfuCkUP8V+meIpP3nog1EMvb2DIFbdUpDm+R5EkerzVTz+t14pno/qVIcTD
 Qs/eVPiItldLEdJtXkiqV+VpyYIONR8M2/jbVuzsdXGOLSzjhE6dyxDO6AaXuYJMjYIN3j7si
 fryb1efui2cI1c/K9w2rkQB+EacYPpo1YektXXkjWgAs1rRgWLIroNfyRzeHAQ6gu0WiH9eff
 rQfxQs67ihrhjKqfk7A7ZhUflwDJU7MiIZFOppgmcyouhwmGqV9RjDkJwHCcX/Swz42CT5SsR
 HnXBC3yDBptgSsjfJgXy6HhlQo9Pockzz9RgVqsiZaLJ0C7LCs/ku933i0KSP4PCg+LElF1xa
 fOKJw2MPteHAcNwDzpJItf8na/RvxEEckkdwaBof97pAIgeaeqMQXKcKHdszo2kfs0l4fkaGL
 yEI1k7o5xniG+e8Q4gpNPbjB6X4/8+coz55asevkNul71VyOINJLTsCwBUnV5FuxyqhPNmfrl
 +A7O5jaqD5xIR8rTx/zxI3cM6TnHW/YJQ8UooFFfgXlyGCDcqrnAzirP8xbRFCG0v2Eh1xILC
 yuvHYDKXOu6UMsqrvkYEZ5TSYG+N5cJB786ogXXNo797oRHWknErpRq/eCLktsdmP2/Dl/9DN
 oN1CNs78dmI4qSn0PqX5QNcFvb1JhJ9TZvLHpGFzXZee3uy94YeJYPa0XuyS1Qs4JRx88/fRc
 tq4XMWG9h3GUII=
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sascha,

please drop this patch from all your stable-series queues....
It shouldn't be backported.

Thanks,
Helge

On 5/10/22 17:43, Sasha Levin wrote:
> From: Helge Deller <deller@gmx.de>
>
> [ Upstream commit 6c800d7f55fcd78e17deae5ae4374d8e73482c13 ]
>
> This reverts commit a9fe7fa7d874a536e0540469f314772c054a0323.
>
> Leads to segfaults on 32bit kernel.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/parisc/kernel/patch.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/arch/parisc/kernel/patch.c b/arch/parisc/kernel/patch.c
> index e59574f65e64..80a0ab372802 100644
> --- a/arch/parisc/kernel/patch.c
> +++ b/arch/parisc/kernel/patch.c
> @@ -40,7 +40,10 @@ static void __kprobes *patch_map(void *addr, int fixm=
ap, unsigned long *flags,
>
>  	*need_unmap =3D 1;
>  	set_fixmap(fixmap, page_to_phys(page));
> -	raw_spin_lock_irqsave(&patch_lock, *flags);
> +	if (flags)
> +		raw_spin_lock_irqsave(&patch_lock, *flags);
> +	else
> +		__acquire(&patch_lock);
>
>  	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
>  }
> @@ -49,7 +52,10 @@ static void __kprobes patch_unmap(int fixmap, unsigne=
d long *flags)
>  {
>  	clear_fixmap(fixmap);
>
> -	raw_spin_unlock_irqrestore(&patch_lock, *flags);
> +	if (flags)
> +		raw_spin_unlock_irqrestore(&patch_lock, *flags);
> +	else
> +		__release(&patch_lock);
>  }
>
>  void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned in=
t len)
> @@ -61,9 +67,8 @@ void __kprobes __patch_text_multiple(void *addr, u32 *=
insn, unsigned int len)
>  	int mapped;
>
>  	/* Make sure we don't have any aliases in cache */
> -	flush_kernel_dcache_range_asm(start, end);
> -	flush_kernel_icache_range_asm(start, end);
> -	flush_tlb_kernel_range(start, end);
> +	flush_kernel_vmap_range(addr, len);
> +	flush_icache_range(start, end);
>
>  	p =3D fixmap =3D patch_map(addr, FIX_TEXT_POKE0, &flags, &mapped);
>
> @@ -76,10 +81,8 @@ void __kprobes __patch_text_multiple(void *addr, u32 =
*insn, unsigned int len)
>  			 * We're crossing a page boundary, so
>  			 * need to remap
>  			 */
> -			flush_kernel_dcache_range_asm((unsigned long)fixmap,
> -						      (unsigned long)p);
> -			flush_tlb_kernel_range((unsigned long)fixmap,
> -					       (unsigned long)p);
> +			flush_kernel_vmap_range((void *)fixmap,
> +						(p-fixmap) * sizeof(*p));
>  			if (mapped)
>  				patch_unmap(FIX_TEXT_POKE0, &flags);
>  			p =3D fixmap =3D patch_map(addr, FIX_TEXT_POKE0, &flags,
> @@ -87,10 +90,10 @@ void __kprobes __patch_text_multiple(void *addr, u32=
 *insn, unsigned int len)
>  		}
>  	}
>
> -	flush_kernel_dcache_range_asm((unsigned long)fixmap, (unsigned long)p)=
;
> -	flush_tlb_kernel_range((unsigned long)fixmap, (unsigned long)p);
> +	flush_kernel_vmap_range((void *)fixmap, (p-fixmap) * sizeof(*p));
>  	if (mapped)
>  		patch_unmap(FIX_TEXT_POKE0, &flags);
> +	flush_icache_range(start, end);
>  }
>
>  void __kprobes __patch_text(void *addr, u32 insn)

