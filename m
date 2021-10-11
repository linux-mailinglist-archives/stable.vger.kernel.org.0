Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72801429707
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhJKSpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 14:45:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25292 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJKSpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 14:45:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BIckQq011753;
        Mon, 11 Oct 2021 14:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0TVdZp8CZyIcGmhupCXobsLVC7Yz9AAA+YCIK7aqVnM=;
 b=USa9DOqiZTb8DB3blIIO6uSIoqhm0H69izzOF0G5M4FUVc522BBGgDGT3wHLmke0CsEl
 Yq2E5GkX1JxzLULQRbkocCFdL497L0oZccCV3Z1uIDGM1BzxFsSgRxFXIoJSjaUvaJes
 mKaHBxkhW/vbUzGeCxFNidAE6hcrKwAG1al8WPEz1tdRQZWlrSpaptc7haaf84JUlOWw
 /cGFRhgGLDLEENB2JtoGWT/u7i8yWnU+680RQVRJIMq42Bp8lyz5kOr0OqBGzSoZhyRY
 xePYPeifsPEMi8q8VOTU23p3qzkXYUAEdWHvQK9xyTBfCOttA/S5fTqiLpCQ9T9An2u2 Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmsrjse73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:42:58 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BIeVhK019234;
        Mon, 11 Oct 2021 14:42:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmsrjse6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:42:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BIfqEF030557;
        Mon, 11 Oct 2021 18:42:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj0u1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 18:42:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BIbJtD59244806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 18:37:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC52742052;
        Mon, 11 Oct 2021 18:42:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D898142045;
        Mon, 11 Oct 2021 18:42:51 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.45.119])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 11 Oct 2021 18:42:51 +0000 (GMT)
Date:   Mon, 11 Oct 2021 20:42:49 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        bfu@redhat.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
Message-ID: <20211011204249.3c53ce2a.pasic@linux.ibm.com>
In-Reply-To: <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
        <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rFoN8xc6J3Czo-dMFnIc_pAlMo6_83_A
X-Proofpoint-GUID: f3mIXnY0SdR1n0-AW0u5T4jB7f_EPJMt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_06,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110110107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 15:45:55 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> > +	if (IS_ERR_OR_NULL(addr))  
> 
> I can be wrong but it seems that only dma_alloc_coherent() used in 
> cio_gp_dma_zalloc() report an error but the error is ignored and used as 
> a valid pointer.


https://www.kernel.org/doc/Documentation/DMA-API.txt says:

Part Ia - Using large DMA-coherent buffers
------------------------------------------

::

	void *
	dma_alloc_coherent(struct device *dev, size_t size,
			   dma_addr_t *dma_handle, gfp_t flag)

[..]

It returns a pointer to the allocated region (in the processor's virtual
address space) or NULL if the allocation failed.

I hope that is still true. If not we should fix cio_gp_dma_zalloc().

> 
> So shouldn't we modify this function and just test for a NULL address here?
> 

Isn't IS_ERR_OR_NULL() safer, in a sense that even if we decided to
eventually return an error code, this piece of code would be robust
and safe?

We may exploit the knowledge that cio_gp_dma_zalloc() either
returns NULL or a valid pointer, but doing it like this is IMHO also an
option.

> here what I mean:---------------------------------
> 
> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> index 2bc55ccf3f23..b45fbaa7131b 100644
> --- a/drivers/s390/cio/css.c
> +++ b/drivers/s390/cio/css.c
> @@ -1176,7 +1176,7 @@ void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, 
> struct device *dma_dev,
>                  chunk_size = round_up(size, PAGE_SIZE);
>                  addr = (unsigned long) dma_alloc_coherent(dma_dev,
>                                           chunk_size, &dma_addr, 
> CIO_DMA_GFP);
> -               if (!addr)
> +               if (IS_ERR_OR_NULL(addr))
>                          return NULL;
>                  gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
>                  addr = gen_pool_alloc(gp_dma, size);
> 
> ---------------------------------
> 
> > +		put_device(&cdev->dev);  
> 
> addr is not null if addr is ERR.
> 

Your point?

> > +	return addr;  
> 
> may be return IS_ERR_OR_NULL(addr)? NULL : addr;
> 

See above. I don't think that is necessary.

> >   }
> >   EXPORT_SYMBOL(ccw_device_dma_zalloc);
> >   
> >   void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
> >   {
> > +	if (!cpu_addr)
> > +		return;  
> 
> no need, cpu_addr is already tested in cio_gp_dma_free()
> 

This is added in because of the put_device(). An alternative would be
to call cio_gp_dma_free() unconditionally do the check just for the
put_device(). But I like this one better.

Thanks for your feedback!

Halil

> >   	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
> > +	put_device(&cdev->dev);
> >   }
> >   EXPORT_SYMBOL(ccw_device_dma_free);
> >   
> > 
