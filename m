Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2B824E52
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfEULtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 07:49:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbfEULtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 07:49:03 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LBmKK9090457
        for <stable@vger.kernel.org>; Tue, 21 May 2019 07:49:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2smg4g9wwc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 21 May 2019 07:49:02 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 21 May 2019 12:48:59 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 May 2019 12:48:56 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4LBmtK133161418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 11:48:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9085EAE053;
        Tue, 21 May 2019 11:48:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BEFBAE045;
        Tue, 21 May 2019 11:48:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.126])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 May 2019 11:48:54 +0000 (GMT)
Subject: Re: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Tue, 21 May 2019 07:48:43 -0400
In-Reply-To: <e81b761c-9133-a432-4d06-3cfe57e29e4b@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
         <20190516161257.6640-3-roberto.sassu@huawei.com>
         <1558387212.4039.77.camel@linux.ibm.com>
         <e81b761c-9133-a432-4d06-3cfe57e29e4b@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052111-0008-0000-0000-000002E8EB58
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052111-0009-0000-0000-00002255A150
Message-Id: <1558439323.4039.141.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210073
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-05-21 at 09:26 +0200, Roberto Sassu wrote:
> On 5/20/2019 11:20 PM, Mimi Zohar wrote:
> > On Thu, 2019-05-16 at 18:12 +0200, Roberto Sassu wrote:
> >> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> >> index 52e6fbb042cc..80e1c233656b 100644
> >> --- a/Documentation/admin-guide/kernel-parameters.txt
> >> +++ b/Documentation/admin-guide/kernel-parameters.txt
> >> @@ -1588,6 +1588,9 @@
> >>   			Format: { "off" | "enforce" | "fix" | "log" }
> >>   			default: "enforce"
> >>   
> >> +	ima_appraise_req_evm
> >> +			[IMA] require EVM for appraisal with file digests.
> > 
> > As much as possible we want to limit the number of new boot command
> > line options as possible.  Is there a reason for not extending
> > "ima_appraise=" with "require-evm" or "enforce-evm"?
> 
> ima-appraise= can be disabled with CONFIG_IMA_APPRAISE_BOOTPARAM, which
> probably is done when the system is in production.
> 
> Should I allow to use ima-appraise=require-evm even if
> CONFIG_IMA_APPRAISE_BOOTPARAM=n?

Yes, that should be fine.  It's making "ima_appraise" stricter.

Mimi

