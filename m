Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853DD263B48
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 05:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgIJDS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 23:18:27 -0400
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:35610 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIJDSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 23:18:18 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2020 23:18:17 EDT
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 1CC8D20F05;
        Thu, 10 Sep 2020 00:52:56 +0000 (UTC)
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.156])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id B3CBE200FE;
        Thu, 10 Sep 2020 00:52:51 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 336373F162;
        Thu, 10 Sep 2020 02:52:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 046F02A911;
        Thu, 10 Sep 2020 02:52:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1599699168;
        bh=D8Rx4XNdW7iycZCOZNL/5TBrTdaKyK7RNrdOMjIaj38=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rmvLqgAqrZ2hvUHsTsa5co0Jzwu6DeChyQfOPHPdXOcMyYrSeC1pCCfx+OGeP+M3Q
         OZx0Pu7Y653bf7EVektXeSLcPJoRV+i7vNxaudLfuxoGZaaqsO1PXTMkwHTkHVkS22
         +TzcsFygQlghg6rHg+QeSR63dBbxM4JO4V59D10Y=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uKQKwz0uYRLp; Thu, 10 Sep 2020 02:52:46 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Thu, 10 Sep 2020 02:52:46 +0200 (CEST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id CEEBA40FF4;
        Thu, 10 Sep 2020 00:52:43 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="HM6emQRP";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1197-90.members.linode.com [45.79.98.90])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id EF4ED40FF4;
        Thu, 10 Sep 2020 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1599699134;
        bh=D8Rx4XNdW7iycZCOZNL/5TBrTdaKyK7RNrdOMjIaj38=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HM6emQRPCVOt4SGBD43g0qbp9tNA0mgb+xhruqhuSSyOXGv82rEBe1JD2e75hT+NC
         lc9PyvXGYxkugBNB6ZWiByQ1H/pS8J6mWTmHXQ+YuFoTf+UNlxvMJBl3gRYwOcNQgU
         OMPQYmjvx5k3SjVL/K20ZmT1aZeQyvwEb49/feM0=
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <be0840ac-ecb4-1c93-828f-0773f348f4b0@flygoat.com>
Date:   Thu, 10 Sep 2020 08:51:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <1599624552-17523-3-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CEEBA40FF4
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[9];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[vger.kernel.org,lemote.com,gmail.com];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2020/9/9 12:09, Huacai Chen Ð´µÀ:
> Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.

It doesn't make sense at all.

How can you allocate IRQ without irqchip backing it?

- Jiaxun

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>   drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
> index 9bf6b9a..9f6719c 100644
> --- a/drivers/irqchip/irq-loongson-pch-pic.c
> +++ b/drivers/irqchip/irq-loongson-pch-pic.c
> @@ -35,6 +35,7 @@
>   
>   struct pch_pic {
>   	void __iomem		*base;
> +	struct irq_domain	*lpc_domain;
>   	struct irq_domain	*pic_domain;
>   	u32			ht_vec_base;
>   	raw_spinlock_t		pic_lock;
> @@ -184,9 +185,9 @@ static void pch_pic_reset(struct pch_pic *priv)
>   static int pch_pic_of_init(struct device_node *node,
>   				struct device_node *parent)
>   {
> +	int i, base, err;
>   	struct pch_pic *priv;
>   	struct irq_domain *parent_domain;
> -	int err;
>   
>   	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
> @@ -213,6 +214,22 @@ static int pch_pic_of_init(struct device_node *node,
>   		goto iounmap_base;
>   	}
>   
> +	base = irq_alloc_descs(-1, 0, NR_IRQS_LEGACY, 0);
> +	if (base < 0) {
> +		pr_err("Failed to allocate LPC IRQ numbers\n");
> +		goto iounmap_base;
> +	}
> +
> +	priv->lpc_domain = irq_domain_add_legacy(node, NR_IRQS_LEGACY, 0, 0,
> +						 &irq_domain_simple_ops, NULL);
> +	if (!priv->lpc_domain) {
> +		pr_err("Failed to add irqdomain for LPC controller");
> +		goto iounmap_base;
> +	}
> +
> +	for (i = 0; i < NR_IRQS_LEGACY; i++)
> +		irq_set_chip_and_handler(i, &dummy_irq_chip, handle_simple_irq);
> +
>   	priv->pic_domain = irq_domain_create_hierarchy(parent_domain, 0,
>   						       PIC_COUNT,
>   						       of_node_to_fwnode(node),
