Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0162D36E2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 00:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbgLHXYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 18:24:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3392 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731707AbgLHXYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 18:24:04 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8N3Own193780;
        Tue, 8 Dec 2020 18:23:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ArI9mn5c+DgcORrXnxRTVG0KuLT4LUHxpjN2rZtQdJU=;
 b=WfRXxdrizvvAZTNds3WUHHo626Mj3F14pIR5gq614lT1XggqPWWY7zeugCFF0VylUlEB
 9g0Xe8eSVrknX1rsE4zHMF/ucoP2FicUrAt9GqV6vcoWd3LKG36L6tDQcEepn+TQq3Ec
 OBXODHsR7ddGsYR5eY/+kijf8uArkfDkV6aIRQVEUiIBeuPBlIStSbFBaIfiGH4uW3hq
 FGp/IQOx1S/JuT42hJZ11rKbtbyO+tN84LwW9GrUxHD1vcMGlKTOc0XdiXq5BvwZ9yzc
 e8X0qA2iyqcdemGocPBvd35jY7XraEpTWJZ3EZwzYOSELc6+8eBVdI5yU9kx1Dudd8Vo eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ahdbtjm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 18:23:16 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8N3Zgp194937;
        Tue, 8 Dec 2020 18:23:15 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ahdbtjkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 18:23:15 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8NMmuK009905;
        Tue, 8 Dec 2020 23:23:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhm0y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 23:23:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8NNBkt27001226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 23:23:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7A59AE055;
        Tue,  8 Dec 2020 23:23:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75282AE051;
        Tue,  8 Dec 2020 23:23:11 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 23:23:11 +0000 (GMT)
Received: from [9.81.212.44] (unknown [9.81.212.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id DBE9160167;
        Wed,  9 Dec 2020 10:23:09 +1100 (AEDT)
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from
 userspace
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     nathanl@linux.ibm.com, leobras.c@gmail.com, stable@vger.kernel.org,
        dja@axtens.net
References: <20200820044512.7543-1-ajd@linux.ibm.com>
 <e58e8c42-d422-1bd7-ab38-9a1fb118fca4@linux.ibm.com>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Message-ID: <19104e21-da4a-7c5c-1291-87686d4822d1@linux.ibm.com>
Date:   Wed, 9 Dec 2020 10:23:02 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <e58e8c42-d422-1bd7-ab38-9a1fb118fca4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_17:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080141
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/12/20 5:59 am, Tyrel Datwyler wrote:
>> +	{ "ibm,open-errinct", -1, -1, -1, -1, -1 },
> 
> There is a typo here. Should be ibm,open-errinjct.
> 
> kernel: [ 1100.408626] sys_rtas: RTAS call blocked - exploit attempt?
> kernel: [ 1100.408631] sys_rtas: token=0x26, nargs=0 (called by errinjct)
> 
> Which is producing this when trying to invoke the errinjct tool.
> 
> I'll send a fixes patch out shortly.

*sigh*

Thanks for picking this up!


-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited
