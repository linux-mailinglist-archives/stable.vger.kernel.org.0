Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB56059DB
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 10:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiJTIdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 04:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJTIdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 04:33:09 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9478218C966;
        Thu, 20 Oct 2022 01:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXZqPyls0o5Y9sJ31Oh/9IKM6OdrbeN9o4Eah3BM2i1zw0qxNY1nsm7UaFSAHnpAvTwifDn1KCuUR0YRWpo9ytEgqye/kiLxU11MwEuhAFwdV4ftzp/SlwuTpzxrpHKx3t4cWtxFoXx3ZetNXvIwQIYYWmM+CQmxeywTtz+SrLjiJe2vtqZBfaXnMo7zfvw9IYEwsPCsnpJHysgSVXiL9bsg5goS8RyNU2I6J692XCEymKWmHswUMJkmYmyykLcYFT7js7DvT1iY/JA6yP7ikaD7ek+WuJ98mDa68jt9abZOo85xNs/FGY0mJ0d9id+nla+k0yaA4lWunjf2PUoAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGxT5GolkJ5cy4DYPUQBdD7diD47paThoJ3YMBMYWo8=;
 b=YrHo0QdjYPTeS4nK4dbLhKWfs1eKTs0RK/c5vYh34guVafDredKXrdFHarcDEw5f9KOupJhv2C1z/0pXOzPpK8p6vvOtZ98qAKp9VY0hiUEs/G76T0b5QJayT6vWwa9nSpMSSBmewyK4QSAltj8UnXGz+Of2Nv1hGoOU5l8xVVDSUCXT6wbGuv7Ar7aPGnfyuZ4F0aogoyM/ZZkeRBq8UGerxoBttXq2k7qrrGIkYHY1xrcoDEvHXP5vlmdfzE3d7TVoIH6C+fdSINfAuGJAdiMbbRV4UhlxYaAuQ2IyKPqqCibUgKnfdxM/d8Lpfq5GfSF4CPsyVNJ2PRGLoWfWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=theobroma-systems.com; dmarc=pass action=none
 header.from=theobroma-systems.com; dkim=pass header.d=theobroma-systems.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theobroma-systems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGxT5GolkJ5cy4DYPUQBdD7diD47paThoJ3YMBMYWo8=;
 b=U1FozSzxDRqeKptQYdT+/w1xFcHLg8m7DUPDvDL2A2ybYsenY9oNWGZMAEkVKcoNQRP8gnKtRsX1GxmMFD/6jAfOqYCJUd3E9D5yzT9yHE70C8pBZyT94hOxWjIiBd7utafbTef7uRELNUqDJLoP2J3BPq+XisfOe3JNZgIgb/xRY5UUVKRMjx2VAGAClO1PmCMC3t+vPzG840aGZt77M5+ZtHlmy0tH0xtj9KTvdEE4NZvHoX0JCry+HXhb7pw0iUnSgVf0eexRG0fVYWNtA7Wm2oMirdwLfqhI6MonKBiNoaM4aGehFrOiBgBlrj+1u6tuTQuzizlx2p1erQzy6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=theobroma-systems.com;
Received: from DU2PR04MB8536.eurprd04.prod.outlook.com (2603:10a6:10:2d7::10)
 by DB8PR04MB6857.eurprd04.prod.outlook.com (2603:10a6:10:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28; Thu, 20 Oct
 2022 08:32:56 +0000
Received: from DU2PR04MB8536.eurprd04.prod.outlook.com
 ([fe80::5e5e:1989:e5ec:c833]) by DU2PR04MB8536.eurprd04.prod.outlook.com
 ([fe80::5e5e:1989:e5ec:c833%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 08:32:56 +0000
Message-ID: <6cd1ce13-ac27-11c8-9ee2-616ab49d4105@theobroma-systems.com>
Date:   Thu, 20 Oct 2022 10:32:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] arm64: dts: rockchip: lower rk3399-puma-haikou SD
 controller clock frequency
Content-Language: en-US
To:     Heiko Stuebner <heiko@sntech.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Quentin Schulz <foss+kernel@0leil.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
 <Y1AQHqm+cOmrrveJ@kroah.com>
 <52349f5d-661f-3e38-9745-01a84ddf820f@theobroma-systems.com>
 <8130714.T7Z3S40VBb@phil>
From:   Quentin Schulz <quentin.schulz@theobroma-systems.com>
In-Reply-To: <8130714.T7Z3S40VBb@phil>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0551.eurprd06.prod.outlook.com
 (2603:10a6:20b:485::12) To DU2PR04MB8536.eurprd04.prod.outlook.com
 (2603:10a6:10:2d7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8536:EE_|DB8PR04MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: b199da9e-9a17-43f4-d69e-08dab275b04f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xOo31YuuWmRdW9IRdU8jRWXvN3s6BX6vb9lYbSKo2J/pB0zW1ZlbLs63J+YxYySTd7K1jlJ1EhfQx2gBIehE2WBteD1+0U824bQ7gKAb2lJ/tZIakKlZlIQKjwE0OQlaCfnVygEn9hvCfIPA8l0QKel6hlcS89CY/E5ZXUZKMHD8Akh42wI9SBalLM25udFT8LkRK03rDYqGFn+70/ePcdvKEnjvExnO70ojbiqoxEP/dsczkvb5X5MmellNQggyAE/L4ZTFmEockUQTgjB6sjtA+SG2EhmxOkAG0iZy7EJsMZ/Sp5PrBcZTI0SB00DnlwA0aIgmX7x5WKd2fwyDEJ3RLRWmBUgSxGyKjutCCZvUiJ4vkBMaDyxCnADhorJ3h6Ox4C8MdLJmz5DfJ1ZHD4izSsVw66ygLhGBFkVk8zEorIVdjaXz7cDpRdbdhOxhbxrmc2UVALLxToa6umqmRSBiwp7d6pyKW1FlQo0+y/Oynk9GGax+jIzkBjTfqkWTsLTdoXq3bdGbkKSm/0Eg3CjSV0uMvVTOoye5pDaCcTeG67il0O4StUt/pKigApSlEGll+9zhJB+3WiG96JXEiqLXdPqccifCSkfypoqVn3PA/tOtKp442Zq3m0n8BvqqhYVYYW2jRDlTTaWSVjxQr+vj5uL7tNjYMMsdJz8U9u6lGmId+jYAIPcQcoDHkywnm4ksj7vYu4s9kU70sHGaxom5uS6XhJ4sQsNwoibBpPUngilZYIyYIhaC4uP1qTn7wletabZsbLVbWtxyS6AtjRHxfh9GK92Y9mQK1E8+obPCiflPzC0S8sQWI6IPHdP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8536.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39850400004)(376002)(366004)(136003)(451199015)(31686004)(31696002)(2906002)(86362001)(5660300002)(38100700002)(44832011)(186003)(7416002)(83380400001)(2616005)(26005)(316002)(6486002)(478600001)(6506007)(110136005)(6512007)(8676002)(41300700001)(66946007)(66476007)(53546011)(36756003)(921005)(8936002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3hWdm4yNE9paERPbnJYdk9sYXNnbVZ2VnQzaEZ1cElybitoK3hCcndpWURB?=
 =?utf-8?B?NDJ6Nk5IbUdRbWRESTBKVnVYMk5HZGFvMVlnVlhoUDdrcGVCVjFaSG1mdmtP?=
 =?utf-8?B?QnVNMWhNdjlMZTFQWkVqZURUak1xbmFyRFdiL0QvbnVWY05GWWMvVThyaVgv?=
 =?utf-8?B?RmJFWGlxRmF6VXhIdWRPbzlVNzM3OWdpM1Q0Q21rL21vT0VKZHp0RkdoSEZs?=
 =?utf-8?B?cnMvb3M4V2QyOTF0aEJUQVo0NUhkMnhreGVLMllIZW4wT0tCN0swY2FRNUlL?=
 =?utf-8?B?UFl5S2hHNmRnejRHUmtWOWZuWklTYWZJTVZFYVhNc1EwRlJJV2V6cERxcS9Z?=
 =?utf-8?B?T0lidHlBTjdTSE1BVmtxUVRjSXYzU1A5SzAwNjVGWUp6VlY4OW9IbFhYL0Vl?=
 =?utf-8?B?RHZsSm9NdDN1K2hwS0s1cVJIKzgzcFZ4WEgrTE1HT1d5dThMbVl6MVRrbTda?=
 =?utf-8?B?VEpkSXF3S1M2czhlNEtsNWc3VFNaYU5zKzZ3V3I3Mkl1TnV5dlBKYW9nZTBN?=
 =?utf-8?B?KzlHVFlDb25CbHRIN1hrUjNCMWQvYU8vOU8xeGRyZFVYVVRWWjlWSDdZUXhO?=
 =?utf-8?B?YmRQUUprK3ZtMVdOWkVWNmoycVBhU0NmT3I5SFBRUG5MZWZqR05aRHBwWlVK?=
 =?utf-8?B?Q29NMHZyM05FZU5LSzR6Z0xxT1dsNTFGb0xLMll2SllxQ1BUR09Oc1VpR09C?=
 =?utf-8?B?bG5HQ0JBMVkrdC9iYVQ0Mm8xaytYWCttbkluWU1XTDdwaWJUbmF4SndkTStI?=
 =?utf-8?B?WmRjQzZyTzJHbVg3bExRc3pjWG96TXlQY0h2RWZERHFGeXE4eHM4VUtvNUR5?=
 =?utf-8?B?R01LbGVNUy81amRxV2hjbURLM1diVitUSW1SRVltN3JnMmI1Q3hDSXFtQXBC?=
 =?utf-8?B?NHVRbVdXZTlSd1puQm9OdFplQnpBLzNZWWk4TXJzWlc3R01McXo5QTJKOEEv?=
 =?utf-8?B?SzFWcUI0NFZSU3hnVGlLaFlNSnh2dEp1YitaWnZtNDc4L1J4YUY0c0t5Mkcw?=
 =?utf-8?B?aTh4TWd1WWxBSGlPZFhpMkZWVGVENkxzV0lSd2xNU1gzRkZFYlRRWEdLN3pl?=
 =?utf-8?B?dE1VVnpFWnl5enZrTFpnZkxycmZ2UHRoZkg3TnJPZElJdE5oZUpmaW9vQlJH?=
 =?utf-8?B?YjFkUlVvWW94RXI2bDducmo2bG0wQ0xPNXh6TnJVS3M3aG1MOGxpU25JMFRX?=
 =?utf-8?B?SnZnZkZHTmNFWFo5UXNGRG1SYTBLYVhST2JMR2wxcHBCWkcxTENTUHBVOXE0?=
 =?utf-8?B?QUtqZzZnam5vdTNremt0Um1qdmRRcWlncjcvbzBDYkt0WlhydGJpUnVENUM2?=
 =?utf-8?B?bkZKSThieWZJSlV1VlVua0cxWXNqbXp0YXVYRnlEVVg4azRsSFN5QUR0VWZQ?=
 =?utf-8?B?RktKM3hibENhNStoM09GRmdBUyt4YlVYYjBiemo0M3pjcmdya29qb3JZa1Rn?=
 =?utf-8?B?OGZNdkFCQmVreGZ6eEN4UlFkZjF4cEhQRHZmQWR6V0FkYjh3NnlZNzNlL3hL?=
 =?utf-8?B?RFhGcndBRDRDMnJoNVNSWmd0QTZqWG85SUwxOFdrVFk4VE01alMvK3U0aHhm?=
 =?utf-8?B?dXB4S21qZ3M3OXlXbGZLaEdZUjlOeURiY2ZDYnlndk9tS2JOSkdESHFDNE5J?=
 =?utf-8?B?ZlhjRU5rZ0g3L283TDlJbzZESXAxMDBjVnNzcHVnN0Vlck4vaU1vd1pSdC95?=
 =?utf-8?B?eVRwazVzZHZ3ZXZzdDFQbThXZjJaOUxRSXJ3M0RIQ1N0MERteGEwMFhYdXlS?=
 =?utf-8?B?b3RKZkZDK090SkNvWHNpT2E0ZlRRVFBNVFhIQXBXS012ZEhNMFVLVUs4Y3hY?=
 =?utf-8?B?MWE4TmFwTlc0NUMwbFBzMnJ6dVg1SW9xV0hubFRwVEo4RjN3U2JncEMrall5?=
 =?utf-8?B?aUdXMGdhak5BM2lHR0hMRHhqU3BuOEI3WnI1NWlRMTdRQi9IOTBRcGZrbHVa?=
 =?utf-8?B?bXlFbHh3ajhsOWRLemUwNGFsSCswMnRoK3ZUbGpRazRaSlpGdjh5dERScmRP?=
 =?utf-8?B?blNic0lwbFAxSGkzNkxHdmZOQVNkTFNtNEE0NW9EQ3I4MXg5UmhoNmlkVUVW?=
 =?utf-8?B?djdObHhES1dQOW9IZ25KTmRiQVhoSTBIT3kwU24xUXFaZzd3c0sxVk9mNlJS?=
 =?utf-8?B?aTM5cHdiam9sdHBQZFhaMzVSRUJGZW5LV2FCVXZXNHVSR1U3KzlqY0RIZU5i?=
 =?utf-8?Q?nRjuBAuDq5Bz8Y5e5RZPlAo=3D?=
X-OriginatorOrg: theobroma-systems.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b199da9e-9a17-43f4-d69e-08dab275b04f
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8536.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 08:32:56.8879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5e0e1b52-21b5-4e7b-83bb-514ec460677e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amAhMjmc2qpXWAHQLyyCqkqk9dc82YRtPjaGAzv4X9nME1JAhhpPuD4Uv1nQEtXF4qsDogkLk6nQ/BAZHr6ag97RT82iSm+q5ZxDNRtwLfka94yyqVR4/mNG8+inG7fA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Heiko,

On 10/19/22 19:15, Heiko Stuebner wrote:
> Hi Quentin,
> 
> Am Mittwoch, 19. Oktober 2022, 17:59:54 CEST schrieb quentin.schulz@theobroma-systems.com:
>> Hi Greg,
>>
>> On 10/19/22 4:56 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Wed, Oct 19, 2022 at 04:27:27PM +0200, Quentin Schulz wrote:
>>>> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
>>>>
>>>> From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
>>>
>>> You can not have 2 authors :(
>>>
>>
>> That's a bug in b4 and my patch submission/mail sending workflow, I'll sort something out with the b4 community and send a new version of the patch soon. Thanks for the heads up!
> 
> I guess, Jakob is the original author?

Correct.

> If so, I can simply drop your authorship.
> 

Up to you, don't want to increase maintainer's burden. I'll send a v2 
Monday if you haven't sent the usual "Applied thanks" mail by then :) 
(or if there's feedback of course).

Will work on fixing my workflow/tools til then.

Cheers,
Quentin

> 
> Heiko
> 
>>
>> [...]
>>
>>> It has to be accepted before you are done :)
>>>
>>
>> A "small" detail :)
>>
>> Cheers,
>> Quentin
>>
> 
> 
> 
> 
