Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E0361104
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhDORTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:19:43 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:52358
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233775AbhDORTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 13:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVdMnp1x6Y+LaMNtgU9C5ct6pzNcLDDGLvSlS27E8B4=;
 b=ZFiRlmh6RDH1vyzqVS+HHrT6v2boSVC9I78b0ZLg129K4jwud5KDRgHZ46hn8hiy4f6sLBJ3sXzNKR3kAp+cey2+kfvwgovb8JIHZh/cDjcazKcCpakFCRqqBDzCwlX8hzxtvQnZXv+2Odn4ZYbwSrBF/+4Qss3fXj4Hah0/Css=
Received: from DB9PR01CA0010.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::15) by VE1PR08MB5790.eurprd08.prod.outlook.com
 (2603:10a6:800:1a9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Thu, 15 Apr
 2021 17:19:07 +0000
Received: from DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1d8:cafe::f6) by DB9PR01CA0010.outlook.office365.com
 (2603:10a6:10:1d8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Thu, 15 Apr 2021 17:19:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT007.mail.protection.outlook.com (10.152.20.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 17:19:07 +0000
Received: ("Tessian outbound 82c2d58b350b:v90"); Thu, 15 Apr 2021 17:19:06 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: df917484556ce259
X-CR-MTA-TID: 64aa7808
Received: from 4bcec324905e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5426E218-A376-4EE4-A60A-9E1A9BD6DC26.1;
        Thu, 15 Apr 2021 17:18:55 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 4bcec324905e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 15 Apr 2021 17:18:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPhOjtxDNogM6HEeabPVRGwccLjCI4LAoS5oXISrB3XkiiVc8DqRBSinh9MAv1JI5zbzItIvyFoSSWU4n6FhNs71OxCu9dXWYnDoeHh5vU3GEZs4IODMgJz+6XMm+tOhhgKEoXM5wbeChMvPTYS+KbKX/yy15XfGyorxTx7H3Qd5vIsgzZI2EEhLyhARVaZ54vJI2i/EOJMgE+BoMLsOWt2jSEGC4b7iP7UGoHFfWhJyq7fPVdLd0oOU3lM5CG5IRnnlouH+39Fb7ygDzhE319c0xQjObwNb+JtER5M6Ra1jNlMkDY5dJpKtS0/uAVTRq95Nlu8nY2YkRqEewNlt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVdMnp1x6Y+LaMNtgU9C5ct6pzNcLDDGLvSlS27E8B4=;
 b=TbkzLem0XAxPxE1pdiXw7yw9vPcHTruLLLn5g5T29nLmg+jDWLW7bDqkyJhlfA8o6X9OwFApEeDr10qeoByshK6/QEWy1bzwcF6UWRinBERHrNBuM0tPpRh8ZvmUlXwZkNvJxdlIROESbtMZN4P9mVTdr34nRJ4H44/FHAmT/E3cv/u8i9q+xS82uQGFfG3K3D/E5VFSs4wO6DhoszWrBrLkNE+yXWLk5i3hl+UTqYTstzB9jIyR+h0EO+81Eli2bEvvB9a1Jqt+oGSHKahHPE9XqreD4SEVhXmK4hAW9BfZ+IgVN/fB8wQpOnJDP19cBuZagG5grRWMxNO1A/m14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVdMnp1x6Y+LaMNtgU9C5ct6pzNcLDDGLvSlS27E8B4=;
 b=ZFiRlmh6RDH1vyzqVS+HHrT6v2boSVC9I78b0ZLg129K4jwud5KDRgHZ46hn8hiy4f6sLBJ3sXzNKR3kAp+cey2+kfvwgovb8JIHZh/cDjcazKcCpakFCRqqBDzCwlX8hzxtvQnZXv+2Odn4ZYbwSrBF/+4Qss3fXj4Hah0/Css=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB4986.eurprd08.prod.outlook.com (2603:10a6:10:e0::18)
 by DB6PR08MB2917.eurprd08.prod.outlook.com (2603:10a6:6:25::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 17:18:53 +0000
Received: from DB8PR08MB4986.eurprd08.prod.outlook.com
 ([fe80::3db6:6e76:c14e:60c4]) by DB8PR08MB4986.eurprd08.prod.outlook.com
 ([fe80::3db6:6e76:c14e:60c4%5]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 17:18:53 +0000
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
To:     Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>
Cc:     benh@kernel.crashing.org, boqun.feng@gmail.com,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        longman@redhat.com, mingo@redhat.com, peterz@infradead.org,
        stable@vger.kernel.org, nd@arm.com
References: <20210415150228.GA26439@willie-the-truck>
 <20210415162646.9882-1-alisaidi@amazon.com>
 <20210415164525.GC26594@willie-the-truck>
From:   Steve Capper <steve.capper@arm.com>
Message-ID: <44ea809d-9947-1070-9d88-5dfbc89f48c6@arm.com>
Date:   Thu, 15 Apr 2021 18:18:50 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210415164525.GC26594@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [82.20.144.136]
X-ClientProxiedBy: LO2P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::16) To DB8PR08MB4986.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02WD1B9HV2R.local (82.20.144.136) by LO2P123CA0052.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend Transport; Thu, 15 Apr 2021 17:18:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 637ebc60-5178-4196-2e47-08d90032935a
X-MS-TrafficTypeDiagnostic: DB6PR08MB2917:|VE1PR08MB5790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB579037C6BB745336518810D7814D9@VE1PR08MB5790.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: e/EyPTz+7Br1A5kS9GGCCTu27sbctKS7wNPChLIuHhAF2JPDTwG2vBLmliv9NadHvsOZmpOkveiOMhXPfd9eUBp/LMw60SiJWBe6FUhEpHRUMBVtEmnPXw3KS21AVmxZFtQbB0eU+kW6/4Iw6MSh/KrlkRdaNekeENxMLYEf1NcYgvMX0kVt09XnN65/YVcx6m1P3gFEw0+x1xSXxPlZWTPzcf/HN3LrNSP82t3FtzqkGg58fldLxXcW6FebI+7IOufyHse2OaTRpfoPFs3hZANLN04GvS/I30z1GK3SI1FZPlL1b+mXzzj7Tkc7sB+jw4dEfeJ4FdN2tnsf2cDiY/jCMzkzbWC+xn5MAaO1joFEBQOmJE2slxY/VtRNdsklTfUOXuAhel1Y/D8ReMkPhmjoJ+QiCGCygwN5Q7DUGx7xSGAbXbO7CMIv9/0lVC7VLl9aavYIOTGndrPNQklGj0I7OoyMGHEJBI9vA7RzvwrMFZYjXY4LbAnHmzZxQICfhOKQGCLm7dJ8PvL0VUiD5Ufqds2TraYzGKMYJ/KtqVZSJ+6BI6BTf1W5pAn1u1jtBJnJerO0MIr9BfWDaJylF3ynx3GJeNLmFxfY9KTk8yUEfJk2wj7PNagjIYRWtZKRbNWlWeoiv0Vse/wrMqjHCl26oLKr2XA4CT/Z/yP12bQrPj8AHXpdmKqAGSdBaDj6
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4986.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(110136005)(478600001)(2906002)(66946007)(316002)(66476007)(66556008)(4326008)(16526019)(44832011)(8936002)(956004)(2616005)(8676002)(86362001)(186003)(5660300002)(6512007)(26005)(31696002)(31686004)(6506007)(38100700002)(6486002)(36756003)(83380400001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K2ZzL0lGdVExUDVxWktid3ZaWlVtamJOamxzZGZmdHdjNVN3VWV6d3N4RGRk?=
 =?utf-8?B?Y3cyVVYvQ3c3cU02MHp1eU9INmNOeTZ6U1BtaEZQeE9Wdnc3VXFpSHJEWE5q?=
 =?utf-8?B?Rm0rdkpIZkpQZG5Qa1QxYmhzQUh1dE11eERrUFRSWUM2cGEyR0ZVS01CbDF4?=
 =?utf-8?B?Qnh2c2ZsWXNOSGVWbytOQ0dSczQ5WnZwWlRPQUpXSUVwWkNwZFc1UUNaYXBG?=
 =?utf-8?B?SmdsbEExTHJXblN1cmw4WWFsMHdZTkdpUG5oQjl3NnFHbzJPNU5kNGJjWkRw?=
 =?utf-8?B?MXEydDZsNUNFY0J5U2JEZEpJeUI2UDY5SkQ3SjE2UWE0bSt5bDRXUDJZckRV?=
 =?utf-8?B?NW1IbVNZZmFUWTBxYlFkNy9HK1lsMHVPcXpTa2h0a2JrdDl4RGlTZTNhQTdp?=
 =?utf-8?B?bGI2VStrVHlWSzY0VmkyMFVHang0aXBKZFpLcjJ0WWZSdEY4MnVxVGF6MTk3?=
 =?utf-8?B?bnNzTEYrKysrbEVYbUVkcncyUGNiR3Q2akQwbms4cEtEVCtVNHZ6Wncxa3ZN?=
 =?utf-8?B?WGpjNWVoU3YwbHFQdlYzK0F4NGNzQm9pL3cwOElGQndoc1FUTGtrK2JnK2Zh?=
 =?utf-8?B?OFhDU1ZwRllsQ0FGK2J1eXdMc0NHSE9xaWRoUmhtdTl5MW11MHNNZndDT0RB?=
 =?utf-8?B?Sko4blJNK0gxMU8zeUNxYnhNTEVwZGhTTFAwNjJrNkFMcnpsWXJVSFI0Qkp3?=
 =?utf-8?B?UnFSVnFVYTI2TXZ6czJyczJiZGpHR1pmTkFTTlpQckZ1Yk1sUWZ2UUU2enI1?=
 =?utf-8?B?bndIVEJCS2NlK1RTYzY5SjlESjJPSTB2bWwzRTFRc1lZZEkwSXlJSW5aeUw4?=
 =?utf-8?B?VHd4N0VxaWJIa3B4dE5ZQ0dEdkdKdE4vMU1lWSs5U2E1SkQxSUxNU2ZBV04z?=
 =?utf-8?B?eWU2Z1ZFNktuTTBFTGp6dWhNTG5mL21IZXBZdFIzMTY3NW1SblZlb2orOGp3?=
 =?utf-8?B?NmR4VjFaT29OYTFCbk1QSFdBeFBnWFl4SUZLdlNxSGp2UVNMd1BWcURzNHJO?=
 =?utf-8?B?RFJzeUVkR3BRMXIyaHUwbmt5U254bmZDbEV6ZWwxT1ZjUmxIeFJZUDdHVHBW?=
 =?utf-8?B?cVk5bnExWkRBNEJyVnFsaFBrOHNYYjJrTDhHa2JBdXVNNG1HMGk5dGQ0Y2hO?=
 =?utf-8?B?QkdSemRvVzYrMTQ0Q3hmbDk1MVJ5QzhIcHVmQWdhc25QNVdXQmxzcUhTODdo?=
 =?utf-8?B?TjkyOSs3Y0U1ZExhZ24xd2pLdTZxR2NNQm5JYXZYWFZEanplZ2hlMWd1S1VW?=
 =?utf-8?B?VTdKRjNpZGRyR3JCS2JYYW5KYisrU1AxSXNjbU5odnlZNnphZmxmTTB3eFBa?=
 =?utf-8?B?NWZrZ2tHcFdCS3hpL0YvTTZaQmxsNjAwUDcyaXZMWFc4ZFlVdHFXSVMzQWpx?=
 =?utf-8?B?TGJ5Tmg2dXlQcE5ocGxTTGh5YUlvWUtMa1daeVAyZjhnQkJVR1ZCMEhEZFRR?=
 =?utf-8?B?Nk5PSDJpNUVuZWhyRGNVTVVvZVRvSnNPVDI2QnpFVHM2NDFCQTZ4bnM0NUIx?=
 =?utf-8?B?YlI2TTlZZHBxM0IyTlJXV2FHR0RCeFhXMWIwUXIvVVRsVFBYTTR4aUkraUZj?=
 =?utf-8?B?SG5OWG54OTJ6RmtranV5NU1pTGIzUTR5RDJqY1lBUER0NUhqTXlmZFpkUkJP?=
 =?utf-8?B?aXh2aXBLZGczYnZBZW5DTTROcEIxYmlBTzZiYWpveEdaNjhpVlQxeFJmRlJt?=
 =?utf-8?B?SHZZQlJzbWRlYjhaWVhNcXVZcnVoZnc1d1cxdGpUR1kvWmIzRk9ZN3Z6Tk0v?=
 =?utf-8?Q?O5kX34PcpD9eQWG59inzjjD8xKTDcCqN0qgYoXE?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2917
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2f7c6d7e-11e4-4a5a-750b-08d900328b05
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYXEEmdy09Qt4/x0XR4UW+gUsvzwhzgSoWzyG2yLTSPB18h5PID0ThFhW5+uSmb3c1YF0AjYFr63R7XhmY2pQ/eLQz7ueUaDqOkH0ditd/6uCn4wnLbM3LuxtNCnmIz6IzPZGci1dIxZiFBke2sRMAPVK9GOOwRY945iM8IN+vFIlDvsMkTP/f4mlh3MrdeueFLbVuYDZ0szZ8NFeElF0LhUSPnJ+qYka27EiJV4dsC9ivgPiPkw1xN68dC1qIfz1Y5VSfQWlQOb3n4JdJv6WCeqxRagQcrnWi72PO19Gy4w/T4wQAfyZRaHyV87lyX5YpD6dkrJTLTOZeXLGOg6GmgFF7RWSNF5dIJuTsvU3TM4KHORjesCHtlcC1TXJ7/tM5lx+bzzxij6XK5jDzzp4KrJSYgmgr3M/uOdClsh6bgAjlOgaZ9OJJIMm3zXolJzpBcvoNldUY0oM/bsbcz23PVUTh9pqlAGKP4ALcafMQ7hrAcLdlV80dwqRQYWBAZbw5f5JOjaEpODUpvtqMC2R61GyeX3j43upoLwMDoVyhmLgV+XpHnemdkkD0vrnKhC3culDCCrvo77+4ggN35tMRJ2AeB0T5qmujcntjClgAqw5Gowp4lZ2wmVwtmOi60A6ro2GrFlpbHosOc7S/VQW/wjhaHxdj/2A3TLhquzeUOZRbTCVl1TK63Z3e4R21tb
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(956004)(53546011)(6506007)(5660300002)(70206006)(47076005)(316002)(86362001)(31686004)(2906002)(82310400003)(6486002)(44832011)(478600001)(16526019)(83380400001)(110136005)(450100002)(8676002)(8936002)(26005)(4326008)(82740400003)(2616005)(36756003)(6512007)(186003)(336012)(36860700001)(31696002)(70586007)(81166007)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 17:19:07.0051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 637ebc60-5178-4196-2e47-08d90032935a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5790
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hiya,

On 15/04/2021 17:45, Will Deacon wrote:
> On Thu, Apr 15, 2021 at 04:26:46PM +0000, Ali Saidi wrote:
>>
>> On Thu, 15 Apr 2021 16:02:29 +0100, Will Deacon wrote:
>>> On Thu, Apr 15, 2021 at 02:25:52PM +0000, Ali Saidi wrote:
>>>> While this code is executed with the wait_lock held, a reader can
>>>> acquire the lock without holding wait_lock.  The writer side loops
>>>> checking the value with the atomic_cond_read_acquire(), but only truly
>>>> acquires the lock when the compare-and-exchange is completed
>>>> successfully which isn’t ordered. The other atomic operations from this
>>>> point are release-ordered and thus reads after the lock acquisition can
>>>> be completed before the lock is truly acquired which violates the
>>>> guarantees the lock should be making.
>>>
>>> I think it would be worth spelling this out with an example. The issue
>>> appears to be a concurrent reader in interrupt context taking and releasing
>>> the lock in the window where the writer has returned from the
>>> atomic_cond_read_acquire() but has not yet performed the cmpxchg(). Loads
>>> can be speculated during this time, but the A-B-A of the lock word
>>> from _QW_WAITING to (_QW_WAITING | _QR_BIAS) and back to _QW_WAITING allows
>>> the atomic_cmpxchg_relaxed() to succeed. Is that right?
>>
>> You're right. What we're seeing is an A-B-A problem that can allow
>> atomic_cond_read_acquire() to succeed and before the cmpxchg succeeds a reader
>> performs an A-B-A on the lock which allows the core to observe a read that
>> follows the cmpxchg ahead of the cmpxchg succeeding.
>>
>> We've seen a problem in epoll where the reader does a xchg while
>> holding the read lock, but the writer can see a value change out from under it.
>>
>> Writer                               | Reader 2
>> --------------------------------------------------------------------------------
>> ep_scan_ready_list()                 |
>> |- write_lock_irq()                  |
>>      |- queued_write_lock_slowpath()  |
>>        |- atomic_cond_read_acquire()  |
>>                                       | read_lock_irqsave(&ep->lock, flags);
>>                                       | chain_epi_lockless()
>>                                       |    epi->next = xchg(&ep->ovflist, epi);
>>                                       | read_unlock_irqrestore(&ep->lock, flags);
>>                                       |
>>           atomic_cmpxchg_relaxed()    |
>>    READ_ONCE(ep->ovflist);
> 
> 
> Please stick this in the commit message, preferably annotated a bit like
> Peter's example to show the READ_ONCE() being speculated.
> 

I can confirm that this patch fixes a problem observed in
ep_scan_ready_list(.) whereby ovflist appeared to change when the write
lock was held.

So please feel free to add:
Tested-by: Steve Capper <steve.capper@arm.com>

Also, I have spent a decent chunk of time looking at the above issue and
went through qrwlock, so FWIW, please feel free to add:
Reviewed-by: Steve Capper <steve.capper@arm.com>

Cheers,
-- 
Steve
