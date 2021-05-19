Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7987388CBF
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbhESL1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 07:27:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237819AbhESL1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 07:27:19 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JB5YaK002366;
        Wed, 19 May 2021 07:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xjNwDg6g7R/jUn4STa3QG5nV0qyInx4KtgFWDfuBse0=;
 b=lbW3PP5qWk9eiRNicUTrzl5EBQnharuU086gFlmexOGxkaemMp3ZGbxA+Wl+Ywey+ybT
 TI+EcYWjqW9NX/y2S4pvTMg9b5WZQ3wCLUfo2ytYO0bRkRabTalekV6yNlDG6RqDX/kr
 g6FwFIJm4GzWmTNfRo7+fXUR4KiRxNa3WILi3TPAX3UxzQ1XqOuHKzEIXEOhprY6rDJP
 Bkb4tys9EtrL4IsAdhBOC96DuOZH2ba4wjDxu0f9BZVVQZ60/1+msNoV7u957iH3RWOp
 dx2UokkhcFioPHUr+JbzKpD2lzZU8NlEskyM3QypBawyOtpQkGLY/SzTnD5qkImZn4o6 AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n0a02qre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:25:58 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JB5nXF003560;
        Wed, 19 May 2021 07:25:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n0a02qqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:25:57 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JBPXaF011293;
        Wed, 19 May 2021 11:25:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgt2cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 11:25:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JBPqrA34013598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 11:25:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B8CDAE056;
        Wed, 19 May 2021 11:25:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC9E8AE051;
        Wed, 19 May 2021 11:25:51 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 19 May 2021 11:25:51 +0000 (GMT)
Date:   Wed, 19 May 2021 13:25:49 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210519132549.295d48db.pasic@linux.ibm.com>
In-Reply-To: <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
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
        <20210518173351.39646b45.pasic@linux.ibm.com>
        <ca5f1c72-09a3-d270-44a0-bda54c554f67@de.ibm.com>
        <20210519012709.3bcc30e7.pasic@linux.ibm.com>
        <250189ed-bded-5261-d8f3-f75787be7aeb@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _iyEpA1SPmLyKZ1JJ59LaZOsF_ozL0VD
X-Proofpoint-GUID: J30VBoJ0VeHxI7dmTnPyIu16zuzxnH5P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190074
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 May 2021 10:17:49 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 19.05.21 01:27, Halil Pasic wrote:
> > On Tue, 18 May 2021 19:01:42 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 18.05.21 17:33, Halil Pasic wrote:  
> >>> On Tue, 18 May 2021 15:59:36 +0200
> >>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:  
> > [..]  
> >>>>>>
> >>>>>> Would it help, if the code in priv.c would read the hook once
> >>>>>> and then only work on the copy? We could protect that with rcu
> >>>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> >>>>>> unsetting the pointer?  
> >>>
> >>> Unfortunately just "the hook" is ambiguous in this context. We
> >>> have kvm->arch.crypto.pqap_hook that is supposed to point to
> >>> a struct kvm_s390_module_hook member of struct ap_matrix_mdev
> >>> which is also called pqap_hook. And struct kvm_s390_module_hook
> >>> has function pointer member named "hook".  
> >>
> >> I was referring to the full struct.  
> >>>      
> >>>>>
> >>>>> I'll look into this.  
> >>>>
> >>>> I think it could work. in priv.c use rcu_readlock, save the
> >>>> pointer, do the check and call, call rcu_read_unlock.
> >>>> In vfio_ap use rcu_assign_pointer to set the pointer and
> >>>> after setting it to zero call sychronize_rcu.  
> >>>
> >>> In my opinion, we should make the accesses to the
> >>> kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
> >>> not sure if that is what you are proposing. How do we usually
> >>> do synchronisation on the stuff that lives in kvm->arch?
> >>>      
> >>
> >> RCU is a method of synchronization. We  make sure that structure
> >> pqap_hook is still valid as long as we are inside the rcu read
> >> lock. So the idea is: clear pointer, wait until all old readers
> >> have finished and the proceed with getting rid of the structure.  
> > 
> > Yes I know that RCU is a method of synchronization, but I'm not
> > very familiar with it. I'm a little confused by "read the hook
> > once and then work on a copy". I guess, I would have to read up
> > on the RCU again to get clarity. I intend to brush up my RCU knowledge
> > once the patch comes along. I would be glad to have your help when
> > reviewing an RCU based solution for this.  
> 
> Just had a quick look. Its not trivial, as the hook function itself
> takes a mutex and an rcu section must not sleep. Will have a deeper
> look.

I refreshed my RCU knowledge and RCU seems to be a reasonable choice
here. I don't think we have to make the rcu read section span the 
call to the callback. That is something like

--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -613,6 +613,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
        unsigned long reg0;
        int ret;
        uint8_t fc;
+       int (*pqap_hook)(struct kvm_vcpu *vcpu);
 
        /* Verify that the AP instruction are available */
        if (!ap_instructions_available())
@@ -657,14 +658,21 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
         * Verify that the hook callback is registered, lock the owner
         * and call the hook.
         */
+       rcu_read_lock();
        if (vcpu->kvm->arch.crypto.pqap_hook) {
-               if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
+               if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner)) {
+                       rcu_read_unlock();
                        return -EOPNOTSUPP;
-               ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
+               }
+               pqap_hook = READ_ONCE(vcpu->kvm->arch.crypto.pqap_hook->hook);
+               rcu_read_unlock();
+               ret = pqap_hook();
                module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
                if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
                        kvm_s390_set_psw_cc(vcpu, 3);
                return ret;
+       } else {
+               rcu_read_unlock();
        }
        /*
         * A vfio_driver must register a hook.

Should be sufficient. The module get ensures that the pointee is still
around for the duration of the call. The handle_pqap() from
vfio_ap_ops.c checks the vcpu->kvm->arch.crypto.pqap_hook the same
lock that is used to set it to NULL, and bails out if it is NULL. It
is a bit convoluted, but it should work.

Regards,
Halil

