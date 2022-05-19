Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C852D1DF
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbiESL4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 07:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbiESL4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 07:56:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF2266AF5;
        Thu, 19 May 2022 04:56:50 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24J9njiB014680;
        Thu, 19 May 2022 11:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7ukxmzai3Of0C2DKPzah5+6xoHT5hdoRomBqRrlp/Yg=;
 b=PhQ7vRDp1w9gdhXqZp8KaLNKu8CUDQ4sgwM+7+27tw1fJ/N35+ENPvK/RoCw0s3SQ//i
 W8T84CWAlVoiEJPHngpb2wsCMzJGOzRUaa59j+MipsTNHEqQmxtPsjGgC2SvlUioP4H/
 94P8F/u+S0s09OG9M7c26PY2PJpGYOfRUeMjyd/ODkoRxakc4gPGIZCuoXeMpw2coiPt
 ZeqfEzLEebdIbR5fX0bvcHcZO2YUbtUbJQ28PePEMAzgzH8dVznT/CZ002iO2mQ4Td4+
 UvHdTfJVT6VQAlzB6cp/XulprAJNCe10ilIv16GSquIvqLvvRevdfEDT/HQz0KuxG8Kv +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5kkw2st2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 11:56:35 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24JBlm1O018178;
        Thu, 19 May 2022 11:56:34 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5kkw2ssb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 11:56:34 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24JBqir1021062;
        Thu, 19 May 2022 11:56:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428wv05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 11:56:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24JBgYo238273382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 11:42:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C5914203F;
        Thu, 19 May 2022 11:56:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6D3B42041;
        Thu, 19 May 2022 11:56:25 +0000 (GMT)
Received: from sig-9-65-82-167.ibm.com (unknown [9.65.82.167])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 11:56:25 +0000 (GMT)
Message-ID: <c47299b899da4ad4b6d3ad637022ad82c8ed6ed2.camel@linux.ibm.com>
Subject: Re: [PATCH v8 4/4] kexec, KEYS, s390: Make use of built-in and
 secondary keyring for signature verification
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Baoquan He <bhe@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        akpm@linux-foundation.org
Cc:     Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org,
        keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Suchanek <msuchanek@suse.de>,
        Dave Young <dyoung@redhat.com>, Will Deacon <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Chun-Yi Lee <jlee@suse.com>, stable@vger.kernel.org,
        Philipp Rudo <prudo@linux.ibm.com>,
        linux-security-module@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Date:   Thu, 19 May 2022 07:56:25 -0400
In-Reply-To: <20220519003902.GE156677@MiWiFi-R3L-srv>
References: <20220512070123.29486-1-coxu@redhat.com>
         <20220512070123.29486-5-coxu@redhat.com> <YoTYm6Fo1vBUuJGu@osiris>
         <20220519003902.GE156677@MiWiFi-R3L-srv>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pODijiS05G_BlMkECJ3lUiCw2rg3g4l4
X-Proofpoint-GUID: oUjdCxRT26f3yTIYGuFU7UbYqUR4xUcJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_03,2022-05-19_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 malwarescore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc'ing Jarkko, linux-integrity]

On Thu, 2022-05-19 at 08:39 +0800, Baoquan He wrote:
> On 05/18/22 at 01:29pm, Heiko Carstens wrote:
> > On Thu, May 12, 2022 at 03:01:23PM +0800, Coiby Xu wrote:
> > > From: Michal Suchanek <msuchanek@suse.de>
> > > 
> > > commit e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> > > adds support for KEXEC_SIG verification with keys from platform keyring
> > > but the built-in keys and secondary keyring are not used.
> > > 
> > > Add support for the built-in keys and secondary keyring as x86 does.
> > > 
> > > Fixes: e23a8020ce4e ("s390/kexec_file: Signature verification prototype")
> > > Cc: stable@vger.kernel.org
> > > Cc: Philipp Rudo <prudo@linux.ibm.com>
> > > Cc: kexec@lists.infradead.org
> > > Cc: keyrings@vger.kernel.org
> > > Cc: linux-security-module@vger.kernel.org
> > > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > > Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>
> > > Acked-by: Baoquan He <bhe@redhat.com>
> > > Signed-off-by: Coiby Xu <coxu@redhat.com>
> > > ---
> > >  arch/s390/kernel/machine_kexec_file.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > 
> > As far as I can tell this doesn't have any dependency to the other
> > patches in this series, so should I pick this up for the s390 tree, or
> > how will this go upstream?
> 
> Thanks, Heiko.
> 
> I want to ask Mimi if this can be taken into KEYS-ENCRYPTED tree.
> Otherwise I will ask Andrew to help pick this whole series.
> 
> Surely, this patch 4 can be taken into s390 seperately since it's
> independent, both looks good.

KEYS-ENCRYTPED is a type of key, unrelated to using the .platform,
.builtin, .machine, or .secondary keyrings.  One of the main reasons
for this patch set is to use the new ".machine" keyring, which, if
enabled, is linked to the "secondary" keyring.  However, the only
reference to the ".machine" keyring is in the cover letter, not any of
the patch descriptions.  Since this is the basis for the system's
integrity, this seems like a pretty big omission.

From patch 2/4:
"The code in bzImage64_verify_sig makes use of system keyrings
including
.buitin_trusted_keys, .secondary_trusted_keys and .platform keyring to
verify signed kernel image as PE file..."

From patch 3/4:
"This patch allows to verify arm64 kernel image signature using not
only
.builtin_trusted_keys but also .platform and .secondary_trusted_keys
keyring."

From patch 4/4:
"... with keys from platform keyring but the built-in keys and
secondary keyring are not used."

This patch set could probably go through KEYS/KEYRINGS_INTEGRITY, but
it's kind of late to be asking.  Has it been in linux-next?  Should I
assume this patch set has been fully tested or can we get some "tags"?

thanks,

Mimi

