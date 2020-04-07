Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57E1A08B1
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 09:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgDGHxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 03:53:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbgDGHxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 03:53:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0377afIW067659
        for <stable@vger.kernel.org>; Tue, 7 Apr 2020 03:53:07 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082hgew2j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 03:53:07 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 7 Apr 2020 08:52:52 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 08:52:49 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0377r0TR45613076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 07:53:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F413011C05B;
        Tue,  7 Apr 2020 07:52:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4532511C052;
        Tue,  7 Apr 2020 07:52:59 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.171.200])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 07:52:59 +0000 (GMT)
Subject: Re: [PATCH v2 1/5] KVM: s390: vsie: Fix region 1 ASCE sanity shadow
 address checks
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, stable@vger.kernel.org
References: <20200403153050.20569-1-david@redhat.com>
 <20200403153050.20569-2-david@redhat.com>
 <ee3f6c69-4401-066d-6f87-806667facf35@de.ibm.com>
 <c5c9fdcd-37ce-029d-a412-8987a901a116@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 7 Apr 2020 09:52:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c5c9fdcd-37ce-029d-a412-8987a901a116@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040707-0012-0000-0000-0000039FD6DB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040707-0013-0000-0000-000021DCF729
Message-Id: <3431ccbb-25b2-66fc-5e07-3f449c03b087@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_01:2020-04-07,2020-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=850 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070059
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 07.04.20 09:49, David Hildenbrand wrote:
> On 07.04.20 09:33, Christian Borntraeger wrote:
>>
>> On 03.04.20 17:30, David Hildenbrand wrote:
>>> In case we have a region 1 ASCE, our shadow/g3 address can have any value.
>>> Unfortunately, (-1UL << 64) is undefined and triggers sometimes,
>>> rejecting valid shadow addresses when trying to walk our shadow table
>>> hierarchy.
>>>
>>> The result is that the prefix cannot get mapped and will loop basically
>>> forever trying to map it (-EAGAIN loop).
>>>
>>> After all, the broken check is only a sanity check, our table shadowing
>>> code in kvm_s390_shadow_tables() already checks these conditions, injecting
>>> proper translation exceptions. Turn it into a WARN_ON_ONCE().
>>
>> After some testing I now triggered this warning:
>>
>> [  541.633114] ------------[ cut here ]------------
>> [  541.633128] WARNING: CPU: 38 PID: 2812 at arch/s390/mm/gmap.c:799 gmap_shadow_pgt_lookup+0x98/0x1a0
>> [  541.633129] Modules linked in: vhost_net vhost macvtap macvlan tap kvm xt_CHECKSUM xt_MASQUERADE nf_nat_tftp nf_conntrack_tftp xt_CT tun bridge stp llc xt_tcpudp ip6t_REJECT nf_reject_ipv6 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ip6table_filter ip6_tables iptable_filter rpcrdma sunrpc rdma_ucm rdma_cm iw_cm ib_cm configfs mlx5_ib s390_trng ghash_s390 prng aes_s390 ib_uverbs des_s390 ib_core libdes sha3_512_s390 genwqe_card sha3_256_s390 vfio_ccw crc_itu_t vfio_mdev sha512_s390 mdev vfio_iommu_type1 sha1_s390 vfio eadm_sch zcrypt_cex4 sch_fq_codel ip_tables x_tables mlx5_core sha256_s390 sha_common pkey zcrypt rng_core autofs4
>> [  541.633164] CPU: 38 PID: 2812 Comm: CPU 0/KVM Not tainted 5.6.0+ #354
>> [  541.633166] Hardware name: IBM 3906 M04 704 (LPAR)
>> [  541.633167] Krnl PSW : 0704d00180000000 00000014e05dc454 (gmap_shadow_pgt_lookup+0x9c/0x1a0)
>> [  541.633169]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
>> [  541.633171] Krnl GPRS: 0000000000000000 0000001f00000000 0000001f487b8000 ffffffff80000000
>> [  541.633172]            ffffffffffffffff 000003e003defa18 000003e003defa1c 000003e003defa18
>> [  541.633173]            fffffffffffff000 000003e003defa18 000003e003defa28 0000001f70e06300
>> [  541.633174]            0000001f43484000 00000000043ed200 000003e003def978 000003e003def920
>> [  541.633203] Krnl Code: 00000014e05dc448: b9800038		ngr	%r3,%r8
>>                           00000014e05dc44c: a7840014		brc	8,00000014e05dc474
>>                          #00000014e05dc450: af000000		mc	0,0
>>                          >00000014e05dc454: a728fff5		lhi	%r2,-11
>>                           00000014e05dc458: a7180000		lhi	%r1,0
>>                           00000014e05dc45c: b2fa0070		niai	7,0
>>                           00000014e05dc460: 4010b04a		sth	%r1,74(%r11)
>>                           00000014e05dc464: b9140022		lgfr	%r2,%r2
>> [  541.633215] Call Trace:
>> [  541.633218]  [<00000014e05dc454>] gmap_shadow_pgt_lookup+0x9c/0x1a0 
>> [  541.633257]  [<000003ff804c57d6>] kvm_s390_shadow_fault+0x66/0x1e8 [kvm] 
>> [  541.633265]  [<000003ff804c72dc>] vsie_run+0x43c/0x710 [kvm] 
>> [  541.633273]  [<000003ff804c85ca>] kvm_s390_handle_vsie+0x632/0x750 [kvm] 
>> [  541.633281]  [<000003ff804c123c>] kvm_s390_handle_b2+0x84/0x4e0 [kvm] 
>> [  541.633289]  [<000003ff804b46b2>] kvm_handle_sie_intercept+0x172/0xcb8 [kvm] 
>> [  541.633297]  [<000003ff804b18a8>] __vcpu_run+0x658/0xc90 [kvm] 
>> [  541.633305]  [<000003ff804b2920>] kvm_arch_vcpu_ioctl_run+0x248/0x858 [kvm] 
>> [  541.633313]  [<000003ff8049d454>] kvm_vcpu_ioctl+0x284/0x7b0 [kvm] 
>> [  541.633316]  [<00000014e087d5ae>] ksys_ioctl+0xae/0xe8 
>> [  541.633318]  [<00000014e087d652>] __s390x_sys_ioctl+0x2a/0x38 
>> [  541.633323]  [<00000014e0ff02a2>] system_call+0x2a6/0x2c8 
>> [  541.633323] Last Breaking-Event-Address:
>> [  541.633334]  [<000003ff804983e0>] kvm_running_vcpu+0x3ea9ee997d8/0x3ea9ee99950 [kvm]
>> [  541.633335] ---[ end trace f69b6021855ea189 ]---
>>
>>
>> Unfortunately no dump at that point in time.
>> I have other tests which are clearly fixed by this patch, so we should propbably go forward anyway.
>> Question is, is this just another bug we need to fix or is the assumption that somebody else checked 
>> all conditions so we can warn false?
> 
> Yeah, I think it is via
> 
> kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()->gmap_table_walk()
> 
> where we just peek if there is already something shadowed. If not, we go
> via the full kvm_s390_shadow_tables() path.
> 
> So we could either do sanity checks in gmap_shadow_pgt_lookup(), or
> rather drop the WARN_ON_ONCE. I think the latter makes sense, now that
> we understood the problem.

Ok, so I will drop the WARN_ON_ONCE and fixup the commit message.

