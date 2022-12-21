Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4476536AB
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLUSwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiLUSwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:52:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19955D4;
        Wed, 21 Dec 2022 10:52:30 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLIfboR016729;
        Wed, 21 Dec 2022 18:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=OrHHXKFP368Fu0c2joQznANZOK7KuX2EnNR7sqFdqbo=;
 b=RnBtCZxMv/m+fsrkfmbBBOFh4GebrrBcNR0W99Rqxp3wLiYVtl82WZ//xK5jzDtFka3S
 qDsdXjR4EwUUiKHkI3VYPbVp/vISGRlwJyHfZOd5OmWkQR++gB78xOZvVf7MeHolzHS6
 ZlEnEElkM06aU8DIXNwcxJ74E+EjtE+dwD//RtzeyQvWZc6bsntyxc1iz/uHTn0f2oqT
 sqhUx6Xwf9jritZI/gQnuxUNC+GeCFEo0eGB7wjUliPevAMSvjdZq7w5LS00HQcNp94n
 TaQ7LrdV51m1cMqaw4FBL4mL6mbUAK1Pj4ewEYokgd84jlLdaBmZOhdv6RBerzONsKx9 og== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mm7n606hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 18:52:23 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLIaH10027541;
        Wed, 21 Dec 2022 18:52:22 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mh6yv4420-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 18:52:22 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BLIqKOs53281164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 18:52:20 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 361565805E;
        Wed, 21 Dec 2022 18:52:20 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C286858052;
        Wed, 21 Dec 2022 18:52:19 +0000 (GMT)
Received: from sig-9-65-212-99.ibm.com (unknown [9.65.212.99])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Dec 2022 18:52:19 +0000 (GMT)
Message-ID: <8cff4354dcd583d92da19aa2c52999f70b3decca.camel@linux.ibm.com>
Subject: Re: Stable backport request
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "Guozihua (Scott)" <guozihua@huawei.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Date:   Wed, 21 Dec 2022 13:52:09 -0500
In-Reply-To: <Y6NPAr7mFTZ9hhCZ@kroah.com>
References: <c946a51ca8b059d1526af1078473e62c58edc357.camel@linux.ibm.com>
         <Y6NPAr7mFTZ9hhCZ@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NwaErEvRK8zXkzagw-JgjbcF1xTen1Gk
X-Proofpoint-ORIG-GUID: NwaErEvRK8zXkzagw-JgjbcF1xTen1Gk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_11,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210157
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, 2022-12-21 at 19:22 +0100, Greg KH wrote:
> On Wed, Dec 21, 2022 at 09:50:09AM -0500, Mimi Zohar wrote:
> > Stable team,
> > 
> > Please backport these upstream commits to stable kernels:
> > - c7423dbdbc9e ("ima: Handle -ESTALE returned by
> > ima_filter_rule_match()"
> > 
> > Dependency on:
> > - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
> > 
> > Known minor merge conflicts:
> > - Commit: 65603435599f ("ima: Fix trivial typos in the comments") fixed
> > "refrences" spelling, causes a merge conflict.
> > - Commit 28073eb09c5a ("ima: Fix fall-through warnings for Clang") adds
> > a "break;" before "default:", causes a merge conflict.

Up to linux-5.9.y, there are two merge conflicts - a spelling error and
a missing "break" before "default:", which are the result of the above
commits.  Otherwise the two commits apply cleanly:
 - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
 - c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()"

> > Simplifies backporting to linux-5.4.y:
> > - 465aee77aae8 ("ima: Free the entire rule when deleting a list of
> > rules")
> >   except for the line "kfree(entry->keyrings);" - introduced in 5.6.y.
> > - 39e5993d0d45 ("ima: Shallow copy the args_p member of
> > ima_rule_entry.lsm elements")
> > - b8867eedcf76 ("ima: Rename internal filter rule functions")
> > - f60c826d0318 ("ima: Use kmemdup rather than kmalloc+memcpy")
> 
> I'm sorry, but I'm confused.
> 
> What exact commits are needed in what order for which stable trees?

The above 4 commits are needed, in the order listed, for linux-5.4.y
before applying these two commits:
 - d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")
 - c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()"

> > A patch for kernels prior to commit b16942455193 ("ima: use the lsm
> > policy update notifier") will be posted separately.
> 
> But that commit has been backported to 4.19.y and newer stable trees,
> right?

No, b16942455193 ("ima: use the lsm policy update notifier") was
upstreamed in linux-5.3.y and has not been backported to linux-4.19.y. 
We're still determining for linux-4.19.y the best way to address the
bug that commit c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()") addresses.

> 
> confused,

I hope this clarifies things...

-- 
thanks,

Mimi

