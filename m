Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF31614A15
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiKAL5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiKAL5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:57:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C7B632D;
        Tue,  1 Nov 2022 04:57:40 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1BsVKN034449;
        Tue, 1 Nov 2022 11:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UU2OVLyRFQWblX6Bgns3JmLCMcn+pjyZngTrFCH7Oq4=;
 b=PCobK7eqqySZBQm7BlisnYLug4EBnNcXM7oazZRKoQpFvk0dKjmPbT/5OH3q+NdB6gsZ
 6iTH6sstU4FdYD1iqyrxdzHFXFfNpiiF1Bkvfq6Ypbvc55VPMeK+44MaPFvZaI2NJ74F
 hHvR2mWBNfa+UErxNmedwD3VyzMf8/y77rhmFJhZDIui2g4v6tdf1WDsmxquc5npfNnS
 KKIxhwvzmE02fcPEwJzGNsFgBLr0XKv94I5kp2KJtLJLN1SZkz8e8YoWtkToMH0v4ee4
 BKsNK1+rzRZPDjm/P1+QS1i7yYez4GGZWeglYfN9XRwTuI7aQYpr23sFJGLbl/lvV9+R kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjw7tt8yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 11:57:21 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A1BpZK7035036;
        Tue, 1 Nov 2022 11:57:21 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kjw7tt8yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 11:57:21 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A1BokD0010795;
        Tue, 1 Nov 2022 11:57:20 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3kguta0re6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Nov 2022 11:57:20 +0000
Received: from smtpav03.dal12v.mail.ibm.com ([9.208.128.129])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A1BvKRn10224376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Nov 2022 11:57:20 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB4E15803F;
        Tue,  1 Nov 2022 11:57:18 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1680858061;
        Tue,  1 Nov 2022 11:57:18 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.189.66])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Nov 2022 11:57:17 +0000 (GMT)
Message-ID: <cee0b0176edc942ecc0ce6f4d585c239f9b7c425.camel@linux.ibm.com>
Subject: Re: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Aditya Garg <gargaditya08@live.com>,
        "chyishian.jiang@gmail.com" <chyishian.jiang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Date:   Tue, 01 Nov 2022 07:57:17 -0400
In-Reply-To: <8CB9E43B-AB65-4735-BB8D-A8A7A10F9E30@live.com>
References: <8CB9E43B-AB65-4735-BB8D-A8A7A10F9E30@live.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zge99lZrCYUCxOnvM_rD_JuFr53dJRrL
X-Proofpoint-GUID: 8SUFS2ZDxrTrw_6zpKDYdKfWqqPFy30H
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_06,2022-11-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aditya,

On Thu, 2022-10-27 at 10:01 +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> The iMac Pro 2017 is also a T2 Mac. Thus add it to the list of uefi skip cert.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aditya Garg <gargaditya08@live.com>

I found this list of computers with the Apple T2 Security Chip - 
https://support.apple.com/en-us/HT208862, but not a list that
correlates them to the system ID.  With this update, is this the entire
list?

thanks,

Mimi

> ---
>  security/integrity/platform_certs/load_uefi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
> index b78753d27d8ea6..d1fdd113450a63 100644
> --- a/security/integrity/platform_certs/load_uefi.c
> +++ b/security/integrity/platform_certs/load_uefi.c
> @@ -35,6 +35,7 @@ static const struct dmi_system_id uefi_skip_cert[] = {
>  	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
>  	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
>  	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
> +	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
>  	{ }
>  };
>  


