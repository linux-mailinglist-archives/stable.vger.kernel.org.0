Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCF4221711
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgGOVd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 17:33:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGOVd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 17:33:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FLXDYE060310;
        Wed, 15 Jul 2020 21:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6i7a/+Ftd2K970NxwLayuhRouIazIIIQDDJat+whMFw=;
 b=qCP6k6b2urUJzM8nWGTncHRnyyhNQjJ+3oK/tIG08Wg51I1dsW4Z9S1VBwYOTRN+Txri
 YwtvswTAk1QSMuGX1Zp1jgOzeaJEYdHCEiniFN5HEQGZWZaHyPSYAOiTV1ZrsFII1Sf/
 lD383z+II+mnmn93OFAdWZ/nI0rJM1OLSV5sSFNYy3OR9HxEAatj1VaCcCHMmN5FqTgA
 j4O420kqdLKIjL4HYutIx+MsdMAh8uAaKuN2L/93PFaJaFQRGENdO8dOLGEyna9TAb2S
 3IHa5ayoC4yaDTnG3igutk2RbXbKTxUQw5St4J623Y55jEJY8HaRsDdvKQwSuqEk2i5Q oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cmdw9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 21:33:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FLXsS1090662;
        Wed, 15 Jul 2020 21:33:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb8x2ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 21:33:56 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FLXs7j016123;
        Wed, 15 Jul 2020 21:33:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 14:33:54 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sasikumar.pc@broadcom.com, anand.lodnoor@broadcom.com,
        "# v5 . 3+" <stable@vger.kernel.org>, sankar.patra@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com,
        kashyap.desai@broadcom.com
Subject: Re: [PATCH] megaraid_sas: remove undefined ENABLE_IRQ_POLL macro
Date:   Wed, 15 Jul 2020 17:33:52 -0400
Message-Id: <159484881799.21031.14072399069865189813.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715120153.20512-1-chandrakanth.patil@broadcom.com>
References: <20200715120153.20512-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=851 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=867 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Jul 2020 17:31:53 +0530, Chandrakanth Patil wrote:

> Issue:
> As ENABLE_IRQ_POLL macro is undefined, the check for ENABLE_IRQ_POLL
> macro in ISR will always be false leads to irq polling non-functional.
> 
> Fix:
> Remove ENABLE_IRQ_POLL check from isr

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Remove undefined ENABLE_IRQ_POLL macro
      https://git.kernel.org/mkp/scsi/c/07d3f0455002

-- 
Martin K. Petersen	Oracle Linux Engineering
