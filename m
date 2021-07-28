Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185323D89C2
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 10:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbhG1I2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 04:28:20 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:7687
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235274AbhG1I2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 04:28:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFuWdbpRuJpMeOTn1shPKwxgqqEhF6cp/xuKvTYZyHIiMhslJilj0BxMjzxGCOzSfmSfMyIB/vlY/K6N2cCkkjvOfuOox266LRaUfqT+ki1cJLoNQi7EmuXTYUZIrDx7ZQKzIGx0l4d8NSopKOxRx6+tXH/xt30xUFJhHK6HRFTHxULbOIoTroGiKkoI62iOUycy6KMY8jC0Gt/senMz/sZzzW6Lvj6EFCsV+XTBIv4hlrJ1uLnJ2d7CYd+Ewvyzr3v/Dl0hmxGIEyvPBaD4HBxTn4VZ+kpqFjpoqdIefyWLFiyXP2cCUQlcE5tGg5QoqdQH76rkdgesvFalrHLxsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysyx6fcv0Ac+DHs+cy+2dJSlKqlGb1cRvNoOUcNWA3c=;
 b=IFS5JFUUIFoIpwX2QCWv9frwmrliRsE5DzWUN/RKpLkk/CiaUgFkQ1xe8T93z0MUxlYyMicpF9GwadJeD79S9cxr/Fh7Qixv8fOUJGtFwDL6Z63XY6NBhewmgy+ISdHa2NwDgnkryjsn+3xyHqtHPHps+wb7KSKMBdyPc87QEdFv+SxpqGhEh/7s2LMY3kyGwOCrxh32JXq1nvaVT2lmsgiOUjRlFo+IKpIqrijoIhX1haRYO1Rvt9M66Qw9/AB8NQLX7TE+i6d1Zenk79Y9eXH1em4HCA6AjZs5FDUAEFp6Aoo2d2qS3z9/tV+8HP3z+/WVyRop8SqDdxuqMKWzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysyx6fcv0Ac+DHs+cy+2dJSlKqlGb1cRvNoOUcNWA3c=;
 b=JdA8N/kX2qvwJhzyR2hyaXAXoQ8+M7Cm/muSK0cKiQAisk32AF3rgUtnOXWxk+LU3rNYXRC9JFbSTVPy24CXfrt+XqaRcQHGbf+DldXV/KHwQGA+SO9qYefxaHCpsg+r8mRARyMGKJ6ULp5asSr7bn42Z9iabADWZZSVGDts2bQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0401MB2559.eurprd04.prod.outlook.com (2603:10a6:800:57::8)
 by VI1PR04MB3247.eurprd04.prod.outlook.com (2603:10a6:802:8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.30; Wed, 28 Jul
 2021 08:28:14 +0000
Received: from VI1PR0401MB2559.eurprd04.prod.outlook.com
 ([fe80::1dc0:b737:bf34:46b]) by VI1PR0401MB2559.eurprd04.prod.outlook.com
 ([fe80::1dc0:b737:bf34:46b%3]) with mapi id 15.20.4352.031; Wed, 28 Jul 2021
 08:28:14 +0000
Date:   Wed, 28 Jul 2021 11:28:11 +0300
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dongas86@gmail.com,
        shawnguo@kernel.org, kernel@pengutronix.de, aford173@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] clk: imx6q: fix uart earlycon unwork
Message-ID: <YQEVG1R1IDxB8odE@ryzen>
References: <20210702085438.1988087-1-aisheng.dong@nxp.com>
 <YPVWY4h+nSP6IGZc@ryzen>
 <162741907003.2368309.8765989426815970294@swboyd.mtv.corp.google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162741907003.2368309.8765989426815970294@swboyd.mtv.corp.google.com>
X-ClientProxiedBy: VE1PR03CA0003.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::15) To VI1PR0401MB2559.eurprd04.prod.outlook.com
 (2603:10a6:800:57::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ryzen (188.26.184.129) by VE1PR03CA0003.eurprd03.prod.outlook.com (2603:10a6:802:a0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 08:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8aef85e-d733-44d7-0e16-08d951a1a440
X-MS-TrafficTypeDiagnostic: VI1PR04MB3247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB324728F42CC6C067C036EA9BF6EA9@VI1PR04MB3247.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNLjcRKyDVg84/REV6u5UVOwgYVoId4bELBcRa2SOgacY+8lWCzUoBYi6mcxNuaJPPdFtekXebXlynFXRnzx3yDmbvojuLkeOhPzcTT2gNs7T7w/zviTsXdKDnzg4iWnZ6wzNQvJLJThlDVZwvohsQd0YYKnuzUtEmvwBJdpVcENOVmRF9UUtUIDWT2u8kMySUeQB5djHjHFDyu1NgQERicFCfA7muXwuJUJX8tGi7frCOb/aTYKlCjZqRPqJSSHW37h71GNB1KYVv20emvZ2NmS/95RiBv99Jp/6VwdGE7sFYPA5jZQSfD809qCqYlaTvYMMGVjxLy4KsbmH4eTF1RP4Wz6nUBxZ/m0JYE1QCzxeIk/Yx9T58CGlwZtpNRuO5fbJZ3hL1D8SCtd2a7DM1xhfQM2g2yKba22WOfZPzD6PChPTVPazkKD9cu4knS0TeY3EY0O20UrSIcMKFf4SzQUh7H0dhIKK7PTUfB8B9q1erO+/8Yo5eC/wnFpFnm3e6E+VxW4zhz33zvgmKDr9/KeNlLEv+YBUIi7Pt4rptCtSC9dCIpb9vKUnY9DEqjjGyIAkQ/TOQnhIqNqdbOI97JE7C5f4pU3RaikHSfnC8++zSThsXT42GebTSkOXKIncwULsZENuWL9t+Q8YmlT05stF/FRYqm8cxT/IbLEwJw33gNKkh982AgfprPr4hzFKBU3cJWeGc621RSQLIAjmlez1vnmrvWxQmYEOpBSmbk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2559.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(66476007)(4326008)(66556008)(508600001)(316002)(52116002)(5660300002)(66946007)(53546011)(26005)(86362001)(9686003)(38100700002)(38350700002)(6916009)(33716001)(6496006)(9576002)(8676002)(8936002)(2906002)(83380400001)(55016002)(4744005)(186003)(44832011)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bSuGduS1wgwfOIDqYpySnv04UykDnlTJGloq8W7jt3UMRLNgPBgFoWIh4Tj7?=
 =?us-ascii?Q?RYOo+i+2xhk2z48isIr71jttpN2I6fGOzmhr4GBnv3PzHRLJAkLTruRuKhM/?=
 =?us-ascii?Q?6gduUc3aUL44EcNXLQBUljGVvRTEg1bJ8LqWoJXq+UzYG78bwwJtIaqQAUS7?=
 =?us-ascii?Q?3JK01vpFEaItqgRh+33m1jGAhdy9He8GfHQnsnUZRPllGkTf1vlBpsiuSS64?=
 =?us-ascii?Q?YjF/tDGHViFAh3BjvXymERAZn6AE4oVpA7m22b3u6ObvFxNGBvtJdRgrbA84?=
 =?us-ascii?Q?whkyVxRnrfrDYpTQ7eZveSSHqSzzer9BdR1J2SjeTZmBuy2I19ycG8fn6ZnB?=
 =?us-ascii?Q?AZQVngfVGVFybYliyufqEEgqi8Vb9KN/m8ZcxVn+hwcvG63WxaEsCHrAW76r?=
 =?us-ascii?Q?6bnib7gaG2c2ydEj7hw15mUWdG5T9qHLCS9Q1u7NJdTwROmHFfeE+DIwdqCI?=
 =?us-ascii?Q?Z7KA5bAeXwKQ0BMys8HYrv5CCVZzSsGESW4ZoHRgt+MMTDQJ2onYAVJouKFq?=
 =?us-ascii?Q?7DJ3xm/5f7phNvzp1IOCCMYMUKf9g4VqJrClyQ95yKu/8Ky3U2kh03wQiB43?=
 =?us-ascii?Q?SafvIfOxOeVjaAneGKU0+CdwMxFweRtUDsRSKVG/b1AaERo9aF4xTeR+Xjnv?=
 =?us-ascii?Q?ypk+qzVsAq6xn0B+SMAhm4P9eHyJznj5pk7nK/wMAr3cG8KJS1Rkw+m9CzTW?=
 =?us-ascii?Q?cO1PB/XRQicixpdCidhPvDv8xStffLFlMjRbW1PKZPNck/GEFGgqeXcizEXU?=
 =?us-ascii?Q?FaWXJr6+JaSz4wEV+eqpHTGJhpyDcP4CeSFj0GJgZqcOOcj+AUQDSqcKCfQX?=
 =?us-ascii?Q?XW4YMese/MkHBEt2jkXeWtJXxVDYNU0qt15jp7O0lyNXE5XEf2Y4nY7sNuIt?=
 =?us-ascii?Q?5a7qBvWr7+csK0tkAeP8wKZ4AeWt/F4lKmlIWduIWNqoXIG3tBVoHhmWYQ/E?=
 =?us-ascii?Q?BCBfvT01AqohHWFjwWE/aSTxQaZ6COk+GXxprfWi6Ide6PVexj79O5XJrKvJ?=
 =?us-ascii?Q?f+gkwr27mrnpMExNK00qlvjpBe2PhNANnAK0MzRktWKH3AgLf+Qicetr+epz?=
 =?us-ascii?Q?mUyFnDezU6N4eSI4K9QNUfP1ss64L8sg5aGzLBkLSm9TBjasGjDiUJqg48Hx?=
 =?us-ascii?Q?xqdSfPnQ6fjFtWRLgZVlMLqA2WLAfmnDGJ62c8QmP9wTViSigc+3YJQs0GBO?=
 =?us-ascii?Q?z8DK4w91GhaRfwro27jOvyhXQ84KL9Tr2pSTx2kE+hzZQkf8lHhJ5XmG3oTf?=
 =?us-ascii?Q?afGsXX1JVwRTDJt/OuK9Yxsa9k6ltAfKUJXuM8DJhp8rsR/xNUY6S2FW42si?=
 =?us-ascii?Q?F5REGUqvnebhqYJiWajCMBpD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8aef85e-d733-44d7-0e16-08d951a1a440
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2559.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 08:28:13.9990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cD1JpLlfVZEGY/lZH1rtaxS47RVYzj7eqHaPHkUvTnuUimXzIlMhSipfeuk+EvofMhIb36FgPrIduorCtZaadQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3247
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-07-27 13:51:10, Stephen Boyd wrote:
> Quoting Abel Vesa (2021-07-19 03:39:31)
> > On 21-07-02 16:54:38, Dong Aisheng wrote:
> > > The earlycon depends on the bootloader setup UART clocks being retained.
> > > There're actually two uart clocks (ipg, per) on MX6QDL,
> > > but the 'Fixes' commit change to register only one which means
> > > another clock may be disabled during booting phase
> > > and result in the earlycon unwork.
> > > 
> > > Cc: stable@vger.kernel.org # v5.10+
> > > Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
> > > Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> > 
> > 
> > Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
> > 
> > Stephen, will you pick this up ?
> > 
> 
> Sure I can pick it up if you need me to pick it to fixes?

Yes, please.

Thanks.
