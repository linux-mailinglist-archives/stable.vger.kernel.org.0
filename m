Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31818242B3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 23:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfETVUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 17:20:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbfETVUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 17:20:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4KL1qXI083750
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:20:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sm3ashkn5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 20 May 2019 17:20:32 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 20 May 2019 22:20:29 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 May 2019 22:20:25 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4KLKOJU41549938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 21:20:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DEE111C04C;
        Mon, 20 May 2019 21:20:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6389911C04A;
        Mon, 20 May 2019 21:20:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.80.109])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 May 2019 21:20:23 +0000 (GMT)
Subject: Re: [PATCH 3/4] ima: don't ignore INTEGRITY_UNKNOWN EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Mon, 20 May 2019 17:20:12 -0400
In-Reply-To: <20190516161257.6640-3-roberto.sassu@huawei.com>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
         <20190516161257.6640-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052021-0008-0000-0000-000002E8B39A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052021-0009-0000-0000-000022556723
Message-Id: <1558387212.4039.77.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-05-16 at 18:12 +0200, Roberto Sassu wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 52e6fbb042cc..80e1c233656b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1588,6 +1588,9 @@
>  			Format: { "off" | "enforce" | "fix" | "log" }
>  			default: "enforce"
>  
> +	ima_appraise_req_evm
> +			[IMA] require EVM for appraisal with file digests.

As much as possible we want to limit the number of new boot command
line options as possible.  Is there a reason for not extending
"ima_appraise=" with "require-evm" or "enforce-evm"?

Mimi

> +
>  	ima_appraise_tcb [IMA] Deprecated.  Use ima_policy= instead.
>  			The builtin appraise policy appraises all files
>  			owned by uid=0.

