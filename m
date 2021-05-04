Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A3337313B
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 22:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhEDUJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 16:09:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57168 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbhEDUJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 16:09:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144K60OY019918;
        Tue, 4 May 2021 20:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gst0sqoodD3D0wuODielBG5V4oPQXZoSg6SFwTHSENE=;
 b=PwfnLRf41nq1fLlAimWVCE8f3XKDojDBQaVOhWn3MnSftMKAGOsBasZyI1YSqi7lDaaq
 yaa9a1CAC5bo7rNfd68vmPntjXL0OIym+yDXUUShBlLaqdSjuVIzE+bq/jsWgU9C18N2
 mk0YSSf8Fxw8Wv5YQ6bnAwGnRcUFj4oiCDmFGr2Ft7QG5l/kqHZeFlfIIkwbs5xbuSZr
 ER9eT1FYt3dpKiHSenyZGsZpZLU5Vqym7ze4DWP0oI5C7CmxAuY+8F4t53fcdVZKgGNy
 y7oxWkWQWpaysSa9n/srQZ/qpul/Wk4uYnkSx/B3mYvmqYQdX8vbsdhlQADUfYQ7tOpt kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 388xds0ag5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 20:08:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144K5PV3009789;
        Tue, 4 May 2021 20:08:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 389grsfsqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 20:08:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHaykNPwjRngBsnMlrjhVUX0ASdlTEgWclFUJwc7+6S4ZxIxbHWnf6g8nO0sdaotF8Hmj3zgyyjIhYU/Md9AsBepvEluM+jZ0nhuPNvfAfzjICHr9IpS0keW7WL2Fl0tLqmwiwhQGQH4wmQTidLfZ34/cXn9q6QC4kfLrtovT1MhEgeq4FjS6+UOwnzvF0eRD1sjYxRN2I+cxPBSH8lQxk4heQx8kXEw7J2CTahuR/L45gPE3QngsRIOtJ6Td1Zqwmu4k88hBTiNhmv5JCrtlvYmjdIwa2TFyOLcbsW2YHESa4++LreBFd+LjEQL0vkvrWGxeVXophVLl/PDMflfsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gst0sqoodD3D0wuODielBG5V4oPQXZoSg6SFwTHSENE=;
 b=B7tklC7gc5x88hZA45d0p9NQ5EXZDLmLnoF0z25UmUTmhv7qE8U0nv5uDeQVxY0ith9en3eHRNEutQREpR9eZHeOvvWRmOdaWuflkIVsn1+jlPDWIp8thu8Jp9jGIZ3ahy+hVO3ecosYXVM7kstOhgh/n/lh/agXTV6KR5/065ngO5XmAEQpaiZTj7fSl06YZNxM4a8wdPqjOuqL65377L7QBMo6w74+oip5FRbjsDbyvQc/V9gXgG4+CJiK7sW1oQ+cKoyrTqIfd0AkHKa4g+L83KU5J2OVKen7vSud0Y/5D5KLVELyCqAGiLP80WwEHa1XDSpZH8GzIx1uzEfOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gst0sqoodD3D0wuODielBG5V4oPQXZoSg6SFwTHSENE=;
 b=eEkL9H8viJVOM2sfwkdsJvER5m1S3dZy+60LDRpqPMaLWR+cvALJHcqggseJPJq9dn/d/0wV+KR8yDlczoFGiUJT8sAVjqqEFxdiv0p5kTS7MRHD9LLGRy3cWu521TE8MJPCnXzyyP9p2anMb5XeL4Gj0rLQ3AsyexJidwrEhP8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Tue, 4 May
 2021 20:07:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 20:07:59 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: need to back port ("scsi: ufs: Unlock on a couple error paths")
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7jijnxu.fsf@ca-mkp.ca.oracle.com>
References: <20210504184635.GT21598@kadam>
Date:   Tue, 04 May 2021 16:07:56 -0400
In-Reply-To: <20210504184635.GT21598@kadam> (Dan Carpenter's message of "Tue,
        4 May 2021 21:46:35 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:33f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Tue, 4 May 2021 20:07:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 978c7fe4-a37d-4c13-4183-08d90f385083
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45178165B69DD49850B506878E5A9@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6HY7Ll/MvpfbZToYz+lQxefgkmLxq/wYw+gpg0rjYBApoBb9qY09VKi20s5ooijxDBFkh/05lTqCyQuGcPkQKBzAVW6/8TV6K/ueTqrqVviQDD7e6PMZPRMSvjX9HvtCycw/N+g5ReyuWOXMeTmxBfX4OJmZpUMSUsydQ1NRYXuMw/8IlflLD8hXmJQO/RvZOfBgs7iCrABO2oVbsVw/AsGlKmSMwrxeGwyeXb/Tc06g5PrQdQBNYWhDC6W0TxmXBbSUDWmjwaeinrpO5wLLPRd2l16Kg6p5GbDWq0fUIfTV1bPbxINpU6AUsDv96xeFZ1ySVTJkXzrr06nsdfKrQ7kJu+aK1UaRyDmeDbA54ZU6Llfw0Uqey9fzyHJbvpjIMIxnGyYHJ2PdKOabeowMydgu7Z//nASQ/vBZGUJAnUwi5Kb+kgy2kHEc2I3vF+hLTNpCr9+/1izY06GyeQZj+6n6OoA/r0kCav1CHK0ddthRK1i3ZruOzBlm3VvYFtD68t69TbXd7ijLel/k8PJH43iIyo8p1XqGiIkTl1P3q5ggV94n9L3sxjkQDdYPB6Eo4Tub8EqxJkp+T6lyuO4TfXF0kqyTeflCc9AvHOB411QzwRQ6E+PLyIeQtYnDGicTIfQEU76PWKn3MFcmbeRiv60utXtqOlYBYO7u4WZFQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(956004)(6862004)(54906003)(86362001)(4326008)(38350700002)(66946007)(26005)(16526019)(2906002)(186003)(66556008)(38100700002)(52116002)(7696005)(8936002)(316002)(55016002)(36916002)(66476007)(6636002)(478600001)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/ICBmW6v7NZGQvP0+JVwrjSUfZNaTic4nGC67jjlX/l+ySneZs9KBuCee+kz?=
 =?us-ascii?Q?m+8Y75BLu6AEhIN/mjh6A60ECb+wsIg0NX8Ov+0zpPnEe4RjLhPNvXiOEnJp?=
 =?us-ascii?Q?CBbqfPx0PWUA3dTQ0XNyg5rfF2mWEbfdl0PFgA0WNJkJXGajWXrTtR31Y2VH?=
 =?us-ascii?Q?OjgA/2AOwmmZHb+RB4WoLsLvSu50xbbzC6vea4d1dAaT94gbP+IPc0xMiUKo?=
 =?us-ascii?Q?V7XtMC3Qbe5JITze4Wf0unt3v8y9NU2dyCY1zkp27VrsryBHFeQe7qathiAA?=
 =?us-ascii?Q?qf5bDwj6jaK72de3Yam9ffAQAErBkyit2QsnljzT20mVVer9HEZfwVWbaouC?=
 =?us-ascii?Q?gUz+ah7TAr0N7QPS3pgByRHVVxi8DvzWjjOqQJskKBIWHStlASTuPPEhwsS8?=
 =?us-ascii?Q?XIwJoUUiYLgnU1EkSUVOYKN6cEhNc7Qji7Zhvzaf3k+xulMaWRM54hReGo6C?=
 =?us-ascii?Q?Udr1WhT57zDtq/LSgmwPwTr57aI1YXhY9UketsnqRO8G8KRQACYbLY6e8L7g?=
 =?us-ascii?Q?AFYbU4AOXbsorw7qlpuoL6Sxi92FD3BVGj1u/kZfa6uZm0GAW5WEyR5fQaEc?=
 =?us-ascii?Q?IsSy2sEq+TuuWpjMnt4rb4OnkhzNI7+3GBldyX4IEdDUGv1d6wbJ++pHO2cB?=
 =?us-ascii?Q?sOJeC94W4Y8X4XUY/sNd6Oh2uV4fxFGojqZVZmZzkUIFJHAkgZGUJBP9S3zZ?=
 =?us-ascii?Q?d0PRfYh0zyK4qHt+gxCXhtQ6/yuYzIyE8hKXBzLZxdq+kDQ2L3g1bCZO9uoe?=
 =?us-ascii?Q?7RR4UqtyieeT3Ypj3zuRAyWKp8C82ooUHIucOhcBLuut2/jxURHjEAn3bnTP?=
 =?us-ascii?Q?YeEJvInbrkYQM+pRX/OIGv1hYUrJq7kR/r28v5zmsnbmp3WF0JL805xem966?=
 =?us-ascii?Q?sv+rYseE+xCwJMjvGKnz9anQKJi70rFOw0D1rUDL8H7bgrYQBppxVCYHYEF1?=
 =?us-ascii?Q?3iaXARlrGaI7yjK+P8q7FUi/SBRU5j8+ZFFkQFIE7UBvpSs/qwfv0DM6uKMA?=
 =?us-ascii?Q?BwCT4cKWY1XrVGVHDqcZEX4nWiXxWian6d39QIlkmbsSx9IiPTNWdyOusc0h?=
 =?us-ascii?Q?NA3U/ASy+1oybE+y9ZBzkW1rZYO3Ma4sOXFBZS8GNS+0z5pg6litL+oa8vmg?=
 =?us-ascii?Q?lcGR6uc8ZaI0dI+H9ejUIXN5NQbCjJv3aILyEodlTm5MCb570Og/01u0zgjJ?=
 =?us-ascii?Q?P6CASpXufzHRXivBdK/4lnOJ0Ls6a6uCtNXJ72BR6ePd428ftZ34sX6qnB1X?=
 =?us-ascii?Q?NN7nrKUVXLNM0Db7RGwqM+aWxLg7RRHzLXQuEZ8Gh+RHShtibG5fmdXcCKAe?=
 =?us-ascii?Q?8JprT1sDgsB3zIoE3JKvVc7Z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978c7fe4-a37d-4c13-4183-08d90f385083
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 20:07:59.4224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AEqWRu5R5Lx/V9EhGxlda5TlUHSfCSjQkHp9A09SIBLfU/kj8FqtsA8rahcV4sb+C+x6EhibLSTHyQFzlPB2Iwq1ZouZ33ql9AGSRMBZ48c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105040134
X-Proofpoint-ORIG-GUID: BekxwVwTDLoW6GRlB0FchINiUR6TPoSt
X-Proofpoint-GUID: BekxwVwTDLoW6GRlB0FchINiUR6TPoSt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040134
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Dan!

> I don't know git well enough to say what went wrong.  I don't think
> the SCSI tree rebases?

I try very hard to avoid it but it happens. Bart's patch went into 5.6
and I still have the old SHA you referenced in my repo:

    $ git branch --contains a276c19e3e98
    5.6/scsi-queue-old

Given the '-old' suffix I assume I had to rebase for some reason.

These days I have a separate, ephemeral staging branch that I use to let
patches simmer and the static checkers to do their thing. Once I get a
sufficient amount of success emails from the various bots I shuffle
things over to the proper scsi-queue branch. At that point the SHA
should be stable.

I try to be very careful about updating any commit references when I
move things out of staging. My git hook script verifies that any SHAs
referenced in patch descriptions are ancestors of both Linus' tree and
the branch I'm currently on. If a referenced SHA is not an ancestor of
any of those trees, the commit fails. I do something like this:

    $ git merge-base --is-ancestor a276c19e3e98 linus/master ; echo $?
    1 # Not in Linus' tree
    
    $ git merge-base --is-ancestor 7252a3603015 linus/master ; echo $?
    0 # In Linus' tree

A quick git blame on my git hook reveals that I implemented the SHA
ancestry validation in 2019 shortly after the Bart's commit was
merged. Not sure if I added the check due to that discrepancy. Certainly
possible.

-- 
Martin K. Petersen	Oracle Linux Engineering
