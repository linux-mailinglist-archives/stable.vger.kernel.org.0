Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89762C638E
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgK0LGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:06:08 -0500
Received: from mail-eopbgr50135.outbound.protection.outlook.com ([40.107.5.135]:47232
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbgK0LGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 06:06:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml68l/cpyQ3uE9w8HlZWAwtke66lzjJcN6gq9jXRNCBXEKPIGxt1tCrd25J3i31OUiiSvSx3uviPZAN9ggrY/yMnN2VZNwC8ZM2bG8WjweCxGCWva2IteSZCA79KImFBno4eYByYPr3JniCDz2NrRu8Y7+Yq6gNNYu+EX5VUm/YhJwvQ4AmTFN819qP9GrZiNTqsMoFyPf/0ndJbMSSXhAv9+U4oqglmxByidEUHd6ofdpcMF1VBx2Zq46OmUyEPYTGfZwf18kW+Q/ibCam4axQHcOQQY1smK9Veb3SA6e4aBzqWQaYGrDThUkLpnnRBELseq/ML2bLdkxaiGOJKTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWrr7NKBrelqdUmuJBVyy4VRHbGjFgxvHqlNf37bL3Q=;
 b=jIOeVN9sKx9PbRPLW7rOGQxpBRirdp/r2Ea1yqnllR4eTX7q5cm4WbQWVFjLoCob0Zd8wwFABp+VRz9JKcvINkFjcjhwYVayiUksStRNin+EIEV4pGBViWImxtZUdWgqMG2ls75y2RU180MTLJA5nafc6xCHD4UI1h12xFE54QsliU9lGHgJWCtjG/VQZPrUFDtB/G43Q+li8sHy73oN5eDFSW0JGCHJOnhVtVPum0F0FSMB+nrefoXC5FNY13o44F0N9if6X8IrXUjZuYJnZdo8TqW5JpNTn0iV8MKkuUU6XbPvuwwMdUPI49M1zis8Oc5r2bhB4V9683zBM/WxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWrr7NKBrelqdUmuJBVyy4VRHbGjFgxvHqlNf37bL3Q=;
 b=OtAGFU2zsN1LvBCs+34LBxp5mbYLkIpjtoHvu1uNmXo+Ig5gKjOomO7boZVrStNMgHApVMYwBT7yvVmkf5NkXxyRCjVC2JEvjJxf0joo1PoN00qGaz7qWLMBpbdeAJt8uGGuqvGPfhb2/cvxPQnRYdKwVE/7k19hatAdRhMA8wY=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4197.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 27 Nov
 2020 11:06:05 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 11:06:04 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Biwen Li <biwen.li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: please add 35425bafc772 to 5.9-stable
Message-ID: <ef5b5f86-5d08-cb9b-c4f8-f6c09489ff4e@prevas.dk>
Date:   Fri, 27 Nov 2020 12:06:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.216.59.226]
X-ClientProxiedBy: HE1PR05CA0286.eurprd05.prod.outlook.com
 (2603:10a6:7:93::17) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by HE1PR05CA0286.eurprd05.prod.outlook.com (2603:10a6:7:93::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 11:06:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4f0cb11-6367-4b46-bd78-08d892c46ef2
X-MS-TrafficTypeDiagnostic: AM9PR10MB4197:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4197CBB34B569DEE3823E6AD93F80@AM9PR10MB4197.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zYVI89KegtNLAuha3BWoaUb9a7L9VbJ5N7qn1kjQJod3ChASTyBITC4UpFM0XZA9vLrQDm0ChZaOQRLOfZ4W3Ssp7zfhiefJ4HAMTQUH8EzuNGWcx9NYN6c7Vuwjsm7e2By3vleuv9UfKRJaYKEXfZLeniHMUUEclOaNPyM9O6Ctd2cw1kkrGXGwQRm8p5delnbmMOd8t3r8AjVoEiIe8WT29clRuyVmRlNZCCUVDX2XNapPL0xOlQXJyvJRoQVOLo1rbiHlqHpTw/qvo2bcQ0YYruwvITTWvOKOkMkfDPrHVKMMBjHRz9DUK2kCXyET7MaHnJKZs3/tDzFSJ24cYhAurhYlPJR+tSIgHGDKLOvUR9tW0vFvW7QytevbrzJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(39840400004)(376002)(396003)(366004)(4744005)(52116002)(8936002)(31696002)(16576012)(5660300002)(8676002)(8976002)(316002)(54906003)(26005)(110136005)(66556008)(4326008)(66476007)(31686004)(66946007)(16526019)(956004)(2616005)(86362001)(36756003)(186003)(478600001)(2906002)(44832011)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?h90wFEqn0Lyk0t3d2IPiMbTgaz4FLFFC7OLXiSXcGfAhsgDcAKC1d4w3?=
 =?Windows-1252?Q?1VHheQsKK9/MOEWtYPq1lxqMHeP4ututLNxL6Uc8TlbHy4/1l0dZ3pT1?=
 =?Windows-1252?Q?sruMyv7q1pw+xBbD9R/Ru4UY8g0eGV+lyn8ydMSpdrx5CdOfbz65LgY5?=
 =?Windows-1252?Q?4Mr1bSVMj75nccrgIhrKtlIv2GIW/In0oVBzXkQepsM5POrmVL0kQt8p?=
 =?Windows-1252?Q?DEdar7NTrWfDD2UzDm+EBMZikDayvXgGk+efHdxV+jL2TgNncyHEui3A?=
 =?Windows-1252?Q?rZCyZk9GtQgg6GeONJ+U0dKzVvERlcsyGFIbZQ8YOUfk9oVJR/SddqzG?=
 =?Windows-1252?Q?LmMw8iaeAdxZUJHe+jKxlrFNLl5RZ/Ctr0kYa9yB/jdQOerKZn47BnCD?=
 =?Windows-1252?Q?Glbl5ixf+egTK7VDE0uE2MXTpEKdlq5JUK6BwQt/SQ0g9S2RJI9cxMoA?=
 =?Windows-1252?Q?SYhMFsZULtSIM37jkb6CzR69X3FVB8Y3OYEw1LRbF7+B4vE6iKU1B1jL?=
 =?Windows-1252?Q?DkN3WW111/KExzIkBHxd/YT6Z+NM5zeMe4BgpdGKChO+b+rPoOQ2kfNR?=
 =?Windows-1252?Q?DAomE0w3/Dx5jxrLj5tjf26JFFS9pZiyBSrkqyAu8KYffTOtPm9vvxPf?=
 =?Windows-1252?Q?fxA6vRq2hoiCTrpPvTZE58MP7JULrHAbb2Sja4VsEUdXA3s3s1reZS6n?=
 =?Windows-1252?Q?H7OpUmseo7Z3rCFg10qUYrpiMy7jWNgAzHBcqq/r5gU0iCRsAWCbVJXW?=
 =?Windows-1252?Q?Edfn4g/kbVorjcXI1/JmdHqj9YAOIqyDrIn1Ct2l6eCVFRcxQkexj1ng?=
 =?Windows-1252?Q?cufLT0slGgSjKm9EVJufHsidvouqaZVjAQVFjnsuW73CtSjsSkcAVYAV?=
 =?Windows-1252?Q?WZRgUhYhY8WGoqCNFSrib/tNq1OkwVNOO8rlwDgPYe/+Wl6GH/MKO7F5?=
 =?Windows-1252?Q?GTbvLbExtD0L/mR3VO8Vsrqdc4HGGojqTvpEmVzBup3kiN/aVx6NakOm?=
 =?Windows-1252?Q?dAmYt3B7DReWAmiosQa8oJ5iqJ3oowB2G4lX6La3l0iXmKKKkmr7T6Sl?=
 =?Windows-1252?Q?Cycs8nZoNoXeHsAW?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f0cb11-6367-4b46-bd78-08d892c46ef2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 11:06:04.8730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZ8zoEeDba7N3Jmib0AhmwiWQEEsK/6MtvIQR++l2lQ1s9ZDlcDl/JBy3WTiwVYjgrvZVFqshqVtUYGh4ZAzGXVahWi01MhGwUQYHdstxg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4197
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

Can you add

commit 35425bafc772ee189e3c3790d7c672b80ba65909
Author: Biwen Li <biwen.li@nxp.com>
Date:   Tue Sep 15 15:32:09 2020 +0800

    rtc: pcf2127: fix a bug when not specify interrupts property

to the 5.9 stable queue? It fixes

commit 27006416be16b7887fb94b3b445f32453defb3f1
Author: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date:   Wed Aug 12 10:51:14 2020 +0200

    rtc: pcf2127: fix alarm handling

which is only in 5.9.

Thanks,
Rasmus
