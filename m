Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0092C3F890E
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbhHZNfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:35:42 -0400
Received: from mail-dm6nam08on2074.outbound.protection.outlook.com ([40.107.102.74]:27425
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242365AbhHZNfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:35:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg1QOjG/Z0n4M9vwEeBKT9QlnrwLmkZTCblolKPJKdji1cG01v5vRGptPd7DypB4Qukx6uWxGYEiHeD7F+QNmovVN/xe0cFm1pLBmI8N3bYFSxlITjJuBOm22YDKeBkiNoLu/jLv/dPrns3jxvsUIrscWszlH1596XoOLvg5V8POPbKbAWlOoS9ZIIHKVUDgnplSiZvhwcVZ+utHVDH/8qrGSTBjLAfp66WSNXuketXIwMv1ItPge8g+V4oZEoZcyX9MsM9J0YH88HIunj6FBXWf8H7JGZJJRkDSuG5DWE6gFZS6Z+W6KOm9pwNS3HqMQIEHZ2cF5KPhryOTtOte0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhHODo+HKhKykbwKnJvSWonJtrfdmRDNnIYIhbijHfM=;
 b=gfrTS4Dg1Tjm5M9YN1362ivXISD/ly6SWNH5ZCERuNHS5i9hwDz4d1qbvUVLwre2nBRWGm12oQldZ23+2J++YeWjwQpLLCTrltmC+ZxF6kXCb9i5yGXJWjMax1cXk+DFSqMSlDEI25pp0VuV34zbA3myrYUKMUIbDDR6lznqf9pRfd7JqwQmclJGxt2NiLVz0Alk3vAkj6bQfJgC75sJFhnKkA1GK0D8CqByBFGQODFAwJ7IxFENuDvidxrn3O4i6ll9soqiMztOBN6aEGkZvzeFNweQ6guXR68MkHg/gkYECjP/tuYzj7ko2ivh33ua1F5alAbhvLDypyazVe+WhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhHODo+HKhKykbwKnJvSWonJtrfdmRDNnIYIhbijHfM=;
 b=hu1RzEwC+pTPaIvcKRzQInIEeBphV8FpWLFTmucIavQBAWyeFIRKgWD5uzzP7NXmj7zAvqEPmf4HacmF88d8r/5V0Z+etJaWp3I4+G0PceAjyN99lZNFBNyCh4BY5K98EX19zi71wuiP9LTSXB+iqO8Zbq5pEG2MNHmPiOu5jFU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5295.namprd12.prod.outlook.com (2603:10b6:5:39f::23)
 by DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 13:34:51 +0000
Received: from DM4PR12MB5295.namprd12.prod.outlook.com
 ([fe80::cfb:1a7f:ad3b:384d]) by DM4PR12MB5295.namprd12.prod.outlook.com
 ([fe80::cfb:1a7f:ad3b:384d%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 13:34:51 +0000
Subject: Re: [PATCH 1/4] drm/amd/display: Update number of DCN3 clock states
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <nicholas.kazlauskas@amd.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        "for 3.8" <stable@vger.kernel.org>
References: <20210826011002.425361-1-aurabindo.pillai@amd.com>
 <CADnq5_M+THmHo_-ti=or18cRvBuExdiNcXybVLcVRj2_KfsBuw@mail.gmail.com>
From:   Aurabindo Pillai <aurabindo.pillai@amd.com>
Message-ID: <f50a71cf-cf4b-45aa-693e-697f2a139a34@amd.com>
Date:   Thu, 26 Aug 2021 09:34:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CADnq5_M+THmHo_-ti=or18cRvBuExdiNcXybVLcVRj2_KfsBuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0128.namprd04.prod.outlook.com
 (2603:10b6:408:ed::13) To DM4PR12MB5295.namprd12.prod.outlook.com
 (2603:10b6:5:39f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.254.44.76] (165.204.84.11) by BN0PR04CA0128.namprd04.prod.outlook.com (2603:10b6:408:ed::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Thu, 26 Aug 2021 13:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7180bc00-f5a0-460d-2198-08d968964833
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB529444BC443173005ED9A2F58BC79@DM4PR12MB5294.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dhn4J7YN6u8wzpqYqHyVaK7C0MWPmEpdJRbhL0L4NxVDxIwwsXqQTmqdhdDtHiqMy3iqMhlid597RaLxOPmyDQ491bDZ2NBEDylmv/ax914aJbx9/hiHAzV1hS+aVCzl3jicKY/FEb4ESt/4kTQnrv1H1DKz3SCZoJy5EQU+dQZIkmb0MNHGk+ubILBSQNJtM++Wrg1tcdCS7YfF7miua5bMaBgxNjzxCYa8vDf8dol/NB1unGX58cUAfA7ULeOlewCDCEftbVQF7nhZ3DyxAS2PEb9ozr1fRF+fpnMlHHmOB2QKHmnZQihFi9PcVIvW0lxY57SmLxRcYwmddvn2qLT/+tXjZzuFemyu+AnUAECZMiq0nMZbgRsKV5YMheXBYDuK5yQoBNFiZ6sWuhg3RkY4M1TZPxEd+cJezoUQWsg4+blJUY31QWM+g5mclo7GV4+QtTE3XqCEGZK5y/JRbTgBwpWAwY/3YJP+dmy8l7J0qW6U7vSM4zxL2EI30hfJYI++i1E9XrgW5sGBrnbxWGkSgkmiQPTs4HA0YBN7U8nktNznh/BxN4U6vRhW3xb4AcTblK7TLjgxfBg5/f+1IXbeosLkxneNnkJem1kJKVEg9af1Y0WadGTNWwWyvrjuCPKhYZtOehZjU85XXcv1zrASMugCIxNhGQXR0kvc0t9L8jlc+khBDqoonHG2nRSJiXRRx6a44Zw9isGf2jCMnBb4pSQn6YCW1xLadoAZ+gg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5295.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(31686004)(66946007)(54906003)(186003)(66476007)(66556008)(16576012)(4326008)(966005)(26005)(53546011)(6916009)(8676002)(83380400001)(44832011)(38100700002)(5660300002)(316002)(956004)(2616005)(45080400002)(478600001)(8936002)(31696002)(86362001)(6486002)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STM4eGdsUXQvSUtuZEphQ2dXNFovQ3NVTWhrbjVIU1hVNDhvOWxiVDNFWHhk?=
 =?utf-8?B?bnJWNnJwdGFBck8zVlBNT2NPOVdDUThhM3BwVUNnNHllYkJIMitVS3BxVnRa?=
 =?utf-8?B?a0hIcDVpU2tROTMvTjRYVDBPTDgwTjA1eFdXampBNGMwd2RpMGRhMDliOEU1?=
 =?utf-8?B?VXNLNnV3WittazljdzNuVy9JY3VjSWgvQ3pCcW5DTU04ZDllYVVBZkZwWTZV?=
 =?utf-8?B?MEw2VzEvNXdlaGZrSHVHY3MzdlpHOXJOS0c5VHVSY1ROalk4ZE1XN3RFaHpx?=
 =?utf-8?B?ajZSMmZuWXJyRzZMS0RXRm9acHc0QUR4UWFKdVhKM3U1YnN4Tm1ERTBJWlc4?=
 =?utf-8?B?bXhyY2UwRWJBbVd4OERqa2s0Y1JkL1oxLzBJcDA2dERPTkdpZ3R4SDVRYlRn?=
 =?utf-8?B?WHBqODBhVDUySE5uVnRiYzdGTitGSjg0MFhBM3FTRVd1NnZRU3ovdmllcEtD?=
 =?utf-8?B?R2lGVDZXY2Zra0RFT2RMV2x6TFhKVitrWWxWK3N1RFNTNlo3aE1FeStxb3dN?=
 =?utf-8?B?WWd5bnNFdnR5RVErc2ZyNG1uKysxaW85ZXRiYjN1dy9LeGJZNzBObWRtR3lU?=
 =?utf-8?B?M0M2SjdoTmJDSCtjVXdWQkU5aHpvM1E5b3d2SGdxUWdKSjJtUjF2Z0ZyRUN6?=
 =?utf-8?B?cHhyT05JdnJsRlNwLzlROVBZS0ZSKzJxNGlDREVIN1ZQMTVXK3JobW4vMlp3?=
 =?utf-8?B?MFZFTmFJVy8wS3diV2RDQ1hpZ0NkUVVTSUNndUwxSGlwNEVqUXVxUkp3RWJP?=
 =?utf-8?B?UkRTNUZMcTN0aDNVV3Q0Yit6ZFF4bTRaZklGTFk3MDNCUFRiVHRaTXBBOWlj?=
 =?utf-8?B?a3dHckZoMkZiK1YyMUZtQ05QMVE1U2dvakJKWUJzQkw4RU5RZ0pBUC9xL2tv?=
 =?utf-8?B?Tk1rbitiUGFSR3R6c0JkM1doZG0wQTZBSy9McFUrYW5JYnR5OFVvcG5lNzk4?=
 =?utf-8?B?bHg3RjAxUHdTcExvWW51MWZQTVE3WGJyVXVWbHV4ME1YcGRaYkRxTS9jeU1R?=
 =?utf-8?B?RFJ3eWsrOEprUzlXMUY0a3J3Q1J3R3hCUXBQNThIMDlqRDV0QnF6djNYR3Zj?=
 =?utf-8?B?emRGaE8ybmt4endIaHgyVTdMblgrcU5vOXlyTEN5bEdSekJlcUlkLzkyajhX?=
 =?utf-8?B?OXg3dCtIaFJWTWl3cXIyS2dCSGIvTGhmWUhMSXgxckZaZXlYbGhnOG5mQjl0?=
 =?utf-8?B?eEhFMEhjdHFRSlZsdEwzajg0RS9VclQ3MXNlZm1lazZRaUpmNWw4OXd4Q24v?=
 =?utf-8?B?RHBKd1Y2cjRqWlRreG1LMk94M0p2blVFeTBxWGRvaW1TZGRJNkt3UWtQd0xD?=
 =?utf-8?B?SUYrSkg0eDdBZmJNQ3Bma0FyVi92Z0FvUk9OYmErQVI0VFJFSHoxQmRJYnF5?=
 =?utf-8?B?UkduVHQzS00wTXlnUjF1V2RlanlaRXRzYTRHbzdNTkU4cC9BK05oaGhhU1pH?=
 =?utf-8?B?RlZDaHY4T3oyY2k4NEMrUXY3RG9uaXNRcXRWeUFOUjlNQ3M1WnMvNHI1Skxv?=
 =?utf-8?B?WTN1ZERUeXBFdzJZU0FlNUpERms1clJjVytxT2dSQkgzbC9rbkZZbHZwRVo4?=
 =?utf-8?B?RlFtVnZoUXowazdYbWxTUnYrUGdXQWMxa041a0hPbVNLNFpjWHFoWm1Od0tx?=
 =?utf-8?B?UitEekVrU3dnbGVUT3crU3g4dzNVdDJyQXRHOVhIK25IWm02aDErRTRReWll?=
 =?utf-8?B?ZnlDS09ESldiV3ltY3ltMy9oZGlCQWx4TnpZWDZ3VnNjSnpjakdmNVlSU2E5?=
 =?utf-8?Q?EMQJYVwZ9cY+fN9KgIwHJmRacirASzHHcWh5SVQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7180bc00-f5a0-460d-2198-08d968964833
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5295.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 13:34:51.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OW/GFk73IlvclgzjPMgR+Y6tKWvg1Oq6HwYjA8hcTTEoBbyQ1JNEBGHdAnPSvssgDy6kz71fdYxp/8H/ljS+Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Bug info added and applied, thanks!

On 8/25/21 10:00 PM, Alex Deucher wrote:
> On Wed, Aug 25, 2021 at 9:10 PM Aurabindo Pillai
> <aurabindo.pillai@amd.com> wrote:
>>
>> [Why & How]
>> The DCN3 SoC parameter num_states was calculated but not saved into the
>> object.
>>
>> Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
>> Cc: stable@vger.kernel.org
> 
> Please add:
> Bug: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fdrm%2Famd%2F-%2Fissues%2F1403&amp;data=04%7C01%7Caurabindo.pillai%40amd.com%7C13083d4cd17f491b251608d968355aa9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637655400644887757%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=5OBOO0C%2FszESMd5QEjmRKKRsOM4KiMKFNWz6IdLOipM%3D&amp;reserved=0
> to the series.  With that fixed, series is:
> Acked-by: Alex Deucher <alexander.deucher@amd.com>zz
> 
>> ---
>>   drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
>> index 1333f0541f1b..43ac6f42dd80 100644
>> --- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
>> +++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
>> @@ -2467,6 +2467,7 @@ void dcn30_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params
>>                          dram_speed_mts[num_states++] = bw_params->clk_table.entries[j++].memclk_mhz * 16;
>>                  }
>>
>> +               dcn3_0_soc.num_states = num_states;
>>                  for (i = 0; i < dcn3_0_soc.num_states; i++) {
>>                          dcn3_0_soc.clock_limits[i].state = i;
>>                          dcn3_0_soc.clock_limits[i].dcfclk_mhz = dcfclk_mhz[i];
>> --
>> 2.30.2
>>
