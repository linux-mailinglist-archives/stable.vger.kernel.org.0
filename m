Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA09337BDC
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 20:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfFFSHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 14:07:46 -0400
Received: from mail-eopbgr680064.outbound.protection.outlook.com ([40.107.68.64]:56046
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727559AbfFFSHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 14:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKYi4h4F3IV9sDB7hdjgm9kZ7qG6VxWWCN/iQP8uNZ8=;
 b=gTYWA5JXSq1mGWeVQCrbgZEr0aCGN8+ZJac4HwtmcINw/4JAS+kJ5SxnYc+vpypR5lQrejS3zXx426KgNiAUiq1GFPPj0ZLy9OudWdc1DPDFXrq7EKZ15AQynMCFsOgzvTPE8MzjIy4YohdVMk9K82CD6+11kYbWdJwgiAalJ3E=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5174.namprd05.prod.outlook.com (20.177.231.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.5; Thu, 6 Jun 2019 18:07:39 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::2cb6:a3d1:f675:ced8%3]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 18:07:39 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Daniel Dao <dqminh@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Kernel 4.19.47 with commit
 8715ce033eb37f539e73b1570bf56404b21d46cd failed to execute NX-protected page
Thread-Topic: Kernel 4.19.47 with commit
 8715ce033eb37f539e73b1570bf56404b21d46cd failed to execute NX-protected page
Thread-Index: AQHVG6ee872BPYqaiUuLw39IcODYwqaN1IYAgACPCoCAADkWAIAAUX0A
Date:   Thu, 6 Jun 2019 18:07:39 +0000
Message-ID: <2EB7FDCB-E032-4B05-9CE5-3BE705762434@vmware.com>
References: <CA+wXwBT6+zov5MyPH7XvVZX1JDzviisW2FHUu=G9jHpVCSfeeg@mail.gmail.com>
 <20190606011942.GH29739@sasha-vm>
 <CA+wXwBRqcU2Vrso1nDPOjbux970vddb2-96subT6ht2rcZXYhQ@mail.gmail.com>
 <20190606131558.GJ29739@sasha-vm>
In-Reply-To: <20190606131558.GJ29739@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3777ee-d746-490e-43b8-08d6eaa9dd0c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5174;
x-ms-traffictypediagnostic: BYAPR05MB5174:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR05MB51744B1CDBEAE561438890E3D0170@BYAPR05MB5174.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(396003)(346002)(136003)(199004)(189003)(316002)(305945005)(26005)(2906002)(11346002)(186003)(82746002)(6512007)(7736002)(54906003)(6306002)(66476007)(33656002)(76116006)(486006)(8676002)(446003)(73956011)(5660300002)(25786009)(81156014)(81166006)(36756003)(66556008)(64756008)(53936002)(66446008)(66946007)(71190400001)(83716004)(86362001)(71200400001)(256004)(3846002)(6116002)(91956017)(14444005)(68736007)(478600001)(45080400002)(99286004)(6506007)(66066001)(8936002)(6436002)(6246003)(76176011)(2616005)(476003)(6486002)(6916009)(4326008)(229853002)(14454004)(102836004)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5174;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: weOZLQNzyAAOT6CBnbsX1stwGRoCmkXd0fDTwDxWqeJO6T8NpQNpN3/1TzbSFSZY0xBcNlPkhwseop9iRBjyuXqpbrG2wWV0TV07slQ+gwPSHykkxrbWunyJ8Uxmy35M3S4BtNCAHzM7WzQ2SKM9jeJ7KSc6VL5eI9mE/8Y2yQc8sAUhkzfj5xxzIbAN1W8qAMyZJgLSFfZFcsRfL2mFt3QsRjLjZXEb13Jc4/LMhkRfg7IORZAbyJztwvOh8tzSfCVC5ClMTYD8/mggSHd6iOYrWY9DV1n6XLCWqXKch8OJDOUk/gwfk4Dvr88f16Y4jGJVmRmAgAlaH42CRSRbNgGt8ktsYGXyKabCRlgas+1EGJ8AaeReW53KEWghftKYvXpID0leJhJ3XyChzP7iAJsfmvVEKrpE1Gxj1HQz8nI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DCA1F7252964C498B7A9CFF70FAD9AC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3777ee-d746-490e-43b8-08d6eaa9dd0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 18:07:39.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5174
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jun 6, 2019, at 6:15 AM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> On Thu, Jun 06, 2019 at 10:51:39AM +0100, Daniel Dao wrote:
>> On Thu, Jun 6, 2019 at 2:19 AM Sasha Levin <sashal@kernel.org> wrote:
>>> On Wed, Jun 05, 2019 at 03:04:26PM +0100, Daniel Dao wrote:
>>> >Hi there,
>>> >
>>> >We are testing kernel 4.19.47 with some tools utilizing kprobe,
>>> >resulting in panics that look like:
>>> >
>>> >[ 1085.318031] kernel tried to execute NX-protected page - exploit
>>> >attempt? (uid: 65534)
>>> >[ 1085.334028] BUG: unable to handle kernel paging request at ffffffff=
c0428000
>>> >[ 1085.349128] PGD 13a3e10067 P4D 13a3e10067 PUD 13a3e12067 PMD
>>> >c1e860067 PTE 8000000bbd075061
>>> >[ 1085.365779] Oops: 0011 [#1] SMP KASAN PTI
>>> >[ 1085.377879] CPU: 30 PID: 29734 Comm: nginx-fl Tainted: G    B
>>> >O      4.19.47-cloudflare-kasan-2019.6.0 #2019.6.0
>>> >[ 1085.396652] Hardware name: Quanta Computer Inc QuantaPlex
>>> >T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
>>> >[ 1085.414041] RIP: 0010:0xffffffffc0428000
>>> >[ 1085.425965] Code: Bad RIP value.
>>> >[ 1085.436832] RSP: 0018:ffff88a015e2fb18 EFLAGS: 00010246
>>> >[ 1085.449853] RAX: 0000000000000003 RBX: ffff889f73448900 RCX: 000000=
0000000218
>>> >[ 1085.464719] RDX: ffff889fe4893c00 RSI: 0000000000000002 RDI: ffff88=
9f73448900
>>> >[ 1085.479626] RBP: ffff88a015e2fe18 R08: 0000000000000006 R09: 000000=
0000000000
>>> >[ 1085.494677] R10: 000000008a08850a R11: 0000000000000000 R12: ffff88=
9f7344890c
>>> >[ 1085.509890] R13: ffff889f73448c54 R14: ffff889f73448c7a R15: 000000=
0000002c19
>>> >[ 1085.525252] FS:  00007f51582f5680(0000) GS:ffff88a03fb80000(0000)
>>> >knlGS:0000000000000000
>>> >[ 1085.541810] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> >[ 1085.555812] CR2: ffffffffc0427fd6 CR3: 0000002039fee004 CR4: 000000=
00001606e0
>>> >[ 1085.571154] Call Trace:
>>> >[ 1085.581676]  ? tcp_set_state+0x5/0x5b0
>>> >[ 1085.593532]  ? tcp_v4_connect+0xbd7/0x2000
>>> >[ 1085.605809]  ? tcp_sk_init+0x1220/0x1220
>>> >[ 1085.617810]  ? selinux_socket_connect_helper.isra.55+0x277/0x400
>>> >[ 1085.631808]  ? sock_poll+0x218/0x300
>>> >[ 1085.643407]  ? selinux_netcache_avc_callback+0x30/0x30
>>> >[ 1085.656701]  ? __inet_stream_connect+0x630/0xbd0
>>> >[ 1085.669508]  ? expand_files.part.9+0x640/0x640
>>> >[ 1085.682145]  ? ipip_gro_complete+0x110/0x110
>>> >[ 1085.694627]  ? __inet_stream_connect+0xbd0/0xbd0
>>> >[ 1085.707397]  ? inet_stream_connect+0x53/0xa0
>>> >[ 1085.719830]  ? __sys_connect+0x1f6/0x270
>>> >[ 1085.731964]  ? __ia32_sys_accept+0xb0/0xb0
>>> >[ 1085.744201]  ? mutex_lock+0x85/0xe0
>>> >[ 1085.755815]  ? ep_show_fdinfo+0x3c0/0x3c0
>>> >[ 1085.767916]  ? syscall_trace_enter+0x566/0xc30
>>> >[ 1085.780429]  ? __x64_sys_epoll_ctl+0x237/0x1080
>>> >[ 1085.792883]  ? exit_to_usermode_loop+0x140/0x140
>>> >[ 1085.805425]  ? __audit_syscall_exit+0x73e/0xa30
>>> >[ 1085.817925]  ? __x64_sys_connect+0x6f/0xb0
>>> >[ 1085.829915]  ? do_syscall_64+0x8e/0x280
>>> >[ 1085.841539]  ? prepare_exit_to_usermode+0xe1/0x140
>>> >[ 1085.854067]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> >[ 1085.867000] Modules linked in: xt_length xt_connlimit nf_conncount
>>> >xt_hashlimit iptable_security sch_fq md_mod dm_crypt algif_skcipher
>>> >af_alg dm_mod dax ip6table_nat nf_nat_ipv6 ip6table_mangle
>>> >ip6table_security ip6table_raw xt_nat iptable_nat nf_nat_ipv4 nf_nat
>>> >xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ipv4 xt_connmark iptable_mangle
>>> >xt_owner ip6table_filter ip6_tables xt_CT xt_socket nf_socket_ipv4
>>> >nf_socket_ipv6 iptable_raw nfnetlink_log xt_NFLOG xt_bpf xt_comment
>>> >xt_conntrack xt_mark xt_multiport xt_set xt_tcpudp ipt_GLBREDIRECT(O)
>>> >nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 fou ip6_udp_tunnel
>>> >udp_tunnel iptable_filter bpfilter ip_set_hash_netport ip_set_hash_net
>>> >ip_set_hash_ip ip_set nfnetlink sit ipip tunnel4 ip_tunnel tun 8021q
>>> >garp stp mrp llc sb_edac x86_pkg_temp_thermal kvm_intel kvm irqbypass
>>> >[ 1085.996378]  crc32_pclmul crc32c_intel pcbc aesni_intel aes_x86_64
>>> >ipmi_ssif crypto_simd cryptd glue_helper intel_cstate intel_uncore
>>> >sfc(O) intel_rapl_perf tpm_tis tpm_tis_core mdio tpm ipmi_si
>>> >ipmi_devintf ipmi_msghandler efivarfs ip_tables x_tables
>>> >
>>> >Reproducible steps on my local machine are as follow:
>>> >1. Run kernel 4.19.47
>>> >2. We are going to test kprobe on tcp_set_state using
>>> >https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgi=
thub.com%2Fiovisor%2Fbcc%2Fblob%2Fmaster%2Ftools%2Ftcplife.py&amp;data=3D02=
%7C01%7Cnamit%40vmware.com%7C4e1e84da0eb34b42bf7008d6ea811e99%7Cb39138ca3ce=
e4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636954237621231884&amp;sdata=3D9n4InlHNbbuO=
AU%2FGqSuKN3gQ8GfNT1Tmkr6etrp7Pv8%3D&amp;reserved=3D0. But
>>> >probably any workload utilizing kprobe would work
>>> >    - Run some workload that creating tcp connections. I'm runing
>>> >`python -m SimpleHTTPServer` and `wrk -d60s -c10
>>> >http://localhost:8000`
>>> >    - Run the script
>>> >https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgi=
thub.com%2Fiovisor%2Fbcc%2Fblob%2Fmaster%2Ftools%2Ftcplife.py&amp;data=3D02=
%7C01%7Cnamit%40vmware.com%7C4e1e84da0eb34b42bf7008d6ea811e99%7Cb39138ca3ce=
e4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636954237621231884&amp;sdata=3D9n4InlHNbbuO=
AU%2FGqSuKN3gQ8GfNT1Tmkr6etrp7Pv8%3D&amp;reserved=3D0. Expect it
>>> >to not crash the kernel and producing some output
>>> >
>>> >Reverting commit 8715ce033eb37f539e73b1570bf56404b21d46cd makes it
>>> >work for me locally. I also tested kernel
>>> >5.2.0-rc3-00024-g788a024921c4 locally (latest Linus tree) and not
>>> >seeing the issue, so maybe somewhere along the backporting process, we
>>> >failed to backport all the required patches ?
>>>=20
>>> Uh, that might indeed be the case. Could you try cherry picking the
>>> following 3 patches on top of your 4.19 tree and trying again?
>>>=20
>>> git cherry-pick d2a68c4effd821f0871d20368f76b609349c8a3b 3c0dab44e22782=
359a0a706cbce72de99a22aa75 7298e24f904224fa79eb8fd7e0fbd78950ccf2db
>>=20
>> I cant reproduce after cherry picking the 3 patches on top of 4.19.47.
>=20
> I've queued them up for 4.19. Thank for the report and testing!

Sorry for the late response. Yes, these patch-set was not supposed to be
broken in such a manner.

