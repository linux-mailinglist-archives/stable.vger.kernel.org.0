Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5538B532F2E
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiEXQp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbiEXQp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:45:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF427427FF;
        Tue, 24 May 2022 09:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1653410713;
        bh=gLTqESgkAFXqK+taUv6Ift55c8iBixK6EHmM6tkr+gs=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Ntf5/GKPt7waxQaMaK91YXanz0KAshFY6MJ595uEIAJGjwVkzYt11D2x5AiYA0b4L
         twFxRySc+irwcXFnXYMcXCcV6bmOiofaZRn0+Bbib8yOkx5N2cAqRkOjefbe7J6YES
         Iqi2teVjOTaqqmn8FakI/Zq7URGni2+MtNEz2W84=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.137.3]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MPokN-1oFtl42BsZ-00MrQe; Tue, 24
 May 2022 18:45:13 +0200
Message-ID: <786f58e8-aa61-d439-c9bb-4a27599d2aa5@gmx.de>
Date:   Tue, 24 May 2022 18:44:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH AUTOSEL 5.10 2/8] parisc: Disable debug code regarding
 cache flushes in handle_nadtlb_fault()
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
        zhengqi.arch@bytedance.com, linux-parisc@vger.kernel.org
References: <20220524160035.827109-1-sashal@kernel.org>
 <20220524160035.827109-2-sashal@kernel.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220524160035.827109-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:lxjHMfxahx2TQbAWs57lPcq/4pfkYB1LueL12A81ItzRKOHqtC5
 prI0PdUpPX+ZV+ug1dWE1Y7yDjLaTULuj+7l6JO6U9GOmUDrP2LKSXlcuH3eLy//2gEzQJx
 rQCRNoz3YEBjeuiS/K6R5a2HK3vGW1GKMQmpK4W1srU3zXvyUyiW4IZYwoOKVlxdMIpOc/T
 mQX/e4mgmonfqX73Lu0+w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rWhv9GBFGZM=:xV29K9fWzhmf773KfTlsUz
 Ikf52/0aHB5vOQIBKFABHzm6X5oWLcXySsabm19UtEQZXtfdAhJIo1vNjaZ2W2fLBRBZCqrTT
 /lio+1p84hJdwbNA6rDXzYkDwcGyt7dpTX3k5eBgN0YRen/FOoQ9OsdqUmBSJF7SEuTAceSwd
 ZnVy3lbLOt3tdB5YjpAYX7Gpu6p+X0dABKH/e7rh9Y1wxch1RxkldREvqIhjv/iYb9fnMDZi5
 8DNLr9WK6wPTSxVrvs7wypDhJV4ogp+aQajIg3KpSVJ7lgxnFKgxUEeHDmATxfmsiUZkSMKmY
 vSZtgDu+IGyus8QN6NNepGsyfz8vCXS+a+2odmFsdHXwRekxQtwsoJKaGsotS1uCaD6Zi/lcU
 BuysxZIVSy1nAe5pFiWc+P/nSSffq+4LhQohcJKATQvJXMK2mo3Z0+U5BtWGa0ORy/2rmRyAO
 CPL+rAkPRsqRtlogQ5XUg7ExSQn2H7mfB09FC+5vPhgxQE3/bGM6VCz5TosHQzuDpzUZtegC6
 Pby5VvYreBkcsOvDoplsz9u9e+f3Wc7bFsmoVaJO9QNBBGp010y0PStDWONLb0laMRhIb/98V
 jsS8+cc6xXSwjilMZ3aKdxhekaqpyNa/dw+yKk4sN91HBuagQzXYF6YSlr+dmrKRYkf8OiAqw
 uSM3itKcDJyy0N5elr+W/c2++Q312XgmoRP1QAOzC7QDTx2RSqRWMM5udX42bJ2LwY7ewAlH2
 3riI5TlvuyK6EqKQ2Ko7DkmxnSeiwzUsJtclqZmgKlC+7271iIWIBBeE8Dihi85PcSbsNsbxD
 0InxplVOTwNoOS6VKdfNKB3cyKnb9PON3L2hkDHvldS0jkgXOdSQImaYeYZMzLabpePOFpUBV
 hIOQw5g684ZgL9eB5H2fhKntcSGZYHcn7SUYeR6fO6Cy44U/ZPu+eJ0VtUyA31yEXIhYC+a5r
 xiI8Co0QpY8gGE467YLTdE/58i4VESW5xHTPMLcROGTbNaxAwYtzzgavX3Z0AWj9iaWdWMxnO
 pQLncz4W/54Ax76szGC7XTjtcvBv1CbBYFmj7IutA/Nb4Ey7G5qkz3OXAP1liorvUcgkdtLzL
 2ICqcEcttdAj1H1mW5MYdSxcZAbvMXw07qN
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sascha,

On 5/24/22 18:00, Sasha Levin wrote:
> From: John David Anglin <dave.anglin@bell.net>
>
> [ Upstream commit 67c35a3b646cc68598ff0bb28de5f8bd7b2e81b3 ]
>
> Change the "BUG" to "WARNING" and disable the message because it trigger=
s
> occasionally in spite of the check in flush_cache_page_if_present.

Please drop this patch from the backporting-queue (v5.10, v5.15 and v5.17)=
.
It's not necessary since the warning will only trigger on v5.18 on machine=
s
with PA8800/PA8900 processors.

Thanks.
Helge


> The pte value extracted for the "from" page in copy_user_highpage is rac=
y and
> occasionally the pte is cleared before the flush is complete.  I assume =
that
> the page is simultaneously flushed by flush_cache_mm before the pte is c=
leared
> as nullifying the fdc doesn't seem to cause problems.
>
> I investigated various locking scenarios but I wasn't able to find a way=
 to
> sequence the flushes.  This code is called for every COW break and locks=
 impact
> performance.
>
> This patch is related to the bigger cache flush patch because we need th=
e pte
> on PA8800/PA8900 to flush using the vma context.
> I have also seen this from copy_to_user_page and copy_from_user_page.
>
> The messages appear infrequently when enabled.
>
> Signed-off-by: John David Anglin <dave.anglin@bell.net>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/parisc/mm/fault.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
> index 5faa3cff4738..2472780d4039 100644
> --- a/arch/parisc/mm/fault.c
> +++ b/arch/parisc/mm/fault.c
> @@ -22,6 +22,8 @@
>
>  #include <asm/traps.h>
>
> +#define DEBUG_NATLB 0
> +
>  /* Various important other fields */
>  #define bit22set(x)		(x & 0x00000200)
>  #define bits23_25set(x)		(x & 0x000001c0)
> @@ -449,8 +451,8 @@ handle_nadtlb_fault(struct pt_regs *regs)
>  		fallthrough;
>  	case 0x380:
>  		/* PDC and FIC instructions */
> -		if (printk_ratelimit()) {
> -			pr_warn("BUG: nullifying cache flush/purge instruction\n");
> +		if (DEBUG_NATLB && printk_ratelimit()) {
> +			pr_warn("WARNING: nullifying cache flush/purge instruction\n");
>  			show_regs(regs);
>  		}
>  		if (insn & 0x20) {

