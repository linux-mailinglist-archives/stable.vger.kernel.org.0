Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD90F1F19BA
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgFHNQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:16:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728955AbgFHNQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 09:16:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 058D31Mh024598;
        Mon, 8 Jun 2020 09:15:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g77q4s53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 09:15:04 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 058D3hrN029505;
        Mon, 8 Jun 2020 09:15:04 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g77q4s3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 09:15:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 058DAG8R011919;
        Mon, 8 Jun 2020 13:15:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 31g2s81mc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 13:15:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 058DExbF59834450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 13:14:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B033B11C04C;
        Mon,  8 Jun 2020 13:14:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1D6511C04A;
        Mon,  8 Jun 2020 13:14:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.178.150])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 13:14:58 +0000 (GMT)
Message-ID: <1591622098.4638.67.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Remove __init annotation from ima_pcrread()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        torvalds@linux-foundation.org
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        "Bruno E. O. Meneguele" <bmeneg@redhat.com>
Date:   Mon, 08 Jun 2020 09:14:58 -0400
In-Reply-To: <20200607210029.30601-1-roberto.sassu@huawei.com>
References: <20200607210029.30601-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_12:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxscore=0 adultscore=0 clxscore=1015
 cotscore=-2147483648 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=984 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080097
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Sun, 2020-06-07 at 23:00 +0200, Roberto Sassu wrote:
> Commit 6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in
> ima_eventdigest_init()") added a call to ima_calc_boot_aggregate() so that
> the digest can be recalculated for the boot_aggregate measurement entry if
> the 'd' template field has been requested. For the 'd' field, only SHA1 and
> MD5 digests are accepted.
> 
> Given that ima_eventdigest_init() does not have the __init annotation, all
> functions called should not have it. This patch removes __init from
> ima_pcrread().
> 
> Cc: stable@vger.kernel.org
> Fixes:  6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()")
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thank you for fixing this so quickly!  Jerry, Bruno, thank you for the
Reviews.  This patch is in Linus' tree as: 8b8c704d913b ("ima: Remove
__init annotation from ima_pcrread()".

Mimi
