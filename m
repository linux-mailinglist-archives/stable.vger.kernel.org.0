Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105903322E8
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhCIKXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:23:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229691AbhCIKX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 05:23:26 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129A2Zd7030158;
        Tue, 9 Mar 2021 05:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y2WYqbW5vkjG0KSIX+1BH32UqUNLKp0S+GdGNFjfW1A=;
 b=XYrn2b4dcNORFoL99o+Qbz1b3dq78V3Ao9bB+BdXZQFlU8G/s+IYLNTca9UR/n97dDzN
 UVhhIYw7wdeV3R61Rk8acVlmgj2IRaljbiY8AGPcTpiEF9iNvEni4IHUasmWDEER5Cyc
 5uXqP7PAKH0pUM8VYdMAZvcTwjIlp8s3C6pNlZ7OHi1uobcAESqSHoXkyEBaN0UDzykI
 QgTLQlO0BXQPQboZNX2OEJWaDQOR0t31CWwmrF/IpGTsZvjm5Rv4Gq/wqOrw58CyiR4r
 q2aWs0c4H37Q07ocllO1T6rF96viRmeEOux1e+Eqe4k9Og4QNISmkhr+lXw9NqpH5aPr tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375wdd61up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 05:23:21 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129A4qBj038770;
        Tue, 9 Mar 2021 05:23:20 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375wdd61tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 05:23:20 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1299rm5V009628;
        Tue, 9 Mar 2021 10:23:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3741c89chq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 10:23:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129AN0N030867852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 10:23:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE8B9A4051;
        Tue,  9 Mar 2021 10:23:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19FE4A404D;
        Tue,  9 Mar 2021 10:23:15 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.42.128])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  9 Mar 2021 10:23:15 +0000 (GMT)
Date:   Tue, 9 Mar 2021 11:23:13 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210309112313.4c6e3347.pasic@linux.ibm.com>
In-Reply-To: <8f5ab6fa-8fd3-27d8-8561-d03ff457df16@linux.ibm.com>
References: <20210302204322.24441-1-akrowiak@linux.ibm.com>
        <20210302204322.24441-2-akrowiak@linux.ibm.com>
        <20210303162332.4d227dbe.pasic@linux.ibm.com>
        <14665bcf-2224-e313-43ff-357cadd177cf@linux.ibm.com>
        <20210303204706.0538e84f.pasic@linux.ibm.com>
        <8f5ab6fa-8fd3-27d8-8561-d03ff457df16@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_09:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=861 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Mar 2021 12:43:44 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On the other hand, if we don't have ->kvm because something broke,
> then we may be out of luck anyway. There will certainly be no
> way to unregister the GISC; however, it may still be possible
> to unpin the pages if we still have q->saved_pfn.
> 
> The point is, if the queue is bound to vfio_ap, it can be reset. If we can't
> clean up the IRQ resources because something is broken, then there
> is nothing we can do about that.

Especially since the recently added WARN_ONCE macros calling reset_queues
unconditionally ain't that bad: we would at least see if there is a
problem with cleaning up the IRQ resources.

Let's make it unconditional again and observe. Can you send out a v4 with
this and the other issue fixed. 

Regards,
Halil
