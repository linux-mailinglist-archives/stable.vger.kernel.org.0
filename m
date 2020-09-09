Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372FF262DF0
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 13:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgIILgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 07:36:42 -0400
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:45280
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729521AbgIILf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 07:35:27 -0400
Received: from BL0PR12MB2577.namprd12.prod.outlook.com (2603:10b6:207:42::20)
 by BL0PR12MB2513.namprd12.prod.outlook.com (2603:10b6:207:4a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Wed, 9 Sep
 2020 11:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/nu0L42PiJBSIPgAqnP2hAX1cgUwyL9hGjyOv6FtBM6hYbpElNEqeuX2SBjhi5A9C3hfwT2RPo7CKME1VE5IwezwzMY+IxSEfHXR/9i0nCkpfEFXq79Z4ujy1ct1zDcN2E+mnDyVdn34OewDeBYgNN2cUhheIZY9wdb8BZ/PwvfF1QGBa/qwPjOmY3uU3+1d7JO0QDIuKJmAuCFV4CD1rBNDcE8tI50CdQXClEQ8+B3NeS86IHzbSQU9cv3s1YxYV+X9BVZ0pShbmJFb3fxp1qC1yO+l6kabGhtw0DEtKSswpFuCDk44a+LGc3O7lnFQTk2lHl9e+o9hq64s7DMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkimQOEDA2SAtuJdk0i0H3cyM41EypixKoicSSFeZyU=;
 b=QKFGzAG7CJnsl05QUVx4o2T4xdd4Yd4P9K9PxmT1zcBUq8LrwKjxIXwCK5x0FnxhxkzyxFHWCzB5fQcDsXSeQjPDI4Nosnf9JmJnvXPk/FbuBr7nzoe7ojWXrQHXDWEBIOYaDDUyjwJ95rYDr1mIUdBEmE61VuCP4P0M6QHIabQh2puOzqCH0xEEC4D7MxNTEBEqE/2cigq2Wk2wDfpNBbq1aOU0hdtbd5avE5Ps/M7EA6/OdjsLyNWGEanpnb31ikKjXqNTZwqzT4uT0Pl7SeChUcR5E/VGUmc6c8eucSjaJdMZtgUvluknO/797k55jT3jLgL+CCLSEL9E5wNgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkimQOEDA2SAtuJdk0i0H3cyM41EypixKoicSSFeZyU=;
 b=0q7osHpSz0W37wDyPbfz6t6rwAcyDXQnFAX9M0mN4hitZGMasHCfRQGOR99rmpBnGCFxGPoaqxPcPHlCgtK2UC30vkX+bvLZMh+09sSO3cSJk4Yuhm5YHPTeCTEb33Duv8CcgHBRCRMGXKBusz2hzS25rmzwnJHWV827EZA9FOo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB2577.namprd12.prod.outlook.com (2603:10b6:207:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Wed, 9 Sep
 2020 11:15:18 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60%6]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 11:15:18 +0000
Subject: Re: [PATCH 5.8 101/186] drm/radeon: Prefer lower feedback dividers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200908152241.646390211@linuxfoundation.org>
 <20200908152246.531365310@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <77ec0338-32a1-6379-858c-359f636a0e58@amd.com>
Date:   Wed, 9 Sep 2020 13:15:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200908152246.531365310@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.9 via Frontend Transport; Wed, 9 Sep 2020 11:15:16 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f4cbf93-5393-4fba-8ee4-08d854b1a201
X-MS-TrafficTypeDiagnostic: BL0PR12MB2577:|BL0PR12MB2513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB25776EE5F685E85BA94B9BD283260@BL0PR12MB2577.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Up87vEtWHoLtcEDi2I94AE6kUkUbEkhiXxRv5vQ5LWlvjVi3HuyGwbg4pmE9R4vvfH8aaZ17Zx62wnLGOiGBBeKpA30VhXbOBV3rdhwUPxb60GSr5YNMXBcRH3dji+e6nVoyk/ibBV6iobQU6DsKtGH36XE9y8nxhYGh5wLR9k3gg8qjEecyzqTHZKsYxSL2o508mQ/KIOUMaNcxISRAiF24EGEP+0IhtZlY5q8EHk96nDxbNsm2TUyjbiKAnG/wFRm62wyfMqQvVV88G3SMHsPsX0ACYqaQmEgSz5P6NvTdKHhQ/A5PNPzEGCw2VkbUg5am7sqe+hawzvyTsg1+PNRLZM0phziRBaun5MKtf0Da0e2NbXpX0OzDQBNvFgd/4aG1/u+yi9XEuS5FpewOdWm80hzcOMDVI4BqegmTc/VlbQV7BADJF9Ty4vLuzNCuXIjLLQfiWjvJwarWPa7r0mtvmy9UUssd0SrsPcDcldU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(346002)(376002)(136003)(66556008)(45080400002)(8936002)(478600001)(2616005)(36756003)(6666004)(966005)(86362001)(5660300002)(31696002)(54906003)(186003)(16526019)(66946007)(66476007)(31686004)(8676002)(4326008)(52116002)(6486002)(316002)(83380400001)(2906002)(66574015)(154273002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X4QwmX8+WXpAga+WiaX4Q3MLSjGA+3EjjKn8GMYjRiEEa7bU2EvhCw5dvJs1J3h0boXTiaXsvS39dJtd2KAIvXVcOPWxY8EXe7rOkIe1jTq9FXqbWcfdxOAcwDI/Qe3RjmQO3baPw1L6SJIqeFAN4HyH4eiorR6Hnzq8FAQfxPDZYn7XnbsHpqJwbl7hBmT6WsIUD1/WOmY2S7rBYkkRS1czI0vg+qBWpJ2Plqur7XuLce11L1gakBM+E+y4bZZkpOTGJqubTGWlTaGHkk8geiNNKODyEya3hqt3BS+6VeRtmHxUHmFy22O35Hvu9AXv9PNLxsg4Nma5TW2TD1td6u4CuVT2kokbTcx8FzeDt8AqVdm48deMzXIyf69U3Gtcn5vCxTC4jW/8XrA0OrcKIPoLRs7NAzVTEE/pM5G/UMfjJtBt92TfXqpNDIwmxRUb9nKy7VLag2a3L7lGl/EJKfWl4p5/aA+8ag0YiR2Vc1V54b5CfYjcRAFTmScZ4is89ZXoMJD7Xl5Tb7WBkwv+upVe1fLHZnXkcY1pfcxS99HCKEXzictJkPDv136LGjEeuPeoAskil/8ftS0LySkK+RAhivrriV2vzgwK9hkyH6dx962QNJaWfLmj7CzBc3mzEYPPp4yxYzJ7MGL5yra85BeRWCR8EzrNwoQ1fsxjQ6jn+gfZAgZUOkK9UM8uurFY9UrVdgjxZAlWVteoXkSxfw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4cbf93-5393-4fba-8ee4-08d854b1a201
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 11:15:17.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u02+UWhoxzBoLlI1qv3T3RlZrKNqzszbB3/WkeDalIt3V+nK9HNvI/fNS0NrwfeD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2577
X-OriginatorOrg: amd.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

please drop that patch. It turned out to break a lot of different setups 
and we are going to revert it now.

Thanks,
Christian.

Am 08.09.20 um 17:24 schrieb Greg Kroah-Hartman:
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>
> [ Upstream commit fc8c70526bd30733ea8667adb8b8ffebea30a8ed ]
>
> Commit 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
> fixed screen flicker for HP Compaq nx9420 but breaks other laptops like
> Asus X50SL.
>
> Turns out we also need to favor lower feedback dividers.
>
> Users confirmed this change fixes the regression and doesn't regress the
> original fix.
>
> Fixes: 2e26ccb119bd ("drm/radeon: prefer lower reference dividers")
> BugLink: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugs.launchpad.net%2Fbugs%2F1791312&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C9fcd8f691f97451da30608d8540e3896%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637351767352887370&amp;sdata=KKx0nGwITXVSg5Bg7XJHbVh0T30knZDioivKxO4%2F%2BB0%3D&amp;reserved=0
> BugLink: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugs.launchpad.net%2Fbugs%2F1861554&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C9fcd8f691f97451da30608d8540e3896%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637351767352897339&amp;sdata=KWknTc75Zjw3clREsEfY6wtDcv%2F3gddeyHhrhlHN0nY%3D&amp;reserved=0
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/radeon/radeon_display.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index df1a7eb736517..840c4bf6307fd 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -933,7 +933,7 @@ static void avivo_get_fb_ref_div(unsigned nom, unsigned den, unsigned post_div,
>   
>   	/* get matching reference and feedback divider */
>   	*ref_div = min(max(den/post_div, 1u), ref_div_max);
> -	*fb_div = DIV_ROUND_CLOSEST(nom * *ref_div * post_div, den);
> +	*fb_div = max(nom * *ref_div * post_div / den, 1u);
>   
>   	/* limit fb divider to its maximum */
>   	if (*fb_div > fb_div_max) {

