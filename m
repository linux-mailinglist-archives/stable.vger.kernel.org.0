Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744C464667D
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 02:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLHB04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 20:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLHB0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 20:26:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5168E5BD;
        Wed,  7 Dec 2022 17:26:48 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NuCAB007810;
        Thu, 8 Dec 2022 01:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0U7NkuOQGqCf+AbL4x1M/DsyzZ0QRdnP/o7uPmqlkzo=;
 b=YI/uuStUjg7pDRI/JxMxTP/PUa0M4JlR5qYxuLk3KlvJJwyImiUP2l+oWnxaOp4YGljd
 3WnTs/MbscctGA/JRulbS6puf5/I6e8aH2gvbkzG87Fn1q7ThdZvuCt+mBUK9kaWQd0K
 UqJqZeZ004WUCXPuy9dbE1FA3W4kxZCs3hXXO2+DhvUhiXeelnYWxZw2+KSKNZb/HGBG
 La/b0XVr3grDEXPa6Zj1XVJAQhSt/cjzJiwDxHRE0TAJ8sKck9JGpw04Sfq6nZo2l/Hj
 ybi2MjVvXCLcKWlgwzZJyUpBVwRBhG+DZcPP6Ouq+ITm1/iBRyrRnu8MjFJEPO5WjvyM 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mb4xjsw33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 01:26:30 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B818H7q031768;
        Thu, 8 Dec 2022 01:26:30 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mb4xjsw24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 01:26:30 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B80HMlV019024;
        Thu, 8 Dec 2022 01:26:28 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3m9nq8f15r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Dec 2022 01:26:28 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B81QRbg8979076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Dec 2022 01:26:27 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25C435805E;
        Thu,  8 Dec 2022 01:26:27 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A7A458043;
        Thu,  8 Dec 2022 01:26:26 +0000 (GMT)
Received: from sig-9-65-245-72.ibm.com (unknown [9.65.245.72])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Dec 2022 01:26:26 +0000 (GMT)
Message-ID: <b3d0cfa7f5391968ce332977eb602305cd57e891.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] evm: Alloc evm_digest in evm_verify_hmac() if
 CONFIG_VMAP_STACK=y
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 07 Dec 2022 20:26:26 -0500
In-Reply-To: <5813b77edf8f8c6c68da8343b7898f2a5c831077.camel@huaweicloud.com>
References: <20221201100625.916781-1-roberto.sassu@huaweicloud.com>
         <20221201100625.916781-2-roberto.sassu@huaweicloud.com>
         <Y4j4MJzizgEHf4nv@sol.localdomain>
         <c8ef0ab69635b99d5175eaf4c96bb3a8957c6210.camel@huaweicloud.com>
         <Y4pIpxbjBdajymBJ@sol.localdomain>
         <5813b77edf8f8c6c68da8343b7898f2a5c831077.camel@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fK-L_tPf8ohPEfNIebm3DP5FRfmeWGUV
X-Proofpoint-ORIG-GUID: E1Mk3SrlRiQhZqnRopE6DLUmU1RfGO4m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-12-05 at 09:22 +0100, Roberto Sassu wrote:
> On Fri, 2022-12-02 at 10:49 -0800, Eric Biggers wrote:
> > On Fri, Dec 02, 2022 at 08:58:21AM +0100, Roberto Sassu wrote:
> > > On Thu, 2022-12-01 at 10:53 -0800, Eric Biggers wrote:
> > > > On Thu, Dec 01, 2022 at 11:06:24AM +0100, Roberto Sassu wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > 
> > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > mapping") checks that both the signature and the digest reside in the
> > > > > linear mapping area.
> > > > > 
> > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > stack support"), made it possible to move the stack in the vmalloc area,
> > > > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > > > adjacent pages.
> > > > > 
> > > > > Fix this by checking if CONFIG_VMAP_STACK is enabled. If yes, allocate an
> > > > > evm_digest structure, and use that instead of the in-stack counterpart.
> > > > > 
> > > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > ---
> > > > >  security/integrity/evm/evm_main.c | 26 +++++++++++++++++++++-----
> > > > >  1 file changed, 21 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> > > > > index 23d484e05e6f..7f76d6103f2e 100644
> > > > > --- a/security/integrity/evm/evm_main.c
> > > > > +++ b/security/integrity/evm/evm_main.c
> > > > > @@ -174,6 +174,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > > > >  	struct signature_v2_hdr *hdr;
> > > > >  	enum integrity_status evm_status = INTEGRITY_PASS;
> > > > >  	struct evm_digest digest;
> > > > > +	struct evm_digest *digest_ptr = &digest;
> > > > >  	struct inode *inode;
> > > > >  	int rc, xattr_len, evm_immutable = 0;
> > > > >  
> > > > > @@ -231,14 +232,26 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > > > >  		}
> > > > >  
> > > > >  		hdr = (struct signature_v2_hdr *)xattr_data;
> > > > > -		digest.hdr.algo = hdr->hash_algo;
> > > > > +
> > > > > +		if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > > > > +			digest_ptr = kmalloc(sizeof(*digest_ptr), GFP_NOFS);
> > > > > +			if (!digest_ptr) {
> > > > > +				rc = -ENOMEM;
> > > > > +				break;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +		digest_ptr->hdr.algo = hdr->hash_algo;
> > > > > +
> > > > >  		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
> > > > > -				   xattr_value_len, xattr_data->type, &digest);
> > > > > +				   xattr_value_len, xattr_data->type,
> > > > > +				   digest_ptr);
> > > > >  		if (rc)
> > > > >  			break;
> > > > >  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
> > > > >  					(const char *)xattr_data, xattr_len,
> > > > > -					digest.digest, digest.hdr.length);
> > > > > +					digest_ptr->digest,
> > > > > +					digest_ptr->hdr.length);
> > > > >  		if (!rc) {
> > > > >  			inode = d_backing_inode(dentry);
> > > > >  
> > > > > @@ -268,8 +281,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
> > > > >  		else
> > > > >  			evm_status = INTEGRITY_FAIL;
> > > > >  	}
> > > > > -	pr_debug("digest: (%d) [%*phN]\n", digest.hdr.length, digest.hdr.length,
> > > > > -		  digest.digest);
> > > > > +	pr_debug("digest: (%d) [%*phN]\n", digest_ptr->hdr.length,
> > > > > +		 digest_ptr->hdr.length, digest_ptr->digest);
> > > > > +
> > > > > +	if (digest_ptr && digest_ptr != &digest)
> > > > > +		kfree(digest_ptr);
> > > > 
> > > > What is the actual problem here?  Where is a scatterlist being created from this
> > > > buffer?  AFAICS it never happens.
> > > 
> > > Hi Eric
> > > 
> > > it is in public_key_verify_signature(), called by asymmetric_verify()
> > > and integrity_digsig_verify().
> > > 
> > 
> > Hmm, that's several steps down the stack then.  And not something I had
> > expected.
> > 
> > Perhaps this should be fixed in public_key_verify_signature() instead?  It
> > already does a kmalloc(), so that allocation size just could be made a bit
> > larger to get space for a temporary copy of 's' and 'digest'.
> 
> Mimi asked to fix it in both IMA and EVM.

At the time I thought the problem was limited to
integrity_digsig_verify() and just to the digest.

I'll leave it up to you and Eric to decide what is the preferable
solution.

> 
> > Or at the very least, struct public_key_signature should have a *very* clear
> > comment saying that the 's' and 'digest' fields must be located in physically
> > contiguous memory...
> 
> That I could add as an additional patch.

Thanks, the new patch containing the comment looks fine.

-- 
thanks,

Mimi

