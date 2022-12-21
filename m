Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E726532AC
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 15:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiLUOud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 09:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiLUOu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 09:50:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C61523BD0;
        Wed, 21 Dec 2022 06:50:28 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLEh5K7027729;
        Wed, 21 Dec 2022 14:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : content-type : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vw003GsQEmfzDs0RM0b6cXPgeY6dEyRVpRQn6K2HK5w=;
 b=f5oN/eMU5lnUvK5iLTOUWFKWjgPUeAGqo7T8mC3gJB3P6kUPanzdu5iPKkna3thlvntQ
 mujttboLadBFG4iZQUdAkiC8fXr76ceGXG5/OzJYgBap4oXYntL8MyOEE7N8HHNspSC3
 AnMKaoJiUfwKIpdwHfyHmLZdnCplKOZdM+GfUORZwPAWENntlKbZ9aIgFu7TDDBUoUYl
 ebp/SR5ejywsTBh5exeBBrlOeimVWf6Xt+BtOMX2gmaxaWIwgqwDlFWL8Aq3SGWqgy5K
 XPcsEEfM+u0Kx1uMCDrLKuHI8XldPuD9yI7VP2983AwX2gEpgk3LcHjyRRFE8QKxt+ps Pg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mm45a09wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 14:50:12 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLDMclC010167;
        Wed, 21 Dec 2022 14:50:11 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yv3qay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Dec 2022 14:50:11 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BLEoAiB39715268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 14:50:10 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E5935805A;
        Wed, 21 Dec 2022 14:50:10 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EDA558060;
        Wed, 21 Dec 2022 14:50:09 +0000 (GMT)
Received: from sig-9-65-212-99.ibm.com (unknown [9.65.212.99])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Dec 2022 14:50:09 +0000 (GMT)
Message-ID: <c946a51ca8b059d1526af1078473e62c58edc357.camel@linux.ibm.com>
Subject: Stable backport request
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        "Guozihua (Scott)" <guozihua@huawei.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>
Date:   Wed, 21 Dec 2022 09:50:09 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fSDgYpVMDgLffpKlFPnjqQMkHzxWNxT8
X-Proofpoint-ORIG-GUID: fSDgYpVMDgLffpKlFPnjqQMkHzxWNxT8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_07,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 clxscore=1011
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212210120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable team,

Please backport these upstream commits to stable kernels:
- c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()"

Dependency on:
- d57378d3aa4d ("ima: Simplify ima_lsm_copy_rule")

Known minor merge conflicts:
- Commit: 65603435599f ("ima: Fix trivial typos in the comments") fixed
"refrences" spelling, causes a merge conflict.
- Commit 28073eb09c5a ("ima: Fix fall-through warnings for Clang") adds
a "break;" before "default:", causes a merge conflict.

Simplifies backporting to linux-5.4.y:
- 465aee77aae8 ("ima: Free the entire rule when deleting a list of
rules")
  except for the line "kfree(entry->keyrings);" - introduced in 5.6.y.
- 39e5993d0d45 ("ima: Shallow copy the args_p member of
ima_rule_entry.lsm elements")
- b8867eedcf76 ("ima: Rename internal filter rule functions")
- f60c826d0318 ("ima: Use kmemdup rather than kmalloc+memcpy")

A patch for kernels prior to commit b16942455193 ("ima: use the lsm
policy
update notifier") will be posted separately.

thanks,

Mimi

