Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F6A48C0B4
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 10:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351938AbiALJGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 04:06:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34900 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351922AbiALJGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 04:06:20 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20C8pOBP029584;
        Wed, 12 Jan 2022 09:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : references : date : message-id :
 mime-version : content-type; s=pp1;
 bh=rFayo3zWIt8IBV+NQldKq4wgXu8k8OS3vTQgQUzk5bo=;
 b=gOPbP8j+N8N0N7ykm6GxQR0pC+JD/wvgEQ/RAlZCW8LBFo0L7fXrs3gJeSx/yXdELbIM
 U27Ru7lR8sT5rkLzg2am10FyMzAtpH9pZNlC8R9K6axXabGdP9fI/s3idxariuaLOu0q
 wffEIG0xhTAbEybBDFHg9j7a9CpS2VAGNchQ+v5XjMBeY5UyRYmQgj6ZDFwqedU0VdWb
 nmFkGOEeFQAPCYts3dNZAadixJgsitksk2mqDaud1xLzmkkn0U0/THrB5QNfOHmagoHf
 7pfMRablHVSKSgySmEcCG0CHwbGoqdHYOUsUGI4VJ1g9La/7L90cbXbwoBHrCvkkLfN3 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhuugr9ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:06:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20C8pcGk030538;
        Wed, 12 Jan 2022 09:06:18 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhuugr9gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:06:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20C92H3k027925;
        Wed, 12 Jan 2022 09:06:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3df289nuxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 09:06:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20C96E8G40174008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 09:06:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74CFAAE04D;
        Wed, 12 Jan 2022 09:06:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DC9FAE058;
        Wed, 12 Jan 2022 09:06:14 +0000 (GMT)
Received: from localhost (unknown [9.171.34.68])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jan 2022 09:06:14 +0000 (GMT)
From:   Alexander Egorenkov <egorenar@linux.ibm.com>
To:     gregkh@linuxfoundation.org, hca@linux.ibm.com, ltao@redhat.com,
        prudo@redhat.com, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/kexec: handle R_390_PLT32DBL rela
 in" failed to apply to 5.15-stable tree
In-Reply-To: <1639748305210135@kroah.com>
In-Reply-To: 
References: <1639748305210135@kroah.com>
Date:   Wed, 12 Jan 2022 10:06:14 +0100
Message-ID: <8735lt8gs9.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 23S9soUxiDQsrdcjCKUkzs6gz3f0NxKy
X-Proofpoint-GUID: Ijwhn11sApVkbW51RUUtt1iyChm_Oz0N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_03,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=934 malwarescore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>

please apply the following upstream commits (in this order):

1. edce10ee21f3916f5da34e55bbc03103c604ba70
2. 41967a37b8eedfee15b81406a9f3015be90d3980
3. abf0e8e4ef25478a4390115e6a953d589d1f9ffd (the failed commit)

Thanks!

Regards
Alex
