Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA6E17F713
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgCJMHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:07:41 -0400
Received: from mail-eopbgr760071.outbound.protection.outlook.com ([40.107.76.71]:55201
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbgCJMHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Topcon.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRrJ/c0fREReMdLjkv30IAPBcrezHLCvkT+Vu5EPd1g=;
 b=P1JA4XVZSYld8qIC+TACqqTBXWR6PfPzieK1woXbx9CtyUVzb/FcRsXgmYjfdmCrCSMlN9236s2+zjDZB4aNqRmoHGVa4hZCWnjyqWRdZLAt5wk0nC3qrZ1/lqnMVjGV7oJsiq0ItGySg3flzfHEhn9wSwBOb3rz4eqPo32xehw=
Received: from BN6PR13CA0019.namprd13.prod.outlook.com (2603:10b6:404:10a::29)
 by BY5PR06MB6516.namprd06.prod.outlook.com (2603:10b6:a03:23b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 12:07:37 +0000
Received: from BN7NAM10FT031.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::4) by BN6PR13CA0019.outlook.office365.com
 (2603:10b6:404:10a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.8 via Frontend
 Transport; Tue, 10 Mar 2020 12:07:36 +0000
Authentication-Results: spf=permerror (sender IP is 104.40.229.156)
 smtp.mailfrom=topcon.com; st.com; dkim=pass (signature was verified)
 header.d=Topcon.com;st.com; dmarc=pass action=none header.from=topcon.com;
Received-SPF: PermError (protection.outlook.com: domain of topcon.com used an
 invalid SPF mechanism)
Received: from eu1.smtp.exclaimer.net (104.40.229.156) by
 BN7NAM10FT031.mail.protection.outlook.com (10.13.156.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 12:07:34 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43)
         by eu1.smtp.exclaimer.net (104.40.229.156) with Exclaimer Signature Manager
         ESMTP Proxy eu1.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Tue, 10 Mar 2020 12:07:36 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 37929661
X-ExclaimerImprintLatency: 1756864
X-ExclaimerImprintAction: 6cc49dd00d7a48e5b45391d526aa3dce
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZl7bo1yLBeeRwWJI8/s4khNJaAJlJmL3z6JoqnSaXhDJ155DWzMSbw22DSzxhfCJi14x94v1zVpjqTwyGdpFcqlYvCTs0x5wtVJmVCZDztVTyqo+ifduPtezjjCvTYuBNH/zwGSnXx3kxwVleKhQHq9D3JQU4ttt4Xbq5oYy8kbvYAa5vX7rruUY9ZIp5vZCKOR10gGwfjhhs3SOsbcrMQhWdPUPC2x9RZyL0KndghvgUv3HUoV57z6d379HlORfCjNM9q6CliJDtJ7mYGq+3RlosK/45X/mHuul1R1upr7ieLcqqoEju4YWU5Rccd5MG38mJescqmDHGm9xjE9Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRrJ/c0fREReMdLjkv30IAPBcrezHLCvkT+Vu5EPd1g=;
 b=cqsAz2tCXrRwBkKE4umfo91t9vOz0WMBNz7ycUrmY0yIsxROVqqIBbwMVDZqGVmC7PBGGsi5s1tpbvbobKzFW371dBL25X9UVjh600JmxUaVOEipSwmhQjt7ZbMewEjtOuu5MsJXsVvT+gZdmccs0TRzT6OiABqSq9dHJHY/SBhdbLcYMglEBNU8tihbMfZiEhgS4frlgaz/iQ9gvBX8kZSCKyYTNv+Kkf8GjhAxZV3TvwALSEQFXwG2ggvcQkA7AW6J4O/mchjjlRvnMyESGAbBvlAuDeWwYsTX5kuhbxB4t/LXSJDso0VhA7V3bTbN3ED21cdwoG5u1GhHW7J0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=topcon.com; dmarc=pass action=none header.from=topcon.com;
 dkim=pass header.d=topcon.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Topcon.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRrJ/c0fREReMdLjkv30IAPBcrezHLCvkT+Vu5EPd1g=;
 b=P1JA4XVZSYld8qIC+TACqqTBXWR6PfPzieK1woXbx9CtyUVzb/FcRsXgmYjfdmCrCSMlN9236s2+zjDZB4aNqRmoHGVa4hZCWnjyqWRdZLAt5wk0nC3qrZ1/lqnMVjGV7oJsiq0ItGySg3flzfHEhn9wSwBOb3rz4eqPo32xehw=
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=NShubin@topcon.com; 
Received: from MN2PR06MB5742.namprd06.prod.outlook.com (2603:10b6:208:131::32)
 by MN2PR06MB6157.namprd06.prod.outlook.com (2603:10b6:208:db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 12:07:30 +0000
Received: from MN2PR06MB5742.namprd06.prod.outlook.com
 ([fe80::966:ebec:f6b2:111a]) by MN2PR06MB5742.namprd06.prod.outlook.com
 ([fe80::966:ebec:f6b2:111a%5]) with mapi id 15.20.2793.018; Tue, 10 Mar 2020
 12:07:29 +0000
Date:   Tue, 10 Mar 2020 15:08:46 +0300
From:   Nikita Shubin <nshubin@topcon.com>
To:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Cc:     stable@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v5] remoteproc: Fix NULL pointer dereference in
 rproc_virtio_notify
Message-ID: <20200310120846.GA19430@topcon.com>
References: <20200306070325.15232-1-NShubin@topcon.com>
 <20200306072452.24743-1-NShubin@topcon.com>
 <6c7ef4f2-6f71-c2fb-b2e9-ad7cbeb7cfbc@st.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c7ef4f2-6f71-c2fb-b2e9-ad7cbeb7cfbc@st.com>
X-ClientProxiedBy: AM0PR01CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::18) To MN2PR06MB5742.namprd06.prod.outlook.com
 (2603:10b6:208:131::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from topcon.com (193.232.110.5) by AM0PR01CA0077.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 12:07:28 +0000
X-Originating-IP: [193.232.110.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef8f2d71-5414-4885-9014-08d7c4eb9f5e
X-MS-TrafficTypeDiagnostic: MN2PR06MB6157:|BY5PR06MB6516:
X-Microsoft-Antispam-PRVS: <BY5PR06MB6516409F747976E419FB3F16D9FF0@BY5PR06MB6516.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;OLM:5797;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(376002)(366004)(39860400002)(189003)(199004)(2616005)(956004)(6666004)(186003)(86362001)(1076003)(54906003)(16526019)(45080400002)(316002)(66946007)(4326008)(8676002)(36756003)(2906002)(55016002)(5660300002)(33656002)(26005)(8886007)(66556008)(66476007)(52116002)(81166006)(81156014)(7696005)(6916009)(8936002)(53546011)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR06MB6157;H:MN2PR06MB5742.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: topcon.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ySLfDcsoYXlGh+WuO3BwRb+MnF/H9bUwu0b0wD+CKinEGRPlzWAI3Gs8IAyyzFeSiTW4LVCflHirDwoJ9eDoLaLagRqmbxMt6s2ta+cOGvUEsUCow0Vnq8zsVk1pmkXXrlUla72LwImrjT5WsaRzm8+qY5ICMILAMZDmC7uYcayGOQ1JirRbjhkfzk/HRtkCuYc4uTqLIM8RwRvIx3ATuNlKEfee0Fo4ZruRva8x8WGKm21mMm/6mBA4myBd2ff7WFLXEB8T0fjOF5fUkAfsVKbj0NnYVvrWTLD2E4d3AbvLhYZ3vyfAX++U/hcwZJ75KHz8Np8bStvgkuYnUpzv/cEREavedRN0ZXb2MZAbHD3jOvxa6JbYDs/QG2i/jD0wYpsuX1J/YGS4YM8TBQhYQVNeqMyBmEIuU4QVHXYSVM2pK6vbaOvyDwZ+oGigZzvd
X-MS-Exchange-AntiSpam-MessageData: g2BIUcKFoklahZkBgVNQdMJfkU2SMMNMOTFHmSBs6oM7+a+XQoch9h5jL9Kdq1uFmj8KOwLxRhxakUbJgu+FhZMSMbsEhRMmHawHu+wObOb4Y9/5TPW/O/jSDRl9iWXRZOGMQ8ovhqSM+mTrUAMSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB6157
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN7NAM10FT031.eop-nam10.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:104.40.229.156;IPV:CAL;SCL:-1;CTRY:NL;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39860400002)(346002)(448002)(199004)(189003)(7696005)(336012)(26826003)(956004)(16526019)(186003)(26005)(2616005)(478600001)(45080400002)(53546011)(55016002)(54906003)(316002)(4326008)(86362001)(36756003)(8886007)(7636002)(5660300002)(246002)(8936002)(70206006)(70586007)(8676002)(7596002)(6916009)(2906002)(33656002)(6666004)(1076003)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR06MB6516;H:eu1.smtp.exclaimer.net;FPR:;SPF:PermError;LANG:en;PTR:eu1.smtp.exclaimer.net;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: a5a34a1d-82ea-44bc-af2a-08d7c4eb9b22
X-Forefront-PRVS: 033857D0BD
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ucnueL36+K9FO7Nf5lj34WXryPUMNvNhTOB70Z5Qt2LeZNWx7/nSmETTG5/Qij033BEs37xtrqeWnZXxZrzW/vjuJt5XxE/fxsWLpJdzeeasoS+VcLBT7w6ZvQnF5V6blf6YGQP51xvtM7KTOEaire+KxqsrUHiCbcO50RJWu4ZN4ch+al8Hp7AyDoZhyHI0vRaGW6AIj48gHuieTZcSUj1oE9uj1uw6L65+LVWCMkH8LCZ45WeTPx939nVwsOE10XLV2nDhw1VuNIdUstzp8kFf6VR98mWdVDF++2cjuf5TV7Mq3/PtgpfATH3Zw5OHQ9wyZBPWzswNF7WIGITiZIyTQIXfQ1BQtOrT6khRviqJ1XT+Amquq0Na+7ur42IfP0mDvIL5N1Jz96K1SHoSgzPtaSZDrMHzjh3UCxz3KcpLgu8osbGkvt7wIh0gytTC
X-OriginatorOrg: Topcon.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 12:07:34.0924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8f2d71-5414-4885-9014-08d7c4eb9f5e
X-MS-Exchange-CrossTenant-Id: 96c2c3ba-19d3-47b6-ba0b-8f7471bd1f14
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=96c2c3ba-19d3-47b6-ba0b-8f7471bd1f14;Ip=[104.40.229.156];Helo=[eu1.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR06MB6516
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 03:22:24PM +0100, Arnaud POULIQUEN wrote:
> Hi, 
> 
> sorry for the late answer...
> 
> On 3/6/20 8:24 AM, Nikita Shubin wrote:
> > Undefined rproc_ops .kick method in remoteproc driver will result in
> > "Unable to handle kernel NULL pointer dereference" in rproc_virtio_notify, 
> > after firmware loading if:
> > 
> >  1) .kick method wasn't defined in driver
> >  2) resource_table exists in firmware and has "Virtio device entry" defined
> > 
> > Let's refuse to register an rproc-induced virtio device if no kick method was
> > defined for rproc.
> > 
> > [   13.180049][  T415] 8<--- cut here ---
> > [   13.190558][  T415] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > [   13.212544][  T415] pgd = (ptrval)
> > [   13.217052][  T415] [00000000] *pgd=00000000
> > [   13.224692][  T415] Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
> > [   13.231318][  T415] Modules linked in: rpmsg_char imx_rproc virtio_rpmsg_bus rpmsg_core [last unloaded: imx_rproc]
> > [   13.241687][  T415] CPU: 0 PID: 415 Comm: unload-load.sh Not tainted 5.5.2-00002-g707df13bbbdd #6
> > [   13.250561][  T415] Hardware name: Freescale i.MX7 Dual (Device Tree)
> > [   13.257009][  T415] PC is at 0x0
> > [   13.260249][  T415] LR is at rproc_virtio_notify+0x2c/0x54
> > [   13.265738][  T415] pc : [<00000000>]    lr : [<8050f6b0>]    psr: 60010113
> > [   13.272702][  T415] sp : b8d47c48  ip : 00000001  fp : bc04de00
> > [   13.278625][  T415] r10: bc04c000  r9 : 00000cc0  r8 : b8d46000
> > [   13.284548][  T415] r7 : 00000000  r6 : b898f200  r5 : 00000000  r4 : b8a29800
> > [   13.291773][  T415] r3 : 00000000  r2 : 990a3ad4  r1 : 00000000  r0 : b8a29800
> > [   13.299000][  T415] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > [   13.306833][  T415] Control: 10c5387d  Table: b8b4806a  DAC: 00000051
> > [   13.313278][  T415] Process unload-load.sh (pid: 415, stack limit = 0x(ptrval))
> > [   13.320591][  T415] Stack: (0xb8d47c48 to 0xb8d48000)
> > [   13.325651][  T415] 7c40:                   b895b680 00000001 b898f200 803c6430 b895bc80 7f00ae18
> > [   13.334531][  T415] 7c60: 00000035 00000000 00000000 b9393200 80b3ed80 00004000 b9393268 bbf5a9a2
> > [   13.343410][  T415] 7c80: 00000e00 00000200 00000000 7f00aff0 7f00a014 b895b680 b895b800 990a3ad4
> > [   13.352290][  T415] 7ca0: 00000001 b898f210 b898f200 00000000 00000000 7f00e000 00000001 00000000
> > [   13.361170][  T415] 7cc0: 00000000 803c62e0 80b2169c 802a0924 b898f210 00000000 00000000 b898f210
> > [   13.370049][  T415] 7ce0: 80b9ba44 00000000 80b9ba48 00000000 7f00e000 00000008 80b2169c 80400114
> > [   13.378929][  T415] 7d00: 80b2169c 8061fd64 b898f210 7f00e000 80400744 b8d46000 80b21634 80b21634
> > [   13.387809][  T415] 7d20: 80b2169c 80400614 80b21634 80400718 7f00e000 00000000 b8d47d7c 80400744
> > [   13.396689][  T415] 7d40: b8d46000 80b21634 80b21634 803fe338 b898f254 b80fe76c b8d32e38 990a3ad4
> > [   13.405569][  T415] 7d60: fffffff3 b898f210 b8d46000 00000001 b898f254 803ffe7c 80857a90 b898f210
> > [   13.414449][  T415] 7d80: 00000001 990a3ad4 b8d46000 b898f210 b898f210 80b17aec b8a29c20 803ff0a4
> > [   13.423328][  T415] 7da0: b898f210 00000000 b8d46000 803fb8e0 b898f200 00000000 80b17aec b898f210
> > [   13.432209][  T415] 7dc0: b8a29c20 990a3ad4 b895b900 b898f200 8050fb7c 80b17aec b898f210 b8a29c20
> > [   13.441088][  T415] 7de0: b8a29800 b895b900 b8a29a04 803c5ec0 b8a29c00 b898f200 b8a29a20 00000007
> > [   13.449968][  T415] 7e00: b8a29c20 8050fd78 b8a29800 00000000 b8a29a20 b8a29c04 b8a29820 b8a299d0
> > [   13.458848][  T415] 7e20: b895b900 8050e5a4 b8a29800 b8a299d8 b8d46000 b8a299e0 b8a29820 b8a299d0
> > [   13.467728][  T415] 7e40: b895b900 8050e008 000041ed 00000000 b8b8c440 b8a299d8 b8a299e0 b8a299d8
> > [   13.476608][  T415] 7e60: b8b8c440 990a3ad4 00000000 b8a29820 b8b8c400 00000006 b8a29800 b895b880
> > [   13.485487][  T415] 7e80: b8d47f78 00000000 00000000 8050f4b4 00000006 b895b890 b8b8c400 008fbea0
> > [   13.494367][  T415] 7ea0: b895b880 8029f530 00000000 00000000 b8d46000 00000006 b8d46000 008fbea0
> > [   13.503246][  T415] 7ec0: 8029f434 00000000 b8d46000 00000000 00000000 8021e2e4 0000000a 8061fd0c
> > [   13.512125][  T415] 7ee0: 0000000a b8af0c00 0000000a b8af0c40 00000001 b8af0c40 00000000 8061f910
> > [   13.521005][  T415] 7f00: 0000000a 80240af4 00000002 b8d46000 00000000 8061fd0c 00000002 80232d7c
> > [   13.529884][  T415] 7f20: 00000000 b8d46000 00000000 990a3ad4 00000000 00000006 b8a62d80 008fbea0
> > [   13.538764][  T415] 7f40: b8d47f78 00000000 b8d46000 00000000 00000000 802210c0 b88f2900 00000000
> > [   13.547644][  T415] 7f60: b8a62d80 b8a62d80 b8d46000 00000006 008fbea0 80221320 00000000 00000000
> > [   13.556524][  T415] 7f80: b8af0c00 990a3ad4 0000006c 008fbea0 76f1cda0 00000004 80101204 00000004
> > [   13.565403][  T415] 7fa0: 00000000 80101000 0000006c 008fbea0 00000001 008fbea0 00000006 00000000
> > [   13.574283][  T415] 7fc0: 0000006c 008fbea0 76f1cda0 00000004 00000006 00000006 00000000 00000000
> > [   13.583162][  T415] 7fe0: 00000004 7ebaf7d0 76eb4c0b 76e3f206 600d0030 00000001 00000000 00000000
> > [   13.592056][  T415] [<8050f6b0>] (rproc_virtio_notify) from [<803c6430>] (virtqueue_notify+0x1c/0x34)
> > [   13.601298][  T415] [<803c6430>] (virtqueue_notify) from [<7f00ae18>] (rpmsg_probe+0x280/0x380 [virtio_rpmsg_bus])
> > [   13.611663][  T415] [<7f00ae18>] (rpmsg_probe [virtio_rpmsg_bus]) from [<803c62e0>] (virtio_dev_probe+0x1f8/0x2c4)
> > [   13.622022][  T415] [<803c62e0>] (virtio_dev_probe) from [<80400114>] (really_probe+0x200/0x450)
> > [   13.630817][  T415] [<80400114>] (really_probe) from [<80400614>] (driver_probe_device+0x16c/0x1ac)
> > [   13.639873][  T415] [<80400614>] (driver_probe_device) from [<803fe338>] (bus_for_each_drv+0x84/0xc8)
> > [   13.649102][  T415] [<803fe338>] (bus_for_each_drv) from [<803ffe7c>] (__device_attach+0xd4/0x164)
> > [   13.658069][  T415] [<803ffe7c>] (__device_attach) from [<803ff0a4>] (bus_probe_device+0x84/0x8c)
> > [   13.666950][  T415] [<803ff0a4>] (bus_probe_device) from [<803fb8e0>] (device_add+0x444/0x768)
> > [   13.675572][  T415] [<803fb8e0>] (device_add) from [<803c5ec0>] (register_virtio_device+0xa4/0xfc)
> > [   13.684541][  T415] [<803c5ec0>] (register_virtio_device) from [<8050fd78>] (rproc_add_virtio_dev+0xcc/0x1b8)
> > [   13.694466][  T415] [<8050fd78>] (rproc_add_virtio_dev) from [<8050e5a4>] (rproc_start+0x148/0x200)
> > [   13.703521][  T415] [<8050e5a4>] (rproc_start) from [<8050e008>] (rproc_boot+0x384/0x5c0)
> > [   13.711708][  T415] [<8050e008>] (rproc_boot) from [<8050f4b4>] (state_store+0x3c/0xc8)
> > [   13.719723][  T415] [<8050f4b4>] (state_store) from [<8029f530>] (kernfs_fop_write+0xfc/0x214)
> > [   13.728348][  T415] [<8029f530>] (kernfs_fop_write) from [<8021e2e4>] (__vfs_write+0x30/0x1cc)
> > [   13.736971][  T415] [<8021e2e4>] (__vfs_write) from [<802210c0>] (vfs_write+0xac/0x17c)
> > [   13.744985][  T415] [<802210c0>] (vfs_write) from [<80221320>] (ksys_write+0x64/0xe4)
> > [   13.752825][  T415] [<80221320>] (ksys_write) from [<80101000>] (ret_fast_syscall+0x0/0x54)
> > [   13.761178][  T415] Exception stack(0xb8d47fa8 to 0xb8d47ff0)
> > [   13.766932][  T415] 7fa0:                   0000006c 008fbea0 00000001 008fbea0 00000006 00000000
> > [   13.775811][  T415] 7fc0: 0000006c 008fbea0 76f1cda0 00000004 00000006 00000006 00000000 00000000
> > [   13.784687][  T415] 7fe0: 00000004 7ebaf7d0 76eb4c0b 76e3f206
> > [   13.790442][  T415] Code: bad PC value
> > [   13.839214][  T415] ---[ end trace 1fe21ecfc9f28852 ]---
> > 
> > Signed-off-by: Nikita Shubin <NShubin@topcon.com>
> > Fixes: 7a186941626d ("remoteproc: remove the single rpmsg vdev limitation")
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/remoteproc/remoteproc_virtio.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> > index 8c07cb2ca8ba..31a62a0b470e 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -334,6 +334,13 @@ int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
> >  	struct rproc_mem_entry *mem;
> >  	int ret;
> >  
> > +	if (rproc->ops->kick == NULL) {
> > +		ret = -EINVAL;
> > +		dev_err(dev, ".kick method not defined for %s",
> > +				rproc->name);
> > +		goto out;
> > +	}
> > +
> Should the kick ops be mandatory for all the platforms? How about making it optional instead?

Hi, Arnaud.

It is not mandatory, currently it must be provided if specified vdev
entry is in resourse table. Otherwise it looks like there is no point in
creating vdev.


> 
> Regards,
> Arnaud
> 
> >  	/* Try to find dedicated vdev buffer carveout */
> >  	mem = rproc_find_carveout_by_name(rproc, "vdev%dbuffer", rvdev->index);
> >  	if (mem) {
> > 
