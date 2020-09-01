Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D4D258EBB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 14:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgIAM4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 08:56:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgIAMz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 08:55:28 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 081CWkTs003994;
        Tue, 1 Sep 2020 08:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=EsE9aMLgZ5oLOJJb71EKETx/jtQMeuycu+5EYM7apeA=;
 b=Awx3HtL3wnJvpEXKKGxHBBkQC1BvC5v1p65zGwvdUj5KWwh9FMM/PM9OXL3HdP7WkE5w
 oMMmrL+sSxBdDv8i3FJz7XDh6+nR3zEGXUZ3LJVOH/Y4gKnWgf+DK/JBVf2QXJEYyPv1
 +xQLAfMioFA6SZbhMMkSvQxwHqRMAotmZynvZfjEGuf1Z2O4FhJyN9+37Ow44eqW30l4
 YYpa+3i27GcM4h4cFWsvN27LWJVso1z7xjIRpdiNvPWMWmBqabnG1yDkX8wmEelZGVc3
 hzs+yzPKiQtA8cKrWNn39jEcFbUpbjoAD/ft7RoPYwkR0kE/d7ev/FQFl5tbPaXFWOOB PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339pd48nku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 08:55:16 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 081CWm3F004493;
        Tue, 1 Sep 2020 08:55:16 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339pd48njp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 08:55:16 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 081CrGUG022720;
        Tue, 1 Sep 2020 12:55:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 337en8bdxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 12:55:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 081CtB8651118462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 12:55:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4BE611C05C;
        Tue,  1 Sep 2020 12:55:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F100B11C052;
        Tue,  1 Sep 2020 12:55:09 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.77.139])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Sep 2020 12:55:09 +0000 (GMT)
Message-ID: <910f7fe3864925d1052f5f35785dd19ed1505fe6.camel@linux.ibm.com>
Subject: Re: [PATCH 07/11] evm: Set IMA_CHANGE_XATTR/ATTR bit if
 EVM_ALLOW_METADATA_WRITES is set
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "mjg59@google.com" <mjg59@google.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 01 Sep 2020 08:55:09 -0400
In-Reply-To: <7f3dd815639a44ba9b0fb532c217bd21@huawei.com>
References: <20200618160329.1263-2-roberto.sassu@huawei.com>
         <20200618160458.1579-7-roberto.sassu@huawei.com>
         <67cafcf63daf8e418871eb5302e7327ba851e253.camel@linux.ibm.com>
         <a5e6a5acf2274a6d844b275dacfbabb8@huawei.com>
         <ae06c113ec91442e293f2466cae3dd1b81f241eb.camel@linux.ibm.com>
         <7f3dd815639a44ba9b0fb532c217bd21@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_08:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010109
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > > I think it is better to set a flag, maybe a new one, directly in EVM, to notify
> > > the integrity subsystem that iint->evm_status is no longer valid.
> > >
> > > If the EVM flag is set, IMA would reset the appraisal flags, as it uses
> > > iint->evm_status for appraisal. We can consider to reset also the measure
> > > flags when we have a template that includes file metadata.
> > 
> > When would IMA read the EVM flag?   Who would reset the flag?  At what
> > point would it be reset?   Just as EVM shouldn't be resetting the IMA
> > flag, IMA shouldn't be resetting the EVM flag.
> 
> IMA would read the flag in process_measurement() and behave similarly
> to when it processes IMA_CHANGE_ATTR. The flag would be reset by
> evm_verify_hmac().

Sounds good.

Mimi

