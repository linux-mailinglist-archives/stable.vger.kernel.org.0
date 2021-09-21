Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1473412CF1
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhIUCs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351957AbhIUCps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:45:48 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18L1eJsR023857;
        Mon, 20 Sep 2021 22:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=g86bu6UYdOTw8CrRSdIIfyFJZ6DW0/5IWe0xyjvz4dE=;
 b=CWohMfwJXyoabeja3mVz93k/SAZFIkDxesugoI1LB9TUp6Vj8vqRpwac0oUhX3ir9+yb
 P0cox8/j4OqAiuMNE3rYC/gK5wa7teN2I/OZfPdoCctISHc1YKh/qgRKe7DOG0WS5sn/
 M/wTHp6ZIugxvwGzyW1hHBSByYoSFolpEttKXrYNoV8iXR8mRX9GFF9VAT6m6tSVp5za
 Uj0pjV6Lnrb7jwth2oXU6cKGj5UqKnOKbJa07amHNQDyA9ZoMR+FvTk4KXBL4GdQMHtc
 MyCEjS2wXWhAhYTtlvteZrMtd41MoeCLjvYV41UxTBIGIIy3pqyWVW4yUT4X9G12+EG/ tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b735nbpwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 22:44:19 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18L2NQRq028777;
        Mon, 20 Sep 2021 22:44:18 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b735nbpw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 22:44:18 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18L2gCHP005245;
        Tue, 21 Sep 2021 02:44:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3b57r9dtay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 02:44:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18L2iCaO54460746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 02:44:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D57AAE055;
        Tue, 21 Sep 2021 02:44:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD322AE051;
        Tue, 21 Sep 2021 02:44:11 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.4.199])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 21 Sep 2021 02:44:11 +0000 (GMT)
Date:   Tue, 21 Sep 2021 04:43:59 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Message-ID: <20210921044359.2355c29c.pasic@linux.ibm.com>
In-Reply-To: <20210920150616.15668-2-borntraeger@de.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
        <20210920150616.15668-2-borntraeger@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AWRJUq7lBdU9jNKSjM_KlD2CTOVFHBbN
X-Proofpoint-GUID: z-9euliBIriPoGgwGcHmJCCLMkzG_4Il
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_11,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1011 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210013
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Sep 2021 17:06:16 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Christian Bornträger <borntraeger@de.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: <stable@vger.kernel.org> # 3.15+
> Link: https://lore.kernel.org/r/20210827125429.1912577-1-pasic@linux.ibm.com
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [borntraeger@de.ibm.com]: change  idle mask, remove kicked_mask 

LGTM. Thanks for taking care of this!
