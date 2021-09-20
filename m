Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC410411830
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhITPbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:31:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9476 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234117AbhITPbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 11:31:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KEqUmX005142;
        Mon, 20 Sep 2021 11:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QOxMDugNfIIjhAiZgkxusJmlTL421wYHJIwMplwhVQY=;
 b=W83GPId4Hd+F8xgalZtBhHP22B/ECLfuPch8jp1pXkbfQpoCvYi/yy9UbbUJcveIDxy2
 p4TL4FyOlOba6R2G22L/cANmxetbuKnKZypBoS+F7rZnUX6i/uyRQJMMGijHflirniHJ
 4zo1AKn/v8EaOR0iKqicDQXsSqrctDveQdSXs/DxRUJgBOTcPsWX1f14LZW5KYZ6cr9I
 q+tI2O1rjdkJXS7D6NwIHh5bzLL3n2Ezd5Y3mmjnaMo1CAXyc8S/v4jjKkg2pW6NAUVC
 5R93Atz6c5U2tv7GjNXGlkKnWwCSShL90ggrcwBKF9YjkJ2cFp2iMHkeP9J1Q2cOx/T+ Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w94dfbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:30:19 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KEqeZs005776;
        Mon, 20 Sep 2021 11:30:18 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w94dfan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:30:18 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KFR9Fu026815;
        Mon, 20 Sep 2021 15:30:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj9kq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:30:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KFUC0X42598794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 15:30:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F75F4C06F;
        Mon, 20 Sep 2021 15:30:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CECF4C059;
        Mon, 20 Sep 2021 15:30:11 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.21.246])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 15:30:11 +0000 (GMT)
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
 <YUint4b1ETglbj8z@kroah.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <16dad0d8-43bf-1ad7-bf3e-ae3acfde97eb@de.ibm.com>
Date:   Mon, 20 Sep 2021 17:30:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YUint4b1ETglbj8z@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y8UCpFASt39i18TwPb2kmabvEAOPjHb8
X-Proofpoint-ORIG-GUID: C8iVt7EszD-JHo1ucCGgFxdLdxQtanEP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=956 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 20.09.21 um 17:24 schrieb Greg KH:
> On Mon, Sep 20, 2021 at 05:06:15PM +0200, Christian Borntraeger wrote:
>> Stable team,
>>
>> here is a backport for 4.19 of
>> commit a3e03bc1368 ("KVM: s390: index kvm->arch.idle_mask by vcpu_idx")
>> This basically removes the kick_mask parts that were introduced with
>> kernel 5.0 and fixes up the location of the idle_mask to the older
>> place.
> 
> Now queued up, thanks.
> 
>> FWIW, it might be a good idea to also backport
>> 8750e72a79dd ("KVM: remember position in kvm->vcpus array") to avoid
>> a performance regression for large guests (many vCPUs) when this patch
>> is applied.
>> @Paolo Bonzini, would you be ok with 8750e72a79dd in older stable releases?
> 
> That would also have to go into 5.4.y, right?
Ideally yes.
