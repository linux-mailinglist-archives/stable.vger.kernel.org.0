Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAC29881F
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 09:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770766AbgJZIQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 04:16:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1422275AbgJZIQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 04:16:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09Q81o5V172221;
        Mon, 26 Oct 2020 04:16:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pi5K96jF5UOd9ZxoQdZwkGRnhA+Rura+UH3/5o6fVsI=;
 b=Z5gYfaeGYL4TQRm2nuJ8vbD5EEbhdEM6ZLtLhlFS4rcZVlvQo7416y6KbFuK1ucjW7Nw
 JLG8XmJL+Idd7K59+tgbV6bu8Ys144xV3XM58ig2wqIxrPxtgqMHTJX1CCkAHaFJ6BEb
 qQWCWmt5zeJ4kYRCog++24oj2PBHy66S1deRh89QMhCLJjFTfTlQTrYmOiroUY6VnEQ8
 7NAvvIV4hmrxR6wog++PsfM2op0FEHE4ZFC1/REetYeHurgtmwPfp/tXO4Gv0w2WmOmx
 fFnJMHbxggFJCVy55ks72YTOvsMGnWlOZ+eZ+9WQ4U3I4pU8bzAuEukXpM82JmVKRIqr sQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dp3pxng5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 04:16:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09Q86l6T027449;
        Mon, 26 Oct 2020 08:16:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34cbw7syrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 08:16:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09Q8G88t26411422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 08:16:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6F8111C04C;
        Mon, 26 Oct 2020 08:16:08 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7599411C054;
        Mon, 26 Oct 2020 08:16:08 +0000 (GMT)
Received: from [9.145.74.29] (unknown [9.145.74.29])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 08:16:08 +0000 (GMT)
Subject: Re: Patch "s390/qeth: strictly order bridge address events" has been
 added to the 5.8-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        Julian Wiedmann <jwi@linux.ibm.com>, stable@vger.kernel.org
References: <20201026053517.556992085B@mail.kernel.org>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <4617e1c2-d791-3a18-9cfb-953589ab6c29@linux.ibm.com>
Date:   Mon, 26 Oct 2020 10:16:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026053517.556992085B@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_04:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.10.20 07:35, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     s390/qeth: strictly order bridge address events
> 
> to the 5.8-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      s390-qeth-strictly-order-bridge-address-events.patch
> and it can be found in the queue-5.8 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

This requires
commit a04f0ecacdb0 ("s390/qeth: don't let HW override the configured port role").

> 
> 
> commit fb538911d11db15ff92e0588cba365eb92c9d4f2
> Author: Julian Wiedmann <jwi@linux.ibm.com>
> Date:   Thu Aug 27 10:17:05 2020 +0200
> 
>     s390/qeth: strictly order bridge address events
>     
>     [ Upstream commit 9d6a569a4cbab5a8b4c959d4e312daeecb7c9f09 ]
>     

[...]
