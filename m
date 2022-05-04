Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06934519CA5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 12:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbiEDKQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 06:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345526AbiEDKQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 06:16:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F57415A26;
        Wed,  4 May 2022 03:13:01 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2449ddDH006554;
        Wed, 4 May 2022 10:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=1/EdRZxc1q6wIHNF9coOZr+b2lDewyIBNR14WItW9gk=;
 b=b/Ce3h05m2MMPkA8oUU2w49M7eA6zZzGx1nLSlnGsopr0r+awD+8kb1GONgkAq/Fukcp
 k6F5gzymWGYAVwoQMhUrqGrecY0WkcMy2v6lNKUvkcL8PX0T/lz/pFbD9AOoMDOV5oQW
 Ssw1sqO8YifiHqpN1bmkmU65ENqcA8kZB5vhBjT7EvLCRIoINJTGwS6RKC0PDHPkchuT
 AN9B8h+Knp1qQPOOGSVOmdlenANBfujUkQWKuv01rw7aTt8wLlVr3+tnlJ0j3BhDZMfM
 aKyJi+wKWA5MLrWhpe2RKfvY8A0rFzu17g/bUJwuuhGc/0oyCufqxYMRDey/MQvFPZZ1 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fupn191kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 10:12:52 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2449tw8P007768;
        Wed, 4 May 2022 10:12:52 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fupn191jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 10:12:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244A944M017178;
        Wed, 4 May 2022 10:12:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7ft9qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 10:12:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244ACiMa28508436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 10:12:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA88942041;
        Wed,  4 May 2022 10:12:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E32142045;
        Wed,  4 May 2022 10:12:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.14.176])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 10:12:46 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3] powerpc/rtas: Keep MSR[RI] set when calling RTAS
Date:   Wed,  4 May 2022 12:12:44 +0200
Message-Id: <20220504101244.12107-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0vqfpqbV_p5SVmJ2Uch30SbD5ojBPaYh
X-Proofpoint-ORIG-GUID: 0XEdKwyAxX2UicQDUROQUEYnxw4wZBrh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
big endian mode (MSR[SF,LE] unset).

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

RTAS is expected to be called with MSR[RI] as specified in PAPR+ section
"7.2.1 Machine State":

 R1–7.2.1–9. If called with MSR[RI] equal to 1, then RTAS must protect
 its own critical regions from recursion by setting the MSR[RI] bit to
 0 when in the critical regions.

Fixing this by reviewing the way MSR is compute before calling RTAS. Now a
hardcoded value meaning real mode, 32 bits big endian mode and Recoverable
Interrupt is loaded. In the case MSR[S] is set, it will remain set while
entering RTAS as only urfid can unset it (thanks Fabiano).

In addition a check is added in do_enter_rtas() to detect calls made with
MSR[RI] unset, as we are forcing it on later.

This patch has been tested on the following machines:
Power KVM Guest
  P8 S822L (host Ubuntu kernel 5.11.0-49-generic)
PowerVM LPAR
  P8 9119-MME (FW860.A1)
  p9 9008-22L (FW950.00)
  P10 9080-HEX (FW1010.00)

Changes in V3:
 - Address Michael's comment on the commit's description and some comments
   in the code. There is no functional change introduced in this version.

Changes in V2:
 - Change comment in code to indicate NMI (Nick's comment)
 - Add reference to PAPR+ in the change log (Michael's comment)

Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: stable@vger.kernel.org
Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
---
 arch/powerpc/kernel/entry_64.S | 23 +++++++++++------------
 arch/powerpc/kernel/rtas.c     |  9 +++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 9581906b5ee9..fd77f1300ce2 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -330,22 +330,21 @@ _GLOBAL(enter_rtas)
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
+	/* RTAS runs in 32bits big endian real mode but let MSR[RI] on as
+	 * we may hit NMI (SRESET or MCE). RTAS should disable RI in its
+	 * critical regions (as specified in PAPR+ section 7.2.1).
+	 * MSR[S] is not impacted by RFI_TO_KERNEL (only urfid can unset
+	 * it). So if MSR[S] is set, it will remain when entering RTAS.
+	 */
+	LOAD_REG_IMMEDIATE(r6, MSR_ME|MSR_RI)
+
+	li      r0,0
+	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
 	
 	mtspr	SPRN_SRR0,r5
 	mtspr	SPRN_SRR1,r6
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 1f42aabbbab3..6bc89d9ccf63 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -49,6 +49,15 @@ void enter_rtas(unsigned long);
 
 static inline void do_enter_rtas(unsigned long args)
 {
+	unsigned long msr;
+
+	/*
+	 * Make sure MSR[RI] is currently enabled as it will be forced later
+	 * in enter_rtas.
+	 */
+	msr = mfmsr();
+	BUG_ON(!(msr & MSR_RI));
+
 	enter_rtas(args);
 
 	srr_regs_clobbered(); /* rtas uses SRRs, invalidate */
-- 
2.36.0

