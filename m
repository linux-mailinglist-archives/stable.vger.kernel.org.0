Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230141B2492
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 13:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgDULF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 07:05:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728285AbgDULF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 07:05:57 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LB2jRb118668
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:05:56 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gcbfcyv2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 07:05:56 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Tue, 21 Apr 2020 12:05:09 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 12:05:06 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LB4g8665929586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 11:04:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 754CEA405B;
        Tue, 21 Apr 2020 11:05:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34E50A4054;
        Tue, 21 Apr 2020 11:05:49 +0000 (GMT)
Received: from pic2.home (unknown [9.145.42.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 11:05:49 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.4 71/78] ocxl: Add PCI hotplug dependency to
 Kconfig
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "Alastair D'Silva" <alastair@d-silva.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
References: <20200418144047.9013-1-sashal@kernel.org>
 <20200418144047.9013-71-sashal@kernel.org>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Date:   Tue, 21 Apr 2020 13:05:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418144047.9013-71-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042111-4275-0000-0000-000003C3E50B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042111-4276-0000-0000-000038D96986
Message-Id: <efc55677-f8b9-791a-1c02-8c636ac6600e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_04:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1031 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210088
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 18/04/2020 à 16:40, Sasha Levin a écrit :
> From: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> [ Upstream commit 49ce94b8677c7d7a15c4d7cbbb9ff1cd8387827b ]

This shouldn't be backported to stable.

   Fred


> The PCI hotplug framework is used to update the devices when a new
> image is written to the FPGA.
> 
> Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
> Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20191121134918.7155-12-fbarrat@linux.ibm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/misc/ocxl/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/misc/ocxl/Kconfig b/drivers/misc/ocxl/Kconfig
> index 1916fa65f2f2a..2d2266c1439ef 100644
> --- a/drivers/misc/ocxl/Kconfig
> +++ b/drivers/misc/ocxl/Kconfig
> @@ -11,6 +11,7 @@ config OCXL
>   	tristate "OpenCAPI coherent accelerator support"
>   	depends on PPC_POWERNV && PCI && EEH
>   	select OCXL_BASE
> +	select HOTPLUG_PCI_POWERNV
>   	default m
>   	help
>   	  Select this option to enable the ocxl driver for Open
> 

