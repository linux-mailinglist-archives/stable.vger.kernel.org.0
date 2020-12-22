Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE442E0F09
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 20:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgLVTo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 14:44:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725782AbgLVToZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 14:44:25 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BMJVvIh141664;
        Tue, 22 Dec 2020 14:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=y+KzYvhhDTpXyRtVD37q3AhfB0MloRIzL8zzigYVZqw=;
 b=lI92gLIPdfMi1tYiriETVR9y5HwSdbKPsmLwgEalQW6b2FEGbl7UAcltuXViwsOegUkD
 bdKbm2FWgVEGwLKftGGz9jfnVIZGwW7HZSHgoI/TXS9+2MhRT6KrE6lTgiJTmeC83k91
 Ue9y1EYgL/Hwx7bjWHLBYkl8CE2pEYjSKF5UfRCt+qZb98wah8uc38wNotPoH0AhTaY4
 uisYZmIfh29neHRlD26btrIrgupmWgsRkkC7pSKcwabVeVcW8tuzjUSaAlvp+9uUI6Vc
 Fo1ZsidGdYGv4mG8swIdFMngOHSWVToLPvL/uqTM8VibgjsrpGWYlsBDhDdAvKMlAXsk Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35knyq206r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 14:43:43 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BMJWAuU142136;
        Tue, 22 Dec 2020 14:43:42 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35knyq206d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 14:43:42 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BMJhLkE002424;
        Tue, 22 Dec 2020 19:43:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 35ja5rs2y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 19:43:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BMJhcsp30146816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Dec 2020 19:43:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C78852050;
        Tue, 22 Dec 2020 19:43:38 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.4.181])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 68C475204E;
        Tue, 22 Dec 2020 19:43:37 +0000 (GMT)
Date:   Tue, 22 Dec 2020 20:43:35 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, borntraeger@de.ibm.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v4] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201222204335.1b456342.pasic@linux.ibm.com>
In-Reply-To: <20201222165706.66e0120d.cohuck@redhat.com>
References: <20201221185625.24914-1-akrowiak@linux.ibm.com>
        <20201222050521.46af2bf1.pasic@linux.ibm.com>
        <853da84f-092b-6b94-62d5-628f440abc40@linux.ibm.com>
        <20201222165706.66e0120d.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_10:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220138
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 22 Dec 2020 16:57:06 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 22 Dec 2020 10:37:01 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
> > On 12/21/20 11:05 PM, Halil Pasic wrote:  
> > > On Mon, 21 Dec 2020 13:56:25 -0500
> > > Tony Krowiak <akrowiak@linux.ibm.com> wrote:  
> 
> > >>   static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
> > >>   				       unsigned long action, void *data)
> > >>   {
> > >> -	int ret;
> > >> +	int ret, notify_rc = NOTIFY_DONE;
> > >>   	struct ap_matrix_mdev *matrix_mdev;
> > >>   
> > >>   	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
> > >>   		return NOTIFY_OK;
> > >>   
> > >>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
> > >> +	mutex_lock(&matrix_dev->lock);
> > >>   
> > >>   	if (!data) {
> > >> -		matrix_mdev->kvm = NULL;
> > >> -		return NOTIFY_OK;
> > >> +		if (matrix_mdev->kvm)
> > >> +			vfio_ap_mdev_unset_kvm(matrix_mdev);
> > >> +		notify_rc = NOTIFY_OK;
> > >> +		goto notify_done;
> > >>   	}
> > >>   
> > >>   	ret = vfio_ap_mdev_set_kvm(matrix_mdev, data);
> > >>   	if (ret)
> > >> -		return NOTIFY_DONE;
> > >> +		goto notify_done;
> > >>   
> > >>   	/* If there is no CRYCB pointer, then we can't copy the masks */
> > >>   	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> > >> -		return NOTIFY_DONE;
> > >> +		goto notify_done;
> > >>   
> > >>   	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> > >>   				  matrix_mdev->matrix.aqm,
> > >>   				  matrix_mdev->matrix.adm);
> > >>   
> > >> -	return NOTIFY_OK;    
> > > Shouldn't there be an
> > >   +	notify_rc = NOTIFY_OK;
> > > here? I mean you initialize notify_rc to NOTIFY_DONE, in the !data branch
> > > on success you set notify_rc to NOTIFY_OK, but in the !!data branch it
> > > just stays NOTIFY_DONE. Or am I missing something?    
> > 
> > I don't think it matters much since NOTIFY_OK and NOTIFY_DONE have
> > no further effect on processing of the notification queue, but I believe
> > you are correct, this is a change from what we originally had. I can
> > restore the original return values if you'd prefer.  
> 
> Even if they have the same semantics now, that might change in the
> future; restoring the original behaviour looks like the right thing to
> do.

I agree. Especially since we do care to preserve the behavior in
the !data branch. If there is no difference between the two, then it
would probably make sense to clean that up globally. 

Regards,
Halil
