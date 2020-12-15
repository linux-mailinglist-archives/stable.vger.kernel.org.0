Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A402DAAAC
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgLOKN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:13:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgLOKN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 05:13:28 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BFA2jtZ100514;
        Tue, 15 Dec 2020 05:12:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o+PHLjEHHXl4AqT2zqrdT/d6GrCecJktRJ0AJUEBp+c=;
 b=jn+rbCndkR1qbbMkeb8s57B3h5KhlNn8K9+9Ma8T+YrARiEx4sYlro55BfBeNGmKs9vV
 FtTy7fBRs6uQI0GDPq8VsaUIl54+xLJvz60Jvok62/s+I8n4l7PfAcgz+D/AwdWaYQjD
 pys8G9ue9YknuNSCeMPqj3gGbE6lKb2BaeiltU2uiu8V4TetMLYM9ggmVnQZ26iZ2dj2
 w/JEn9cBFffbRt4pNrHhzSfxwWykVL+FR7d8gjS8urf/wIKFgRVM9tm20xvaI9AsuRHp
 8HBCVWxBaVYZyMuIkkD2NZ6rodYIcVumMH8mvf7Dr8nV9PJVBcRNp8CBsV9buOaVJLx+ 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35etrfrt3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:12:38 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BFA3HM6103476;
        Tue, 15 Dec 2020 05:12:38 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35etrfrt2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 05:12:38 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BFABq36018752;
        Tue, 15 Dec 2020 10:12:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 35cn4hb4yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 10:12:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BFACXBw32833928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 10:12:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A1D252054;
        Tue, 15 Dec 2020 10:12:33 +0000 (GMT)
Received: from [9.85.95.164] (unknown [9.85.95.164])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 38DE15204F;
        Tue, 15 Dec 2020 10:12:29 +0000 (GMT)
Subject: Re: [PATCH v2] selftests/vm: Fix building protection keys test
To:     Harish <harish@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, akpm@linux-foundation.org, jhubbard@nvidia.com,
        dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
        bgeffon@google.com, almasrymina@google.com, suxingxing@loongson.cn
References: <20201215100402.257376-1-harish@linux.ibm.com>
From:   Sandipan Das <sandipan@linux.ibm.com>
Message-ID: <9e570819-59b3-5ee9-dd09-a9e0a645a560@linux.ibm.com>
Date:   Tue, 15 Dec 2020 15:42:28 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201215100402.257376-1-harish@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_08:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1011 bulkscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150067
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/12/20 3:34 pm, Harish wrote:
> The patch d8cbe8bfa7d tries to include a ARCH check for powerpc,
> however ARCH is not defined in the Makefile before including
> lib.mk. This makes test building to skip on both x86 and powerpc.
> Fix the arch check by replacing it using machine type as it is
> already defined and used in the test.
> 
> Fixes: d8cbe8bfa7d ("tools/testing/selftests/vm: fix build error")
> Signed-off-by: Harish <harish@linux.ibm.com>

Reviewed-by: Sandipan Das <sandipan@linux.ibm.com>
