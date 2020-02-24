Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC59E16AE09
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 18:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBXRwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 12:52:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXRw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 12:52:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHmTxJ084403;
        Mon, 24 Feb 2020 17:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qmgUgu24Yy0HVd+aU67Awpt3MrSwhtOcS9FZzwYaVTo=;
 b=LwaNxJdGyxXXuQE3FTg/B0ds5e2+ySht3hUU1tTeYjddQnlV2OX538y/Jo78chiF00tu
 En6ZvVbImyz07Hha0YGbE5vZhgI1lJwRWdvLo7aAV6kOjFYMEx+GKLQ1z8pFyRBxg4bC
 7NX8hrXdxdQv9g5DtHvLtajNAP+ODeiLTZFHjmyE7J5Jvi04q0Bck31z3rn0CsvLKS8B
 ex9MEVBrecqFw7Aog2JYZmT1sK5SOVL4cHaKa4YURMGt/twq3loRoizECcY64saqV3mu
 fGRJyYxQXAtOuhxSp1aCmLU0Dlpc6FTC2CN6Pzq3SlCvEOFtgIKbG1Ieh5Z6t9D2zEVZ Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yavxrgy4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:52:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OHm6kB030445;
        Mon, 24 Feb 2020 17:52:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yby5cyq1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 17:52:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OHqQnr013155;
        Mon, 24 Feb 2020 17:52:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 09:52:25 -0800
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] zfcp: fix wrong data and display format of SFP+ temperature
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <d6e3be5428da5c9490cfff4df7cae868bc9f1a7e.1582039501.git.bblock@linux.ibm.com>
Date:   Mon, 24 Feb 2020 12:52:22 -0500
In-Reply-To: <d6e3be5428da5c9490cfff4df7cae868bc9f1a7e.1582039501.git.bblock@linux.ibm.com>
        (Benjamin Block's message of "Wed, 19 Feb 2020 16:09:25 +0100")
Message-ID: <yq14kvfhnzd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Benjamin,

> When implementing support for retrieval of local diagnostic data from
> the FCP channel, the wrong data format was assumed for the temperature
> of the local SFP+ connector. The Fibre Channel Link Services (FC-LS-3)
> specification is not clear on the format of the stored integer, and
> only after consulting the SNIA specification SFF-8472 did we realize
> it is stored as two's complement. Thus, the used data and display
> format is wrong, and highly misleading for users when the temperature
> should drop below 0=C2=B0C (however unlikely that may be).

Applied to 5.6/scsi-fixes, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
