Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EE06344B9
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 20:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiKVTjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 14:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiKVTjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 14:39:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2A56F361;
        Tue, 22 Nov 2022 11:39:33 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMJK7WV017593;
        Tue, 22 Nov 2022 19:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=fqhpTDfxPyVsir4ev5LuPPWGRFEF13TzcH6YSeaIS1w=;
 b=G8jWBqLWFXqTpQG4r8K6SdMRQ4noTGA6bfNY+J6/goD0528M16WU1j6TlPKJkKmyT92n
 /6c56pqCLyVysAoIQRp/H4T700K2I+ku8ugUPdm2uKyKwTWN8fdGAYQuzt205sX+cec6
 vZp+XSAI9rU+z+ikPrdt92pyAeVBud/+FCVkhPH/jRISrFlFxLiG5/NGnv9UnkfwKicw
 4qA9X5ljUADUqDk+Bt4zpJbNsHZz4H+PgUQ0AjdlAPko0NisSaELQ5rVW2fq3pVDscGU
 OhGoxB4w0l7yvWJWl2pQrp70mAbRAT2PRxzgX8kb984NeEPpZx0sAlGwOFED9mI2HkfG PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0xw7jkej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 19:39:17 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AMIKP8C015701;
        Tue, 22 Nov 2022 19:39:17 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0xw7jkeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 19:39:17 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AMJZgYa022314;
        Tue, 22 Nov 2022 19:39:16 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3kxpsabj2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 19:39:16 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AMJdF4q5702386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 19:39:15 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E121058068;
        Tue, 22 Nov 2022 19:39:14 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B36E5805C;
        Tue, 22 Nov 2022 19:39:13 +0000 (GMT)
Received: from sig-9-65-239-173.ibm.com (unknown [9.65.239.173])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 19:39:13 +0000 (GMT)
Message-ID: <9ef25f1b8621dab8b3cd4373bf6ce1633daae70e.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Make a copy of sig and digest in
 asymmetric_verify()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Tue, 22 Nov 2022 14:39:12 -0500
In-Reply-To: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
References: <20221104122023.1750333-1-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MbnRLYy7-EevjB-8VMKuWNDJgxCXgM9n
X-Proofpoint-ORIG-GUID: If9WOnpDCGHW3lfXstBPeOmVhSCG9zlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220152
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Fri, 2022-11-04 at 13:20 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> mapping") requires that both the signature and the digest resides in the
> linear mapping area.
> 
> However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> stack support"), made it possible to move the stack in the vmalloc area,
> which could make the requirement of the first commit not satisfied anymore.
> 
> If CONFIG_SG=y and CONFIG_VMAP_STACK=y, the following BUG() is triggered:

^CONFIG_DEBUG_SG

> 
> [  467.077359] kernel BUG at include/linux/scatterlist.h:163!
> [  467.077939] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> 
> [...]
> 
> [  467.095225] Call Trace:
> [  467.096088]  <TASK>
> [  467.096928]  ? rcu_read_lock_held_common+0xe/0x50
> [  467.097569]  ? rcu_read_lock_sched_held+0x13/0x70
> [  467.098123]  ? trace_hardirqs_on+0x2c/0xd0
> [  467.098647]  ? public_key_verify_signature+0x470/0x470
> [  467.099237]  asymmetric_verify+0x14c/0x300
> [  467.099869]  evm_verify_hmac+0x245/0x360
> [  467.100391]  evm_inode_setattr+0x43/0x190
> 
> The failure happens only for the digest, as the pointer comes from the
> stack, and not for the signature, which instead was allocated by
> vfs_getxattr_alloc().

Only after enabling CONFIG_DEBUG_SG does EVM fail.

> 
> Fix this by making a copy of both in asymmetric_verify(), so that the
> linear mapping requirement is always satisfied, regardless of the caller.

As only EVM is affected, it would make more sense to limit the change
to EVM.

-- 
thanks,

Mimi

