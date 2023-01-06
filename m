Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C51E65F891
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 02:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbjAFBGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 20:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbjAFBGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 20:06:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A856E404;
        Thu,  5 Jan 2023 17:06:07 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30615LES025582;
        Fri, 6 Jan 2023 01:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=h3R+ncZtwTwM04Y652MAPleCpx6WeYs0XK5yDgNWu4k=;
 b=NrTYQumvjvkZ60eixvR7THlaP76SXXmUybLYhC4yjONEqY+mwkIge/Rl37mV8CEJLOI9
 ns33uJhI9dKhOP/xT3A+g7Mg+mTpmX986U2SZICqcNQWA5iHOlqTk4FCsnc+jB8bSLcX
 8yB6niUIGqH9JnD7G/8n0XJ8Og4kUOY1zw40aBYYozH8hDu4DMX2MYfvdwqfAIPlBmL+
 OCKoFRuI3mH5kBSw0rFX3UVyO2z8w1HbMc7IUPXakxTX6vTnj2FH0Sqp3gYQ7BY6HYg0
 WL3753cV6qXrXvhG9fwk++66bNPrg+gNqBqBa6xaEfYidipBNVk1SKpIg7t4DEJe40VT dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx9p0g0e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 01:05:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30615Ypn025982;
        Fri, 6 Jan 2023 01:05:51 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx9p0g0dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 01:05:51 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305MYJ63019814;
        Fri, 6 Jan 2023 01:05:50 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3mtcq80wue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 01:05:50 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30615mmb59834644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 01:05:49 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C90A35805E;
        Fri,  6 Jan 2023 01:05:48 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C333B58058;
        Fri,  6 Jan 2023 01:05:47 +0000 (GMT)
Received: from sig-9-65-221-162.ibm.com (unknown [9.65.221.162])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  6 Jan 2023 01:05:47 +0000 (GMT)
Message-ID: <1b89bdf8c57b3381d15d60a1d20a86277355ed0b.camel@linux.ibm.com>
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Paul Moore <paul@paul-moore.com>,
        "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     dmitry.kasatkin@gmail.com, sds@tycho.nsa.gov,
        eparis@parisplace.org, Greg KH <gregkh@linuxfoundation.org>,
        sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Thu, 05 Jan 2023 20:05:47 -0500
In-Reply-To: <CAHC9VhT0SRWMi2gQKaBPOj1owqUh-24O9L2DyOZ8JDgEr+ZQiQ@mail.gmail.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
         <efd4ce83299a10b02b1c04cc94934b8d51969e1c.camel@linux.ibm.com>
         <6a5bc829-b788-5742-cbfc-dba348065dbe@huawei.com>
         <566721e9e8d639c82d841edef4d11d30a4d29694.camel@linux.ibm.com>
         <fffb29b7-a1ac-33fb-6aca-989e5567f565@huawei.com>
         <40cf70a96d2adbff1c0646d3372f131413989854.camel@linux.ibm.com>
         <a63d5d4b-d7a9-fdcb-2b90-b5e2a974ca4c@huawei.com>
         <757bc525f7d3fe6db5f3ee1f86de2f4d02d8286b.camel@linux.ibm.com>
         <CAHC9VhR2mfaVjXz3sBzbkBamt8nE-9aV+jSOs9jH1ESnKvDrvw@mail.gmail.com>
         <fc11076f-1760-edf3-c0e4-8f58d5e0335c@huawei.com>
         <CAHC9VhT0SRWMi2gQKaBPOj1owqUh-24O9L2DyOZ8JDgEr+ZQiQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rAZ72JXT0Q7Ew0yU5iDhbEv3-PtwyesX
X-Proofpoint-ORIG-GUID: vr6mObpDFcGOA2fgGeNzPR9fBGy9MDIM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_14,2023-01-05_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301060006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-12-15 at 22:04 -0500, Paul Moore wrote:
> On Thu, Dec 15, 2022 at 9:36 PM Guozihua (Scott) <guozihua@huawei.com> wrote:
> > On 2022/12/16 5:04, Paul Moore wrote:
> 
> ...
> 
> > > How bad is the backport really?  Perhaps it is worth doing it to see
> > > what it looks like?
> > >
> > It might not be that bad, I'll try to post a version next Monday.
> 
> Thanks for giving it a shot.

FYI, in the end backporting the atomic to blocking LSM notifier change
was the best solution.  Other than one minor correction, v6 of the
"ima: Fix IMA mishandling of LSM based rule during" looks good.

-- 
thanks,

Mimi

