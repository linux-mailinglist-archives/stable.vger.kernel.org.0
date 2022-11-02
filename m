Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC4617035
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKBWFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 18:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKBWFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 18:05:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB94617B;
        Wed,  2 Nov 2022 15:05:24 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2Lcs8L030144;
        Wed, 2 Nov 2022 22:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7dbezdsWrjkeeMK5twTGOFsoXL1sQg9vzSRIDM1zxyY=;
 b=Bqf5ObwD15lBCgLE6ZdCXPnYGEKFxHtfFJ6e0kWJi0hulVwLosbCrj7lk+AwWDraU/Aq
 QhNsCWo1EYpwJ36tm8delRQdJze8CkC6rUy5tgjMEAMYSOETdKgqPrxk5OPgRGUX6vr7
 Dq7JVP4CfE3f/JQ+D/XMrZ7+jboUH1XkYs5Th55w0MAOvKvKRQSsrApUrU2yneXxGweP
 l2Pe2Fs1TYI5eujOfO2bcxu6eFPF45OvDnpOkEiQB0TJE3ytINRf501MubMAONAJV6u+
 Bbr9xwjpOAbcdm3pOgNm5TNze7Zn5qqkHIy4658wMkzvAWWYFWHRDtkGxP6WsMT4mzHC Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3km0dk8s58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 22:04:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A2M4mJY032545;
        Wed, 2 Nov 2022 22:04:59 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3km0dk8s4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 22:04:59 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A2Los9W018270;
        Wed, 2 Nov 2022 22:04:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3kgutampy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Nov 2022 22:04:58 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A2M4wnv524918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Nov 2022 22:04:59 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F6E25806D;
        Wed,  2 Nov 2022 22:04:57 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49CAD58056;
        Wed,  2 Nov 2022 22:04:56 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.53.174])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  2 Nov 2022 22:04:56 +0000 (GMT)
Message-ID: <ef7375db277ac6a9398ee31a27e95eed717c4832.camel@linux.ibm.com>
Subject: Re: [PATCH] ima: Fix memory leak in __ima_inode_hash()
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaac.jmatt@gmail.com,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Date:   Wed, 02 Nov 2022 18:04:55 -0400
In-Reply-To: <20221102163006.1039343-1-roberto.sassu@huaweicloud.com>
References: <20221102163006.1039343-1-roberto.sassu@huaweicloud.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GNyIH1ZTOMz_JqqTwmGGKkMDxZn7WlVK
X-Proofpoint-GUID: FKRu6htgPJkjapMQl1NhLG56MGNwlI9N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=867 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211020146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Wed, 2022-11-02 at 17:30 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>

Any chance you could fix your mailer?

> 
> Commit f3cc6b25dcc5 ("ima: always measure and audit files in policy") lets
> measurement or audit happen even if the file digest cannot be calculated.
> 
> As a result, iint->ima_hash could have been allocated despite
> ima_collect_measurement() returning an error.
> 
> Since ima_hash belongs to a temporary inode metadata structure, declared
> at the beginning of __ima_inode_hash(), just add a kfree() call if
> ima_collect_measurement() returns an error different from -ENOMEM (in that
> case, ima_hash should not have been allocated).
> 
> Cc: stable@vger.kernel.org
> Fixes: 280fe8367b0d ("ima: Always return a file measurement in ima_file_hash()")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thanks,

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

