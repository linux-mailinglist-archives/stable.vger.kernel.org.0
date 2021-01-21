Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3F72FEAC6
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbhAUMzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:55:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26298 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729576AbhAUKfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 05:35:42 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LAV31q089813;
        Thu, 21 Jan 2021 05:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TZ7aDjxUa13IAdCxCu1hlw5UfGIcj/AfDRbgbyilYM8=;
 b=PPR2MO5r6H5ImQpoFITPMlC83ox/raYI16KO5XUspLypGm9qlOCWbhWOAez1+nVLwpTZ
 KLVmWeD9wXG+BkWIPgAcnWHy1j5UZ3XOBmahUE9UiLKOZfZQq/vXv6gtww35veTBLZrY
 m8InR1zWGWoI+M3fnMzNQ82HaYIdJWzXZnPUBPdhmm2FcCCdg5jB4ftFtoQxLfs9BGi6
 AzTEuR4HIQIwPWcVKBfjOVoJX300zmmFPi00+eVOhzlNCTFDj2v3DPzZ8TbXsuefDbVQ
 RMzZH07bswy0amIe4tm1RvxPSlPtEkMs2dRvU+j6190G/agTrTJspLs9yiBJwkfxY5pV xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677uhr976-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 05:34:47 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LAVn1F092961;
        Thu, 21 Jan 2021 05:34:47 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677uhr953-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 05:34:46 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LAXgwY027447;
        Thu, 21 Jan 2021 10:34:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3668pj8tdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:34:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LAYfpK30802236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 10:34:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFC2B11C064;
        Thu, 21 Jan 2021 10:34:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E471811C054;
        Thu, 21 Jan 2021 10:34:40 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.12.187])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 21 Jan 2021 10:34:40 +0000 (GMT)
Date:   Thu, 21 Jan 2021 11:34:38 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com
Subject: Re: [PATCH 1/1] s390/vfio-ap: No need to disable IRQ after queue
 reset
Message-ID: <20210121113438.2e40c5f9.pasic@linux.ibm.com>
In-Reply-To: <20210121092044.628b77c7.cohuck@redhat.com>
References: <20210121072008.76523-1-pasic@linux.ibm.com>
        <20210121092044.628b77c7.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210052
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Jan 2021 09:20:44 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 21 Jan 2021 08:20:08 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
[..]
> > --- a/drivers/s390/crypto/vfio_ap_private.h
> > +++ b/drivers/s390/crypto/vfio_ap_private.h
> > @@ -88,11 +88,6 @@ struct ap_matrix_mdev {
> >  	struct mdev_device *mdev;
> >  };
> >  
> > -extern int vfio_ap_mdev_register(void);
> > -extern void vfio_ap_mdev_unregister(void);
> > -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> > -			     unsigned int retry);
> > -
> >  struct vfio_ap_queue {
> >  	struct ap_matrix_mdev *matrix_mdev;
> >  	unsigned long saved_pfn;
> > @@ -100,5 +95,10 @@ struct vfio_ap_queue {
> >  #define VFIO_AP_ISC_INVALID 0xff
> >  	unsigned char saved_isc;
> >  };
> > -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> > +
> > +int vfio_ap_mdev_register(void);
> > +void vfio_ap_mdev_unregister(void);  
> 
> Nit: was moving these two necessary?
> 

No not strictly necessary. I decided that having the data types
first and the function prototypes in one place after the former
is nicer.

> > +int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
> > +			     unsigned int retry);
> > +
> >  #endif /* _VFIO_AP_PRIVATE_H_ */
> > 
> > base-commit: 9791581c049c10929e97098374dd1716a81fefcc  
> 
> Anyway, if I didn't entangle myself in the various branches, this seems
> sane.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thank you very much!

Regards,
Halil
