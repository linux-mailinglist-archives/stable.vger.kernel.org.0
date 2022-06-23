Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD06557E7E
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiFWPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiFWPP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:15:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E23A181;
        Thu, 23 Jun 2022 08:15:28 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NExKbi018290;
        Thu, 23 Jun 2022 15:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=F5u2zHCfPrvT0D4IS25BIsAO/MgoXoksBlhIRnmrFdU=;
 b=lJU7hmg+DigXYsrJ9k1wluVNTBniRorT4vXSIWdXDLQDVXKFTs5LbuCzTHdZUoMQqHWH
 oFGisWemEmzcW+sFcDtQF5ZkM1y2xhDmXAIZzjPzhYfQzXOU5N1hhuwlPf9TFrFp4RYT
 D4k4A5txY5hA26GgOSZGwDmxl5ovlP14y/lKcDgOvM6DFzS/UQTmYak4+n5IddM1FoYb
 O60DFMQ/qIsEHFOhY7dOyx/iOeC1Unq5/cAxS7H+K9RHLv8JWC6kn/H7DKL54x8ZlMVX
 K2mNY2HPloOnJ/fOMU5+knJdQZ3J9P0YKPcND9dkh5XUO8UXHHa6aM+ikdngQtWSR8Te iw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gvm1mc6ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:15:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25NF6QBt029353;
        Thu, 23 Jun 2022 15:15:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3gv9r71bbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:15:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25NFEWv723462288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 15:14:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B3EEAE051;
        Thu, 23 Jun 2022 15:15:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 099E8AE04D;
        Thu, 23 Jun 2022 15:15:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 23 Jun 2022 15:15:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D776EE024B; Thu, 23 Jun 2022 17:15:20 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     borntraeger@linux.ibm.com, stable@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
Subject: please consider for stable: "s390/mm: use non-quiescing sske for KVM switch to keyed guest"
Date:   Thu, 23 Jun 2022 17:15:20 +0200
Message-Id: <20220623151520.73354-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u4HEBS2PimDf79Gv14Z9s2F4RzQruD05
X-Proofpoint-GUID: u4HEBS2PimDf79Gv14Z9s2F4RzQruD05
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_06,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable team, please consider
commit 3ae11dbcfac906a8c3a480e98660a823130dc16a
It will noticeable reduce system overhead when this happens on multiple CPUs.

----snip----
commit 3ae11dbcfac906a8c3a480e98660a823130dc16a
    s390/mm: use non-quiescing sske for KVM switch to keyed guest
    
    The switch to a keyed guest does not require a classic sske as the other
    guest CPUs are not accessing the key before the switch is complete.
    By using the NQ SSKE things are faster especially with multiple guests.

    
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Suggested-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220530092706.11637-3-borntraeger@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 697df02362af..4909dcd762e8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -748,7 +748,7 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	pgste_val(pgste) |= PGSTE_GR_BIT | PGSTE_GC_BIT;
 	ptev = pte_val(*ptep);
 	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
-		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
+		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }
