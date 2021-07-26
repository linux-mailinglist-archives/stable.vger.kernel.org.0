Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437893D5380
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhGZGUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 02:20:50 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:51163 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231926AbhGZGUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 02:20:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 86CD6320014C;
        Mon, 26 Jul 2021 03:01:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 26 Jul 2021 03:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm2; bh=J
        zhgFa7wAhuq5NfC2bG2do2m/BKCFKWYoy8V5ZRRaq4=; b=IjwduQBnyUBL6t1EF
        cyUAVwUiSxCiXuv1gkFmCMs/vG4XaCXGXbGFiPtATmmtNB332mktH0sAAXr/J1mF
        RvBHanH39T7QGRI/3TA/2vd4ypL2+EGiGfZExg9tkFlsrdFo9CcddgoS+Ab9uQhP
        bhpwQI5RZESqNimKYLjiaKEzRuMCrdeFD6ha4ETSl1matmNukGXvCHeDfYZ0pc5N
        6oELPoNB8s5opSiXXoGTtqdRPVMIuth3rHR7aDfvad89q0KYNnT/N/m4LfiRXZO8
        pFctAtZ9IoMFJNIIRzzlbdJHVBTf25JhP3qs62uoHnqvgmNDHWkrH/0JHYbKoWWs
        gxiDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=JzhgFa7wAhuq5NfC2bG2do2m/BKCFKWYoy8V5ZRRa
        q4=; b=ctPkjrh0kZ6rr3OMqav13P8XJiClmksad6QIXmI7f0w4shAtzHNoQ31V6
        lEsyJ4isxdcUPqadNbmk41gtTZAhX+dFwCEx/bbiXSR9r3ZxhpUtQeK+J2ekTzZa
        UbBR+FqRqrgt6eg1YaEMsSrdRiWBREkyzZd4sVOuodB/lkF0bCT75+IKIMVxctxI
        8f2/cOX+hhZ1v9LkWfHFScU3nv7s2IZiBwebtEkq1Q4VNJSzxiOmAiJDT0DuyX6A
        fMLLDnVySbjQF2d3cBl/3itNPN2O60Aaw5VKMP2dg5XS8C9w5gO0zHqEsSVmkKUn
        Q12sMnwHwlL8sEH8E98G7pwhdVRTw==
X-ME-Sender: <xms:sl3-YFQZNn9HMt_MiulUaG1Vr8cI_Q-mmi-IhpIPW6oh6xKFGdrLpw>
    <xme:sl3-YOxcMD6Xpgy68vDg1TLcMA77-eAgwTQPi_VsXxK6Yclm1ExTj3qqbxvXFYwxi
    gu7VfhKPKWGrj5Jisk>
X-ME-Received: <xmr:sl3-YK3wAzesuVXLwwY_0CeDGJZI8pr1pSYMHkXa7Utqn640XqGgCjmJy5g2XXwTp77URjKFL_b1PDNXkW0B0yhNyo2E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeeggddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthekredttdeftfenucfhrhhomheplfhirgig
    uhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpeefleduiedtvdekffeggfeukeejgeeffeetlefghfekffeuteei
    jeeghefhueffvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:sl3-YNBTSCEFgb4ICr78pJkz9_uD8WMyhNh_KyUq5gNvqn1NOCPmCw>
    <xmx:sl3-YOhTHAdHaPMhTysTMBWtvj4EjiRZyCY7EDf03VdnGThZnYdt6A>
    <xmx:sl3-YBrGOIXDcKnkR8Iz0BvlotqZOsQhYI1L2P4vqCOctXb3Z5jVGg>
    <xmx:s13-YHVe9CWdR1Rl1RFGlD78tjXBVTWvKmiFy2hJh_l43dwdxlE94A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Jul 2021 03:01:01 -0400 (EDT)
Subject: Re: [PATCH] Revert "MIPS: add PMD table accounting into
 MIPS'pmd_alloc_one"
To:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        ambrosehua@gmail.com
Cc:     Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org,
        Li Xuefeng <lixuefeng@loongson.cn>,
        Yang Tiezhu <yangtiezhu@loongson.cn>,
        Gao Juxin <gaojuxin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>
References: <20210726014837.68280-1-huangpei@loongson.cn>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <a4225543-a746-d9d1-0c93-27d83b695cc3@flygoat.com>
Date:   Mon, 26 Jul 2021 15:00:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726014837.68280-1-huangpei@loongson.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2021/7/26 ÉÏÎç9:48, Huang Pei Ð´µÀ:
> This reverts commit 002d8b395fa1c0679fc3c3e68873de6c1cc300a2.
>
> b2b29d6d011944 (mm: account PMD tables like PTE tables) is
> introduced between v5.9 and v5.10, so this fix should NOT
> apply to any pre-5.10 branch

Missing sign-off.

Also I think you should make it clear that the patch is for stable in 
subject
(like [PATCH for stable]) and Cc stable folks like Greg to catch their 
attention.

Thanks.

- Jiaxun

> ---
>   arch/mips/include/asm/pgalloc.h | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
> index dd10854321ca..166842337eb2 100644
> --- a/arch/mips/include/asm/pgalloc.h
> +++ b/arch/mips/include/asm/pgalloc.h
> @@ -62,15 +62,11 @@ do {							\
>   
>   static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
>   {
> -	pmd_t *pmd = NULL;
> -	struct page *pg;
> +	pmd_t *pmd;
>   
> -	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
> -	if (pg) {
> -		pgtable_pmd_page_ctor(pg);
> -		pmd = (pmd_t *)page_address(pg);
> +	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
> +	if (pmd)
>   		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
> -	}
>   	return pmd;
>   }
>   

