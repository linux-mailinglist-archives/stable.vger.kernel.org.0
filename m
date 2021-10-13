Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D88C42C061
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 14:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhJMMqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 08:46:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34420 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhJMMqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 08:46:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DCX8eM021026;
        Wed, 13 Oct 2021 08:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=e4qeE39nNF63o3oTejjERAXSIzN7WFNAVqNCqaNZdS0=;
 b=bXdKh2QI46h+HoWTks3D/B3G7row03b3rYVbT/nIgjaVQgeqX2JEEXuQUfWPRZFUUyoB
 55qM23TFN7JsXM9l/sPtCIDo7ycrFTvLVryj7J6PsdFITPsTcH0pd3N2j4HWSPhxMLxT
 euwBaWLbYhVJE+9tbS3PiasNQfw3SZjVtDTVoFMfASgzvgRYyQ7QL/ICl75qsrhQAPvx
 ZvoknCx3YXG8QvhQqnvvkofrNKgjCZWn7AFCa8Km27LzXzILVwnIHNWYRz19hM59Aasl
 d7yuXRcAJUB3Jf3O+F80/Sojw7aJSsk/kq0ABs52Az04B0VFZec1P4qggAuOGdnWpUNx CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bntpwxx85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 08:44:36 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DBUBAi030380;
        Wed, 13 Oct 2021 08:44:35 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bntpwxx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 08:44:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DCfUTe016216;
        Wed, 13 Oct 2021 12:44:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2qa0fa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 12:44:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DCiKMl59441428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 12:44:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FB2BA406F;
        Wed, 13 Oct 2021 12:44:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 727F2A407B;
        Wed, 13 Oct 2021 12:44:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 13 Oct 2021 12:44:13 +0000 (GMT)
Date:   Wed, 13 Oct 2021 14:44:08 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        markver@us.ibm.com, Cornelia Huck <cohuck@redhat.com>,
        linux-s390@vger.kernel.org, stefanha@redhat.com,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-devel@nongnu.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v3 1/1] virtio: write back F_VERSION_1 before validate
Message-ID: <20211013144408.2812d9bd.pasic@linux.ibm.com>
In-Reply-To: <20211013081836-mutt-send-email-mst@kernel.org>
References: <20211011053921.1198936-1-pasic@linux.ibm.com>
        <20211013060923-mutt-send-email-mst@kernel.org>
        <96561e29-e0d6-9a4d-3657-999bad59914e@de.ibm.com>
        <20211013081836-mutt-send-email-mst@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jp0uxxHTXTE771ls4ramYMB1Oy-7C_gz
X-Proofpoint-ORIG-GUID: AuiVxpbg965JdHptRviyaH---l1LWaGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=983 clxscore=1015 phishscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130084
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Oct 2021 08:24:53 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> > > OK this looks good! How about a QEMU patch to make it spec compliant on
> > > BE?  
> > 
> > Who is going to do that? Halil? you? Conny?  
> 
> Halil said he'll do it... Right, Halil?

I can do it but not right away. Maybe in a couple of weeks. I have some
other bugs to hunt down, before proceeding to this. If somebody else
wants to do it, I'm fine with that as well.

Regards,
Halil
