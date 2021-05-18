Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367E6388319
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 01:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhERX2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 19:28:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230352AbhERX2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 19:28:44 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IN48ln032311;
        Tue, 18 May 2021 19:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=szwMXhJStHqamyPt//Gt/3KQhxeXPJVI25+JNBO3flE=;
 b=kh/vnmzzokZZYpplxeO+E9xFFRzY+9xs5Mw+qvwjyls/VVv545/sSgj7d8qeC747pGG/
 eNxu7MDjVcPy7dK9b/lQ1dlpy/563cTwKHgpyNzUVbtPQpZW3rDs01cL/BMcfAi1j55T
 P5IvfcmHpEtloVAJT7YS1xNxnSpt8R+OT18BHUUKk1tAlrb/AViVO24y/We0i6j+Vq9b
 NCRh7fOmVWIQGpFyyhXKdavTL/MIS3QstoLnTM+1jy/ZdYB8G5VGO6zjmIh1TWiYk15a
 4WiXOCOXw8LwMeLpOKbIBwba0DGSAXfKMY/+TXAP6l0yQ/rEbvP4hoWEwJXiFCwhOhnx ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mpp1rnma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 19:27:24 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IN5C75042566;
        Tue, 18 May 2021 19:27:23 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mpp1rnkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 19:27:23 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14INODP9025658;
        Tue, 18 May 2021 23:27:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 38j5x88y06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 23:27:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14INRIu044433710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 23:27:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15F73A4051;
        Tue, 18 May 2021 23:27:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3315EA4040;
        Tue, 18 May 2021 23:27:17 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.17.64])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 18 May 2021 23:27:17 +0000 (GMT)
Date:   Wed, 19 May 2021 01:27:09 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210519012709.3bcc30e7.pasic@linux.ibm.com>
In-Reply-To: <ca5f1c72-09a3-d270-44a0-bda54c554f67@de.ibm.com>
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
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WYWN-i9ftGId583qop22oN4cL01dFjk2
X-Proofpoint-ORIG-GUID: fc4uHoZ8JOMCtgybKym1QvvLiAXexPjv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_11:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105180159
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 May 2021 19:01:42 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 18.05.21 17:33, Halil Pasic wrote:
> > On Tue, 18 May 2021 15:59:36 +0200
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
[..]
> >>>>
> >>>> Would it help, if the code in priv.c would read the hook once
> >>>> and then only work on the copy? We could protect that with rcu
> >>>> and do a synchronize rcu in vfio_ap_mdev_unset_kvm after
> >>>> unsetting the pointer?  
> > 
> > Unfortunately just "the hook" is ambiguous in this context. We
> > have kvm->arch.crypto.pqap_hook that is supposed to point to
> > a struct kvm_s390_module_hook member of struct ap_matrix_mdev
> > which is also called pqap_hook. And struct kvm_s390_module_hook
> > has function pointer member named "hook".  
> 
> I was referring to the full struct.
> >   
> >>>
> >>> I'll look into this.  
> >>
> >> I think it could work. in priv.c use rcu_readlock, save the
> >> pointer, do the check and call, call rcu_read_unlock.
> >> In vfio_ap use rcu_assign_pointer to set the pointer and
> >> after setting it to zero call sychronize_rcu.  
> > 
> > In my opinion, we should make the accesses to the
> > kvm->arch.crypto.pqap_hook pointer properly synchronized. I'm
> > not sure if that is what you are proposing. How do we usually
> > do synchronisation on the stuff that lives in kvm->arch?
> >   
> 
> RCU is a method of synchronization. We  make sure that structure
> pqap_hook is still valid as long as we are inside the rcu read
> lock. So the idea is: clear pointer, wait until all old readers
> have finished and the proceed with getting rid of the structure.

Yes I know that RCU is a method of synchronization, but I'm not
very familiar with it. I'm a little confused by "read the hook
once and then work on a copy". I guess, I would have to read up
on the RCU again to get clarity. I intend to brush up my RCU knowledge
once the patch comes along. I would be glad to have your help when
reviewing an RCU based solution for this.   

Regards,
Halil
