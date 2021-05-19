Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C85388E7C
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 14:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbhESNBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 09:01:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232671AbhESNBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 09:01:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JCYMpi038186;
        Wed, 19 May 2021 08:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ac22Ii0um/BS/6HrsN4Nl3r4JeJ2SdWGsxwNx8Os7ww=;
 b=tPEyj35PkHMfS5ByG9DLe11vnoq7+hmsQJHpiRXFGq6kVanpoIE1dUlqX63rWpTkNeHI
 5eIvJgOAs1ud2cwNfTATXfC+3JzLYoVkvEY0/dVgGFDGdZgxd/uZZ4Vfq5muY+mKyqer
 hJDFWMQKtDQcTQ5FojkNWSAnmIzHYL7mk2Z+Pkq8IsljmNUPxPZx0biEClQ0t13Cw1aE
 uDMJdtemiZOalj44vte40myoSFu5lqgl7Mui3/MGE2P1UA1cNqIp7KpYQ6gJg/vYDBtS
 7p0ApfK3WZ/wAq05Kq1yD/g9Gfs3E5SmHZJBtcfwf6icGov7KZN+QGXEr8ra0p8Hlwnh Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n2sdgqq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:59:49 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JCYcwR039311;
        Wed, 19 May 2021 08:59:49 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38n2sdgqp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:59:49 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JCmLak009613;
        Wed, 19 May 2021 12:59:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7t4k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 12:59:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JCxGas20185508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 12:59:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E10FAE058;
        Wed, 19 May 2021 12:59:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85FE5AE04D;
        Wed, 19 May 2021 12:59:43 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 19 May 2021 12:59:43 +0000 (GMT)
Date:   Wed, 19 May 2021 14:59:41 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210519145941.216cae45.pasic@linux.ibm.com>
In-Reply-To: <9c2b4711-5a26-15b0-8651-67a88bf12270@de.ibm.com>
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
        <9c2b4711-5a26-15b0-8651-67a88bf12270@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3ZKf9tAHsZZ1tFS3IM2k4OgK8Z29fWfr
X-Proofpoint-ORIG-GUID: m3R5PeNgVEHPizKDbIpVGSC4x31vbcA3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_05:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 May 2021 13:22:56 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 19.05.21 10:17, Christian Borntraeger wrote:
> > 
> > 
> > On 19.05.21 01:27, Halil Pasic wrote:  
> >> On Tue, 18 May 2021 19:01:42 +0200
> >> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>  
> >>> On 18.05.21 17:33, Halil Pasic wrote:  
> >>>> On Tue, 18 May 2021 15:59:36 +0200
> >>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:  
> >> [..]  
> >>>>>>>
> >>>>>>> Would it help, if the code in priv.c would read the hook once
> >>>>>>> and then only work on the copy? We could protect that with rcu
> >>>>>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> >>>>>>> unsetting the pointer?  
> >>>>
> >>>> Unfortunately just "the hook" is ambiguous in this context. We
> >>>> have kvm->arch.crypto.pqap_hook that is supposed to point to
> >>>> a struct kvm_s390_module_hook member of struct ap_matrix_mdev
> >>>> which is also called pqap_hook. And struct kvm_s390_module_hook
> >>>> has function pointer member named "hook".  
> >>>
> >>> I was referring to the full struct.  
> >>>>>>
> >>>>>> I'll look into this.  
> >>>>>
> >>>>> I think it could work. in priv.c use rcu_readlock, save the
> >>>>> pointer, do the check and call, call rcu_read_unlock.
> >>>>> In vfio_ap use rcu_assign_pointer to set the pointer and
> >>>>> after setting it to zero call sychronize_rcu.  
> >>>>
> >>>> In my opinion, we should make the accesses to the
> >>>> kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
> >>>> not sure if that is what you are proposing. How do we usually
> >>>> do synchronisation on the stuff that lives in kvm->arch?  
> >>>
> >>> RCU is a method of synchronization. We  make sure that structure
> >>> pqap_hook is still valid as long as we are inside the rcu read
> >>> lock. So the idea is: clear pointer, wait until all old readers
> >>> have finished and the proceed with getting rid of the structure.  
> >>
> >> Yes I know that RCU is a method of synchronization, but I'm not
> >> very familiar with it. I'm a little confused by "read the hook
> >> once and then work on a copy". I guess, I would have to read up
> >> on the RCU again to get clarity. I intend to brush up my RCU knowledge
> >> once the patch comes along. I would be glad to have your help when
> >> reviewing an RCU based solution for this.  
> > 
> > Just had a quick look. Its not trivial, as the hook function itself
> > takes a mutex and an rcu section must not sleep. Will have a deeper
> > look.  
> 
> 
> As a quick hack something like this could work. The whole locking is pretty
> complicated and this makes it even more complex so we might want to do
> a cleanup/locking rework later on.
> 

Hm, seems our emails crossed mid air...

> 
> index 9928f785c677..fde6e02aab54 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -609,6 +609,7 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
>    */
>   static int handle_pqap(struct kvm_vcpu *vcpu)
>   {
> +       struct kvm_s390_module_hook *pqap_hook;
>          struct ap_queue_status status = {};
>          unsigned long reg0;
>          int ret;
> @@ -657,14 +658,21 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>           * Verify that the hook callback is registered, lock the owner
>           * and call the hook.
>           */
> -       if (vcpu->kvm->arch.crypto.pqap_hook) {
> -               if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
> +       rcu_read_lock();
> +       pqap_hook = rcu_dereference(vcpu->kvm->arch.crypto.pqap_hook);
> +       if (pqap_hook) {
> +               if (!try_module_get(pqap_hook->owner)) {
> +                       rcu_read_unlock();
>                          return -EOPNOTSUPP;
> -               ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
> -               module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
> +               }

Up to this point the local pqap_hook is guaranteed to point to a valid
object if not NULL, ...
> +               rcu_read_unlock();

... and after this point IMHO it is not.

> +               ret = pqap_hook->hook(vcpu);

So IMHO the pointer deference here is still problematic, but that can
be fixed easily as I described in that email I've sent 3 minutes after
yours. IMHO we need a local copy of cpu->kvm->arch.crypto.pqap_hook->hook
taken within the rcu read critical section. Do you agree?

Regards,
Halil

> +               module_put(pqap_hook->owner);
>                  if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>                          kvm_s390_set_psw_cc(vcpu, 3);
>                  return ret;
> +       } else {
> +               rcu_read_unlock();
>          }
>          /*
>           * A vfio_driver must register a hook.
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index f90c9103dac2..a7124abd6aed 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1194,6 +1194,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>                  mutex_lock(&matrix_dev->lock);
>                  vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
>                  matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> +               synchronize_rcu();
>                  kvm_put_kvm(matrix_mdev->kvm);
>                  matrix_mdev->kvm = NULL;
>                  matrix_mdev->kvm_busy = false;

