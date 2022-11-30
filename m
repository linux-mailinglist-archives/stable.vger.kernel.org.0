Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB163DA70
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiK3QWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiK3QWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:22:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4571164;
        Wed, 30 Nov 2022 08:22:44 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUGIDfN009415;
        Wed, 30 Nov 2022 16:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=M9kl26gvtN7uulzSB4h/nfRY7TTyRluub0wjlj/BbsU=;
 b=Tp1U8kFdDUJDhnHRP8yLlsR8oqvXplR1T6vr6sWaHz+OBZdQPLEnpe1TFckdR0eMbLPi
 C9S/brPSxIA236hjHW8gnet4v0HQrw8/+HSu3hD0gZh/GaXCz5pftenSU0kjVkiy9Vo8
 CO0ug8pDIfmee9Z9ccnzRDsNwNWz19wVugpM6UukzBEk1flXvv/5rY7D47qFoVclIPyt
 vImvH4AuL1hevNANsM9OJlTsW206hI1j9FUyePIui0PysIcxrt7sgeX4ivxaYikrdEqU
 v+Uk/kV31F+cCpf3pAalIOQXDwJGM/CCyS/eUJ9+EDYiWXljhoneM1rxv6Fyn2MOcqPk 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6ajpg25r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 16:22:09 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUGM4tT020654;
        Wed, 30 Nov 2022 16:22:08 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6ajpg254-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 16:22:08 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUGK339017131;
        Wed, 30 Nov 2022 16:22:07 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3m3ae9v5cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 16:22:07 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUGM62H39715330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 16:22:06 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB5E5805C;
        Wed, 30 Nov 2022 16:22:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F69A58064;
        Wed, 30 Nov 2022 16:22:04 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.97.169])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 16:22:04 +0000 (GMT)
Message-ID: <1658d421c391d0609680b89ca0573fab1ca5e091.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, rusty@rustcorp.com.au, axboe@kernel.dk
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 30 Nov 2022 11:22:04 -0500
In-Reply-To: <859f70a2801cffa3cb42ae0d43f5753bb01a7eac.camel@huaweicloud.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
         <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
         <a676b387d23f9ca630418ece20a6761a9437ce76.camel@huaweicloud.com>
         <c6c448c2acc07caf840046067322f3e1110cedff.camel@linux.ibm.com>
         <f8f95d37211bac6ce4322a715740d2b2ae20db84.camel@huaweicloud.com>
         <859f70a2801cffa3cb42ae0d43f5753bb01a7eac.camel@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OqhFVe-j-U0vdgOfmrDyL1wwXNtoPUwi
X-Proofpoint-ORIG-GUID: XTM1SkfjvDUgqGc-GopQssW0Z8n1qyFC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211300112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-11-30 at 15:41 +0100, Roberto Sassu wrote:
> On Wed, 2022-11-23 at 14:49 +0100, Roberto Sassu wrote:
> > On Wed, 2022-11-23 at 08:40 -0500, Mimi Zohar wrote:
> > > On Wed, 2022-11-23 at 13:56 +0100, Roberto Sassu wrote:
> > > > On Tue, 2022-11-22 at 14:39 -0500, Mimi Zohar wrote:
> > > > > Hi Roberto,
> > > > > 
> > > > > On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> > > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > 
> > > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > > mapping") requires that both the signature and the digest resides in the
> > > > > > linear mapping area.
> > > > > > 
> > > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > > stack support"), made it possible to move the stack in the vmalloc area,
> > > > > > which could make the requirement of the first commit not satisfied anymore.
> > > > > > 
> > > > > > If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:
> > > > > 
> > > > > ^CONFIG_DEBUG_SG
> > > > > 
> > > > > > [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> > > > > > [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > [  467.095225] Call Trace:
> > > > > > [  467.096088]  <TASK>
> > > > > > [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> > > > > > [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> > > > > > [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> > > > > > [  467.098647]  ? public_key_verify_signature+0x470/0x470
> > > > > > [  467.099237]  asymmetric_verify+0x14c/0x300
> > > > > > [  467.099869]  evm_verify_hmac+0x245/0x360
> > > > > > [  467.100391]  evm_inode_setattr+0x43/0x190
> > > > > > 
> > > > > > The failure happens only for the digest, as the pointer comes from the
> > > > > > stack, and not for the signature, which instead was allocated by
> > > > > > vfs_getxattr_alloc().
> > > > > 
> > > > > Only after enabling CONFIG_DEBUG_SG does EVM fail.
> > > > > 
> > > > > > Fix this by making a copy of both in asymmetric_verify(), so that the
> > > > > > linear mapping requirement is always satisfied, regardless of the caller.
> > > > > 
> > > > > As only EVM is affected, it would make more sense to limit the change
> > > > > to EVM.
> > > > 
> > > > I found another occurrence:
> > > > 
> > > > static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> > > > 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
> > > > 			enum integrity_status *status, const char **cause)
> > > > {
> > > > 
> > > > [...]
> > > > 
> > > > 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> > > > 					     (const char *)xattr_value,
> > > > 					     xattr_len, hash.digest,
> > > > 					     hash.hdr.length);
> > > > 
> > > > Should I do two patches?
> > > 
> > > I'm just not getting it.  Why did you enable CONFIG_DEBUG_SIG?  Were
> > > you testing random kernel configs?  Are you actually seeing signature
> > > verifications errors without it enabled?  Or is it causing other
> > > problems?  Is the "BUG_ON" still needed?
> > 
> > When I test patches, I tend to enable more debugging options.
> > 
> > To be honest, I didn't check if there is any issue without enabling
> > CONFIG_DEBUG_SG. I thought that if there is a linear mapping
> > requirement, that should be satisfied regardless of whether the
> > debugging option is enabled or not.
> > 
> > + Rusty, Jens for explanations.
> 
> Trying to answer the question, with the help of an old discussion:
> 
> https://groups.google.com/g/linux.kernel/c/dpIoiY_qSGc
> 
> sg_set_buf() calls virt_to_page() to get the page to start from. But if
> the buffer spans in two pages, that would not work in the vmalloc area,
> since there is no guarantee that the next page is adjiacent.
> 
> For small areas, much smaller than the page size, it is unlikely that
> the situation above would happen. So, integrity_digsig_verify() will
> likely succeeed. Although it is possible that it fails if there are
> data in the next page.

Thanks, Roberto.  Confirmed that as the patch description indicates,
without CONFIG_VMAP_STACK configured and with CONFIG_DEBUG_SG enabled
there isn't a bug.  Does it make sense to limit this change to just
CONFIG_VMAP_STACK?

-- 
thanks,

Mimi

