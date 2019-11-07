Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3337F3B93
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 23:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfKGWlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 17:41:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbfKGWlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 17:41:21 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA7MbC4Z006074;
        Thu, 7 Nov 2019 14:41:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LwSqnGOWi7B8Zb3zbZ3d7k6vAFY4kLQ/KE1zsYJ0HAE=;
 b=EUszkNc7ZeQr3q6w6pPcDUuwUUMFY5LKOkmQfWuqpuTmiUbPLZeSLixaRYixZMLCP28y
 DEhNxnoVxFqT1LO5+Z6rCHjUfOG5pjF9mnvZRf+W2DWhR3RuRQJGXFwTfWCmY/TnWJnk
 BJ7j/cQH0FzpU2T1VFHfyi5fGI7hn4Yl5Oo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w4tyjgfcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 14:41:16 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 14:41:15 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 14:41:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB0qg/C1CqmcraCRL0TvQAm0AesZ7UGmrGAtGhA3JHcTOQPK8AJE4g5YU6WewA2HBhC81GWLJnaDWZB7BtEyoXdWhA39CiSZtgsOBU0nxI+ufPxUvpABpkNA7XKW7EJCacC2nry9/tiPTpbrdvihRFu+QcET8gTbg8HoGOxR9EPmBwhf9i9XWBlTRu+9uzVZmUAUiNZiXf0Zhs1Qx1SzxgXchWkzPWyrLxFAebY/TBY2dcpYYUGuwXrjiYnMZk+Cb9XDEWOegk1RoMJrYBYBCVMXtjU33vpz8AZxnlZSmiAaUBVmwS2HhI6zcLSLz1+4FdYq2a/DXhhoWL3bVh/QNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwSqnGOWi7B8Zb3zbZ3d7k6vAFY4kLQ/KE1zsYJ0HAE=;
 b=jW1rq3M/yDKGHAI5DeUZ63vjPZegtfGSjN26sfdu5FvU9KEJpQ4z6ExDjGJ9vhb9LQ8JW3cuq1QKDj16SOQ33q8WAnmkxi8ItjfAy7yDDFJiaaeuiN58R9jXyG5YgKr8JVcznbgXUduv8sRdBeFDFtnow8MN2a210urnHlxK6YbSs5uMwPFgwARqP1rz282Wu6jarl7K7Xtowfacykity8X61Ri2agL1vAiwGYgdRq+1bQyNrUfsssD0f/RODj7VAGdg9cPNtHufU+N672AN7oz76J460BAOtX6kkYmauLY4uLGWi5T92es/LCFQHqqZH5H4d0oCfX0puC/zZ3/JTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwSqnGOWi7B8Zb3zbZ3d7k6vAFY4kLQ/KE1zsYJ0HAE=;
 b=ggoU9cFvdszlA5yRxq4r3DaFK/zgX1naytUe2trsUb5F5bOGz1Q/KfkMiF9HorKmlO+lslhtUNQU/GuAFzqhy0ORqWaZLtGMvjnagbK575/mJm+udMri043IxyzpOoRbjrcVUWCvxY77vW1qVHIeDMk9CKv3U60C8IIaPXdJZF0=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2756.namprd15.prod.outlook.com (20.179.139.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 22:41:13 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0%6]) with mapi id 15.20.2430.023; Thu, 7 Nov 2019
 22:41:13 +0000
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
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/Kd/odWAgABI+QCAAAVsAIAAXr+A
Date:   Thu, 7 Nov 2019 22:41:13 +0000
Message-ID: <20191107224107.GA8219@castle.DHCP.thefacebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107122125.GS8314@dhcp22.suse.cz>
 <20191107164236.GB2919@castle.dhcp.thefacebook.com>
 <20191107170200.GX8314@dhcp22.suse.cz>
In-Reply-To: <20191107170200.GX8314@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:300:ee::30) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5002]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35b97961-fba7-4796-44bb-08d763d397ce
x-ms-traffictypediagnostic: BN8PR15MB2756:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB275652D8D3886335414E7A48BE780@BN8PR15MB2756.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39860400002)(396003)(366004)(189003)(199004)(305945005)(186003)(81166006)(99286004)(7736002)(476003)(486006)(6486002)(46003)(66476007)(64756008)(33656002)(81156014)(1076003)(71190400001)(66446008)(66556008)(66946007)(446003)(8676002)(478600001)(11346002)(86362001)(71200400001)(256004)(4326008)(76176011)(6116002)(54906003)(386003)(6506007)(8936002)(102836004)(316002)(9686003)(2906002)(5660300002)(52116002)(6436002)(14454004)(6246003)(25786009)(6916009)(229853002)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2756;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+TLgiSS5K47WcO8oPPSQv7g2py5j51tTANM+k6eJ8DdTIKeNdSOjpMzGi+yrA9GxazHnvsEPnQ1OypAz4+/ue4f2SjYi57IyHVj2FmGTv4W6mkyMbYwTSSt+InixW1u/2T9AZO4bHWzAAP3GZfGgTdQEzSFmixhbsObRrVDSaMjixNST2dvXg35y0sSXiVMZWbRVvFlO2+WIYCjYzyZSSI0cBld3i7RoGeOD3iMFhA7r2Yl/lHLw863q+KwnFErZWjwMNUkAc6PmoZ05OVrNwGycN3c8L2A0LOqT7JKDzKs5wURjMnyfGwodwec85Jr5vnQZHeKtf9mg0KzoGIRjsPtJrWS0tsWWZxdvfz9l9setDZ+Jji1S8Gbhs4wl0VQA/WzGlTEsEape6JDTbzgUObewn3f5kiDv+IKkA0DZ956qTR+pk/Eyqc3CfP1aEp/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37FC4BAB3B6F8C458F00D810EB53DFDE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b97961-fba7-4796-44bb-08d763d397ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:13.6569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DUzY16LztemHiJcKkepJi3Z6uWiVFexKPbxPR6ZCOJSS/ERrOjeN+xS3SywVeA+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2756
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=904 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070207
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 06:02:00PM +0100, Michal Hocko wrote:
> On Thu 07-11-19 16:42:41, Roman Gushchin wrote:
> > On Thu, Nov 07, 2019 at 01:21:25PM +0100, Michal Hocko wrote:
> > > On Wed 06-11-19 14:51:30, Roman Gushchin wrote:
> > > > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> > > >=20
> > > >  rcu: INFO: rcu_sched self-detected stall on CPU
> > > >  rcu: 33-....: (21000 ticks this GP) idle=3D6c6/1/0x400000000000000=
2 softirq=3D35441/35441 fqs=3D5017
> > > >  (t=3D21031 jiffies g=3D324821 q=3D95837) NMI backtrace for cpu 33
> > > >  <...>
> > > >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> > > >  <...>
> > > >  __memcg_kmem_charge+0x55/0x140
> > > >  __alloc_pages_nodemask+0x267/0x320
> > > >  pipe_write+0x1ad/0x400
> > > >  new_sync_write+0x127/0x1c0
> > > >  __kernel_write+0x4f/0xf0
> > > >  dump_emit+0x91/0xc0
> > > >  writenote+0xa0/0xc0
> > > >  elf_core_dump+0x11af/0x1430
> > > >  do_coredump+0xc65/0xee0
> > > >  ? unix_stream_sendmsg+0x37d/0x3b0
> > > >  get_signal+0x132/0x7c0
> > > >  do_signal+0x36/0x640
> > > >  ? recalc_sigpending+0x17/0x50
> > > >  exit_to_usermode_loop+0x61/0xd0
> > > >  do_syscall_64+0xd4/0x100
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >=20
> > > > The problem is caused by an exiting task which is associated with
> > > > an offline memcg.
> > >=20
> > > Hmm, how can we have a task in an offline memcg? I thought that any
> > > existing task will prevent cgroup removal from proceeding. Is this so=
me
> > > sort of race where the task managed to disassociate from the cgroup
> > > while there is still a binding to a memcg existing? What am I missing=
?
> >=20
> > It's an exiting task with the PF_EXITING flag set and it's in their lat=
e stages
> > of life.
>=20
> This is a signal delivery path AFAIU (get_signal) and the coredumping
> happens before do_exit. My understanding is that that unlinking
> happens from cgroup_exit. So either I am misreading the backtrace or
> there is some other way to leave cgroups or there is something more
> going on.

Yeah, you're right. I have no better explanation for this and the similar,
mentioned in the commit bsd accounting issue, than some very rare race cond=
ition
that allows cgroups to be offlined with a task inside.

I'll think more about it.

Thanks, it's a really good question.

>=20
> JFTR I am not really disputing the patch but I simply do not understand
> how the problem really happened.
>=20
> --=20
> Michal Hocko
> SUSE Labs
