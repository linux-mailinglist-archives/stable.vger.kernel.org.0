Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF38052B8C5
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiERL35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 07:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiERL34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 07:29:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E101778A8;
        Wed, 18 May 2022 04:29:55 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IBOs2m016543;
        Wed, 18 May 2022 11:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=0EciM2JOStnqa7conOmfeN1U3vKQZFHvrLdmVzuLBUk=;
 b=lkrAr7oPP61U5vpzE2lSKvsJx/FVB4lPNeqjp0CexhhHGevAEH4aUhvIsBL7SFp6X8sj
 UKRgQQEPl+4+cnCXIzgIq9SrSX7DA4FKGy58SRCCuZQSWPHLZIyjPxB+BWsZ6yg9jmmS
 RDY/eUfjsLxT/ySmu/5GzSaoNveeWLmt0EgxPvE/x+L3KNILvWQVzwO5iVAqy/mVITwg
 /S7wqiW0xrCoRS2vEnzgXssapY4QwpY0uzwaIoO87I7x0HOP5XZOBQn/QGsgaJgNLEjM
 DxnvxWJiXzTbHJmYSp9Hx46UskLiD6bD90cTajYqIeI2f2W+Sp6oGhhVRLSgZhS/CypZ BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4yw6r29u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:29:40 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IBPnB8023788;
        Wed, 18 May 2022 11:29:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4yw6r28k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:29:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IB854f028911;
        Wed, 18 May 2022 11:29:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjdmg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:29:36 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IBFfBX52232570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 11:15:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27C75A404D;
        Wed, 18 May 2022 11:29:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FCAEA4040;
        Wed, 18 May 2022 11:29:32 +0000 (GMT)
Received: from osiris (unknown [9.145.54.247])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 18 May 2022 11:29:32 +0000 (GMT)
Date:   Wed, 18 May 2022 13:29:31 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Coiby Xu <coxu@redhat.com>
Cc:     kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>, Chun-Yi Lee <jlee@suse.com>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 4/4] kexec, KEYS, s390: Make use of built-in and
 secondary keyring for signature verification
Message-ID: <YoTYm6Fo1vBUuJGu@osiris>
References: <20220512070123.29486-1-coxu@redhat.com>
 <20220512070123.29486-5-coxu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512070123.29486-5-coxu@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QZ2aRxCw1ojqOWeZzANhIM2N8TBQebSk
X-Proofpoint-ORIG-GUID: IjCvJ7YuMN2ii3itPe7V6ahbqtuLjERA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_04,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=905 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 malwarescore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205180059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 03:01:23PM +0800, Coiby Xu wrote:
> From: Michal Suchanek <msuchanek@suse.de>
> 
> commit e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> adds support for KEXEC_SIG verification with keys from platform keyring
> but the built-in keys and secondary keyring are not used.
> 
> Add support for the built-in keys and secondary keyring as x86 does.
> 
> Fixes: e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> Cc: stable@vger.kernel.org
> Cc: Philipp Rudo <prudo@linux.ibm.com>
> Cc: kexec@lists.infradead.org
> Cc: keyrings@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
> Acked-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Coiby Xu <coxu@redhat.com>
> ---
>  arch/s390/kernel/machine_kexec_file.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

As far as I can tell this doesn't have any dependency to the other
patches in this series, so should I pick this up for the s390 tree, or
how will this go upstream?

In any case:
Acked-by: Heiko Carstens <hca@linux.ibm.com>
