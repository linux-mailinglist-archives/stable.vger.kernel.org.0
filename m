Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD3764B660
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 14:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiLMNgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 08:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiLMNgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 08:36:18 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2073.outbound.protection.outlook.com [40.107.241.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181B18E29;
        Tue, 13 Dec 2022 05:36:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJNa5yLD8JtlXIsSkXPoNm8JJSa1d0k5WTw9lbfR9fqJ2E+aXHZye+yADLW6rjqviLmH1czR94AHszU4KyBBbuvuxFwd+qE7kJAe7Si2EnXjOqM76/7QPl4KYH0uXFfM2cZySRduWLnh3kx5ppyK3J1jyRbrqz5qBU9SmIyPi/wLusfR4yNTYfjmfJjuHYWifXfe9ZzvJXU765uVtWX1+7fdHMyRJYvDjHlNGP9MCYcipGxD+PLWZ97d80dGowNl1FGmxiYu+1TLf5gUujuRRKHiJfx7ndAbq/9g8OoCb4HEFg8SttmQRWXkvpUFhkaO5CMZgaD2NWl+0fwLznsggQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6PAdXM0jMa1B6kNQRap1uI/o4J6sPdYGibggRqH73E=;
 b=MvslIHt2HQO6SpgovAx/Fw2aEcmqEGOhwLgMerbNJvr2X1eHwYfsKj6WeB4kr0YtlhbrDBKXcVNgcxUeCOCrF1rvZfRxYovBcefTiuG41Gd5GLSmI1uewrVcl3XG5E2kP7k6ayxEOBputNVcavlNxu7dtiwGoeND2yTrkT/84eXPudlSidFmVBWEuWtQ004n9GduQbqtW1tZuhQ59pFvw6fid17JzA8Z6VQDBkmRiUJdqJO0Hi9Hp8VfAdpUGsIWv9oaPpEjU1/TpLahuZKCYX2pv+1sLrpXpd8CoZ33O92hU3Ls8AuioubLzShm536NJwDOZV0oykoBextQ6GsMeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6PAdXM0jMa1B6kNQRap1uI/o4J6sPdYGibggRqH73E=;
 b=stE5Sb/u7N61Ictw3F4KXVSMXU29rfKK5250YzenORkOrUxRfO8zmuBDfegcp3pkEwcM5A69bMkpa5zWewSI5eEE3izpsgKG5S8o0lLESg/SuH62zZN/W5Z5RO+zYtNyTd3t/nZokzS29yAIifdS6Wyb5zo42dKXYbGgoBMmTgC6RcxXcVJGzxm6Ip5hVmhFmr7hbmOJmm7vGqIhPBaj4I0DjPi4ajBUBafD9DjvbTeRsx80WZ8SBVHpOgVF7du0mP8yMujbs+QBinK9Gw8Uh7iFTPqH86dJMogEBSzBROmHReps5DhI793k4DaGBCgkzp9BlRTLL+Tlgdv6oYTI4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27)
 by PAXPR04MB8781.eurprd04.prod.outlook.com (2603:10a6:102:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Tue, 13 Dec
 2022 13:36:13 +0000
Received: from VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11]) by VI1PR0402MB3406.eurprd04.prod.outlook.com
 ([fe80::a207:31a9:1bfc:1d11%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 13:36:12 +0000
Message-ID: <c4408a3b-5862-3245-e596-613eadc76ed4@suse.com>
Date:   Tue, 13 Dec 2022 14:36:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     prarit@redhat.com, david@redhat.com, mwilck@suse.com,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org> <Y5hRRnBGYaPby/RS@alley>
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y5hRRnBGYaPby/RS@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR0402MB3406.eurprd04.prod.outlook.com
 (2603:10a6:803:c::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:EE_|PAXPR04MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d771df-a6f7-476a-7a30-08dadd0f0051
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K2YfoDaXMGnrXrdINSa3ThK8TQbfRSPwrFT9oaqQ7eHBezbUQ3KJLAzX7OaMbV+WiuoZIrPJ1vzOXAKZoyBNjbUPic8rBiXYBjMKTKYouSwYYwn9DxkxF0vHZdsQ+Y8E80f+yhm2/l2E2E/YP9LZfrHOQUWi9dbJvsT5I5Zp5/d/TRlCMymQApI6d4jm2VRWetlu4GDRHHBVm1xsA73qV4nfGOdLqkcVgTMViEKjO1I4U7lVGNxJFVc55DnXybW4QomQAbDTQbtuRLQLP8QzXHF0hP4zPg0y9gkWDXKP3YCPfVngX9fEv84yBraA5x8Cn31KwCsxM8q7JQCzfCcuGo/uLHC2yRxTr9BLQgVqzrpGXP507O4FD/Wwbce9GzvyR2Gl7uEuA0jtmGAhY+h7Z1F4j5qcs2w8bxq8NVSHwhQxt39IOjTfa9+W2MS/cHR6idtvcI7JhjXYkwxruWe1qUlZKOQO5DE/whvidJLFpSUTRMSoIW+57JsC+Pg9jFw1bFZIuM6KZKKv30lR7muSMy1G0LLcZuoCCMK0qKTm+H8MD4fPcrBAkE04CISUeV4C4bh8jkCSsyXVm27TvTdwpChVCzyfbG5f6v0WywqrD6OKYd/iS3jcvjUXYly6Lu/nSjUxLtmeC+AoFPOJIMAATNO+8lrx+jrRAf5fEbcHd1w+mzVoY//+o1uxQLcD5IMfFgk3fnj1Jmygl2xr3a5pXeXH0qVVha9+cSmIqCKS1Ss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3406.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(36756003)(86362001)(8936002)(6486002)(66899015)(38100700002)(31696002)(478600001)(5660300002)(8676002)(44832011)(2616005)(31686004)(66556008)(110136005)(4326008)(55236004)(66476007)(66946007)(41300700001)(26005)(186003)(4001150100001)(6512007)(2906002)(6506007)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHpNZ20ySWRmYnRmaGs2L0Y0Vnd5ZkZ2TEIwdW9hRUdqeHg5V044VVdpYmdr?=
 =?utf-8?B?QnBoYUJWaGtZbW4vdzJlVDRiK1M3M1NYWUs2VEpjZW5mRy9zK1BBazl5ZXJq?=
 =?utf-8?B?RmtPR1JwRDEzYURmU1lxc3dQK0R2M2pRMzV2cXF0dDN1WTV2YlZzNUVYSGVT?=
 =?utf-8?B?QUFyWGhQMElCWFRRUkFNVktvYVI0WHphVjNUbFNha3FkanNxOVYwRE5zVmRW?=
 =?utf-8?B?aFZnSjU2TTZRblJLUVVqRzJXMExpQzZaaTBWWC9JYjFCSkYzVzd2WURYeFVX?=
 =?utf-8?B?dVdNRXZodlJXOWdmbU9BWTNaNW05cUxFWkFGV3QzbDdhbnBGaXVQbmFFVW9v?=
 =?utf-8?B?anJDRzQ4aDhqdi9zV0VMZmJkSm0yNy9LSzd5aGNpNkFSN1h3UlhiSHdCL01W?=
 =?utf-8?B?aTJiblY0U0FBUjY1NDEvRDRLSFhsK0pZdkxZckYrRldHRm9TSWpYMTZlbFZ5?=
 =?utf-8?B?Y3k2N3l2SU1JYm1zWkpKQk9yY0NVbFg1Q0JRMloxYXZNUEZ4eW9MVUpJOGtS?=
 =?utf-8?B?anJGRS9oWFB2QlNqMklTUVJxcThaTzByTXV4V2xlT0JJZk5BRVpVckxzN3RB?=
 =?utf-8?B?dyt0UHE4SjBJN2MzMytmeGticGk5QUNaR09xbGpEbkRmM2t2QjV3eHQ0Ni96?=
 =?utf-8?B?N0Q1aHFRczZwK1N3amh5OUVYQVBsQUxCSTg4Y1RNc1EwczNFckNiem5mYVNu?=
 =?utf-8?B?bTJ0dTRiSDRETXlaSGRZSjdRVkoxelJteU1vYm1Zb084bGFKVnFMZ2pXN3p2?=
 =?utf-8?B?OW9ON3hQOXg0UE5pMjNOZUlGVDJXTWw0Qjl2bDNabEl6SngyaThhbUFJT3JT?=
 =?utf-8?B?ci9ENVAwWTBGN3d2R3Y2YlU2Q2JSTGZIYTVPd0NpZmZxdG9UbUgycjlsVXdK?=
 =?utf-8?B?VzdQeWhCSDYvZml0ZkcyREp4U0Z3Y3ExTnpSSExhWG1lY2JsYTd3UjR3RllG?=
 =?utf-8?B?MUs4dElZQXIycjRyaHVLeHRRRFJ0WUp5MUpjRVdaVEtmMStjODNZSHA1R3I3?=
 =?utf-8?B?SW1rNTMrTWJZZUZWQllHZzlsbDEvcmgwVWpJSEJSMzhwUmZxeXZ1d1pIVGVi?=
 =?utf-8?B?Vm9jK1l4NzgzVWtITFlTZ0owcTgzSUhZOUV6R0h2N2pVMXFSRW9GUVprdjd3?=
 =?utf-8?B?Z1NIOHVRWUg0QkZtV3JNS1hMQjROa0pHTEk4a3VRZFZaSm13aWJWeW5ZM3RZ?=
 =?utf-8?B?T3FNNk1mZjBuTE14ZGNXZDZYbEhCaFllOE1jQlNlUmxnOHRpYWg0Mk1IZDZH?=
 =?utf-8?B?bGJxMlhSeFJXOE9ZRndNTUpRNmxLeEdjc0JnMDg5R2dGWXlBRE8vT1hJRmU4?=
 =?utf-8?B?cllGYWVMTTU0RVhOYkRwaTNiS0lPZHUvRlhFRVlPTHNuMnFzaHAxR2FONWdS?=
 =?utf-8?B?Q3ZDdnozam1SYmt2UDJIaysvTFl5bWs1NWtVRENLSi9mOFUxUzkySE9ielBo?=
 =?utf-8?B?OWYzSkZ5c3A5SlRBdzNSbU5ZL0I2VFpGdlJMRU5MTlBTeTRzYUMwcEM4cjNt?=
 =?utf-8?B?eG93MWt1T2FSek5kb282TWdhSzhIbC9MRGxYUUJ2MERHQloyMXgzNkh5Rks1?=
 =?utf-8?B?eFF5aTRqRXFYNUZ6Z3RqUjUxUWhTYVJTaEZveEJYdzRDQzU4Zk9xdW9IOXp2?=
 =?utf-8?B?NTBFS1djZVZyK3pYR2dtNC9YK1IwSUlrTFRSNG44b1QwQTM3SFA5aDdMdUNy?=
 =?utf-8?B?QnF3d0E5ZDlPeGg3NnFGMVQ0c1JjUmV2OE9XQWwwbHQxM2x3aWZlcUZ5Y0g2?=
 =?utf-8?B?MWUvMkkyMGJKR2dobUVRVHBHQ0thUGtiR0FrZFJtMGVtMGpjdW5OS3pDU2ZD?=
 =?utf-8?B?ZGJzSytKZVl4UjFqWVF6WmZUOEswLzlscGtyamlzTVBNTVVDVjRaQWZ2M2FX?=
 =?utf-8?B?aEJ2ekVTeVp1VUYraVpSNm5uMFRoMVU5d3BtWE5pcVdua3QrKzFJMVhWbmZv?=
 =?utf-8?B?cGhQaGNpNExnUzVuYmxIbExUWGtkL2QyR2hyNWZ6RGxUN2lwdFA5akRhV1JW?=
 =?utf-8?B?dlJ6d2wrMDU3eTBYeHk5WVoydlBwZUNmYzYwK2xOQkdiczFLSlBKcEN1Tm1r?=
 =?utf-8?B?VjRBdjdqcjd6dUY2VWNBdTJjMTkyZTAreDFXdVdOV2grQWRJeUtOQk5DeFVl?=
 =?utf-8?Q?RGA1mDDXmMnsjrTA1qNgNTzYX?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d771df-a6f7-476a-7a30-08dadd0f0051
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3406.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 13:36:12.7965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDTjRAgO3WaMq13msh4ct8r89KUNpY47MzVVXTD3Qorpjehz76fJWJS/Z+xg3n43AyYRKxtBgyo5lZWP+ZUYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8781
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/22 11:17, Petr Mladek wrote:
> On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
>> 3) *Fixing* a kernel regression by adding new expected API for testing
>> against -EBUSY seems not ideal.
> 
> IMHO, the right solution is to fix the subsystems so that they send
> only one uevent.
> 
> The question is how the module loader would deal with "broken"
> subsystems. Petr Pavlu, please, fixme. I think that there are
> more subsystems doing this ugly thing.

The issue has been seen with cpufreq and edac modules. It is a combination of
them being loaded per CPU and use of a cooperative pattern to allow only one
module of each such type on the system.

Fixing the module loader addresses the immediate regression, but should be
useful in general to cope better if some module which is tried to be loaded
multiple times per N devices is failing its initialization.

I'm not sure if these subsystems can be called "broken". However, I agree it
makes sense to have a look at some of the mentioned drivers separately if they
can be improved to try to load them only once on each system, because they can
be viewed more as whole-platform drivers than per-CPU ones.

Thanks,
Petr
