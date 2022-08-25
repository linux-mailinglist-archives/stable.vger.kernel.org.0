Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3CD5A0DD3
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiHYKXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbiHYKXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:23:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20048.outbound.protection.outlook.com [40.107.2.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F1475CD1;
        Thu, 25 Aug 2022 03:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeF3s78Ogze5P3J6XslqYE/mXjeELvZOOXHRiZ/wRROs4NH2HvJqA/gEL55IPiY6wbOURemtbeoW3gEsR/OfWYsLw9DCZz5otLqmk7BY3hTQB6fkLkKpCxYY7FpunqLFBqsf12motA00v/hv+QLkLfbCMaenhbmu4/IVPFaFlg/IqUD8KDsEx8UEc20RJ7K4AVogGoN3DsheHeNHyV3UU5ovC8pKwHun+3XfvEZHOJ/RjafLS7CTqSbIlsy7C2ZoUgbVd1mtjddDIc/xp1xS5gywiwDfUIlibTsO+VDSpdGsU3txmDk/d4f9dncM/eiWHoVA8VexVoJfsa1ZXNT1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRydoAkaKXOhDms5UqmA8zzHTIkqILjL7ZD8DZsJqW4=;
 b=DQqjg92XeytlI9RBA5fRp9glP6AjRCnNLteQYN4ZJsr1rarDwXqWg2mahsGyMFnFVoiBaiedh27N3kWBJXvJyjT3/65KZH4Bf5wfrYouTl/ArflPVJPXGzbNcLEWvW8Jrc2cv7I0OLcKnY1AR8CkPOO2IE94myi62jJNtjOEf0hZIwSYb8XUg5KZ2BUoqDSTIBMtAiQ/nl5v5TJQ1CgMk0wZo/QnTp7JHnGozc50DokWOlgHuYpxAT2501YkkroCBZGBag9CW3KL74l6b56iUROw4JRVya4tdpmMVGQmsm8xuKKnBHY+HGxuEHb/LEHCrmKWvy7hNILppIPRdomuTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRydoAkaKXOhDms5UqmA8zzHTIkqILjL7ZD8DZsJqW4=;
 b=cR0Oof2W/dlwz1MFoqbX463pI7cTlj28SPuwQFclHkbqh4WkmKjLUInXSThsALt1rYg+LmKSwXq8fSl+ES2ikeXq2wHJfdKtAnT3mgkmbF+GhMb1fsCAVMMG1aqFMIEjUlGMFNbbkRWWPDE0j8CPo/Vx/bnSiq0OffeTM4ukfvIR14y/Ut/bs1fcHEP40IC8VT8eBATAzKx52OIgOs56EaM76miHEUINneNkkFGf+I/mZ5dfB3vVk+QnNHYKFp6zTtRFjUtZnU5//En7NcTPEJCwDZkpsO8osxSQxldEfm2ooS7NTCZDiSOMgjCu3p6OWp2C4vAxC7a2Rhk++zKFHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM0PR04MB7124.eurprd04.prod.outlook.com (2603:10a6:208:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 10:22:45 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 10:22:45 +0000
Message-ID: <d0ef9b45-9730-c9d5-a57e-9b7860d84a13@suse.com>
Date:   Thu, 25 Aug 2022 12:22:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825092600.7188-1-jgross@suse.com>
 <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
 <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0132.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::12) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ae7c851-065a-480f-8959-08da8683c07c
X-MS-TrafficTypeDiagnostic: AM0PR04MB7124:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+fnR6aq7kfvJz4MiGA+i7TtEu+wEa08wnRBua12KsYxmzx+0Dz2HpzeTO5TfFrVVkpOTBGXi3bOI6aw3eUcln8PdEfwc8BjfLsOedxjbI+kBcCeYNumpTmWpGkgM+F/nqCh9xd6z0AwtrEV6GC6Db+FYUrm6VjOm4QCCmIribWJqaf2fwZIWPDpZmul7uDXP7j4ZJIlk2iuy/2I55qJt67saNl0jWHN/Vd91hvmIMP6Z4o9ZWs4oSMMzK/7Sh32k5dgSrYYyLdfDpc11ophTk7DOJ1XNNVGZSF1ZnxiPx+0CPbf2eGsDJdw+0JJl7OuYDeQxuliD766QlCzSRhxbUzooS5Rz0/Mg/XIDBPl6UEpAbFQrctqxhAFQV5asZPIJf1fqdXJ6kG5PEGm2CYaHvsuO2pqiS3MndDiSRJwWvTBICF7aJ7bBVaR9t4HeF78RraDK63CTbe/lU9RKYtaGFOPuLJr/oeRF6m8mPhRA6nuGDWeX/QTdIhsbBH2t8Jjc5N3xzCXLvdukFNAaiWU4fVWQHHslZhOL7rKdhaZDH48LfEEK9Qfox/UZU7/NcCeBLlGtbhJuOTwJwU46CndYiHSzWRFu4teGsrhLFxQTocLztiAr5nJBrQ4bjFyYHca5D3qz0SFTbdBKhIxCjnpi4ymimZeYvSe+elMqmG9N93+uURwUUWQeoGX05COFthcDbw0JBIu5ot5TVKcEvgFfApP1woKuVUioVwX9qE6u/wttEzkMafIIaAXujJWpnWt+ruEK6B4wbbxYd4cAllfYrLSLQtJ67seRv5FAvzc1Hw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(366004)(136003)(39860400002)(86362001)(6666004)(8936002)(41300700001)(38100700002)(37006003)(478600001)(6486002)(6862004)(66946007)(316002)(6636002)(54906003)(66556008)(8676002)(66476007)(4326008)(31696002)(36756003)(31686004)(186003)(2616005)(83380400001)(5660300002)(26005)(2906002)(6506007)(6512007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmJ5eml3Z2VUOVcvK0NpU3NtL0lMdXFZVEg0akNDSzk1L2xURGlISFVWRSs1?=
 =?utf-8?B?aGpGMGxURXNGMFYrbzcyVjBYUDRwQ3N4dWhSRW53M1lLZjVnS0VzU3E4eUpZ?=
 =?utf-8?B?RStxZldIZ3FWNTBUN0Q5c0R0QW9JWDdpTmxnZkFGRnFMejlaWXU3UjRpcVlv?=
 =?utf-8?B?ajNkOFAyMVM0T21QTWhZenZvMVVLQlgvaGhVdVErVDU0UDJuSldGdGk2Q0s3?=
 =?utf-8?B?OUd2c1cyWHd2QU1HdUN4cURFSVJHbUM2TVhmczZUaWhaKzZjYllnWkI4TC9z?=
 =?utf-8?B?R0lSZ1g0dnRTRUU3NHJYVXdlSHViVkp2L3hxSW02c3VUeWJNbmNSR29LaE1T?=
 =?utf-8?B?dGhIbisvNXhnaW92T0tzRmI0UG1zanBveGJCZlJ3dXFXSVNUZkVWTjBKT1dE?=
 =?utf-8?B?SVRQdDJOby9UUi9iS1k1dXg3OTIzeURCTjJyZmptK1pNZDdkZHdIUGcrTVRi?=
 =?utf-8?B?TFFQR1hSNjgrOTU3M2w3YlNrZ2QyOFhEMFpiKzNXendHWE45UzhuYWpuQU1Y?=
 =?utf-8?B?RGRzb3k0RkJ4OFdCM2JwalZjVGthZUh5OTFQTGpmRDNyV3ZYa1c5bklaOXNu?=
 =?utf-8?B?c3JBdENtSmhxNTg1cG85U3V1UUxqV1lDeVF1cnFnYmIvSzJleVdjWXRPZmY3?=
 =?utf-8?B?ZFR0MWhHcGRFOFNMRU41YzRSbzRKR2hLVlFRVHBMMWd5cUM2Q2lRUys0cHVT?=
 =?utf-8?B?YitESXZsUzVhZ3pxMStjblRkNkwxQnlaZmlCYzYvMmdGc3VUZ2ptT3RnZ05o?=
 =?utf-8?B?ZHFIN3lEUFhTMGlaNHZtY3lZa3B6T2ROMFRqZmNiNWdqZ2tjMGE1a2diN3RQ?=
 =?utf-8?B?U1BjVkhPaHMrbG1VSnFJKzJSM2tsbGlkVmgvOXFla0tJc2Y1emNrTXpWNVht?=
 =?utf-8?B?R3preGpwekVLSGwrZzNEVGNscks4SzRSVXZlTUYzYXNKYkZaV3BDUVZBOW9S?=
 =?utf-8?B?QXl6c1A2ZEhmdTdLWDZRU2hBYzhzZWFXbGdyeGlIOGhPemU3dC9DVW02eXZ4?=
 =?utf-8?B?Z0laaVpVQUQzaGx4bDBkcnFvdmVCOW1pQmNTbW05T1U4WDliRkEyTTRIZGhy?=
 =?utf-8?B?SlROY0JYUFkyNXBBMlBKMEgxTUVlY2pHSjZQWXNTS1EyK2tMNzc2TG1zZlFz?=
 =?utf-8?B?NnFHcFBHcWRHMk84QTdhMVp0YURFWW5QOEFGZDByV29KN2E3QytmSFBrRVFF?=
 =?utf-8?B?enZiTThyMjNyYkd5SHpxNTRNaS83aHB5YXE0VDFEdTFtSHBpaWRCYXRMMEFR?=
 =?utf-8?B?UkdXRTkwMjdpTTJGSEpZeEdONjc0R2MvNGluZFg0eDVOMEpxNFpGcktkTlFa?=
 =?utf-8?B?V2FtM242TWM1SkplSXdscFdFTmFSbFZ0cGhyYkRjWlJnS1diaHAwelhQY2xz?=
 =?utf-8?B?SmhCK3ZIWmQwTmFsN1QzRjNPNGJPZEFnSzgyUFY0MmQ2VGxKWWo0QUNycTVw?=
 =?utf-8?B?SFB5ZGY5TzkzWC9ETkpWbTJkN1d1ZHIwQlY1a2FRU3E3eStqa1pRd3JVcHlW?=
 =?utf-8?B?VDQwbm1NVU4yZ25KZnhhbmxqMEtuWm9JTktOUGJFTENHTEptRjYxT3lXUzI1?=
 =?utf-8?B?UFBXYis0cE5Vdmk0ZjJ1b0RQOFVISkoyUDBzU3VKWFQzNDN0bXZZSDFldk1K?=
 =?utf-8?B?OHM4K2VpbTBmbkp3ZzFhbGZ5ZzRCRzJBVjlybFN4NkR3UllsNTRCSUJQT2pT?=
 =?utf-8?B?MHBDZkxCZldzK0lOeTB1Y2U3TTNWMFl1SW9Gb3g3QTA3bm9NU25JWnVpTTAx?=
 =?utf-8?B?bHRXdys3L215K21JR1R3d2g4VE9rajVFTGFkNUhUU0RBa1loRXkzbkI2USt0?=
 =?utf-8?B?bk9sMU1xTmFBSlVpSWNxNzNJaVhwMEFaS1JNcDZ4dFZPcWtncThyTTBXNmd5?=
 =?utf-8?B?cVJRWEZ6Q1EzTzRMYU5wcXEvekNNV2Z1Ri9kMUtvM2xVSmw2NTdjSWZNSjhy?=
 =?utf-8?B?Z0FoREFncmkxOXE1aVRFZWMxVEJiRGQwRFd2WlJjdXg0QWlveDczRDM2Y1Rv?=
 =?utf-8?B?ajA3bExBS1g4SXU0OGVZNU50L3JQV1dkb3pzU0s1SXNFZVRtNUhwS0dibUdZ?=
 =?utf-8?B?TGJBZDZDa3kwVnlHVkViU0RFQkNRenlSaTV2RHJKMzUyVTNuYUdDYXdhQUk3?=
 =?utf-8?Q?9a62fMMxxZwRqcDhSTnEb/iPq?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae7c851-065a-480f-8959-08da8683c07c
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 10:22:45.5977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5foEZJRthTkIv3RiE6Mux4Dov3CPRIxaRWwSWAG1xqxErITfGIWwAEnt1YVp60+2bFZCqPl5n4dw7pSRTo7n1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 12:13, Juergen Gross wrote:
> On 25.08.22 11:50, Jan Beulich wrote:
>> On 25.08.2022 11:26, Juergen Gross wrote:
>>> --- a/drivers/xen/privcmd.c
>>> +++ b/drivers/xen/privcmd.c
>>> @@ -602,6 +602,10 @@ static int lock_pages(
>>>   		*pinned += page_count;
>>>   		nr_pages -= page_count;
>>>   		pages += page_count;
>>> +
>>> +		/* Exact reason isn't known, EFAULT is one possibility. */
>>> +		if (page_count < requested)
>>> +			return -EFAULT;
>>>   	}
>>
>> I don't really know the inner workings of pin_user_pages_fast()
>> nor what future plans there are with it. To be as independent of
>> its behavior as possible, how about bailing here only when
>> page_count actually is zero (i.e. no forward progress)?
> 
> This would require to rework the loop in lock_pages() to be able to
> handle only a partial buffer.

Oh, I see - I've misread the code as if the loop was capping each
iteration's count to the capacity of some internal buffer (as iirc
is being done elsewhere). So ...

> This would add some complexity, but OTOH I'd get an exact error code
> back in case of failure.

... perhaps not worth it then, ...

> I'll have a try and see how the result would look like.

... unless you think this might be relevant in certain cases.

Jan
