Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90B84EC35E
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345283AbiC3MLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345834AbiC3MEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:04:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26DB39178;
        Wed, 30 Mar 2022 04:58:46 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBh5va027506;
        Wed, 30 Mar 2022 11:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=18A9OJUgNmDoRYrIS4z3SJ5vMTgikgfdJTnRRrRgqtQ=;
 b=ZVNQv62NARKYgeO5ScWI0JkDQRJR6Oc0uESH4TmiPRKhRrhxeNiegfgwTP5qyUFBW3LO
 iKLTMlzg6RKvWDMuTHKxLuIPe+JjlI1lexMH20h7xIwNbx1i37/+rSjSD8s+xay0OSQ/
 5qUy+a4Mg6xaXT1ziLMBqiMN2QBtqlbGS4qRtzbdZ3NihIuVQn88V1O2P/llJ8e5bQ7A
 X+dUyYBUUAl2ItBk/xAuFVW30WCpuum7Z0cJEozkb6kEj+TO7DMF73pdlK3qP2Ibioap
 wAi92b0L4+QJ+R093OeArPTiBEZHzfwzCwBGpsFD9u3JOh/zwAmXpvt8tORobXswCcsw kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40q23us8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:58:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UBvw7x003222;
        Wed, 30 Mar 2022 11:58:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40q23urn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:58:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBvVHJ024119;
        Wed, 30 Mar 2022 11:58:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9gg3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 11:58:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UBkW6q47645070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 11:46:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1CFAA405C;
        Wed, 30 Mar 2022 11:58:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C60CA4054;
        Wed, 30 Mar 2022 11:58:31 +0000 (GMT)
Received: from [9.145.166.215] (unknown [9.145.166.215])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 11:58:31 +0000 (GMT)
Message-ID: <85b16843-5477-21b4-7d62-4fc39e48b5cf@linux.ibm.com>
Date:   Wed, 30 Mar 2022 13:58:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
From:   Laurent Dufour <ldufour@linux.ibm.com>
Subject: Re: [PATCH] powerpc/rtas: Keep MSR RI set when calling RTAS
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
References: <20220317110601.86917-1-ldufour@linux.ibm.com>
 <1648542633.wzscjm967w.astroid@bobo.none>
 <8e3175ff-afba-e2a2-4fe6-0f964da0fa4b@linux.ibm.com>
 <87pmm5f1tp.fsf@mpe.ellerman.id.au>
Content-Language: en-US
In-Reply-To: <87pmm5f1tp.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aK2pxcuXYIuzjA7Wl-2CWAQyF6gO3eio
X-Proofpoint-ORIG-GUID: 12WylFQJ-5L4q4Qofr2vd2eGFFIf4CtS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/03/2022, 13:14:10, Michael Ellerman wrote:
> Laurent Dufour <ldufour@linux.ibm.com> writes:
>> On 29/03/2022, 10:31:33, Nicholas Piggin wrote:
>>> Excerpts from Laurent Dufour's message of March 17, 2022 9:06 pm:
>>>> RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32bits
>>>> mode (MSR[SF] unset).
>>>>
>>>> The change in MSR is done in enter_rtas() in a relatively complex way,
>>>> since the MSR value could be hardcoded.
>>>>
>>>> Furthermore, a panic has been reported when hitting the watchdog interrupt
>>>> while running in RTAS, this leads to the following stack trace:
>>>>
>>>> [69244.027433][   C24] watchdog: CPU 24 Hard LOCKUP
>>>> [69244.027442][   C24] watchdog: CPU 24 TB:997512652051031, last heartbeat TB:997504470175378 (15980ms ago)
>>>> [69244.027451][   C24] Modules linked in: chacha_generic(E) libchacha(E) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) algif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
>>>> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) configfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E) t10_pi(E)
>>>> [69244.027555][   C24]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
>>>> [69244.027587][   C24] Supported: No, Unreleased kernel
>>>> [69244.027600][   C24] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
>>>> [69244.027609][   C24] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
>>>> [69244.027612][   C24] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
>>>> [69244.027615][   C24] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
>>>> [69244.027625][   C24] CFAR: 000000000000011c IRQMASK: 1
>>>> [69244.027625][   C24] GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
>>>> [69244.027625][   C24] GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
>>>> [69244.027625][   C24] GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
>>>> [69244.027625][   C24] GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
>>>> [69244.027625][   C24] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
>>>> [69244.027625][   C24] GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
>>>> [69244.027625][   C24] GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
>>>> [69244.027625][   C24] GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
>>>> [69244.027663][   C24] NIP [000000001fb41050] 0x1fb41050
>>>> [69244.027696][   C24] LR [000000001fb4104c] 0x1fb4104c
>>>> [69244.027699][   C24] Call Trace:
>>>> [69244.027701][   C24] Instruction dump:
>>>> [69244.027723][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>>> [69244.027728][   C24] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>>> [69244.027762][T87504] Oops: Unrecoverable System Reset, sig: 6 [#1]
>>>> [69244.028044][T87504] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>>>> [69244.028089][T87504] Modules linked in: chacha_generic(E) libchacha(E) xxhash_generic(E) wp512(E) sha3_generic(E) rmd160(E) poly1305_generic(E) libpoly1305(E) michael_mic(E) md4(E) crc32_generic(E) cmac(E) ccm(E) algif_rng(E) twofish_generic(E) twofish_common(E) serpent_generic(E) fcrypt(E) des_generic(E) libdes(E) cast6_generic(E) cast5_generic(E) cast_common(E) camellia_generic(E) blowfish_generic(E) blowfish_common(E) algif_skcipher(E) algif_hash(E) gcm(E) algif_aead(E) af_alg(E) tun(E) rpcsec_gss_krb5(E) auth_rpcgss(E)
>>>> nfsv4(E) dns_resolver(E) rpadlpar_io(EX) rpaphp(EX) xsk_diag(E) tcp_diag(E) udp_diag(E) raw_diag(E) inet_diag(E) unix_diag(E) af_packet_diag(E) netlink_diag(E) nfsv3(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) netfs(E) af_packet(E) rfkill(E) bonding(E) tls(E) ibmveth(EX) crct10dif_vpmsum(E) rtc_generic(E) drm(E) drm_panel_orientation_quirks(E) fuse(E) configfs(E) backlight(E) ip_tables(E) x_tables(E) dm_service_time(E) sd_mod(E) t10_pi(E)
>>>> [69244.028171][T87504]  ibmvfc(EX) scsi_transport_fc(E) vmx_crypto(E) gf128mul(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_vpmsum(E) xor(E) raid6_pq(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E)
>>>> [69244.028307][T87504] Supported: No, Unreleased kernel
>>>> [69244.028385][T87504] CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
>>>> [69244.028408][T87504] NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
>>>> [69244.028418][T87504] REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
>>>> [69244.028429][T87504] MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
>>>> [69244.028444][T87504] CFAR: 000000000000011c IRQMASK: 1
>>>> [69244.028444][T87504] GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
>>>> [69244.028444][T87504] GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
>>>> [69244.028444][T87504] GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
>>>> [69244.028444][T87504] GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
>>>> [69244.028444][T87504] GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
>>>> [69244.028444][T87504] GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
>>>> [69244.028444][T87504] GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
>>>> [69244.028444][T87504] GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
>>>> [69244.028534][T87504] NIP [000000001fb41050] 0x1fb41050
>>>> [69244.028543][T87504] LR [000000001fb4104c] 0x1fb4104c
>>>> [69244.028549][T87504] Call Trace:
>>>> [69244.028554][T87504] Instruction dump:
>>>> [69244.028561][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>>> [69244.028575][T87504] XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>>>> [69244.028607][T87504] ---[ end trace 3ddec07f638c34a2 ]---
>>>>
>>>> This happens because MSR[RI] is unset when entering RTAS but there is no
>>>> valid reason to not set it here.
>>>>
>>>> Fixing this by reviewing the way MSR is compute before calling RTAS. Now a
>>>> hardcoded value meaning real mode, 32 bits and Recoverable Interrupt is
>>>> loaded.
>>>>
>>>> In addition a check is added in do_enter_rtas() to detect calls made with
>>>> MSR[RI] unset, as we are forcing it on later.
>>>
>>> This looks okay to me, I would just adjust the comment about watchdog
>>> irq. It's more like NMI (SRESET or MCE), watchdog irq could be confusing 
>>> for the soft-NMI timer.
>>>
>>> Otherwise I think it's okay.
>>>
>>> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
>>
>> Thanks Nick,
>>
>> I agree about comment watchdog irq.
>> Michael, could you fix that comment below when applying?
> 
> I can.

Thanks, Michael

> 
> But the changelog also needs to mention that what we're doing is legal
> per PAPR, and reference the relevant sections.
> 
> I think that's section "7.2.1 Machine State", in particular:
> 
>   R1–7.2.1–9. If called with MSR[RI]equal to 1, then RTAS must protect
>   its own critical regions from recursion by setting the MSR[RI] bit to
>   0 when in the critical regions.
> 
> That language appears to go back to PAPR+ Version 1.0, so that should
> cover all PAPR systems.

I agree, referencing this section would be good, I don't have the complete
PAPR+ series, the oldest one I've access to is 2.7, and it is already
mentioning this.

> 
> We also had RTAS on pre-PAPR systems, but I don't think we support any
> of those anymore (on 64-bit).

Unfortunately, I have no knowledge on these systems, neither I'm aware of
such a system I have access to. Do you have any pointer?

> Would also be good to know what machines you've tested this on.

Tests have been done on various systems:
Power KVM Guest
  P8 S822L (host Ubuntu kernel 5.11.0-49-generic)
PowerVM LPAR
  P8 9119-MME (FW860.A1)
  p9 9008-22L (FW950.00)
  P10 9080-HEX (FW1010.00)

Should I send a new version with the commit description updated, and the
comment fixed in the code?

Thanks,
Laurent.
