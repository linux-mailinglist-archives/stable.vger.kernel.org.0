Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F4303997
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 10:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbhAZJzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 04:55:17 -0500
Received: from mail-eopbgr40092.outbound.protection.outlook.com ([40.107.4.92]:12675
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391609AbhAZJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 04:53:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBb8T4eFB9MQGPjQtWjkX3EFP336qP6aewUMMmwXSv5YgNcScCx7PT733RbWktTrACrRXRP009/rv8kMVpPTgk3pRvt3c3O607R+K9C5vsCRHgirf7hzXA696VzXwY7H77kXL10I4Z2ShfLmUtH6G7C2Vx8d0AZJ4Gie41JXk8og3anmjqfBag0ehrHx+9wI6pGje5zBuNfYOv0aJKhv6gGlceiIjudcGLdoAQJwS5exG5BLl46j0Y/bjZR7miftHj+u90OnA6i1lGFOgofNWJ/Mx0S1OzbhX4uNqECbJ3aVqVkQn+8rJKJC+0mtQicSGR6BANuaLCzrucdVoWzsXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2HOai1RO9f/Z1Bbh41GX84mXOSIIb6CrFeZKoOGka4=;
 b=CVOAgcgK4sJ4zDL073fSzL5Vh3FhqZX5D3VDrGkG18F0JjjRfyITbSPCHVTdbsqPpt7jPRGSlF9RCgYoMJqqzlWU28M59OPBh4dvkD+k/c872XDAOtLtgGp3seJWBGEDhtLPx+y5+O9TTOyV5BNhPC3VR/+3xJbcYWl6vbODSBVuhRS7tiPiF0XGbTZY84YvJHTglk+8KrOQzUp2jeyok1inYmybd48HC2DjlMR+M/C5T1V1axoJjAA3F7zMCB1vufQ1SL1+Ci9Sg4tclk9/A0PFM/yMjTI7tInK/7Dux4lfU9jG9nW7eJRNTUleodUc4l7DLiyc+EL3Yyo6eC5AzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2HOai1RO9f/Z1Bbh41GX84mXOSIIb6CrFeZKoOGka4=;
 b=K4Q/KKh6C6YFoj7KLHQfaYWYBPrvSWgyA805LMvDeE5Ynw2U4rMh9z3tEXGs93ZSHWJa4/HiJ1X1vUEd26faXRhhvv+5tgW4+nT6mySLxkoeF1akabIAmtQy8SRqSHqmbx7vDKwWJPgmv0ZlOLifKt/n24pGyBcQld3KquhykaE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Tue, 26 Jan
 2021 09:52:24 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 09:52:24 +0000
Subject: Re: [PATCH 4.19 46/58] net: dsa: mv88e6xxx: also read STU state in
 mv88e6250_g1_vtu_getnext
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183158.687957547@linuxfoundation.org>
 <8447247a-6147-32b6-541d-0dd717ac9882@prevas.dk>
 <b3be188e-f874-72be-d3bc-2c0cc06aba53@prevas.dk> <YA/XvmZrTj4NGqdJ@kroah.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <a91dabc4-3bdc-b379-e47f-85fc44b170df@prevas.dk>
Date:   Tue, 26 Jan 2021 10:52:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YA/XvmZrTj4NGqdJ@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::20) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0602CA0010.eurprd06.prod.outlook.com (2603:10a6:203:a3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 09:52:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b77c5a7-fc10-460e-31be-08d8c1e014ff
X-MS-TrafficTypeDiagnostic: AM0PR10MB3011:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3011E2850046ED43D4D2930F93BC0@AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYz0CYH7E8UQa6JCJeg+VH2Vvr5ZRBKz7l0QETsGgnxS5E2nkF+FugQijSJTDI1+iwugBYmjvKPD2w/7rpNmv7HvDV5uyg663DKunDN2b1u6WE1qBAxY5fHNrQjk5wPWKz/xQEzD3LJ/GtzswM2GhoD/xy1izc1l8h9GwIzxVhQ/9Y+PhHwFtnpwPDdJQHsk5hRSq1FtrYShHVklX74oq89wpJW7S/U5XK60+QHNffli6PK7Kvv3BOTCEMKUlg3BZBl7FyrFV96n8XXiN20r0dU2fsh9SZSpa3AuoCvNY3f+/FbuPhT4cX1MEEseSj2gSLeINcatoJr1FqzKMxjxklarI61riWKkrIetL6cncy7mEGitzQLUsmylZcokQ+h32OqmmNxrOGgU+8OpqrqjeJS3iICKWlYFQpyL09+YMnRJkQ6LqDLHsmEnF1hbyIQ03T9zyYXBq8L3T6D1iAuHKEhWXXSoK9jLN7vA+KiPW6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(2906002)(478600001)(8676002)(52116002)(31686004)(2616005)(956004)(316002)(16576012)(66476007)(66556008)(44832011)(4326008)(54906003)(66946007)(5660300002)(8936002)(16526019)(8976002)(83380400001)(186003)(86362001)(6916009)(6486002)(36756003)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?rU9q6kBPVMCejdsNnpXrZIHooSSNj4Eo+Y45BBuZ+dsE1ak8pYOIiwTj?=
 =?Windows-1252?Q?d7sY0dh9+JpbpCkX7+kl2MWNbSH0Mzrk8/a3B4LMVHQc/KsgqnpLB1Wr?=
 =?Windows-1252?Q?Juvk04zFuFqpParoqLzu3Lf3PI+ydZaz4YqQVW2WFqG91MehbCJGImm/?=
 =?Windows-1252?Q?6auQoPHy37DMVJkHT8DKLC0YlH74Xih14MKU2flh2xhwyXqDxOi+8u+O?=
 =?Windows-1252?Q?1FgwqJSm1H/3GA+QHOo3Fi0VFuTqP+5/2EkD6a2OTJ4e9xlYRQAKab8M?=
 =?Windows-1252?Q?/ep5jBAaqxQc/1z6w0e4QSUZVK46StynLWgWkzpwP8na83ddTNWJigfd?=
 =?Windows-1252?Q?63AUrHXGbW1M78kjL/alfLLG22Sd+YRhslJAAsFXNGKl6X3vMM94hAcU?=
 =?Windows-1252?Q?ZTE05j/n8wkhfgRdxnguWjdU2UxD9VKIF0IKdk9Wmq8GKIFZhKh2FQTb?=
 =?Windows-1252?Q?m1R7oxPB7F6AqR9vJWE89cZmYGvyUDZ+OSZMXWrVK5j75GV0wTRjNntC?=
 =?Windows-1252?Q?iJy1m8SbSQgNaqBH70tXHKawUC0Ku+20Rk+dv5gvTA7IVV+nJrpcvSVi?=
 =?Windows-1252?Q?q2OHn3UW9bjFdq54XIvjsXFjXMZmqL6ZT91rvFqltbVJjg99yB9EKIxz?=
 =?Windows-1252?Q?tfURca1G6LrkJf3RCkdrPQjAgOwHysFCuKt3PPvf7vf+GhUjd/485DJP?=
 =?Windows-1252?Q?1jV/AYVClIFeu2iRvVNIMuCShdhHGuvu+Bq3YwgPaUwCK09EOT9ZvgHU?=
 =?Windows-1252?Q?wgbcunwIWGo+rScDgBxXVUYAdDTUVC45+q9XPmnrGTJ5+XlS3xfJYvKb?=
 =?Windows-1252?Q?/xSPMNfEOxe0w2FKTX8zJbGirRfR8L0ibsWPBRUz2VMltuAcRzrbseK7?=
 =?Windows-1252?Q?IS+fQ5wUgctJ/tNIPMaqB0gn7Au+oSG3n+dZ0+9cbyGR9vwzNE80JCC/?=
 =?Windows-1252?Q?6QeRNnAxJVdL6XTyBCo8tyNbPmxxe2lNG8ITQdpsvrqqH5rqrwepbS2Z?=
 =?Windows-1252?Q?3LX+LeU+S8HQ6SIkcswciQ7n3pX04MM4QyyP7OcU1zF9ezWWoGdejFa2?=
 =?Windows-1252?Q?s8WO5jV1e+PrglUVJDg4RLnl+yb645LJb0SVOyhSHmppS0jkOI2TIKfB?=
 =?Windows-1252?Q?XMOXreaZ3rez6kgSzEJwawJS?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b77c5a7-fc10-460e-31be-08d8c1e014ff
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 09:52:24.3907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9TdkIpv8hSepaxLzZ1JHN4qpVbpnPtZTck+c9t3wXIMwZ06IJ+su1ocNDxPTtQMlp5OvL2h6dVklWW2vUBpcYs03ashPm70cClW6To2GT6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3011
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/01/2021 09.50, Greg Kroah-Hartman wrote:
> On Mon, Jan 25, 2021 at 08:59:54PM +0100, Rasmus Villemoes wrote:
>> On 25/01/2021 20.40, Rasmus Villemoes wrote:
>>> On 25/01/2021 19.39, Greg Kroah-Hartman wrote:
>>>> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
>>>>
>>>> commit 87fe04367d842c4d97a77303242d4dd4ac351e46 upstream.
>>>>
>>>
>>> Greg, please drop this from 4.19-stable. Details:
>>>
>>>>
>>>> --- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
>>>> +++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
>>>> @@ -357,6 +357,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
>>>>  		if (err)
>>>>  			return err;
>>>>  
>>>> +		err = mv88e6185_g1_stu_data_read(chip, entry);
>>>> +		if (err)
>>>> +			return err;
>>>> +
>>>
>>> The function that this patch applied to in mainline did not exist in
>>> v4.19. It seems that this hunk has been applied in the similar
>>> mv88e6185_g1_vtu_getnext(), and indeed, in current 4.19.y, just one more
>>> line of context shows this:
>>
>> Bah, that was from 4.14, so the line numbers are a bit off, but I see
>> you've also added it to the 4.14 queue. Same comment for that one: Drop
>> this from both 4.19.y and 4.14.y.
> 
> Odd, but ok, the Fixes: line lied :)

Sorry, but no, it did not.

The commit 92307069a96c mentioned in Fixes changed the semantics of the
helper mv88e6185_g1_vtu_data_read(), splitting half its functionality to
a new helper mv88e6185_g1_stu_data_read(), and it also added a call of
that new helper in mv88e6185_g1_vtu_getnext().

But the other user of mv88e6185_g1_vtu_data_read(), namely
mv88e6250_g1_vtu_getnext(), was not updated, which is precisely what
87fe04367d842c4d97a77303242d4dd4ac351e46 fixes. However, that other user
of mv88e6185_g1_vtu_data_read() did not exist in 4.19, so the backports
of 92307069a96c to those earlier stable trees didn't introduce that bug.

Rasmus
