Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83866D956
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 10:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbjAQJIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 04:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbjAQJHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 04:07:38 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF5B3456F;
        Tue, 17 Jan 2023 01:02:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfYNUT55GlNXKIKHxvTux7XGqCiVv2/yjk96jOsd2DTYjxD/mU1jHNKxFazJDSN1bKf474tBqZ+fnKjGp/F79iCgl/Babh5YC0JzUuhR/kLOn3RvsPAj6EKh9IWCtRdj+Lt07jCgzhN5B5j+291hYijjXfxvZzmP/MyzEAawAdMVx0FZcs8CtCWA+Fs/o0j5nbnBqxg/eQooN6l6qw6ZUAz6bGRw3GAZErS8X/0+YqNH3mW+lGbZvIV3WpB2PTenVfwEPiNkjRmlmts14308L1SkXqPHGGeUiErQiterHmNTpvAeASTDrraRjimiois5MHbmZIgMytjsiYpiyu+cZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Y89HW+XsXy3meuXU9FFdTcaVOOuQdw4KjiQurTy/rI=;
 b=Ck+OgKMGWP4UdEMZwm+0nSQugM/paAvUnwBZAq15aFqLAIsxdwy6EaWPzYIsxD0dznSg2FcXO2UUyNo4hPQlayJ+1vLlHUy5sC6PEk/RZUn6aMlo88tge3AZKi0OWrKAY2KxdiGc93jULToN2mMN5/nOSjkeeibyXuX+PJqXEleW2gvwQybQ1COrPTWGiG0QPCAvY3rC0lXS/+/0Do7iM+E3Yx8uRPhKLTwdINRL8IldudL+5SEuyjPk0FisKIbJvHg/xCH2lTzqzzuMG6C5rZBPwIPI1bXFGsNSxpRfWd7U6QB9+J7ij9kxLOVOi/KbS7NWaNJh4elWDEhOCWt1Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Y89HW+XsXy3meuXU9FFdTcaVOOuQdw4KjiQurTy/rI=;
 b=S7r8ueLUmz3RZtnGftm/HXaDxhlfT4Mci+aZKRdWi92D61OaBwzcFExIzQnWcJE5PsmBrAtIUj/X1EgOHU4wJLtHUmTJuECbdG9uTtVcDAE3k0PUzlFw1aIyzD2wFxY30lvOV4lweDoypLisQ2Nzy6BWz0Nlclm/al6E0HiYlfTK/yNBbcWdtNjbfh/IYdTZGKScezaqQVfvFwLSk/agfNkwpf0qwSml6tmdqPQ1SKguFlGcSWPfGT77PYcxzrrY6mJG+aVROgn/uEoKhjcWqlqoY6znPJkvpFlsUM3DyseYYESmts/mzN338BQdOzg8mGL2VYoEN8Hajw4kO8laPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DB9PR04MB9259.eurprd04.prod.outlook.com (2603:10a6:10:371::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:02:02 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::8d51:14ac:adfd:2d9b]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::8d51:14ac:adfd:2d9b%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:02:01 +0000
Message-ID: <3c191200-4834-e5f7-9c52-ffd1e2b8ac0c@suse.com>
Date:   Tue, 17 Jan 2023 10:01:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] usb-storage: apply IGNORE_UAS only for HIKSEMI MD202
 on RTL9210
Content-Language: en-US
To:     Juhyung Park <qkrwngud825@gmail.com>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, gregkh@linuxfoundation.org
Cc:     stern@rowland.harvard.edu, zenghongling@kylinos.cn,
        zhongling0719@126.com, stable@vger.kernel.org
References: <20230117085154.123301-1-qkrwngud825@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20230117085154.123301-1-qkrwngud825@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::7) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DB9PR04MB9259:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e81841b-8d2d-4d53-e175-08daf8697f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MnjjSXYGbk27Yxp75Kr5kAA3Vongj01GZRQishgwJaXATf1dSyz2ixBPhUZrNvLr9mTkltd2yfFi0btA5xYTDboWLw2pR42m8m+m40LgJjTuLPs2OBSIwp4GWp53W/Ny3ddR1rbd3koIh4+sH1RQgy58uxJrcCiiTTu9D1ULoP6xrI+75GLAuCwjOd5hhS9kogtGqXJIBuRFcrMsNeQKJjvmT3/veMz6bN5BlMJReleWwYtiDlsprVPQSJ5DWQ6f4WcXEAk8XMgJoSoJumL/NOhdvEsFsooDGDDM7EGYgjFWUvaqLPl1shDWzHVvptD0oOu1Uk8kbtSaXXsN9nVRO0JoohcEWL4mdWdhg2ScWmv1qxVcNIl6u3qv2xlNgiQ2XRYfDS/E5Xkp4TDHtwOII2MA5giDgZr7eSnSME9oaPJjEaSzyFbZMy7cPtUmHaK7qGpIzwFWhINnikdnqAbGxoEHBystO/UXVt6y6RH9p+iHUdBdZ27fyXTNyl8EIt8OquEvktppY2/XmbtutDLPv9bwerJltrXJy6BNXpCqvbsvVMOzul+gCVZ6yleJciU9RfEPzwqmnjQdT/GB/pQphvPJsFFHmAKuiZClsd7SCxAS+5pLba+CIBn8+bbX8cAT8ICIvvKAbNL4LaoK1kAfs6xLpqTz5Ab0EEzUOSBE/ZCjctqWovk5wVUy9x+XOeP7uOM7Psv3FGzmpLwzkI6CK1bcmF1n+lNTvJv1dFYV7BR4yKFRcypmHprCPsJ7XwErOlKWsyw9woUetd73bKgAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(66556008)(6512007)(66946007)(186003)(66476007)(4326008)(83380400001)(2616005)(8936002)(53546011)(8676002)(316002)(2906002)(5660300002)(41300700001)(86362001)(31696002)(36756003)(478600001)(6486002)(966005)(38100700002)(31686004)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWpSWUxMODY5S1VFaWFKS3Z5ck5rN2xCR0RKb0p2YitCVnpnTjlDWVB6SG1p?=
 =?utf-8?B?RmNiQlVaZ0RCOTA5YkI0Y3pPRFd1VlpHbmJFbUs0amRFUHZEakYyMHJzTHg0?=
 =?utf-8?B?ZnZ1bSs3dGxKaURONnhFNTlrQzZtRG4zeFZ1M0Z4cndRckhDR0RQSkNZRFZH?=
 =?utf-8?B?RW5Ga3BsOTNOanVLdFVxTmcyRm5DZUl4dEdxWDBZZXdPRm45NElFNmVKV3JX?=
 =?utf-8?B?dncyWHZqT0o2RG9GWC9oNEMwMW82cFBIMkF5RGZaQ1F1YTdsVUhWRDlnemp1?=
 =?utf-8?B?TzVNeFBNZ2wzeUpYMEdlRnVnUVlwRlEvUVY0YWl4RW5vNktxL2o2M0Q1ZHZB?=
 =?utf-8?B?SDNtcUtUQVNNNHZEY0ZINzNRWDlhT21pUjFoN1NxSkc5b215akhyWHdid2d4?=
 =?utf-8?B?UzVHU0w3Q2lhTzBqeEd2b0Vla2FVc3JZZWo4L0EwejZNRHpKY282aWJkTkF1?=
 =?utf-8?B?dzZuQnBIVDJUTUUwYUNRZUx3Z1N4ZUN2dTFKSVA1TmdZdEFEY2JEYkRhOENl?=
 =?utf-8?B?bmN1L1JCcGlXVjhWekhtMzBxZS9wYUFWM1dDaXRwZDFZTGpVakM5d0pmWVlH?=
 =?utf-8?B?RzJqRDF5ZXlzQU9MWTNLT1pFd2RuYmpQc0VudHFJYjZnOTY0Qi8zUnR5VVNK?=
 =?utf-8?B?YVhldEF3Tk5PZTdJanM3NWpBSW16cjFwYVlRc2c5MjF4MUl2OEM0Nmt0bFNu?=
 =?utf-8?B?aCtJc0g2WUwxbDFpL3VGRmZuVGVpN3o2aDRKYXhla1d2Wm5DcWtray90ek1W?=
 =?utf-8?B?VEZtc0lXMmdmMURZOTBnWVBibDVTc1dLcHpycGJFWXg1TlBmL0FjOXNrbWxU?=
 =?utf-8?B?WHhsTEhqdHNlaFBoZnFSWllzK1JXL1NNQnNZUDc0WmJqWUpNaVg0T3lOOU5J?=
 =?utf-8?B?TFlKd3R0c1VZOWluWGtMckJqNG1pcCtvQnlXQ1I3UE01QkM2aDZpUWtvM0RC?=
 =?utf-8?B?WEFiS3dXdTkrS0l2dHZjTjVFbTAyUlUzeVQwNGNDRUlkOFBudmJkcFI2MW1R?=
 =?utf-8?B?TmxEMHQ3SG9mY0doZmFUSzR6WWFQUnZ3MVFTNDNuY09SamowTlFnUkNLb3J5?=
 =?utf-8?B?Qkw1K1h6SzVWM05VQ096bE1TNlBhejQyME9uQkNaa1VpWDgrTEI1bmVRdzYz?=
 =?utf-8?B?enZtY0FWODZBY1FaRlVHTU4wK3lZcDV3VXo4dzZaNmNVcXhmZ0ZIdGR2R3hr?=
 =?utf-8?B?TWlGa25wMlRaUjFuVHdsYXlwczhXU3NRd3pjVmZEeHJrbCtocXgxcm5BaFFT?=
 =?utf-8?B?RHRVcFo1dUZFNVoxNEFiK3dzSVZWUkYvRTd3WUR5d1NnN2tMS2k2RGhvOEdC?=
 =?utf-8?B?WnB5WVhoUElNMmQ0YWZJWnhVUGJLbk9jREU1TEFyN3ZHZStzcTZhV2xidjRn?=
 =?utf-8?B?eDkyWjZSRnFqSkNCUW1qNmdmT3ZQVExFOWRHa2hDSS9YUmg2WW8yS1VBVmc2?=
 =?utf-8?B?MFU5SmJFbk9SemRYYjZzMVp1NE1KZFFwckNqZzhyR21tVVBtc0RRL25xbVQ5?=
 =?utf-8?B?dW9EVlZpRDQ4bWlDRlJBdnB2UUVRTEIyY210T1c3RXloWkZBZFdpSmhIUDBv?=
 =?utf-8?B?ajZuVnZVV09SNXFFK05xb1VvMUwweU1CM2RNM3lBUVdUVmRGVzRrVVRaUUh6?=
 =?utf-8?B?dWdlenRuQ0xhMitUaGRWVTZMZVQvdjdXb251bm1uUTNWUHI2dzIwdmlKakFi?=
 =?utf-8?B?MzZUbHlaVzA5VnNhM0NMRnRLYzlwUGI4MXNyRFBiWmNSQTZEeXRGek5GYTRi?=
 =?utf-8?B?a1ZHZzlwR0hkRitianoyU2pYK0N6NXQrd3RhRldGM1RYTDJkWXQ0Zy85ZGVj?=
 =?utf-8?B?SVZVRG5oZ2NxeDdMYVVzSmNpOElnNm9FcWt6THh4enhuek5zRC8rbjNMVzdQ?=
 =?utf-8?B?cTlweHZUQ1Q1bUFTam51MHRzVzk3NkNiZW0rUDVTTEJ2RXZWV1Qrd1ppZHRY?=
 =?utf-8?B?bStoR3JQRFhqZzV0dlFEQm5LSnRReXBCYkpQWTBMNm9LZENjU3Z0V2E5Yy9D?=
 =?utf-8?B?SlRKQk9LNmo2TGt4K0NLR0t1L3hZL3owbmhmMllHQlNac1FwRzBLcW51SG5l?=
 =?utf-8?B?WTJLOGZKZWpwU2dFQkNEZWdweko2SmtGaCtEdjNJRTZBZ3FSdmVWeTJvdTc2?=
 =?utf-8?B?bTBlNy9yLzI2aXNBeU0xVzBWc0hWOGhtVjdQVlY2UDFaczVsbXNJY3EzcFQz?=
 =?utf-8?Q?LqbK7O/f2U3gdh8VvFfIjv0tckUTBGKLO6AYS+AdRUlw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e81841b-8d2d-4d53-e175-08daf8697f37
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:02:01.8312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFJJPudOoHnkUXaSI8ryJDeC+medgUJvjm5Z6WA2XFFtoRXqjGYVfGb++qpNT5TdwJ/dATt37xpIgmPgkPOfWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9259
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 17.01.23 09:51, Juhyung Park wrote:
> The commit e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
> blacklists UAS for all of RTL9210 enclosures.
> 
> The RTL9210 controller was advertised with UAS since its release back in
> 2019 and was shipped with a lot of enclosure products with different
> firmware combinations.
> 
> Blacklist UAS only for HIKSEMI MD202.
> 
> This should hopefully be replaced with more robust method than just
> comparing strings.  But with limited information [1] provided thus far
> (dmesg when the device is plugged in, which includes manufacturer and
> product, but no lsusb -v to compare against), this is the best we can do
> for now.
> 
> [1] https://lore.kernel.org/all/20230109115550.71688-1-qkrwngud825@gmail.com
> 
> Fixes: e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Hongling Zeng <zenghongling@kylinos.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
