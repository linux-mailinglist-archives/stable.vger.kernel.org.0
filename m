Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0171837FC8D
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 19:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEMRdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 13:33:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230003AbhEMRdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 13:33:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DH3o4t018583;
        Thu, 13 May 2021 13:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hPaGR7/oBR2n564nVIX+Qno0Rnz64aTYCztemg+ak/A=;
 b=i5jJYWGTAzPFMizgfDtB98PDC9FNvmhMDLf/lqQJHx8MTAwWBvTjLcb7V5vc2DnK/+kr
 KrZcsSrM+Z5gCx58T4mvUV19OLcPIeJqNfWS7ZmrFexD7PUqMqX6H+5UuIHITjNfF5AH
 ytikIEj+PG2iRWC6f0NfOgA1ZUCdTlGtJQ2XwdDC1B7nhk6r3JaiN2qqWAQ0icMP5x9f
 Jq0zNZzuclAS/9cGxfWjweFlVcjO6H3D4Jw0JjdEL2kJ5ktlaI6dVDvGej+FUkOr7GRf
 fig2T+/3kXV0XhKv7AUIbq+AEHvz2EYcFkR3nBpbbtpvhuUk2BBtsHWMTZX51bWTGLzJ 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h76rjecg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 13:32:12 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DH3uEo019038;
        Thu, 13 May 2021 13:32:11 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h76rjebs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 13:32:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DHOHY9027965;
        Thu, 13 May 2021 17:32:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38dj98atra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 17:32:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DHW67Q40894816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 17:32:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C193A4060;
        Thu, 13 May 2021 17:32:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D248A405C;
        Thu, 13 May 2021 17:32:05 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.9.250])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 13 May 2021 17:32:05 +0000 (GMT)
Date:   Thu, 13 May 2021 19:32:03 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cohuck@redhat.com, pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove
 callback
Message-ID: <20210513193203.2cc75952.pasic@linux.ibm.com>
In-Reply-To: <20210513172509.GJ1002214@nvidia.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
        <20210512124120.GV1002214@nvidia.com>
        <759f8840-671a-446c-875b-798dceb10d0f@linux.ibm.com>
        <20210513172509.GJ1002214@nvidia.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PrqHOzYAQPemNRMGquh_shyS6gzU00K3
X-Proofpoint-GUID: t0vKOAsR7gE_ClG0EydzR8iFgpdk-5hg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_10:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=973 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130118
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 May 2021 14:25:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> > I'm sorry, I don't know what a -rc branch is nor how to push this
> > to Alex's tree, but I'd be happy to do so if you tell me now:)  
> 
> If Christian takes it for 5.13-rc then that is OK

I'm pretty confident that Christian is handling this. IMHO there is
no need to bother Alex with it.

Regards,
Halil
