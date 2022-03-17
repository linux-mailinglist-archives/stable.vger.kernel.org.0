Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0D4DC46E
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 12:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiCQLHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 07:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiCQLHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 07:07:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECD61C9B55;
        Thu, 17 Mar 2022 04:06:21 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HATJiE002876;
        Thu, 17 Mar 2022 11:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=bjDod+kHZDl/ajqdBnOYCpzviwrKudbSbq33TCzIQro=;
 b=lOdaNlsHJZzIoZfo45dONRUBe0j4pMRNBpKCBfOgvJt5hHHmhkuxdL3SmAVue9t1n0Jr
 a1SXwcOeG4G66GJd31v2VlJNgwuePPR1/Txfb1WdPZaThobvuKdS79xvBw95RxowGkdX
 g6GPYkWotay6oH3g0Itu63yfD9Ejf41YFvndImRCDcDhUOdKp+UOoDPipTZezAgRGKkM
 IcjNAEnNubwiWvo+ZkpqjwUg4U0ZdFhbRE1w6/gdkvvLYE+Gi8G5JaKA99oDGYzdJUYG
 MwvC76ZYJSiQksPMPG+M0i8URKKZZkXdla9rC9qqkysLzkp5iFvHujf8jLfOgS3jKfCX tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev04pvbt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 11:06:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22HAfT0S004112;
        Thu, 17 Mar 2022 11:06:13 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev04pvbsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 11:06:13 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22HB2a2x027999;
        Thu, 17 Mar 2022 11:06:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3erk58sg52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 11:06:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22HB6AEc40829328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 11:06:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 230204C050;
        Thu, 17 Mar 2022 11:06:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEAB94C04E;
        Thu, 17 Mar 2022 11:06:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.66.50])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Mar 2022 11:06:07 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] powerpc/rtas: Keep MSR RI set when calling RTAS
Date:   Thu, 17 Mar 2022 12:06:01 +0100
Message-Id: <20220317110601.86917-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K82nTEZM-YLRZJkm-rjmME3Qfuu2DH64
X-Proofpoint-ORIG-GUID: -6CyisBvOoFMTo9gRhk5wSrgLM7mgWlW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_04,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
mode (MSR[SF] unset).

The change in MSR is done in enter_rtas() in a relatively complex way,
since the MSR value could be hardcoded.

Furthermore, a panic has been reported when hitting the watchdog interrupt
while running in RTAS, this leads to the following stack trace:

[69244.027433][   C24] watchdog: CPU 24 Hard LOCKUP
[69244.027442][   C24] watchdog: CPU 24 TB:997512652051031, last heartbeat TB:997504470175378 (15980ms ago)
[69244.027451][   C24] Modules linked in: chacha_generic(E) libchacha(E) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) algif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) configfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E) t10_pi(E)
[69244.027555][   C24]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
[69244.027587][   C24] Supported: No, Unreleased kernel
[69244.027600][   C24] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
[69244.027609][   C24] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
[69244.027612][   C24] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
[69244.027615][   C24] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
[69244.027625][   C24] CFAR: 000000000000011c IRQMASK: 1
[69244.027625][   C24] GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
[69244.027625][   C24] GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
[69244.027625][   C24] GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
[69244.027625][   C24] GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
[69244.027625][   C24] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
[69244.027625][   C24] GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
[69244.027625][   C24] GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
[69244.027625][   C24] GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
[69244.027663][   C24] NIP [000000001fb41050] 0x1fb41050
[69244.027696][   C24] LR [000000001fb4104c] 0x1fb4104c
[69244.027699][   C24] Call Trace:
[69244.027701][   C24] Instruction dump:
[69244.027723][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[69244.027728][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[69244.027762][T87504] Oops: Unrecoverable System Reset, sig: 6 [#1]
[69244.028044][T87504] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[69244.028089][T87504] Modules linked in: chacha_generic(E) libchacha(E) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) algif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) configfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E) t10_pi(E)
[69244.028171][T87504]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
[69244.028307][T87504] Supported: No, Unreleased kernel
[69244.028385][T87504] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
[69244.028408][T87504] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
[69244.028418][T87504] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
[69244.028429][T87504] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
[69244.028444][T87504] CFAR: 000000000000011c IRQMASK: 1
[69244.028444][T87504] GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
[69244.028444][T87504] GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
[69244.028444][T87504] GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
[69244.028444][T87504] GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
[69244.028444][T87504] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
[69244.028444][T87504] GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
[69244.028444][T87504] GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
[69244.028444][T87504] GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
[69244.028534][T87504] NIP [000000001fb41050] 0x1fb41050
[69244.028543][T87504] LR [000000001fb4104c] 0x1fb4104c
[69244.028549][T87504] Call Trace:
[69244.028554][T87504] Instruction dump:
[69244.028561][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[69244.028575][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
[69244.028607][T87504] ---[ end trace 3ddec07f638c34a2 ]---

This happens because MSR[RI] is unset when entering RTAS but there is no
valid reason to not set it here.

Fixing this by reviewing the way MSR is compute before calling RTAS. Now a
hardcoded value meaning real mode, 32 bits and Recoverable Interrupt is
loaded.

In addition a check is added in do_enter_rtas() to detect calls made with
MSR[RI] unset, as we are forcing it on later.

Cc: stable@vger.kernel.org
Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/kernel/entry_64.S | 18 ++++++------------
 arch/powerpc/kernel/rtas.c     |  5 +++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 9581906b5ee9..fbc8dfe7da9f 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -330,22 +330,16 @@ _GLOBAL(enter_rtas)
 	clrldi	r4,r4,2			/* convert to realmode address */
        	mtlr	r4
 
-	li	r0,0
-	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
-	andc	r0,r6,r0
-	
-        li      r9,1
-        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
-	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
-	andc	r6,r0,r9
-
 __enter_rtas:
-	sync				/* disable interrupts so SRR0/1 */
-	mtmsrd	r0			/* don't get trashed */
-
 	LOAD_REG_ADDR(r4, rtas)
 	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
 	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
+
+	/* RTAS runs in 32bits real mode but we may hit watchdog irq */
+	LOAD_REG_IMMEDIATE(r6, MSR_ME|MSR_RI)
+
+	li      r0,0
+	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
 	
 	mtspr	SPRN_SRR0,r5
 	mtspr	SPRN_SRR1,r6
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 1f42aabbbab3..d7775b8c8853 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -49,6 +49,11 @@ void enter_rtas(unsigned long);
 
 static inline void do_enter_rtas(unsigned long args)
 {
+	unsigned long msr;
+
+	msr = mfmsr();
+	BUG_ON(!(msr & MSR_RI));
+
 	enter_rtas(args);
 
 	srr_regs_clobbered(); /* rtas uses SRRs, invalidate */
-- 
2.35.1

