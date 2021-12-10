Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DDD4706AB
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 18:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbhLJRHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:07:36 -0500
Received: from mail-eopbgr20120.outbound.protection.outlook.com ([40.107.2.120]:3606
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233725AbhLJRHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 12:07:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO9N/HFl69uzuB4tfVjUf6DxiwSMELvzzU9u1N9RJMDXNLATIgZEWeJS9uCIk6c7M2Pyga88xiwNvvmKMl41y4l+uE5eulbYbkhqYsFNTKdU3/9GKxpbCiJbcuCH7HbLHhKMSFb+/FnIe2LD9q00DibCrbCf5f97P7OYMEQ7LM0NBaFzkAJemuU+8vU1MvqmGJ0mkh9T2eiHNcBfm3hmW+sxg9kHGbuNYdpFv3fzinBiamUBJ4K9DUWznbJPk/cWtDoRjiEnw/8g3ls9epbUICv7wPWR5fSi0KPNNJPOHf6nFpFqhaZRnNGr3WWsE/xTABVkG9gvYjEMkOT24nkNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOtdNAPp9/J64MfMTMgBUzw4TcT//NwZW9DIUpJRwVE=;
 b=aisB1sk03aYHtaUJbab/1zv7c21sfdmQMQQ5pTrkYY/LjzeU1WVzrOFqy6+ksgG9Kd8gYa9lPIS0iu7Udsgtdpa8na+z+2cNsmLhbLQZUVE3S24ztX2aHkemKCB54bxntxo6eG54r1xfFYALuoKGGgznaRdClZlC5PV3U8pccuctSo+bkxTM4kMl+7Sy9teh5PNt9CK06tn/iu44FXKTIUHwprjRVmuTuLhiZ7DozULK8QQvvGhg8q3AzKyE2dIBTfpkzbBnos6n3D9rcBARyRNyLXQa0ArQk/CiO52VEjypJVzdal0RN4AhCNwCIn0J7AAM5kGLP1g88hnH0qfd/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOtdNAPp9/J64MfMTMgBUzw4TcT//NwZW9DIUpJRwVE=;
 b=aqt67vJ2dvo/k6v5aYXBkoTflQNBuT1nLucCtDzJOxMJSQV0XY5W9myISMgqc766iI+CPKNr/OXOQqXKEr2YUKlxt5u9A7CJwUMpKs2WOWvKPyrwy7r56c1XjLXHGQZzRkTM/qJM0a95DQsY33WHDZofvl91cvk5k+shMQAflr9slcMId99KwM6a643r4kwPR9GWjSE7wAUEAGDf+IzgWRTO6LAK8sE65CkIbbHytYtL6fRB8zLCGQp5u4/gy2x+5k0Yqv8tqNl07qzyGXBAML23YS77dsm9Fp9I4N5y9+q/T1Tjf+DLcCkr284SOxajEG/fV43SVS8PWe65AstFGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 17:03:57 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 17:03:57 +0000
Message-ID: <8367754b-bc84-0b11-f775-401bbeb2f007@eho.link>
Date:   Fri, 10 Dec 2021 18:03:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: FAILED: patch "[PATCH] net: mvpp2: fix XDP rx queues registering"
 failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, louis.amas@eho.link, brouer@redhat.com,
        john.fastabend@gmail.com, kuba@kernel.org, mw@semihalf.com
Cc:     stable@vger.kernel.org
References: <163915470517181@kroah.com>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <163915470517181@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0035.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::10) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a10:d780:2:103:c102:da5f:f485:2540] (2a10:d780:2:103:c102:da5f:f485:2540) by PR3P189CA0035.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::10) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 17:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cea19aa-bdb5-4ea9-bf91-08d9bbff0ddf
X-MS-TrafficTypeDiagnostic: DB9PR06MB8058:EE_
X-Microsoft-Antispam-PRVS: <DB9PR06MB80581D9C56A8BFD90537B394FA719@DB9PR06MB8058.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NkHRg81uJ7HYqcjv/m5laO5ZSo/4OuD5BU6y6K3NvVvH8ZbZoaKGpwoEy8f7TPGNax+U9cXSr4KtDLe3akAtdgf1jVWyvBBXgy04Zg7pOKIEbGptjn6KrCS8+6quJVQcDHO2HKBPP3u5MBBI/fZtD74zKot4/Q77aEvpp+WHhYQ3FF5BEfaci95yv1nIyQFgCWrdyR8NT5uGEsGbjvPteDnhEKf1vGZOKC3bsErMRcwPuilTYo0Nbv1Zj1hLFAn8GGz9QOYx6WpqD27s5meEOb3+iLN3cQ7VkUtWae0p52dXlzahTwpK25cY2t+0XPuwLKr64y3HpxdSl92F7UYPV1Qu0OCTACGui6R9wLrIGXRSh/hSLI0C48keJhvp1dkT61Xp2MDoKCynZMLknOPQ+35W15PQko1GIv8zatZjNxii16c81JvcNiR/MPUH8oLLREA52jLzi+jS2Wo40TsFaHEOcXW9RgY5TNtrB+Zdrj3lXBlJ+cFQiwIxaVCSFfSJvWpRxo+z8whDyV/FRt/RVODDPnzDJivGVjVCOFIA5VLTHKXU/LiAUJoDYrchHEDydptX/VgXfwsErXnYF9sY5+UX1gWU4bbL9o7JnlpPJzWsePhGZkqNgM9wJTmYCbivbJJqmEfN+otU8Hg/uHDVYenDndx/ue0XKY/m2fyaVoLZYxADrjyC41cIK4AwkdQMSLRriN9dTidxLs90mA2yQh7nRCjxfxKS2a3IOvJJP4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39830400003)(136003)(396003)(2906002)(6486002)(38100700002)(52116002)(53546011)(5660300002)(31686004)(66946007)(86362001)(4326008)(66476007)(66556008)(316002)(8676002)(83380400001)(36756003)(508600001)(8936002)(4744005)(186003)(2616005)(44832011)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUxQNEdrNE52WTRzS0hwdkN2TkpuaENteHJ2NmRZZit0ZHBOMGMvZnNMVmJX?=
 =?utf-8?B?NVVEbVRTaE4zL2ZXalRNSDJ6RGVUdlhiR1lFRlBkUlVzelViQTBHK2E0bkF5?=
 =?utf-8?B?bzhzK25NNHRFZ0FweXhERmV3YVJFYXR5UGFzc1B6L3ZScUhaNjE1VkdxbkFk?=
 =?utf-8?B?RDg3M3NaM2VKWFFFeUlUYVo4VHpUZjFoSlJMUVpQNjh4cFR2MHZkZlMrOE03?=
 =?utf-8?B?YXZtWDBRT1YyeUNlcTBWdlhEazZrU3RFaUc2YjBsUzYySkJuVWRRN0U5TmtM?=
 =?utf-8?B?bXhwcDloR0l4bFBWaXREOUZuRTFyQUh2Rm5DN3VWL24zMERJcVhtMmcxL1Vm?=
 =?utf-8?B?czgyWFlTU0U1UTJDUEI4NkpKd1E4bEowRWhUSGVvK1duVkpXMmJ5cEJCS080?=
 =?utf-8?B?Y2lMNytXQVhha0pvODVyaklEMDFPQVFSVEM5d3hXYmplRm81OTZncXNvY2pT?=
 =?utf-8?B?ZEprNnhGZjEzc25WN2ZhTHlKOWlVZTUwL2RWcE43MkF0Mk1ZVEdWTnNpeFBP?=
 =?utf-8?B?Ty8xdUIwRThOVVUvYXdQOE03dHh0WWhkM0VsOURSUGNlOUs0bjFBTkxoQStP?=
 =?utf-8?B?NUFWWEtRQXJBZjYxTFNTN3ZQN3NqbTZhU3ByNmMzNE1ZbXF0ZTI1OGZKM1lZ?=
 =?utf-8?B?WXlYaDJUWWRWc3pGOTFneWY3N092NEpYNUdINTJFbmpETWhYL1VEbktWVW1v?=
 =?utf-8?B?Z0lpZnhvSUloekdSOCtPbUxRT1krVmpkV1NLbVZ2MkJlazB4UEhxOEhDNDJR?=
 =?utf-8?B?Zmp4Z3NFNFNmSTBDcU96TThZMjlhVnlPU1pld1ppaU4rWFo5MmkvMjVKNDRl?=
 =?utf-8?B?eXR2c2NIckExbVNiOU1raWdBcmNSVjE1bFlHUk0xZ0ppa210NXpseXc1c0Ri?=
 =?utf-8?B?UGdYa2h4QzgzRmxDcUNJMFJRWFNlY2JnNDYyZFZSYlM2UnhLMGVpVmQzbGpJ?=
 =?utf-8?B?dWNBU0R3cVk2RHQ4T2pGYldQU2hkMll4K25uaCtJbXJmUWViMUZmZTErQjcr?=
 =?utf-8?B?Y01SMVQvYUt5aFZ1eUhHSnluSnA0NlpWcnF4VmIxZlptM0doZ1ArVnpWcVpx?=
 =?utf-8?B?S3J1djZHcm9mSHB1ZnZCU0pSaFRXd3V3V2RJc2RpQjM5ZWttMG16dE5sanhm?=
 =?utf-8?B?aC95VVNWTVlIVXlBbHNzdTJCL2c0VTcvTWRHV3ZRZVFqMFN6eFkxK2lTZnFl?=
 =?utf-8?B?SFNEV24rclFYNUdvVnpFWmtRaWx3djJBSWdpWU5lVE9rMllNWDFINklqN1JT?=
 =?utf-8?B?bTh0UGM3RlFUQy95YTQyM054eVFsNkhpU3duNUNlMWZOeGFCQndIeFFHZmdF?=
 =?utf-8?B?YWZ3S2VOYWNsWkJsVWpBVm5UUVVXNEtQeXduZDFWL1FMMVp2dSs5Rm5qeGRm?=
 =?utf-8?B?b1UzdjEra1EyRXlGUU5KNFN0TFdBcU9XRWx3WTJwV1YrU0QwVXVJNUxabjJw?=
 =?utf-8?B?Z2doajR3U1ZyWmZSRlRDS3RPUHdSQ1l3RU1PTnMzMTFlWm0xL0RxNjRSaG9L?=
 =?utf-8?B?WDJnNzRqOWRjSDdwNVFPcjJ3enBpZHhWZkZvREh5a0tnRFloRUJIY1orTDY0?=
 =?utf-8?B?Nzk3THYySXhHbXRBYlBhU3h4eW0zTzVZay80b0UyS3hzaG4waFV2bXJneXhZ?=
 =?utf-8?B?RExzdFNnMFllMjdIZ09Eeml3ZFJzMmlESndkRU1LN2V6QUV5VnZsczVzWDZ5?=
 =?utf-8?B?RHc2YlRYT2pFNFlhVXJNZHFDQXdybzhzYnNrRWRMR05laFpEZTF2R2hiNE9l?=
 =?utf-8?B?OU1YMTZic0tFUFlTOVRGNFpmN0RwWHg5RHQwSlRaMEJuV296SGNoMEcxQ1hx?=
 =?utf-8?B?N1M4WXREakN1NGU1TEhTVWV4cWxtNWlJSDkwNi9taE1EdFQyYUZYVHNYNERl?=
 =?utf-8?B?U0RYeWY1T2VWKzByNnhTZ3RSNEtONXd0czVQVjJOUFd0Z2NSK3l5TW5rZUsx?=
 =?utf-8?B?VmxYMng4MFZMcUViNlBlVHVHakMvaFRhN1pXN3hPcGV4VG5jSTVJNFQ3R0FT?=
 =?utf-8?B?Tk5CS2QzaG9RcGFFeUVJR3dIZ0hnMXh3SFVOK1MyNUYzbVM5aHJLUjFNN1RI?=
 =?utf-8?B?NG1tSEE1WldxYllOMTRMay9DODdUM2FKckJwSlJ5UDAxU0MxVDBLUFZJVm11?=
 =?utf-8?B?V0Yyc0cwSUgycjhpc2E4RFpUVlMrMXpteVlaQ2cyTmhtcXJoYlZiYllCakM2?=
 =?utf-8?B?WXFYV05zczIrUnBzU3ZvQmY1S2VzUjFOQXlvdHlJTWl0N3JYMTZYUjZsRWNi?=
 =?utf-8?B?bGJEUXVxd0VESnQrbXJwQy8vYkZ2cEoxN3QyckttMXREUHJBVEhiOUNOaWwr?=
 =?utf-8?B?R0hsY1RNV3docmJlZ3RSTUhTSjdTdXk1V1lSa0NLRnRMdXhhZEI2Zz09?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cea19aa-bdb5-4ea9-bf91-08d9bbff0ddf
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 17:03:57.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9e5yHe9XBKFgyaWM2bFgQ4DD6v8PSQlxKZ15pYP9+7KK9vEfPPD8X6EJwmeoUcDUBHAFjshiRWs785W9ddXGaOmXMXkOgf3a8XoQwYL0rNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB8058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

On 10/12/2021 17:45, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I guess that some context changed since we tested the backport. We'll 
send it back as soon as possible (Louis is working on this right now).

> 
> thanks,
> 
> greg k-h

Best regards,

-- Emmanuel Deloget
