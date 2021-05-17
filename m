Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF713383CF9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhEQTL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:11:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3832 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231379AbhEQTL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:11:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HJ4EUF140018;
        Mon, 17 May 2021 15:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6hsvjsITPUCnrFWqTahbJoJfWrEF44ZPGCdggVB0zeM=;
 b=AUvO04ReJBgvqkGfesc/EDb0CbFAdG5ReqwdkDYW/SAKdjaEX/yKsJXSt2Iv9bBK99ku
 YM//N9YR0Q0C/ofwBVAJKcHrCwvTSGfWN3hOsu5v6mw/HHODuLvR/uViLGezqEhyJ/ra
 xAo5OCgAs/QKFrmcSY+A7m8sSpCsRrbRQIK4p+0AwNpo/oExq+NyR7Gz1HTU19utlGIt
 n28yUFjrWCByUAPtcC5xlMYxBMD2oouxo2TUuG1XptC31e5rOypVePfAXgKX7RRqnirl
 hoh6jBMh10gYqUywpykoT9/IZvF6/GTqtGVbwulQUy+kaRbrqaj0JF2otqyVEwz37V/o Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kw8020wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 15:10:39 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HJ4moc144594;
        Mon, 17 May 2021 15:10:39 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kw8020v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 15:10:38 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HJ7DjI018412;
        Mon, 17 May 2021 19:10:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x8925t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 19:10:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HJAXWr44958092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 19:10:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F0B14C044;
        Mon, 17 May 2021 19:10:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B6DC4C046;
        Mon, 17 May 2021 19:10:32 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.52.118])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 17 May 2021 19:10:32 +0000 (GMT)
Date:   Mon, 17 May 2021 21:10:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com, jgg@nvidia.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210517211030.368ca64b.pasic@linux.ibm.com>
In-Reply-To: <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
 <20210512203536.4209c29c.pasic@linux.ibm.com>
 <4c156ab8-da49-4867-f29c-9712c2628d44@linux.ibm.com>
 <20210513194541.58d1628a.pasic@linux.ibm.com>
 <243086e2-08a0-71ed-eb7e-618a62b007e4@linux.ibm.com>
 <20210514021500.60ad2a22.pasic@linux.ibm.com>
 <594374f6-8cf6-4c22-0bac-3b224c55bbb6@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ogxqyuyO29QcstH-3LxOv6LJZsUHq7Il
X-Proofpoint-GUID: AqVjBD1le3CgxS63pCX2SHd9lt62aNha
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021 09:37:42 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >
> > Because of this, I don't think the rest of your argument is valid.  
> 
> Okay, so your concern is that between the point in time the
> vcpu->kvm->arch.crypto.pqap_hook pointer is checked in
> priv.c and the point in time the handle_pqap() function
> in vfio_ap_ops.c is called, the memory allocated for the
> matrix_mdev containing the struct kvm_s390_module_hook
> may get freed, thus rendering the function pointer invalid.
> While not impossible, that seems extremely unlikely to
> happen. Can you articulate a scenario where that could
> even occur?

Malicious userspace. We tend to do the pqap aqic just once
in the guest right after the queue is detected. I do agree
it ain't very likely to happen during normal operation. But why are
you asking?

I'm not sure I understood correctly what kind of a scenario are
you asking for. PQAP AQIC and mdev remove are independent
events originated in userspace, so AFAIK we may not assume
that the execution of two won't overlap, nor are we allowed
to make assumptions on how does the execution of these two
overlap (except for the things we explicitly ensure -- e.g.
some parts are made mutually exclusive using the matrix_dev->lock
lock).

Regards,
Halil

