Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6825419A17E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgCaV66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 17:58:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50284 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731343AbgCaV66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 17:58:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02VLvm8I090045;
        Tue, 31 Mar 2020 21:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TztpD+qjMJPwNznPV3YUeda6TB/mBhrSo00FQGB79CM=;
 b=qGlWUVVBMvYzdGLDGgwRCkRvytKMvux+VMHqACFdOg5AAlvE+rE3I1/SqC/tjaGCnYX5
 L1NuycFA35wjf2b2K6yQEGjyj1GtqScP4N6h3w0fWXCTYFzaakeaQzROp+Wp6uqS1l8V
 tR9qfFfd3KYC2gShsfHih7zrzrdnFFwEhJ6ggQsuzqCGaP3rKYGIPKq+IJa5MkL58wPJ
 MI+upemKM8hcpH+BKXpwensWrrmYFC7gBx7hXCTYt3Btz0xhtqINAuJUXE9G1Dx8ZQWi
 dTKbyPXkB3U1B2QPYWo9rIUKG+3gn8v3S87EU+niyMMlIGVWTPKGx94XC6VIlM83NAo4 ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yun4s7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 21:58:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02VLuo8p142944;
        Tue, 31 Mar 2020 21:58:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 302g2f0thw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 21:58:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02VLwfhO028926;
        Tue, 31 Mar 2020 21:58:41 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 14:58:40 -0700
Subject: Re: +
 mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch added
 to -mm tree
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     akpm@linux-foundation.org, longpeng2@huawei.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        willy@infradead.org, Naresh Kamboju <naresh.kamboju@linaro.org>
References: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
 <eea7c1f8-a2e4-5af1-acc4-3eb21a076d37@oracle.com>
 <20200331044408.GW24988@linux.intel.com> <20200331140804.GN20941@ziepe.ca>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <a018277a-1eb2-a605-0066-482a674662da@oracle.com>
Date:   Tue, 31 Mar 2020 14:58:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331140804.GN20941@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310179
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/20 7:08 AM, Jason Gunthorpe wrote:
> I can't think of an easy fix here.
> 
> Andrew, I think this patch has to be dropped :(
> 
> Longpeng can fix the direct bug he saw by not changing the
> pXX_offset(), but this extra de-reference will remain some
> theortical/rare bug according to the memory model.

FWIW,
I tested Longpeng's V2 patch without the READ_ONCE for *pgd and *p4d
in this environment and it worked fine.

-- 
Mike Kravetz
