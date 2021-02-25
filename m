Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1736A325282
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 16:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhBYPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 10:37:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229845AbhBYPhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 10:37:19 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PFX335027777;
        Thu, 25 Feb 2021 10:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bhVw3KMUCaow66xCSd9nAmtx9kPd8ICFEWEh2CVI9OY=;
 b=qEm78qAOdGK8rOtSgvAIm5kz5bwlMBLBa5yjN8gJq6bKiSOpRtXFiFqRdN1PQOb+X3rY
 C8iq76VKapysB9UCazI6KbA+n4WJZY3QrLYOO3XYUko0NIfXJ2zEIO4rH4/bLJswhEBT
 vt3F1MvkydsDd+YCOvTuMm1fBE4DU3VWkvGamZ7zi5ic/3wkRdpGmGGDADuSGOoCdIst
 YE5OkQ1wD841qUZ33RwcT2FMF40mtIdvLH7X7z8wnmaHHAssK/k/0JqKkBEYKyeZmDsc
 xHZK4Nz28p8VKTisiIxvQQ8Y2sAfS1CQKRrGC+n94A5hK/LKVmDZlfbXSn237ZRNaxoZ KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xefr8fkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 10:36:36 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PFXfLe030703;
        Thu, 25 Feb 2021 10:36:35 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xefr8fga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 10:36:35 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PFMZhG024176;
        Thu, 25 Feb 2021 15:36:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28cjqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 15:36:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PFaRH638928764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 15:36:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A813B4C040;
        Thu, 25 Feb 2021 15:36:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E740D4C046;
        Thu, 25 Feb 2021 15:36:26 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.33.39])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 25 Feb 2021 15:36:26 +0000 (GMT)
Date:   Thu, 25 Feb 2021 16:36:24 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, kwankhede@nvidia.com,
        pbonzini@redhat.com, alex.williamson@redhat.com,
        pasic@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/1] s390/vfio-ap: fix circular lockdep when
 setting/clearing crypto masks
Message-ID: <20210225163624.01a89051.pasic@linux.ibm.com>
In-Reply-To: <f5d5cbab-2181-2a95-8a87-b21d05405936@linux.ibm.com>
References: <20210216011547.22277-1-akrowiak@linux.ibm.com>
        <20210216011547.22277-2-akrowiak@linux.ibm.com>
        <20210223104805.6a8d1872.pasic@linux.ibm.com>
        <63bb0d61-efcd-315b-5a1a-0ef4d99600f4@linux.ibm.com>
        <20210225122824.467b8ed9.pasic@linux.ibm.com>
        <f5d5cbab-2181-2a95-8a87-b21d05405936@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_09:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=639 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102250125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Feb 2021 08:53:50 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> If we add the proposed flag to indicate when the matrix_mdev->kvm
> pointer is in flux, then we can check that before allowing the functions
> in the list above to proceed.

I'm not against that. Go ahead!

Regards,
Halil
