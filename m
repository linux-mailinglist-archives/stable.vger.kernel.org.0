Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD34772C0
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 14:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbhLPNMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 08:12:00 -0500
Received: from mail-am6eur05on2104.outbound.protection.outlook.com ([40.107.22.104]:8897
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237326AbhLPNL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 08:11:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y07/LRbga/94kLVTUJ6X2rpC0hiHxXpjfKt47txlzqdZwY8+6kKc9EAigdxG/KUx26IUvMyuzkFP1p9xH4fnJRRo8yxat44Eezwp73JaKU/tynR8NG4YgalDFFNkWKWgf2EUMv6mHqUH5WugBkiag3aZ2QPBIjerdaYNQzQevc0AE264TcJdnV5VRPywOF+x6orHAw8I9/TZ8pLbC9OoVAetyb94kWTH6VRACMTOEUgleLSp5elbJvILm/pJmAQRIPscplGNbcMBiuUKY7hzsjox273TXeSio3+blXp+2OxPdMX/L7PpR31lmcul2O/WimPURxcpae6lpiaBD590bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo91b8LDSxu1t7nlR1D4Sg9TiwcRRGuHnjeEkvcuUcI=;
 b=WEs63q3ZVsYcu5Dk7BvJHCNSNghNeAd9bGSDLkwM+VTWLcoqlJSknlnpiX9ZcS+Oa/IeSXimdfLej7k7qi9h3WeFnIyQr3zR1ESZdLUZnW92mLpg062l+w2ppG9sfk8PcG1vfA5paQF5Mjkbum/rVLWZBymoC7dak+KUzB0Jp0wBAAeUMUD233FhRcUn8OoWQn0K0FjCQVnoJv1ebqfhv/HTZxY2xBBk+bH0Zr+8GMUp0rl1aLkrYz4DziRyb0LzfBoOcYbsD1k2p5aYYfenzy9bFnMZVZoWbRJvIQ7KGMlKo+esOCKBwNnguqOaprkfp50f3iRVOp6Da5Ja1H7YNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo91b8LDSxu1t7nlR1D4Sg9TiwcRRGuHnjeEkvcuUcI=;
 b=eek+F1Wtp1OZNcoV3kMeou6Xv6JT/QCBDs8YdtxnHHMCxo2LfkDUrAeRbS+sN+vJTgTAU9MVMvE+jM+xelhjW1MQWsm//ckFBZTwniKX/O8MpwfAD9WK8Mc2/40diI6PzxpOrOFsiMub3gjIdTUzO8fZB24i1Kh2sh+zZ9aqQFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34a::22)
 by DU0PR10MB5219.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:347::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 16 Dec
 2021 13:11:54 +0000
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::608f:51b:ced9:9c8f]) by DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::608f:51b:ced9:9c8f%5]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 13:11:54 +0000
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: two imx8m patches for 5.10.y
Message-ID: <40c1f4ec-833f-fd3f-8a16-95d10f4a261d@prevas.dk>
Date:   Thu, 16 Dec 2021 14:11:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0089.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::13) To DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:34a::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5efd4cd3-545e-4f6b-9f77-08d9c095a17b
X-MS-TrafficTypeDiagnostic: DU0PR10MB5219:EE_
X-Microsoft-Antispam-PRVS: <DU0PR10MB52192932B2AEA7BC5AD9A94E93779@DU0PR10MB5219.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sdv1hevYttQEGpdO1Bvudi2u5YRYxFJoNh1w7s5p1DsnOohX8n3fMg0QK/CQ8+tcZ1/ci9X5grxkVwPXdadzKCLc8G6XrMRkZoL/xGMkYcSD4Y59L/70kZhXndCos4b8WFZKodsp/PBGKo6UWir/zcNFJKxXEQHz/Ys0jsnMfJ4GzaDB2WwX5jhBdvQAK47nv8Ob0f89y9h18MdQuVrv6lF9f7lSJONzN1HmgJB8+qy5GLLtzQoZbVXyNwopUQswuTF+COtEnOCHjjUCnHReDY8vi129NcF2BJeSh31VA8Q6GKoZWAT4f/z2PsGNXJLVhLmeGIDUnChnEU9aJuMOYy8gaN2t3IPnbLw+PZvnH9DIC+FihMIgPduq1QpH2mh7jVnO3rcDya6vxtJw14KWjugtYaY0WdLPop3pOgDR7DIhYS5CGihQebwB0tYJt6y7vXbu9ar2MS3eErAA9XMdAKXqgsRwZ+tjF0oUepIoJv5PV6TZGumgNH5DA83dXlJE/fDtdS/CeS9vmYIkGuLTxuLxb5IyhTlmzYJcvUd77kLQ0BS8ZR18gf1RuLyJBxxAPLJ450NnxeVLlyyR3EO4T+I9yIizO/DeYBreVKyRG6KNroqKJ/CkmJSIJOvnyBq44oIy5NjMUuD5kBRe3zCbiePP90BLp30IskJTqPBE4itcAKfzfh/bWN44OMtQQuoJEZoANaTEWzx3Dp5CjPUK7mw5e84f5vcaYyTI4mx0pO+L1n480AHo001gsRR/7f0vRONkH5tf/A76338LHIAmX6S9i9/Mu5e6DfHVxQ/BQcA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(26005)(6666004)(6916009)(36756003)(38350700002)(4326008)(6506007)(31696002)(6486002)(66556008)(508600001)(83380400001)(31686004)(54906003)(52116002)(316002)(66946007)(66476007)(2906002)(38100700002)(8676002)(186003)(6512007)(2616005)(44832011)(8936002)(8976002)(86362001)(4744005)(5660300002)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?7R4R22/we8IgPNax0rGMLcAd487bfYSaOvqriScLqdIxIXsKl615pqKG?=
 =?Windows-1252?Q?Ikx9ShLt4Zl50GKwlFNvz7HhT3PzhXeLtXv28CBMzq9N/5Zzd6YcUvW2?=
 =?Windows-1252?Q?8+qq8TWKxoY0C0ZMy8FitUFImKXAMElQsjwI4trEj/GMFnTmrkpfuXdA?=
 =?Windows-1252?Q?EKM+moMhaKb2k8JPqnqPwVzYqUGCNo07MNzJRJgNx95MDqdLSeGi9pMk?=
 =?Windows-1252?Q?hcdDT42qlJtQ+V5i5GFcCLlCf9yIJxRjcQVixseONLzkWebRuUioqUzw?=
 =?Windows-1252?Q?or3blWjvS7sJzKdtpwAlVnDf0rCfepoJYdhDC0fKI9CMt+0PmlvO6lRZ?=
 =?Windows-1252?Q?wiRQJDvZ1BLnl4ZZ2jcz6PX3zNB33cdtjJDU5yzFZTpqzPADAR+qWKMZ?=
 =?Windows-1252?Q?3cFNfSGkRDT4FAY++QTTvVDHcQQLizp8GKqHEJT1IIDJV2nZs68BZRmu?=
 =?Windows-1252?Q?7nyKGErJ5lF7T0NMB3ze7fnTTotrQz/l1+gecgyQTfo7KtSrtA1sE3+3?=
 =?Windows-1252?Q?+0jsjKjSvi7SPQvAq0eS2r1ZGoissmH3XhbqSYbP4ykgqreLeWUA9p0x?=
 =?Windows-1252?Q?AAQ1ghhDFTvPRrIh/RxyxEOORrcEEEPXZCbXIBcmiDTLJ1mxBzLcppLN?=
 =?Windows-1252?Q?QacCqa6SRl6jmJq/gbpdtF60yYtwoAxLIuogWy8MgaaiKGBUkH6pgpGp?=
 =?Windows-1252?Q?J3OqAvF9zK2xVDnKMqj8l8yjYgDS/KxVlC07CuwElu/AlAAQ+GaSawpv?=
 =?Windows-1252?Q?w846MZjYQsVKAob3z4Cs9dgmyPX0wY4F81T2zIeJ2y52qW+ndrozlpIH?=
 =?Windows-1252?Q?b3uT4syn6DdC6xMBXNVskATFEDFtGRpP1Rmfk+jNTeo1NDWGrjtKs+W4?=
 =?Windows-1252?Q?BRRdKXJI1PX9KhjGmRxf5XiYtyV5Y8XrGAcFTg6cbcnhuMIN3PfdQJCm?=
 =?Windows-1252?Q?jXc0LXvhncD/rHQJlBNlbAUv5uEf6ii6g6BKUeNamiDLdX2ak3Fk3+ky?=
 =?Windows-1252?Q?If067zJ+rfFcBQ+qpXdo2+JBhb2LBCpSnU3wSD52lK2ZocuCzZR8VMos?=
 =?Windows-1252?Q?R5CcxVtjRJB5drX8fvCHi4nSQXIX63ZdAgS94LPcu/LIdvagS8c86e97?=
 =?Windows-1252?Q?f17q0AVQJ53fUY1gZQHXwS8ZwiQkQrD9jWZkHQ4UvaZ6ynW3QjMnJWjP?=
 =?Windows-1252?Q?ZFv7QcyZ8o4ydqjFsDccAq1mCtOyfQuXBYT/ybkQU7z7v5Wo1eZOBG5N?=
 =?Windows-1252?Q?x4GZW3/RdbWsYbnu+0H2XkLDtsJxnAd0HMbhKLeM0UffvmaKSX/BZmB4?=
 =?Windows-1252?Q?xNZsNzwRl0kuLxceXRKS95bGVmqrVlNKz0gddn2O1H/sy6i5MRR+9ocx?=
 =?Windows-1252?Q?zVA9Jorc5xrmogtWen/zb4u84nVNDulyqEyvn05u+S7iQY72Vqfb6huj?=
 =?Windows-1252?Q?+pvPmBKBapy5QY5bWkDdkq6FEFLr5NcJdVDJBdzSn++reCcQx9/pCVdQ?=
 =?Windows-1252?Q?Q9iBNljF5kKcFDFpsvRNaXEBkBtOGT2MvR8Uhqw/pnHHS+OLgf6KgEJG?=
 =?Windows-1252?Q?ZqP/QeBOWx4j+dp88Zk562vx61uTpFAfoGAddGHQLG6QRYTj05iFyDuC?=
 =?Windows-1252?Q?lHzTff5c7/wtx6inC6q5kVLhP9GhbH3l331K1gMCYyhqsBKvX46qJnL1?=
 =?Windows-1252?Q?jjQou2fRSxGRXeo/F4EeBwyfnYE2KSxtoecQQ7pxQF8dhVZ8a5OEJzZd?=
 =?Windows-1252?Q?UTJoMm5WZPzQvfwWnK1Ejc50cwLI3+O3sPkIL7YI4ZKG+28rxzhXgsVI?=
 =?Windows-1252?Q?9X1pKw=3D=3D?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5efd4cd3-545e-4f6b-9f77-08d9c095a17b
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:11:54.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jkJQV6E1QnsECfxiNZfrD9ekbwa6ISj3mtd8+mcefkWvhFAii8nPK/2+E5c6TuVU40s2UNtjN7cSNaUT/tqfT+wHNj2lsnnP/yt14868CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB5219
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

Please include commits

70eacf42a93a - arm64: dts: imx8m: correct assigned clocks for FEC
798a1807ab13 - arm64: dts: imx8mp-evk: Improve the Ethernet PHY description

in the 5.10.y -stable branch. They fix ethernet on the imx8mp-evk board
(the first is relevant for all imx8m boards, but I've only tested on
imx8mp-evk).

One also needs to have the realtek_phy driver available during early
boot (so either built in or as module in initramfs). Upstream has

6937d8c71f69 - arm64: configs: Select REALTEK_PHY as built-in

but I'm not sure if such a defconfig change (which affects every arm64
board, as opposed to the much more localized .dts changes) is applicable
in -stable. We maintain our own .config anyway, so I don't need
6937d8c71f69 in 5.10-stable.


Thanks,
Rasmus
