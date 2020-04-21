Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A208E1B247F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgDULDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 07:03:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbgDULDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 07:03:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LB2GEl053217
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:03:40 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvgrdun-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:03:40 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Tue, 21 Apr 2020 12:03:32 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 12:03:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LB3YU923134340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 11:03:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E179BA405C;
        Tue, 21 Apr 2020 11:03:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E2FA4064;
        Tue, 21 Apr 2020 11:03:34 +0000 (GMT)
Received: from pic2.home (unknown [9.145.42.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 11:03:34 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.4 70/78] pci/hotplug/pnv-php: Remove erroneous
 warning
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Alastair D'Silva" <alastair@d-silva.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org
References: <20200418144047.9013-1-sashal@kernel.org>
 <20200418144047.9013-70-sashal@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Date:   Tue, 21 Apr 2020 13:03:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418144047.9013-70-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042111-0028-0000-0000-000003FC425A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042111-0029-0000-0000-000024C20597
Message-Id: <3f547720-ec27-7a12-d80e-79cd46477daf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_04:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 clxscore=1031 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210084
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 18/04/2020 à 16:40, Sasha Levin a écrit :
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 658ab186dd22060408d94f5c5a6d02d809baba44 ]


This doesn't need to be backported to stable.

   Fred


> On powernv, when removing a device through hotplug, the following
> warning is logged:
> 
>       Invalid refcount <.> on <...>
> 
> It may be incorrect, the refcount may be set to a higher value than 1
> and be valid. of_detach_node() can drop more than one reference. As it
> doesn't seem trivial to assert the correct value, let's remove the
> warning.
> 
> Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
> Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20191121134918.7155-7-fbarrat@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/pci/hotplug/pnv_php.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
> index d7b2b47bc33eb..6037983c6e46b 100644
> --- a/drivers/pci/hotplug/pnv_php.c
> +++ b/drivers/pci/hotplug/pnv_php.c
> @@ -151,17 +151,11 @@ static void pnv_php_rmv_pdns(struct device_node *dn)
>   static void pnv_php_detach_device_nodes(struct device_node *parent)
>   {
>   	struct device_node *dn;
> -	int refcount;
>   
>   	for_each_child_of_node(parent, dn) {
>   		pnv_php_detach_device_nodes(dn);
>   
>   		of_node_put(dn);
> -		refcount = kref_read(&dn->kobj.kref);
> -		if (refcount != 1)
> -			pr_warn("Invalid refcount %d on <%pOF>\n",
> -				refcount, dn);
> -
>   		of_detach_node(dn);
>   	}
>   }
> 

