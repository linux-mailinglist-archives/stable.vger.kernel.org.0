Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A0342971D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 20:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhJKSut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 14:50:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232866AbhJKSus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 14:50:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BIcjvl016660;
        Mon, 11 Oct 2021 14:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bS+rZTbAhxksXQhveTxyUijqQCp/p0eQafDLQ2L6AeE=;
 b=gOUUnWOiQZaltC1NIN3XpkRgMEtLL6WZ1JNFMSFXuBpB0Ifz4w9wPFHsbjBXG09WnA/z
 M2CuvKAPjtgnfuOlAXl4FwAmRPjX7xDrUvj6MMGXgIj3tdqjthEsMynnOVVtMQ0wZij8
 s/qS+hPEnbyKFYW4sorKR/Mm2Fh3ptX13zE5WeHNE/zzf+5vA8kCnFjUjnN/py1htnBq
 G/V9W9uu4URcm5q6w4Uk6cSR3G2KtQl9n1jgJ9XKlXuNkUxdARhG04Utt6UImh58TOW9
 EJKOuuxQpoHf5X0ZLQLfCWGnm3MM2IfYL/erHm8TdWaGksrCV/cr7/drBcWYL1dVeKIg yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmtb10rhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:48:48 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BIl9rW016958;
        Mon, 11 Oct 2021 14:48:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmtb10rgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:48:47 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BIlIpr003722;
        Mon, 11 Oct 2021 18:48:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q98q0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 18:48:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BIhA1Q61210980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 18:43:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A02F11C05B;
        Mon, 11 Oct 2021 18:48:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6316E11C04A;
        Mon, 11 Oct 2021 18:48:40 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.45.119])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 11 Oct 2021 18:48:40 +0000 (GMT)
Date:   Mon, 11 Oct 2021 20:48:37 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
Message-ID: <20211011204837.7617301b.pasic@linux.ibm.com>
In-Reply-To: <874k9ny6k6.fsf@redhat.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
        <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
        <874k9ny6k6.fsf@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FHw5qwKgeIRfgdN0RXacFKDA_-XaTldS
X-Proofpoint-ORIG-GUID: bu3PtKbJ-F9UbCyxUCshrA7DTleiLK5L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_06,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=875 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 16:33:45 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, Oct 11 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > On 10/11/21 1:59 PM, Halil Pasic wrote:  
> >> diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
> >> index 0fe7b2f2e7f5..c533d1dadc6b 100644
> >> --- a/drivers/s390/cio/device_ops.c
> >> +++ b/drivers/s390/cio/device_ops.c
> >> @@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
> >>    */
> >>   void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
> >>   {
> >> -	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
> >> +	void *addr;
> >> +
> >> +	if (!get_device(&cdev->dev))
> >> +		return NULL;
> >> +	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
> >> +	if (IS_ERR_OR_NULL(addr))  
> >
> > I can be wrong but it seems that only dma_alloc_coherent() used in 
> > cio_gp_dma_zalloc() report an error but the error is ignored and used as 
> > a valid pointer.  
> 
> Hm, I thought dma_alloc_coherent() returned either NULL or a valid
> address?

Yes, that is what is documented.

> 
> >
> > So shouldn't we modify this function and just test for a NULL address here?  
> 
> If I read cio_gp_dma_zalloc() correctly, we either get NULL or a valid
> address, so yes.
> 

I don't think the extra care will hurt us too badly. I prefer to keep
the IS_ERR_OR_NULL() check because it needs less domain specific
knowledge to be understood, and because it is more robust.

Regards,
Halil
