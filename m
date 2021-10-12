Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B3E42AFB4
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhJLWjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 18:39:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232419AbhJLWjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 18:39:33 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CL1cdF010905;
        Tue, 12 Oct 2021 18:37:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sCeXo3dqmkP0/xhNkOSvbSYV07M3tvRrK4r1EnU84Cw=;
 b=jmWXkZKLI5Zql9HD18VOCm80ynoGt/I550/eS1cYqrEZX31AOj8JITnikqhSiCGWQtJV
 RPPx/50aPIEFqSiX8/nDCY1CFL82FY0glrUkm1l4etCnyUEZ6JMGPygdMOJFBOrIyRiC
 5BlXdaJJzEec78RSxld3Q10eWgfLO77KrCVA9nZtAUxB8ismy+675kVJXu3jHzb6OMlX
 i6sSrVpHUD6LJOmNIeiYwTe3s6fCkurW9xtnmaKXo+2GqCsTC2FwsEZpRE+hntvKdOsZ
 cME3ICWfELUNNkEE6zZkeWRnl7/XgJ0fwEobtjYY74DiJrvZ2fL6cGa3BwapKWwV0DHU OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnhwv9mbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 18:37:30 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CMbTWD025404;
        Tue, 12 Oct 2021 18:37:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnhwv9mbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 18:37:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CMXQSG029155;
        Tue, 12 Oct 2021 22:37:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q9mv53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:37:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CMbOpv45810034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 22:37:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0325D52083;
        Tue, 12 Oct 2021 22:37:24 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id DF42152082;
        Tue, 12 Oct 2021 22:37:22 +0000 (GMT)
Date:   Wed, 13 Oct 2021 00:37:14 +0200
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
Message-ID: <20211013003714.1c411f0b.pasic@linux.ibm.com>
In-Reply-To: <87pmsawdvr.fsf@redhat.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
 <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
 <874k9ny6k6.fsf@redhat.com>
 <20211011204837.7617301b.pasic@linux.ibm.com>
 <87pmsawdvr.fsf@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FnNmoyxqV9kzXznksfIDmwOd5XzzJui5
X-Proofpoint-GUID: ALJzMp_pvrvA8cXvFjEHX09NUna6vrZG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_06,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxlogscore=718 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120119
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 15:50:48 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> >> If I read cio_gp_dma_zalloc() correctly, we either get NULL or a valid
> >> address, so yes.
> >>   
> >
> > I don't think the extra care will hurt us too badly. I prefer to keep
> > the IS_ERR_OR_NULL() check because it needs less domain specific
> > knowledge to be understood, and because it is more robust.  
> 
> It feels weird, though -- I'd rather have a comment that tells me

This way the change feels simpler and safer to me. I believe I explained
the why above. But if you insist I can change it. I double checked the
cio_gp_dma_zalloc() code, and more or less the code called by it. So
now I don't feel uncomfortable with the simpler check.

On the other hand, I'm not very happy doing changes solely based on
somebody's feelings. It would feel much more comfortable with a reason
based discussion.

One reason to change this to a simple NULL check, is that the
IS_ERR_OR_NULL() check could upset the reader of the client code,
which only checks for NULL.

On the other hand I do believe we have some risk of lumping together
different errors here. E.g. dma_pool is NULL or dma ops are not set up
properly. Currently we would communicate that kind of a problem as
-ENOMEM, which wouldn't be a great match. But since dma_alloc_coherent()
returns either NULL or a valid pointer, and furthermore this looks like
a common thing in all the mm-api, I decided to be inline with that.

TLDR; If you insist, I will change this to a simple null pointer check.

> exactly what cio_gp_dma_zalloc() is supposed to return; I would have
> expected that a _zalloc function always gives me a valid pointer or
> NULL.

I don't think we have such a comment for dma_alloc_coherent() or even
kmalloc(). I agree, it would be nice to have this behavior documented
in the apidoc all over the place. But IMHO that is a different issue.

Regards,
Halil

