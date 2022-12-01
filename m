Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FB163F7E9
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 20:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiLATJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 14:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiLATJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 14:09:30 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC23C23FB;
        Thu,  1 Dec 2022 11:09:29 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1IniCb016930;
        Thu, 1 Dec 2022 19:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=4uw+CPCRVemdMEHUsrEWI16bTHWIR3y+meuRPmGVEXM=;
 b=iHBh2x43WY1hV8toN79ddPg0L+XlgzW4kFgvWiPcnGmSmBXH3Ymxr3YS+2t+IHMbmiap
 SlPoASeB/lMf2oVeXBmmbljztRE7bYGw3HuQUi9zjkhC1dIVjieFgYSAFcZzvJ7jtufs
 lP5MBsTockLzbDbPQ/cmnK5WxNRuCwYXppPMJZEpJkoHashkAHprzQRjJIJFO/mBHdgW
 wv08+31hdP7VzWC/GYLFIlrTZBCb8PbjyaTq5Ol8sRojiiIydOnUWf/dFzGb6mp1aUoz
 9JSOviUtOaDTZarq+GCbn7KW1N1aMd9Eb8xzd5jzEUK/FwECj5PPWZbbHG3YZPbwcHJD 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m71vy8dpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 19:09:02 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1IsNbN032282;
        Thu, 1 Dec 2022 19:09:01 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m71vy8dpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 19:09:01 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1J66XM007115;
        Thu, 1 Dec 2022 19:09:00 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02dal.us.ibm.com with ESMTP id 3m3aea5vyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 19:09:00 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1J8x2232637276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 19:08:59 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBA45803F;
        Thu,  1 Dec 2022 19:08:59 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B87865805A;
        Thu,  1 Dec 2022 19:08:58 +0000 (GMT)
Received: from sig-9-77-152-136.ibm.com (unknown [9.77.152.136])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 19:08:58 +0000 (GMT)
Message-ID: <66d9f3dbfddc5d73e73fa0c6152d70ff1739427a.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] evm: Alloc evm_digest in evm_verify_hmac() if
 CONFIG_VMAP_STACK=y
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Thu, 01 Dec 2022 14:08:58 -0500
In-Reply-To: <Y4j4MJzizgEHf4nv@sol.localdomain>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
         <20221201100625.916781-2-roberto.sassu@huaweicloud.com>
         <Y4j4MJzizgEHf4nv@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jdNx7N97xn_u8jqVnC_7__uTCrd7I81J
X-Proofpoint-ORIG-GUID: aDnjaeoreon_8zq-GzNuPhmJ8ePUeZuE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_13,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212010141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-12-01 at 10:53 -0800, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 11:06:24AM +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > mapping") checks that both the signature and the digest reside in the
> > linear mapping area.
> > 
> > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > stack support"), made it possible to move the stack in the vmalloc area,
> > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > adjacent pages.
> > 
> > Fix this by checking if CONFIG_VMAP_STACK is enabled. If yes, allocate an
> > evm_digest structure, and use that instead of the in-stack cbounterpart.
> > 
> > Cc: stable@vger.kernel.org # 4.9.x
> > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > ---
> >  security/integrity/evm/evm_main.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > index 23d484e05e6f..7f76d6103f2e 100644
> > --- a/security/integrity/evm/evm_main.c
> > +++ b/security/integrity/evm/evm_main.c
> > @@ -174,6 +174,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  	struct signature_v2_hdr *hdr;
> >  	enum integrity_status evm_status = INTEGRITY_PASS;
> >  	struct evm_digest digest;
> > +	struct evm_digest *digest_ptr = &digest;
> >  	struct inode *inode;
> >  	int rc, xattr_len, evm_immutable = 0;
> >  
> > @@ -231,14 +232,26 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  		}
> >  
> >  		hdr = (struct signature_v2_hdr *)xattr_data;
> > -		digest.hdr.algo = hdr->hash_algo;
> > +
> > +		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > +			digest_ptr = kmalloc(sizeof(*digest_ptr), GFP_NOFS);
> > +			if (!digest_ptr) {
> > +				rc = -ENOMEM;
> > +				break;
> > +			}
> > +		}
> > +
> > +		digest_ptr->hdr.algo = hdr->hash_algo;
> > +
> >  		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
> > -				   xattr_value_len, xattr_data->type, &digest);
> > +				   xattr_value_len, xattr_data->type,
> > +				   digest_ptr);
> >  		if (rc)
> >  			break;
> >  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
> >  					(const char *)xattr_data, xattr_len,
> > -					digest.digest, digest.hdr.length);
> > +					digest_ptr->digest,
> > +					digest_ptr->hdr.length);
> >  		if (!rc) {
> >  			inode = d_backing_inode(dentry);
> >  
> > @@ -268,8 +281,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> >  		else
> >  			evm_status = INTEGRITY_FAIL;
> >  	}
> > -	pr_debug("digest: (%d) [%*phN]\n", digest.hdr.length, digest.hdr.length,
> > -		  digest.digest);
> > +	pr_debug("digest: (%d) [%*phN]\n", digest_ptr->hdr.length,
> > +		 digest_ptr->hdr.length, digest_ptr->digest);
> > +
> > +	if (digest_ptr && digest_ptr != &digest)
> > +		kfree(digest_ptr);
> 
> What is the actual problem here?  Where is a scatterlist being created from this
> buffer?  AFAICS it never happens.

Enabling CONFIG_VMAP_STACK is the culprit, which triggers the BUG_ON
only when CONFIG_DEBUG_SG is enabled as well.

Refer to commit ba14a194a434 ("fork: Add generic vmalloced stack
support").

-- 
thanks,

Mimi


