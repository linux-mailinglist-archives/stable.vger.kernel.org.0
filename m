Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B02F34CF
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 17:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbfKGQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 11:42:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26240 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfKGQmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 11:42:50 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7GObtf013933;
        Thu, 7 Nov 2019 08:42:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MEgNoqGwl/5kCdJmC3YLZn1K5KZXcc9VcNRMI5/2KYs=;
 b=TbWn3rPEPi8wV+KWs8hWy7a20UUjOPLJo0tkETUN16UelpFzFXeaZSNW25ARtvLLmyLo
 HaTqAZZ78oDg3HsaADh2e7BlmWZ0J+R992uv0El2/rW6w1qnNAHEx0RUQJU5gxH41ZJr
 MpWvhA3Zvm9Fqx474Jh3ie6oWaZLr0b99tY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0p2pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 08:42:44 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 08:42:43 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 08:42:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+s6QXWkvkPSaYX2YahVbtcFJjIZ45hf1J8wKODT2iK/8vCNhoNrXVrJr7B+Uc2uu3HCqU4669kJ4jQzWh6anslxhr8E859kV+L9hRu1H6ZTclAA3b46rUTDHg8iFMXPxQ2N7CfDsXTOOB0bjfQ9IzWPgb5iWMDIfZifqOlXrWhnAgjRvgW+0qWewUDu+XONgk25zO7GjqS8TqV1DMel8M/MV33ssDqYVS0AV3ZxyJyrZoUpW7cCoV6KAftLxoU1porEAUOkcsOfeaBId2D3f92mSzD+ljYzjVOQjISAfGcbU2UoBgWOEp8nDIxYhQCfEfldjdn/ARky2Vj9QifMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEgNoqGwl/5kCdJmC3YLZn1K5KZXcc9VcNRMI5/2KYs=;
 b=bJZml34xKGwJIYNZkTwM974fc5BI7/d3vOBeEoEqNmQeIsyFbl0PVXdB+29oPKaIwAcqmEy0EBXNJYfL3JvncWY53BsSWKCWO5ya8hKrRDFpy1yVQqfRpA2hiJNzY7ZM7oIH68xGA6glwm/CR4FRSP5ae2dXLo9RJ6lkXQDqFaPB7DeTpV0b+eAmTorC4xXdR72hgiFd7HrEHGQlCmrkkOBA6HPEJst/g9YJaDrpGOzfHBCIgObMRCtoIQyNcZ0TmKc1RyCiqQuucUZn/c7wSehv/1Efn5Vi+AkVmhSTBj6niE7OAvjDrRjTTJhiWTD0oJPv1I1ySp2QFjE7+NzSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEgNoqGwl/5kCdJmC3YLZn1K5KZXcc9VcNRMI5/2KYs=;
 b=T01/LSstuBG7YaHfEm+zCa1HOwdcgYwey12Zthg54q++kwP732rVX7BWQwPrRG+fWVpOfslPvFHq7S+pXQhyk0E+Jw7JsspzXPUta7ybyv2J2GkhUNyCXlDtncn6S9fTx8Of1anpkNZcjOxV9zI4fcM1/W/Pj+dW4Jin0ngZ+2c=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2530.namprd15.prod.outlook.com (20.179.139.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 16:42:41 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0%6]) with mapi id 15.20.2430.023; Thu, 7 Nov 2019
 16:42:41 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Topic: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/Kd/odWAgABI+QA=
Date:   Thu, 7 Nov 2019 16:42:41 +0000
Message-ID: <20191107164236.GB2919@castle.dhcp.thefacebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107122125.GS8314@dhcp22.suse.cz>
In-Reply-To: <20191107122125.GS8314@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0052.namprd19.prod.outlook.com
 (2603:10b6:300:94::14) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8c0f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c2c3c63-afaf-4c40-4e24-08d763a181cc
x-ms-traffictypediagnostic: BN8PR15MB2530:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB2530D7D4F13487ACEC2EA11CBE780@BN8PR15MB2530.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(136003)(346002)(199004)(189003)(7736002)(6436002)(1076003)(305945005)(102836004)(446003)(76176011)(52116002)(386003)(6506007)(11346002)(316002)(476003)(486006)(6916009)(46003)(54906003)(2906002)(5660300002)(71190400001)(33656002)(186003)(8936002)(71200400001)(6116002)(8676002)(86362001)(81166006)(81156014)(256004)(4326008)(99286004)(478600001)(229853002)(25786009)(66476007)(66446008)(64756008)(66556008)(66946007)(9686003)(6512007)(14454004)(6246003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2530;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMeCPa5DEQyGkPifPfwHTSO1RNmjn6BYhUhMaR4FZNKtAuo0BKP/ddRyOf6KGTjKccOnbl90FC9jQkYTT3hM3j5AypaypynrPjWZOOFGtVoFUES2VYbWirr1jZV69/P8sSBKkoL0sTsh5odKdwyZ/XCmqI1DQpVXMVEYJgpjE3GUzRL+gxHOaCVh9l3r8qhph1k0X+giAdd3/F4DH1HhPxdMHH0ZKN3p/RaI8puqIXp4xCV8GrHJRVZY85/23T5Q4OJwZH2IfrDB8PYSVODnALBubGXBD5V1QGUcMgmXY0Pi8fGsVsyG6A7mLY4HvMwdXD7jYEZ1FNxqB/W3NXbYvM3YdAnYApA5O7C2wys51SBwZTT0bvVfrLd7iqaXbbsKX8WYnt0GvZ4admrwceDKRA1O4qtY133ZX6egujocsAnpyszaNlyvELppWeB7/Pwo
Content-Type: text/plain; charset="us-ascii"
Content-ID: <409B6DC1851DFF4BACC2C54170799C66@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2c3c63-afaf-4c40-4e24-08d763a181cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 16:42:41.6258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jpEZ9YQN9tvfkt839Cay2p49joNFIheOvthAQZGYLRucYME4FGvXFMX6bieSojn7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2530
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=655
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070156
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 01:21:25PM +0100, Michal Hocko wrote:
> On Wed 06-11-19 14:51:30, Roman Gushchin wrote:
> > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> >=20
> >  rcu: INFO: rcu_sched self-detected stall on CPU
> >  rcu: 33-....: (21000 ticks this GP) idle=3D6c6/1/0x4000000000000002 so=
ftirq=3D35441/35441 fqs=3D5017
> >  (t=3D21031 jiffies g=3D324821 q=3D95837) NMI backtrace for cpu 33
> >  <...>
> >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> >  <...>
> >  __memcg_kmem_charge+0x55/0x140
> >  __alloc_pages_nodemask+0x267/0x320
> >  pipe_write+0x1ad/0x400
> >  new_sync_write+0x127/0x1c0
> >  __kernel_write+0x4f/0xf0
> >  dump_emit+0x91/0xc0
> >  writenote+0xa0/0xc0
> >  elf_core_dump+0x11af/0x1430
> >  do_coredump+0xc65/0xee0
> >  ? unix_stream_sendmsg+0x37d/0x3b0
> >  get_signal+0x132/0x7c0
> >  do_signal+0x36/0x640
> >  ? recalc_sigpending+0x17/0x50
> >  exit_to_usermode_loop+0x61/0xd0
> >  do_syscall_64+0xd4/0x100
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >=20
> > The problem is caused by an exiting task which is associated with
> > an offline memcg.
>=20
> Hmm, how can we have a task in an offline memcg? I thought that any
> existing task will prevent cgroup removal from proceeding. Is this some
> sort of race where the task managed to disassociate from the cgroup
> while there is still a binding to a memcg existing? What am I missing?

It's an exiting task with the PF_EXITING flag set and it's in their late st=
ages
of life.
