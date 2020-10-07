Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE2285809
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 07:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgJGFK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 01:10:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbgJGFKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 01:10:25 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0974XOE4063737;
        Wed, 7 Oct 2020 01:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BeLgSRRyePvDsbUzJJIPXqvE4mGEMjgnMEsZNh/CarQ=;
 b=szEnWsEfwVBQ9YsLZGOumHqPCoTcG0gK7UT1Wjtzkqg1gXe5QMFVVwCnmNmafCxlCRwF
 oeb534RGrtHn09hstcwOfvWHx/D7oEmC0zDphikN5oqjwTJDWGcKlWDX9+11B4zlvPVa
 yW0gLRDuAtw7UDhmav8LJbX1eQD9VpXN18h3xVAOr5jqdS/5ZobzqT/pOMbRjtkR4qca
 sxpECsueXt6s5BTukv/BqgWtdXponFsYXOtHoVDjz75aobIkNEQX7cKndfPdfnDm4BmF
 t23KLGURe5LUKexGK+6sk0OZKROfHfttvikOpQ7jTq0UOTbTDb09I+vp/O0InJ9e5R4h 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341559b1u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 01:10:15 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0974XsYe065086;
        Wed, 7 Oct 2020 01:10:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341559b1th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 01:10:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09751Zbi008110;
        Wed, 7 Oct 2020 05:10:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 33xgx8a1cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 05:10:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0975AA2932112914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 05:10:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BE554C052;
        Wed,  7 Oct 2020 05:10:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 363364C05A;
        Wed,  7 Oct 2020 05:10:10 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 05:10:10 +0000 (GMT)
Received: from [9.206.128.123] (unknown [9.206.128.123])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id C5088A0218;
        Wed,  7 Oct 2020 16:10:08 +1100 (AEDT)
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from
 userspace
To:     Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com, dja@axtens.net,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
References: <20200820044512.7543-1-ajd@linux.ibm.com>
 <20200826135348.AD06422B4B@mail.kernel.org>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Message-ID: <421cba41-20bf-f874-c81a-8b7f9944c845@linux.ibm.com>
Date:   Wed, 7 Oct 2020 16:10:08 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200826135348.AD06422B4B@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_03:2020-10-06,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070028
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/8/20 11:53 pm, Sasha Levin wrote:
> How should we proceed with this patch?

mpe: I believe we came to the conclusion that we shouldn't put this in 
stable just yet?

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited
