Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E82C24ACFF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 04:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHTC2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 22:28:03 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:53184
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgHTC17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 22:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsaggnM88m4czUCMso6kpuWWj+T7yFaPwCRBD0io6NM=;
 b=gh6SG09Zn99y4V8Q/0kK1pIHFfT1EyzhY2IhuR/2/kFIZ9d8c4JDw6I86Z97/AeNjjLcYDsjs2crohJge2IwNZdG/szs7pBxnNb1bxe0+lTKovEudOei6ppfcYtXZS2ADKs3wOyWRZ47vpq6QtKSim65XTovAhcfdh1IPHCMkmE=
Received: from DB8PR09CA0003.eurprd09.prod.outlook.com (2603:10a6:10:a0::16)
 by VE1PR08MB5872.eurprd08.prod.outlook.com (2603:10a6:800:1aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 02:27:51 +0000
Received: from DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:a0:cafe::d7) by DB8PR09CA0003.outlook.office365.com
 (2603:10a6:10:a0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend
 Transport; Thu, 20 Aug 2020 02:27:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT007.mail.protection.outlook.com (10.152.20.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 02:27:51 +0000
Received: ("Tessian outbound e8cdb8c6f386:v64"); Thu, 20 Aug 2020 02:27:50 +0000
X-CR-MTA-TID: 64aa7808
Received: from c0e2cc3f9e74.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C949F279-4654-43AA-97DD-E1BF105F6FB0.1;
        Thu, 20 Aug 2020 02:27:45 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c0e2cc3f9e74.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 20 Aug 2020 02:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLyHr7a+ROqgfIKO+HtRLI9C8OKjxxSDjt4Y5Y4E0UMikNBDX+oWsVDQ9g/Dv9zlexJiNNiRGNCS4PMmEqnE3hbmTk4QJwBSmFq9KDhBOPAzILntDbG9nNS/vRcwXYhcfhbgepivuOWmYLP33XiaLqwBzkxIHgm4YGOUr+BVWPNhjkPkq5Ug+0516uZJl/YABvtyD6Kqq8L/GReWrjJrbm0SIGgtQjZaKjCBFSHcmA/GTmmt/bs8Lvmx1W3/mq77yhz9c5dWaXYJAZPykQ91gDu78NcZtn/ow8Ya7KdLlfQK5YQX74aNQbwjOxIWfcPhLHiY0eGLM9ue7dIVkWF6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsaggnM88m4czUCMso6kpuWWj+T7yFaPwCRBD0io6NM=;
 b=EqwMR9g3RJadt3lEYsuBn0MkmVU2IstfIK2AgROg6zv3+xPGOKh0vDbZByWxJIKLjp5J12p6zr6Jvum6KGuMrvnrTeWojtH1RoO3633aRcEwzG/bXiJjjtClRAvHuehcoMwZIye8fZwOf/JSpqllPEj/fns/5keYQn6ts6VIPaKZ3cScs/+5bmHDeH4R02e6JHEHNv696YFtZI1Ys/r3QQU6uIKLmTUnteNvY0QthyYS1zrhzOMDq7MAN4/roj31Jc0ddLpsKhTZnirII8OHfB4J1f3WjY985w41KdhuN4gRZgEGGRxDHMziw4y1vkBZM3Lk7n+yWltBNXrrjeKHig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsaggnM88m4czUCMso6kpuWWj+T7yFaPwCRBD0io6NM=;
 b=gh6SG09Zn99y4V8Q/0kK1pIHFfT1EyzhY2IhuR/2/kFIZ9d8c4JDw6I86Z97/AeNjjLcYDsjs2crohJge2IwNZdG/szs7pBxnNb1bxe0+lTKovEudOei6ppfcYtXZS2ADKs3wOyWRZ47vpq6QtKSim65XTovAhcfdh1IPHCMkmE=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB3384.eurprd08.prod.outlook.com (2603:10a6:20b:4a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Thu, 20 Aug
 2020 02:27:41 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::4c55:d523:5c8c:92e7]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::4c55:d523:5c8c:92e7%4]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 02:27:41 +0000
From:   Justin He <Justin.He@arm.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
        Kaly Xin <Kaly.Xin@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dalias@libc.org" <dalias@libc.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "ysato@users.sourceforge.jp" <ysato@users.sourceforge.jp>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] mm/memory_hotplug: fix unpaired
 mem_hotplug_begin/done" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] mm/memory_hotplug: fix unpaired
 mem_hotplug_begin/done" failed to apply to 4.19-stable tree
Thread-Index: AQHWdiRDvDbVQH7NC0CoKwpwBIlaRqlAPcOw
Date:   Thu, 20 Aug 2020 02:27:40 +0000
Message-ID: <AM6PR08MB4069874E06B127B704F0D683F75A0@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <1597840117224138@kroah.com>
In-Reply-To: <1597840117224138@kroah.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5A2B46957AC7034FA87077586628E0E8.0
x-checkrecipientchecked: true
Authentication-Results-Original: linuxfoundation.org; dkim=none (message not
 signed) header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50431aa7-64ba-4d62-244c-08d844b0a312
x-ms-traffictypediagnostic: AM6PR08MB3384:|VE1PR08MB5872:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5872EA072B42D3F6BD095FB7F75A0@VE1PR08MB5872.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: RO0ulJLUfW49rQ/UnEUOb7vmPg3Bz4qBBgSMg8i7lJNmZHhwWFdf7pjt1W7WGpwgRSs6x7euH/FNzZTqCkgBrjriYvZ7hzHX6oyE7sG8qwZ1dXDkQVYtEUfLcaBulywDOHWe7ft0BIuBnZoV4tu24P1rRiaByqxzBDadzTMoFbIIlnKtojqPbryaa3CQD+XjWIvvaPGaG+OwDFRRuAA2+RBrn9h0KWIg8oV6dAcRlMGmJTBf9fsQt2WLeHr3mspZBnBf8n5P9mtfaX/w4Q9DbtXMKaOPatAWgav/YRpiTsYB5Td45VtTHnhidMrj9f/mPiA18Z5VBmTLA3mYyD7KkIqjfhj8zLdhtS9pjrREJx3324SVt34FbmKLIwboMr59qzqLPMsoNm5BYnO2LtBeksLsPflnzOe1ZW6i+FUOs2rqDxMjjQY8fSwvRwG0Byil
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(7416002)(83380400001)(4326008)(5660300002)(64756008)(2906002)(76116006)(9686003)(66476007)(186003)(6506007)(53546011)(66946007)(52536014)(66446008)(66556008)(86362001)(33656002)(55016002)(110136005)(8676002)(316002)(8936002)(7696005)(71200400001)(478600001)(26005)(966005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: OfmM/JOePK6ZbGyKdmJEutHiGtas+9QLnRBjbhq/P/CRXGHbc8wUWLEF52P70NXnvgHGJFySaoSFRdCMjmsVVFAneq73lFONZFOa6bEW8uqdtMv5CfUZyu8qtwBM4j4uw2kmLKi9vIG5H5hPmKXPa0c2UvT4NYZl8tKJVKX2lshS8+qyj2FWGpuGvVZpr5pvtglRpfvFPEqrFPMtHbesl3rc8dn7o0v1JpRCQzH4XTOdQMozHNtfhS4rnFtPsLd0TJcrxn6Bw9VCG6h609D9S8gFAgqLfg9oK1UdHOgcF5hV8TdaGM7lAkx4xyWU9zMy8nl49bd6BGXMQC7fuJPs7LCqeF0wmaTdy0vquP+lVwuXFHJWarU2Xhuxt1VpZCtKne2a/Kj+FYjbtanoLyOQpam3KqEBjGTOs+u4bqso45Wav4bhg73PPiT0AdHfLalc0NJRp1YgdZrjX40QHAEJDIyPx55TmA2qTxk2hFS7I4ALFYVNfgAowtJfvIAKP/v5ebtea8BTqMerCkoQSJFSEKRCoST0ViSFWtyS5vf9F4569KpWeXiwWCWJczMUmdZ4HDsKZIqeTezVTqbolO9FEDoXzWFdmSc6edNQ6og1kMDfXCPjEkrqDiIzQkJp9L5c2Y8S5xCJQxCYDmkpvqeUsg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3384
Original-Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 4254fe69-1aa5-428c-51a3-08d844b09cf9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zrQhjkhj3lCPAZDjgWE7EXgmS+LZgztxcJz82g6DuknJUf/p57hfakD7gyLW6pPc1uDCqbPepeFUpdY4M9ITwItW0m5Nm/7iayPf/iYAAXiDvkI3ekRYet15P6ppUjOw5CcCaM9GJooq7PpatECWowhOCxN10mShIjQB/VKHzt9jeYasOuHY2gQ73gCWuBO1gq9LYQVA6edDNSPxZxIVATgD5Fu6GF9n9cGnOFVSyXYjJCVm1tZv3N+jaP1YcTsKztPz4wL8Uv53GpC+kbPMHZzpJ6k3rAjDsOYwUb1QTmzxqxklzc34TYgfwSbYO/LfUfeEOYTvT4v0dGz1P5vw2H7bH2SE1FfBJ0q+IOJLbUUvxsYIC9fSuMZPE13vT82REBqrmJ3lqZo8SZty9RH7nmBJo1Y9QNeW6+y9n5bkusR0YAhc4mX8sflrbqdEAhngyi5SJj5U0sXau3oICuo88Q1Qwp+yrH7HTPiLvdxXd7isrxbaSx5+8BOEeVFBoupf
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966005)(70206006)(55016002)(26005)(7696005)(8676002)(83380400001)(81166007)(316002)(82740400003)(86362001)(5660300002)(52536014)(966005)(53546011)(47076004)(336012)(2906002)(478600001)(356005)(82310400002)(6506007)(186003)(4326008)(33656002)(8936002)(110136005)(70586007)(9686003)(921003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 02:27:51.3663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50431aa7-64ba-4d62-244c-08d844b0a312
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5872
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
If anybody wants to backport it to stable tree, there are 2 pre-condition f=
or
this commit ("[PATCH] mm/memory_hotplug: fix unpaired mem_hotplug_begin/don=
e")

1. eca499ab3 ("mm/hotplug: make remove_memory() interface usable") applied
in v5.2, it disabled the BUG() when check_memblock_offlined_cb() failed.
2. f1037ec0c ("mm/memory_hotplug: fix remove_memory() lockdep splat")
in v5.5, it introduced the unpair but depends on eca499ab3

I checked https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/=
tree/mm/memory_hotplug.c?h=3Dlinux-4.19.y#n1913.
Looks like stable tree v4.19 hasn't applied eca499ab3 but applied f1037ec0c=
.
Hence I don't think v4.19 needs this patch.


--
Cheers,
Justin (Jia He)



> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Wednesday, August 19, 2020 8:29 PM
> To: Justin He <Justin.He@arm.com>; Jonathan.Cameron@Huawei.com; Kaly Xin
> <Kaly.Xin@arm.com>; akpm@linux-foundation.org; bhe@redhat.com;
> bp@alien8.de; Catalin Marinas <Catalin.Marinas@arm.com>; dalias@libc.org;
> dan.j.williams@intel.com; dave.hansen@linux.intel.com;
> dave.jiang@intel.com; david@redhat.com; fenghua.yu@intel.com;
> hpa@zytor.com; hslester96@gmail.com; logang@deltatee.com; luto@kernel.org=
;
> masahiroy@kernel.org; mhocko@suse.com; mingo@redhat.com;
> peterz@infradead.org; rppt@linux.ibm.com; stable@vger.kernel.org;
> tglx@linutronix.de; tony.luck@intel.com; torvalds@linux-foundation.org;
> vishal.l.verma@intel.com; will@kernel.org; ysato@users.sourceforge.jp
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] mm/memory_hotplug: fix unpaired
> mem_hotplug_begin/done" failed to apply to 4.19-stable tree
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From b4223a510e2ab1bf0f971d50af7c1431014b25ad Mon Sep 17 00:00:00 2001
> From: Jia He <justin.he@arm.com>
> Date: Tue, 11 Aug 2020 18:32:20 -0700
> Subject: [PATCH] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done
>
> When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
> online at that time), mem_hotplug_begin/done is unpaired in such case.
>
> Therefore a warning:
>  Call Trace:
>   percpu_up_write+0x33/0x40
>   try_remove_memory+0x66/0x120
>   ? _cond_resched+0x19/0x30
>   remove_memory+0x2b/0x40
>   dev_dax_kmem_remove+0x36/0x72 [kmem]
>   device_release_driver_internal+0xf0/0x1c0
>   device_release_driver+0x12/0x20
>   bus_remove_device+0xe1/0x150
>   device_del+0x17b/0x3e0
>   unregister_dev_dax+0x29/0x60
>   devm_action_release+0x15/0x20
>   release_nodes+0x19a/0x1e0
>   devres_release_all+0x3f/0x50
>   device_release_driver_internal+0x100/0x1c0
>   driver_detach+0x4c/0x8f
>   bus_remove_driver+0x5c/0xd0
>   driver_unregister+0x31/0x50
>   dax_pmem_exit+0x10/0xfe0 [dax_pmem]
>
> Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep
> splat")
> Signed-off-by: Jia He <justin.he@arm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Cc: <stable@vger.kernel.org>[5.6+]
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Chuhong Yuan <hslester96@gmail.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Cc: Kaly Xin <Kaly.Xin@arm.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Link: http://lkml.kernel.org/r/20200710031619.18762-3-justin.he@arm.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6289a909ea36..ce3d858319bd 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1757,7 +1757,7 @@ static int __ref try_remove_memory(int nid, u64
> start, u64 size)
>   */
>  rc =3D walk_memory_blocks(start, size, NULL,
> check_memblock_offlined_cb);
>  if (rc)
> -goto done;
> +return rc;
>
>  /* remove memmap entry */
>  firmware_map_remove(start, start + size, "System RAM");
> @@ -1781,9 +1781,8 @@ static int __ref try_remove_memory(int nid, u64
> start, u64 size)
>
>  try_offline_node(nid);
>
> -done:
>  mem_hotplug_done();
> -return rc;
> +return 0;
>  }
>
>  /**

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
