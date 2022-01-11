Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9F48B8D8
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 21:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiAKUt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 15:49:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244133AbiAKUt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 15:49:26 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BJw48A025909;
        Tue, 11 Jan 2022 20:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=o3avqyjwXEI91DdMmCszgg6jcrCz6nUJDl/zqgWuzcs=;
 b=NizOnBJ70AJz/xtFmcjynRdh7yPH57aOELwPmD3OQkuHnS1FZzSaxs8XislMcKHWwx+h
 XYw86hnMBmrO/+4bu3lZd1wlWfuwz0PZjsCNbQCRC8Gi4cKefPNsZmr1JykZideHFzDq
 w20P4Q4lvfGYRFV0gYjmkqh9isxsyxGDnOewndDlwKWVzgy6HUPkLJg7XNu9JW3gQ/lJ
 mTgv53NwSLUaftQ9Vwe9j2F0Qbpbqh9yxZWg7lmfQP0aR1Hw4eQ0yo0Txz36KV9rSFnf
 ChxDSbgOKO6julcOCuxkq8+/7xOhSrSixCNZx5G4GjrpWhzeqfAxL8mxJ2UMcVJO66wr Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhgh18uut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 20:49:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BKaxfa003121;
        Tue, 11 Jan 2022 20:49:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhgh18uub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 20:49:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BKY0kh025691;
        Tue, 11 Jan 2022 20:49:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3df28a291j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 20:49:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BKn1Rn47120642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 20:49:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C66BCAE055;
        Tue, 11 Jan 2022 20:49:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82592AE058;
        Tue, 11 Jan 2022 20:49:01 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 11 Jan 2022 20:49:01 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Pingfan Liu <kernelfans@gmail.com>
Subject: Re: [PATCH 2/2] tracing: Add test for user space strings when
 filtering on string pointers
References: <20220107225655.647376947@goodmis.org>
        <20220107225840.003487216@goodmis.org>
Date:   Tue, 11 Jan 2022 21:49:01 +0100
In-Reply-To: <20220107225840.003487216@goodmis.org> (Steven Rostedt's message
        of "Fri, 07 Jan 2022 17:56:57 -0500")
Message-ID: <yt9dczkyt2v6.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HrRNlRYq5xzOVqxasedEk3L3llRklEWD
X-Proofpoint-GUID: EAKNwtcVpZGUwgai_6J1lzq1tgRLNq7n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=912 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steve,

Steven Rostedt <rostedt@goodmis.org> writes:

> From: Steven Rostedt <rostedt@goodmis.org>
>
> Pingfan reported that the following causes a fault:
>
>   echo "filename ~ \"cpu\"" > events/syscalls/sys_enter_openat/filter
>   echo 1 > events/syscalls/sys_enter_at/enable
>

[..]

> +static __always_inline char *test_string(char *str)
> +{
> +	struct ustring_buffer *ubuf;
> +	char __user *ustr;
> +	char *kstr;
> +
> +	if (!ustring_per_cpu)
> +		return NULL;
> +
> +	ubuf = this_cpu_ptr(ustring_per_cpu);
> +	kstr = ubuf->buffer;
> +
> +	if (likely((unsigned long)str >= TASK_SIZE)) {

I think that would not work on architectures where addresses for kernel
and user space could overlap, i.e. with different address spaces?

> +		/* For safety, do not trust the string pointer */
> +		if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
> +			return NULL;
> +	} else {
> +		/* user space address? */
> +		ustr = str;
> +		if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
> +			return NULL;
> +	}
> +	return kstr;
> +}
