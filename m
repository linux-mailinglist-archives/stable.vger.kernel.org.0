Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE46B10C1
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 19:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCHSMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 13:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCHSMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 13:12:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDB0CE967
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 10:12:32 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328HqfZV029548;
        Wed, 8 Mar 2023 18:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : content-type : mime-version; s=pp1;
 bh=BlZ88hJ8snuL0eUvPJQ7dViQ+IjCAuDjzFgLZZkIzEk=;
 b=fkNbSmTG58wbxbxrL/tTyAbHM6+nSm1QeM2psXtZQu6fxvBDb3fTKbWiHTh+mTSBIWdm
 qFH3BijrZIyspblWa0KU2xEQhYfvMMsAaY7uX05W8r8tlhIJAzSIs0Ym/11+EtCAeDDZ
 ER2gSIBcP7ptQ3pRjBipu/hZ+iRu7zMhAAcxvdWxcqKj6NAt3RiNbfvAZDTvTwTSf/de
 KXhW7nZnpT4WhumDPSl1I2MjEHYwJukdH7akyanI69JOh3uz+99DKPAjenTi+1VqWtBL
 EquYJQpURETO1XuGK4rozkR/bhfCrVzBzKm+mzrOHsA46+jWXB+qtFhmZ6qIqFjLZQ2f Ig== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6t3b19pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328I6l6k032313;
        Wed, 8 Mar 2023 18:12:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3p6g038vrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 18:12:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328ICQsV2687514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 18:12:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F52920043;
        Wed,  8 Mar 2023 18:12:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 019ED20040;
        Wed,  8 Mar 2023 18:12:26 +0000 (GMT)
Received: from localhost (unknown [9.171.38.19])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  8 Mar 2023 18:12:25 +0000 (GMT)
Date:   Wed, 8 Mar 2023 19:12:24 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH stable 4.14 4.19 0/2] Fix s390 static key early usage
Message-ID: <cover.thread-194e16.your-ad-here.call-01678297576-ext-9970@work.hours>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OX4Uy-4DHI98qxGoTO3b0VIjCXpSAtD1
X-Proofpoint-ORIG-GUID: OX4Uy-4DHI98qxGoTO3b0VIjCXpSAtD1
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_12,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=652 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit e4f74400308c ("s390/archrandom: simplify back to earlier design
and initialize earlier") has been backported to stable releases including
4.14 and 4.19.
Backport for 4.19
Link: https://lore.kernel.org/all/20220704102416.326257-1-Jason@zx2c4.com/
Backport for 4.14
Link: https://lore.kernel.org/all/20220704102819.337213-1-Jason@zx2c4.com/

Unfortunately on stable 4.14 and stable 4.19 it missed dependencies which
results in kernel warning and panic:
[    0.202386] static_key_enable_cpuslocked(): static key 's390_arch_random_available+0x0/0x10' used before call to jump_label_init()
[    0.202400] WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:131 static_key_enable_cpuslocked+0x56/0xc8
[    0.202432] Modules linked in:
[    0.202451] CPU: 0 PID: 0 Comm: swapper Not tainted 4.19.275-25331-g5504146b2053 #2
[    0.202467] Hardware name: IBM 3931 A01 701 (KVM/Linux)
[    0.202485] Krnl PSW : (____ptrval____) (____ptrval____) (static_key_enable_cpuslocked+0x56/0xc8)
[    0.202504]            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[    0.202526] Krnl GPRS: 00000000fffd3474 000000000133074c 0000000000000076 0000000000eaaab2
[    0.202544]            0000000000000000 000000008e64b4cd ffffffffffffffff 0000000000000000
[    0.202561]            0000003d13b13b13 0000000000f2eb88 0000000001113018 0000000002008488
[    0.202579]            0000000001372380 0000000000bea608 00000000002e36ea 0000000000f0fe20
[    0.202600] Krnl Code: 00000000002e36de: c0200059cf3b        larl    %r2,0000000000e1d554
[    0.202600]            00000000002e36e4: c0e50045cf06        brasl   %r14,0000000000b9d4f0
[    0.202600]           #00000000002e36ea: a7f40001            brc     15,00000000002e36ec
[    0.202600]           >00000000002e36ee: c0e5fff33089        brasl   %r14,0000000000149800
[    0.202600]            00000000002e36f4: 5810c000            l       %r1,0(%r12)
[    0.202600]            00000000002e36f8: ec1c000c007e        cij     %r1,0,12,00000000002e3710
[    0.202600]            00000000002e36fe: 5810c000            l       %r1,0(%r12)
[    0.202600]            00000000002e3702: ec180029017e        cij     %r1,1,8,00000000002e3754
[    0.202636] Call Trace:
[    0.202654] ([<00000000002e36ea>] static_key_enable_cpuslocked+0x52/0xc8)
[    0.202672]  [<00000000002e3858>] static_key_enable+0x38/0x48
[    0.202691]  [<00000000010b0a52>] setup_arch+0xb72/0xb80
[    0.202709]  [<00000000010aa966>] start_kernel+0x7e/0x540
[    0.202728]  [<000000000010008a>] startup_continue+0x8a/0x300

[    0.207861] Jump label code mismatch at random_init+0x60/0x1a8 [00000000010f72f8]
[    0.207882] Found:    c0 f4 00 00 00 21
[    0.207899] Expected: c0 04 00 00 00 01
[    0.207916] New:      c0 04 00 00 00 00
[    0.207935] Kernel panic - not syncing: Corrupted kernel text
[    0.207950] CPU: 0 PID: 0 Comm: swapper Tainted: G        W         4.19.275-25331-g5504146b2053 #2
[    0.207967] Hardware name: IBM 3931 A01 701 (KVM/Linux)
[    0.207984] Call Trace:
[    0.208002] ([<0000000000113f6a>] show_stack+0x8a/0xd8)
[    0.208021]  [<0000000000badcba>] dump_stack+0xaa/0xe8
[    0.208038]  [<0000000000b9d68c>] panic+0x12c/0x270
[    0.208055]  [<0000000000b9d1c0>] dump_fault_info.isra.0+0x0/0x330
[    0.208073]  [<000000000011ec10>] __jump_label_transform+0x98/0xc8
[    0.208090]  [<00000000010c5810>] jump_label_init+0xd8/0x138
[    0.208112]  [<00000000010aaace>] start_kernel+0x1e6/0x540
[    0.208130]  [<000000000010008a>] startup_continue+0x8a/0x300

The following 2 patches are needed to solve the issue.

Vasily Gorbik (2):
  s390/maccess: add no DAT mode to kernel_write
  s390/setup: init jump labels before command line parsing

 arch/s390/kernel/setup.c |  1 +
 arch/s390/mm/maccess.c   | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.38.1
