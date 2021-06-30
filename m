Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20CE3B7D08
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 07:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhF3FpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 01:45:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41822 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhF3FpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 01:45:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15U5YiA8062858;
        Wed, 30 Jun 2021 01:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : content-transfer-encoding : in-reply-to; s=pp1;
 bh=oZQ9636NLf23VbLHwcXpCEz97s8LtbkAJkNghES0cAw=;
 b=OZgcwi5j8P9zwlQVAEReTOARnDFBNknJTPSJ47hozgUN0ZQRzpsa4aD6wcht36fQ9dFo
 /2ap1KZ+SC8nk9dJalRipuV3JOrSW/lZEU0W6w/Ofi+g/4b3Pv78et6ieEgxmYU5qSuF
 MUk/D0zjPVnYE8SGLCZjCYnf8pLXHcHoU1vMEctu8UwYJZJ1yXrXLscCjv9QRYpG82uJ
 K05YQ6RPMLPW+XgypLXlft+df2CNWpQjtyKa3gpirz5n4hp4XkuzKIp4RGsTDe7cF1Dn
 c9LOvXmyRTXDmyA683HCdF7xfARP1oXCSiZCkd8oYgRAqv1NfSJoWlX8nwuMW/0gL5rB GQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gewpmsbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 01:42:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15U5bbC0029670;
        Wed, 30 Jun 2021 05:42:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 39duv89kby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 05:42:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15U5gPU435914088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 05:42:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C14E0A4066;
        Wed, 30 Jun 2021 05:42:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F150A405B;
        Wed, 30 Jun 2021 05:42:24 +0000 (GMT)
Received: from linux.vnet.ibm.com (unknown [9.126.150.29])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Jun 2021 05:42:23 +0000 (GMT)
Date:   Wed, 30 Jun 2021 11:12:22 +0530
From:   Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To:     C?dric Le Goater <clg@kaod.org>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
Message-ID: <20210630054222.GX2633526@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20210629131542.743888-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210629131542.743888-1-clg@kaod.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5d_LAVMwoBCrE1FgdjJudfK9lHyNMMFh
X-Proofpoint-GUID: 5d_LAVMwoBCrE1FgdjJudfK9lHyNMMFh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_01:2021-06-29,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300034
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* C?dric Le Goater <clg@kaod.org> [2021-06-29 15:15:42]:

> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
> runtime. Today, the IPI is not created for such nodes, and hot-plugged
> CPUs use a bogus IPI, which leads to soft lockups.
> 
> We could create the node IPI on demand but it is a bit complex because
> this code would be called under bringup_up() and some IRQ locking is
> being done. The simplest solution is to create the IPIs for all nodes
> at startup.

Thanks for quickly coming up with the fix.

> 
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Cc: stable@vger.kernel.org # v5.13
> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
> This patch breaks old versions of irqbalance (<= v1.4). Possible nodes
> are collected from /sys/devices/system/node/ but CPU-less nodes are
> not listed there. When interrupts are scanned, the link representing
> the node structure is NULL and segfault occurs.
> 
> Version 1.7 seems immune. 
> 
> ---
>  arch/powerpc/sysdev/xive/common.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index f3b16ed48b05..5d2c58dba57e 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1143,10 +1143,6 @@ static int __init xive_request_ipi(void)
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
> -- 
> 2.31.1
> 

-- 
Thanks and Regards
Srikar Dronamraju
