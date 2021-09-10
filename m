Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48FB4066EE
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 07:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhIJF4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 01:56:32 -0400
Received: from smtpout1.mo3005.mail-out.ovh.net ([79.137.123.220]:33415 "EHLO
        smtpout1.3005.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230417AbhIJF4c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 01:56:32 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2021 01:56:31 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.51])
        by mo3005.mail-out.ovh.net (Postfix) with ESMTPS id ECA4513EFE4;
        Fri, 10 Sep 2021 05:48:19 +0000 (UTC)
Received: from kaod.org (37.59.142.100) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 10 Sep
 2021 07:48:19 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-100R003b2afc9eb-92ed-4917-a57a-8775a7168fc9,
                    7E3151BA03BDFE499776E315E3312AC0A00E288C) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Subject: Re: [PATCH AUTOSEL 5.14 38/99] KVM: PPC: Book3S HV: XICS: Fix mapping
 of passthrough interrupts
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
References: <20210910001558.173296-1-sashal@kernel.org>
 <20210910001558.173296-38-sashal@kernel.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <27739836-bad2-6b3f-7f40-e84663fbbf24@kaod.org>
Date:   Fri, 10 Sep 2021 07:48:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210910001558.173296-38-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.100]
X-ClientProxiedBy: DAG1EX1.mxp5.local (172.16.2.1) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: c650a476-78a5-43c6-9aa9-2b943421663f
X-Ovh-Tracer-Id: 17411760584997833510
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrudegtddgleekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepjeetfeejteefhfeuveethfduffeftdelvdeghfelhfeljeehheeuieevudeggefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddttdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepshgrshhhrghlsehkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/10/21 2:14 AM, Sasha Levin wrote:
> From: Cédric Le Goater <clg@kaod.org>
> 
> [ Upstream commit 1753081f2d445f9157550692fcc4221cd3ff0958 ]
> 
> PCI MSIs now live in an MSI domain but the underlying calls, which
> will EOI the interrupt in real mode, need an HW IRQ number mapped in
> the XICS IRQ domain. Grab it there.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20210701132750.1475580-31-clg@kaod.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>


Why are we backporting this patch in stable trees ?

It should be fine but to compile, we need a partial backport of commit
51be9e51a800 ("KVM: PPC: Book3S HV: XIVE: Fix mapping of passthrough 
interrupts") which exports irq_get_default_host().

Thanks,

C.


> ---
>  arch/powerpc/kvm/book3s_hv.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 085fb8ecbf68..1ca0a4f760bc 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5328,6 +5328,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
>  	struct kvmppc_passthru_irqmap *pimap;
>  	struct irq_chip *chip;
>  	int i, rc = 0;
> +	struct irq_data *host_data;
>  
>  	if (!kvm_irq_bypass)
>  		return 1;
> @@ -5392,7 +5393,14 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
>  	 * the KVM real mode handler.
>  	 */
>  	smp_wmb();
> -	irq_map->r_hwirq = desc->irq_data.hwirq;
> +
> +	/*
> +	 * The 'host_irq' number is mapped in the PCI-MSI domain but
> +	 * the underlying calls, which will EOI the interrupt in real
> +	 * mode, need an HW IRQ number mapped in the XICS IRQ domain.
> +	 */
> +	host_data = irq_domain_get_irq_data(irq_get_default_host(), host_irq);
> +	irq_map->r_hwirq = (unsigned int)irqd_to_hwirq(host_data);
>  
>  	if (i == pimap->n_mapped)
>  		pimap->n_mapped++;
> @@ -5400,7 +5408,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
>  	if (xics_on_xive())
>  		rc = kvmppc_xive_set_mapped(kvm, guest_gsi, desc);
>  	else
> -		kvmppc_xics_set_mapped(kvm, guest_gsi, desc->irq_data.hwirq);
> +		kvmppc_xics_set_mapped(kvm, guest_gsi, irq_map->r_hwirq);
>  	if (rc)
>  		irq_map->r_hwirq = 0;
>  
> 

