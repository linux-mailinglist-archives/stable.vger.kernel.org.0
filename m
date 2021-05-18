Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AA387C7F
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 17:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbhERPfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 11:35:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238479AbhERPfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 11:35:20 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IFXeVh077928;
        Tue, 18 May 2021 11:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TQr62DpZ4SQb4D5M08QfWn2SRhd+ESpxOz7ZKFQozY0=;
 b=MCe4+h/HY+ahovMfQ8XPsbQqbuT7U/WzGO0CzkNnq/71nDRRDxX3zy1VdFG7xMKtzpta
 L9EjozSdue6fY2JtpUNQ5vhtWi4JE35gwJcuTih5YaJ5ZVvIgqvR1b4N0JBrvVatBbkK
 npRbfEpzEnbNEn2nyKRn4qke3+/2NKEjnXfIvAWbdEsMjMFIcBJBAfuMQjxmxgnluJZn
 u8Zk0/SFKydxPQJxwPFgw7pqctqS5GxgIRJF5vke1n27hMNS+5z97bqGmxWSJcBJ/qc8
 2KHTSNbcwuYTbigkbdGo+jd5zHtmJqUh49F+3OHrWMeUsBUYmvLTRR+80VpBw5qGOMTz Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mfatafef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 11:34:00 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IFXuuK079543;
        Tue, 18 May 2021 11:34:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mfatafd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 11:33:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IFXNg5022860;
        Tue, 18 May 2021 15:33:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x89jw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 15:33:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IFXsLj33030438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:33:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DB1A42047;
        Tue, 18 May 2021 15:33:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFB6442041;
        Tue, 18 May 2021 15:33:53 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.17.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 18 May 2021 15:33:53 +0000 (GMT)
Date:   Tue, 18 May 2021 17:33:51 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210518173351.39646b45.pasic@linux.ibm.com>
In-Reply-To: <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
        <20210512203536.4209c29c.pasic@linux.ibm.com>
        <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
        <20210513194541.58d1628a.pasic@linux.ibm.com>
        <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
        <20210514021500.60ad2a22.pasic@linux.ibm.com>
        <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
        <20210517211030.368ca64b.pasic@linux.ibm.com>
        <966a60ad-bdde-68d0-ae2f-06121c6ad970@de.ibm.com>
        <9ebd5fd8-b093-e5bc-e680-88fa7a9b085c@linux.ibm.com>
        <494af62b-dc9a-ef2c-1869-d8f5ed239504@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t3K8MoDSLSCjFz7UQHyiJ7pzRaIflBtA
X-Proofpoint-ORIG-GUID: oKisr6c5qlFYMRjJi5pfcvZJA4yiC3BW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_07:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 May 2021 15:59:36 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.05.21 15:42, Tony Krowiak wrote:
> > 
> > 
> > On 5/18/21 5:30 AM, Christian Borntraeger wrote:  
> >>
> >>
> >> On 17.05.21 21:10, Halil Pasic wrote:  
> >>> On Mon, 17 May 2021 09:37:42 -0400
> >>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>>  
> >>>>>
> >>>>> Because of this, I don't think the rest of your argument is valid.  
> >>>>
> >>>> Okay, so your concern is that between the point in time the
> >>>> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
> >>>> priv.c and the point in time the handle_pqap() function
> >>>> in vfio_ap_ops.c is called, the memory allocated for the
> >>>> matrix_mdev containing the struct kvm_s390_module_hook
> >>>> may get freed, thus rendering the function pointer invalid.
> >>>> While not impossible, that seems extremely unlikely to
> >>>> happen. Can you articulate a scenario where that could
> >>>> even occur?  
> >>>
> >>> Malicious userspace. We tend to do the pqap aqic just once
> >>> in the guest right after the queue is detected. I do agree
> >>> it ain't very likely to happen during normal operation. But why are
> >>> you asking?  
> >>
> >> Would it help, if the code in priv.c would read the hook once
> >> and then only work on the copy? We could protect that with rcu
> >> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> >> unsetting the pointer?

Unfortunately just "the hook" is ambiguous in this context. We
have kvm->arch.crypto.pqap_hook that is supposed to point to
a struct kvm_s390_module_hook member of struct ap_matrix_mdev 
which is also called pqap_hook. And struct kvm_s390_module_hook
has function pointer member named "hook".

> > 
> > I'll look into this.  
> 
> I think it could work. in priv.c use rcu_readlock, save the
> pointer, do the check and call, call rcu_read_unlock.
> In vfio_ap use rcu_assign_pointer to set the pointer and
> after setting it to zero call sychronize_rcu.

In my opinion, we should make the accesses to the
kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
not sure if that is what you are proposing. How do we usually
do synchronisation on the stuff that lives in kvm->arch?

BTW, something as simple as a cmpxchg which boils down to the
CSG instruction for us would suffice in this case (or forcing
any interlocked update type construct). 

> 
> Halil, I think we can do this as an addon patch as it makes
> sense to have this callback pointer protected independent of
> this patch. Agree?

Unfortunately I didn't quite get at the bottom of what exactly gets
leaked. My intuition is, that trading a leak for an use after free
is in general not a good idea. In this particular case, assuming
userspace is well behaved, the use after free is very unlikely,
but then I don't consider the leak to be awfully likely either. A
well behaved userspace should not attempt to remove the mdev while
it is associated with a guest. We documented that in:
Documentation/s390/vfio-ap.rst
"""
  remove:
    deallocates the mediated matrix device's ap_matrix_mdev structure. This will
    be allowed only if a running guest is not using the mdev.
"""
BTW this patch should probably change that piece of documentation as
well.

In this case, because the leak is much likelier than the use after
free (assuming a non-malicious-userspace) the trade may be worth it. Yet my
independent opinion is that I would prefer this fixed in one go and
properly. But I do trust your judgement better than mine (especially in
matters like this). So feel free to go ahead (i.e. I'm not going to NACK
this). 

Regards,
Halil
