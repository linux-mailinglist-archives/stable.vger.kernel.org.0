Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3189413062
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 10:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhIUIsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 04:48:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11690 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231239AbhIUIsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 04:48:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18L7TUdi021405;
        Tue, 21 Sep 2021 04:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PobOmmegEH6kXd2FN2lCCRb2+GTx6TIzMiNiHKbLoPs=;
 b=Nip2LyXBHqzNYS5VL/uoP8tvS0Sm2C+N9AqloUwTtOuTo7EcN/LxT6RUjT4IZ98vg54C
 90a7oii9vtnP79diHtgxBym01ahxSXGRXRuVXsoBhjvHfT7BBAwbRpNEZBemqlh0lOYB
 nlhjE6DnqK0ICkZ6iSpFezcjciqF13Gm8NxRSx7UzVfwWy2BqCI5+WRDi/E+J+CwLuE3
 JpB9PIOdzIniBErgvDX42oPJoUwDronCGbK/ImPTXJkdJwHRnLr8XF1hG6nLUe5fkMMC
 /db6k6ZUStxL03UwLCZbmIIjeVJb1yI/bMEjOUohkHXcZcuQEIk+d4J7ISa2c5n9eiSf 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7b25hkqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 04:46:35 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18L7UBD8023271;
        Tue, 21 Sep 2021 04:46:35 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7b25hkqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 04:46:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18L8XDoe009919;
        Tue, 21 Sep 2021 08:46:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r9hsvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 08:46:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18L8kTvT37814560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 08:46:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1585A5204F;
        Tue, 21 Sep 2021 08:46:29 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.63.127])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4CA6652051;
        Tue, 21 Sep 2021 08:46:28 +0000 (GMT)
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
To:     Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
 <b9b9e014-d8d9-1a76-679b-cd7af54ad3f9@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <e8881cf8-987c-e2b2-5cda-8e3c5a19cc99@de.ibm.com>
Date:   Tue, 21 Sep 2021 10:46:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b9b9e014-d8d9-1a76-679b-cd7af54ad3f9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3I4wTNbfXkT_iyYtuGRFVcr9x30Xim7d
X-Proofpoint-GUID: qlA7xGCSlnlUQg_f-vCG7Uo7MIE894kJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210055
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 20.09.21 um 20:05 schrieb Paolo Bonzini:
> On 20/09/21 17:06, Christian Borntraeger wrote:
>> here is a backport for 4.19 of
>> commit a3e03bc1368 ("KVM: s390: index kvm->arch.idle_mask by vcpu_idx")
>> This basically removes the kick_mask parts that were introduced with
>> kernel 5.0 and fixes up the location of the idle_mask to the older
>> place.
>>
>> FWIW, it might be a good idea to also backport
>> 8750e72a79dd ("KVM: remember position in kvm->vcpus array") to avoid
>> a performance regression for large guests (many vCPUs) when this patch
>> is applied.
>> @Paolo Bonzini, would you be ok with 8750e72a79dd in older stable releases?
> 
> Sure, I suppose you're going to send a separate backport that I can ack.

It does seem to apply when cherry-picked, but I can send it as a patch if you and Greg
prefer it that way.
