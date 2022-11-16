Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CDB62CC31
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 22:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbiKPVGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 16:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiKPVFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 16:05:31 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3139B45A02;
        Wed, 16 Nov 2022 13:04:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AGKLQi0037116;
        Wed, 16 Nov 2022 21:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Hm6PNSbhq9LhjwmrseFl2/g4hvgBcTxn6rmb+SYDL5c=;
 b=bNf/hxDYWOMp2O92YGnU7xVy3OwLgzGKpoVrHxy71bXWxTVCuL3T4OjnGMiRmoNWY5jc
 4neXymNU7N3SWSRlsGuvGqlLNTBzshBiwOpW/ti3Yeao0Y5IqkCjTqkJXa41qNSOpBs0
 rFMtoeJgl7zqed+Ygvs9Z+93uf39ebgpUeCkvgGVQQg35HV7qvK2yRg8JHyOrk2joV2c
 iPliU5nmIm9OCIWNTJpJOAu/vR436Y4qwsCFhDhGcoPRXohNoRqje2nfof3tHjpvWPPD
 BTFQK24dmOHGygvTHBtfoETW2mlXR3yu9EBiJKpZR7UygS4xSvq9nGhybFtp0XqV6elX WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kw6u08xt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 21:03:51 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AGKT2Xv025076;
        Wed, 16 Nov 2022 21:03:50 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kw6u08xsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 21:03:50 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AGKpQCr014409;
        Wed, 16 Nov 2022 21:03:49 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3kt34a43pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 21:03:49 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AGL3mdB7143996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Nov 2022 21:03:48 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 327935805E;
        Wed, 16 Nov 2022 21:03:48 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 182395805D;
        Wed, 16 Nov 2022 21:03:46 +0000 (GMT)
Received: from sig-9-77-134-48.ibm.com (unknown [9.77.134.48])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 16 Nov 2022 21:03:45 +0000 (GMT)
Message-ID: <e46fb092970bd12a8461a513f1cf8b63e4f54714.camel@linux.ibm.com>
Subject: Re: [PATCH v4 1/5] reiserfs: Add missing calls to
 reiserfs_security_free()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, casey@schaufler-ca.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, nicolas.bouchinet@clip-os.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Wed, 16 Nov 2022 16:03:45 -0500
In-Reply-To: <20221110094639.3086409-2-roberto.sassu@huaweicloud.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
         <20221110094639.3086409-2-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4WI5dW9j1NtENgHLvVqyis6bif4IMoub
X-Proofpoint-ORIG-GUID: oHtKRpgB1VOFGdykFp3diWuPuAl-uBcg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 spamscore=0 priorityscore=1501 mlxlogscore=316
 suspectscore=0 clxscore=1011 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-11-10 at 10:46 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
> during inode creation") defined reiserfs_security_free() to free the name
> and value of a security xattr allocated by the active LSM through
> security_old_inode_init_security(). However, this function is not called
> in the reiserfs code.
> 
> Thus, add a call to reiserfs_security_free() whenever
> reiserfs_security_init() is called, and initialize value to NULL, to avoid
> to call kfree() on an uninitialized pointer.
> 
> Finally, remove the kfree() for the xattr name, as it is not allocated
> anymore.
> 
> Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
> Cc: stable@vger.kernel.org
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: Mimi Zohar <zohar@linux.ibm.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

