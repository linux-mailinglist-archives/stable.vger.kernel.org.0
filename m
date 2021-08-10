Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C83E5951
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 13:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhHJLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 07:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233534AbhHJLpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 07:45:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ABY09B123658;
        Tue, 10 Aug 2021 07:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : content-transfer-encoding : in-reply-to; s=pp1;
 bh=DrxOvVjXvx4Usb0oRpmvjcssmygkJTOd39m1oRTMqWA=;
 b=jdULNt1L6s1kaRAqq/Pktez8U6DO+82GmMUI2ayh7Pe8fNdaEzmBf8aDQ4c8s+pOWD4c
 KVKgNdKUxsoDeLKO3QyMTInJo8aTMkEabnTj+CZxXUeyaZdtdC4vVIXbrP3VXAIHnpEk
 HDKzgUzqY/Sav0mxy5GRbPyVYCn/PmCykhmqtsRwV9IWUww6+A85Y8v5wjwA8xlxvbjP
 QRYWLXe5SksMGbBbqFa/m+T5c+IE3L9DKteLWAllwHKEIOeEOq8SvA8H6bHId/opKQDY
 +J+8Q6H5bIWICBS0CYs38SHcbJq99Ln0CrU1x8Pi8zSQT2x0oYhNRI2GfqEAq/X3m7Xi OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abq69b53u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 07:45:08 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ABYNHw127420;
        Tue, 10 Aug 2021 07:45:08 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abq69b530-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 07:45:08 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17ABhcCZ023174;
        Tue, 10 Aug 2021 11:45:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8nbhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 11:45:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17ABfsXw58065158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 11:41:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C7EFA408E;
        Tue, 10 Aug 2021 11:45:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5688DA4040;
        Tue, 10 Aug 2021 11:45:01 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.126.150.29])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 11:45:01 +0000 (GMT)
Date:   Tue, 10 Aug 2021 17:15:00 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     C?dric Le Goater <clg@kaod.org>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v2] powerpc/xive: Do not skip CPU-less nodes when
 creating the IPIs
Message-ID: <20210810114500.GA21942@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20210807072057.184698-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210807072057.184698-1-clg@kaod.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fTe7YivEAUtEoM3gO7sMQIp-cilkYyyc
X-Proofpoint-ORIG-GUID: A84w7q9yz5WAXuzKybwMJINUsSe7ANke
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_05:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1011
 malwarescore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100073
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* C?dric Le Goater <clg@kaod.org> [2021-08-07 09:20:57]:

> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
> runtime. Today, the IPI is not created for such nodes, and hot-plugged
> CPUs use a bogus IPI, which leads to soft lockups.
> 
> We can not directly allocate and request the IPI on demand because
> bringup_up() is called under the IRQ sparse lock. The alternative is
> to allocate the IPIs for all possible nodes at startup and to request
> the mapping on demand when the first CPU of a node is brought up.
> 

Thank you, this version too works for me.

Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>


> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Cc: stable@vger.kernel.org # v5.13
> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Laurent Vivier <lvivier@redhat.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Message-Id: <20210629131542.743888-1-clg@kaod.org>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/sysdev/xive/common.c | 35 +++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dbdbbc2f1dc5..943fd30095af 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -67,6 +67,7 @@ static struct irq_domain *xive_irq_domain;
>  static struct xive_ipi_desc {
>  	unsigned int irq;
>  	char name[16];
> +	atomic_t started;
>  } *xive_ipis;
>  
>  /*
> @@ -1120,7 +1121,7 @@ static const struct irq_domain_ops xive_ipi_irq_domain_ops = {
>  	.alloc  = xive_ipi_irq_domain_alloc,
>  };
>  
> -static int __init xive_request_ipi(void)
> +static int __init xive_init_ipis(void)
>  {
>  	struct fwnode_handle *fwnode;
>  	struct irq_domain *ipi_domain;
> @@ -1144,10 +1145,6 @@ static int __init xive_request_ipi(void)
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
>  
> -		/* Skip nodes without CPUs */
> -		if (cpumask_empty(cpumask_of_node(node)))
> -			continue;
> -
>  		/*
>  		 * Map one IPI interrupt per node for all cpus of that node.
>  		 * Since the HW interrupt number doesn't have any meaning,
> @@ -1159,11 +1156,6 @@ static int __init xive_request_ipi(void)
>  		xid->irq = ret;
>  
>  		snprintf(xid->name, sizeof(xid->name), "IPI-%d", node);
> -
> -		ret = request_irq(xid->irq, xive_muxed_ipi_action,
> -				  IRQF_PERCPU | IRQF_NO_THREAD, xid->name, NULL);
> -
> -		WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
>  	}
>  
>  	return ret;
> @@ -1178,6 +1170,22 @@ static int __init xive_request_ipi(void)
>  	return ret;
>  }
>  
> +static int __init xive_request_ipi(unsigned int cpu)
> +{
> +	struct xive_ipi_desc *xid = &xive_ipis[early_cpu_to_node(cpu)];
> +	int ret;
> +
> +	if (atomic_inc_return(&xid->started) > 1)
> +		return 0;
> +
> +	ret = request_irq(xid->irq, xive_muxed_ipi_action,
> +			  IRQF_PERCPU | IRQF_NO_THREAD,
> +			  xid->name, NULL);
> +
> +	WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
> +	return ret;
> +}
> +
>  static int xive_setup_cpu_ipi(unsigned int cpu)
>  {
>  	unsigned int xive_ipi_irq = xive_ipi_cpu_to_irq(cpu);
> @@ -1192,6 +1200,9 @@ static int xive_setup_cpu_ipi(unsigned int cpu)
>  	if (xc->hw_ipi != XIVE_BAD_IRQ)
>  		return 0;
>  
> +	/* Register the IPI */
> +	xive_request_ipi(cpu);
> +
>  	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
>  	if (xive_ops->get_ipi(cpu, xc))
>  		return -EIO;
> @@ -1231,6 +1242,8 @@ static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>  	if (xc->hw_ipi == XIVE_BAD_IRQ)
>  		return;
>  
> +	/* TODO: clear IPI mapping */
> +
>  	/* Mask the IPI */
>  	xive_do_source_set_mask(&xc->ipi_data, true);
>  
> @@ -1253,7 +1266,7 @@ void __init xive_smp_probe(void)
>  	smp_ops->cause_ipi = xive_cause_ipi;
>  
>  	/* Register the IPI */
> -	xive_request_ipi();
> +	xive_init_ipis();
>  
>  	/* Allocate and setup IPI for the boot CPU */
>  	xive_setup_cpu_ipi(smp_processor_id());
> -- 
> 2.31.1
> 

-- 
Thanks and Regards
Srikar Dronamraju
