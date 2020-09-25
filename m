Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486312789E6
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgIYNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 09:47:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgIYNry (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 09:47:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PDjJcc134598;
        Fri, 25 Sep 2020 13:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xKCctV3/JkpuA0CeolFxLW6LjuoTV+gIWojGjEUuvTM=;
 b=Evr6KiHcwdY+QWckT2kb6SI8LpNY2p3khJjGLfuH0VNrl7ongez0rx9oclFh1fZBmOSr
 i4G2vvknJ6SGtq7LetRlN8AIIDgb4stkOWGCkc5Hsnnz2PgyXL4p8oe5+T92q/Rhg96t
 BqEuFRJ4BmPFA7OHplLoNoDhOSEqwvIUUKxMj2n+FnomC2AddXoydiVwKTmldQ6XbkoO
 /dpeh8avVh3Z1B+e3bsbCo6wznmtdAKjAqfUNoNzwmvSlTCqOPhkGrO6D6Y6Q6P3Uu3W
 EOmmjWkPcAcSwVd/lnVb2hr2WHBCEIjsoVaBPb5Hdrf1uf41Tp0ttkMMnKxD+z0/pOhZ PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgv1ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 13:47:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PDeDvs062429;
        Fri, 25 Sep 2020 13:45:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33r28ydunh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 13:45:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08PDjTDW020127;
        Fri, 25 Sep 2020 13:45:29 GMT
Received: from [10.74.86.146] (/10.74.86.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 06:45:29 -0700
Subject: Re: [PATCH] x86/xen: disable Firmware First mode for correctable
 memory errors
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
References: <20200925101148.21012-1-jgross@suse.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <171970df-5f6e-5a2b-e784-e62d300a005b@oracle.com>
Date:   Fri, 25 Sep 2020 09:45:26 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200925101148.21012-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/25/20 6:11 AM, Juergen Gross wrote:
> @@ -1296,6 +1296,14 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  
>  	xen_smp_init();
>  
> +#ifdef CONFIG_ACPI
> +	/*
> +	 * Disable selecting "Firmware First mode" for correctable memory
> +	 * errors, as this is the duty of the hypervisor to decide.
> +	 */
> +	acpi_disable_cmcff = 1;
> +#endif


Not that it matters greatly but should this go under if (xen_initial_domain()) clause a bit further down?


Either way:


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


