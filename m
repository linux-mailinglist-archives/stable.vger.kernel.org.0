Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9C6B0204
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 09:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCHIuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 03:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCHItx (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 03:49:53 -0500
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9750A984DC;
        Wed,  8 Mar 2023 00:49:52 -0800 (PST)
Received: from pps.filterd (m0209328.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288T7Kh001191;
        Wed, 8 Mar 2023 08:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=xOVfh7PUep12LtuecEq/07jqxrKfNCnvOeSWU2B2jWo=;
 b=VXqsHvFB2430bvaxXk/OV++6rhmeybgUMGxvapButwJFu6hdoLnAZRLL+tRIBXtdNytR
 acud3mH0/Lg4JrDiRKRtPcBc5njLp3ZdJeM+O5fRpIbQFs3bm/YxuoQXTvrTnfw+Jtzh
 SRaooiBWNnvKqOBEJxz3fasakVVDC47+Of6GFkNlh+sGUvkqfXeG5cF28OHUWmUcZKC+
 vUR8EzOZu3M5KvJ9bXe696w6+EOmP8SfrccK3bbHYFISSUjMbnKQxlafh4ucRms0cn53
 FRge5MIHWNu056EvwpPdU1fuAeC2NngvDLWEDMSYptfe3RIewdSVyoyBOvv8fqHm+ggk Rg== 
Received: from eur03-vi1-obe.outbound.protection.outlook.com (mail-vi1eur03lp2106.outbound.protection.outlook.com [104.47.30.106])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3p6gasrb0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 08:49:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBm5EOlOL0EPe+gcDsUF9lefc6z1hIGJPz/R3Z7FS6Q7UMyVy100jVQsJ1wLADNFuUgYs5RKauVzSvOQQ4XjSE3stdha5qftqZw1EKDBsvOw+e7rkBBRyDbhb1520utYNNfMvZRor4JJ/2DgECQ9Et3vznI1Yv7ps6XE5wEnJ6n6luu86my+pJU0axklgk6oMBoyAElXgfLHKG1w4C53kZN1NDZSw+d9rtiMmfurAB+gKQ5uC3KCP177x29FkqWGRmX/2X7/ki2AJptzc2IeR3iH7f8UkfW0eRzEiBBF1ut7YdaIDoeiyU0cK6Rek9p2ImHKU5LBP2RFKSwWjsRWFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wEnRjRvBOjVzGzx29xxzb1fEDApI3OsELEz9cayzqw=;
 b=facRlAYn1fIlEQ09eyLqI9IFFMCGkmc094/AG3Gep4AE2HbfUpWf/xE4NDgZsoT1O/lhCN7PAy3gmBW97eERItjnyaWnC06Gk1m7GyNmmb3v2b65OASGBpLVmI2PJrOUPmZgNxhAr8MKIVBxk00yy5yEPtIFaCDGtHPaCnzOf/RA9o0uXyG8dZcVv3+Hl408Pr86r3n8NVcIMocoA1Zi3lpOE+FeAYFEP4jTAzv+NHHuwhGI+TI6jmAVptRixew4+OMbNj0omkYPH4BuEKtJZ9W+/VTlJBIXw1Kx80/1mHvPi1W+pNKhrjNDzIsvvU6MlGKy9TShvtKNRHSOqY+Rxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:30d::9)
 by GV1P193MB2357.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:2d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 08:49:08 +0000
Received: from AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab]) by AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 ([fe80::b1ea:2de8:5297:f6ab%4]) with mapi id 15.20.6178.016; Wed, 8 Mar 2023
 08:49:08 +0000
Message-ID: <5cbc4ad7-19b6-a95a-1859-b7fbdb5b04f0@sony.com>
Date:   Wed, 8 Mar 2023 09:49:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 1/2] maple_tree: Fix mas_skip_node() end slot detection
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable@vger.kernel.org, zhangpeng.00@bytedance.com
References: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
 <20230307180247.2220303-2-Liam.Howlett@oracle.com>
Content-Language: en-US
From:   Snild Dolkow <snild@sony.com>
In-Reply-To: <20230307180247.2220303-2-Liam.Howlett@oracle.com>
X-ClientProxiedBy: LO4P302CA0024.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::10) To AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:30d::9)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P193MB1332:EE_|GV1P193MB2357:EE_
X-MS-Office365-Filtering-Correlation-Id: e773cc2c-02b2-4073-985b-08db1fb1fab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNCh1I6Q6x0iWs6wIxhJdebun7h6U/qj02MG606SHhE1LstVAxrUt/4pfcIrrNwirolGejbB3x+mVa7Wi3FbBzpmfb4E5cyHWAViIlDPdTpbg5KQIEa+sWELOF2r0dpfhFzD9BsdVz0SDzmOu1rmTlJRaCnfgtDBDEX7X34IdsS7eyhj94kpPwjWqZL4BaSyiIYH6wthLB3asbxRa3plrvK4izm2ElyJQYZ5jWU74t4UNs1y/EnlO5ft/9eoYCLeL5+z9DQ5JBO9ET+5tjTUcQRZpl9FXtePhGE8KdHTsixqGjWKYZaTVCLXWFEmusjZhtXobbP96D4zp7lzkpquy/NdCYkbaPVjADHnBjDvpUpChr+ub4kv/3P7LV7kpbPEmDQ2wJ6ghbHVsjihutDE9P4pIR9nejyJ23YCQviRDaYP5kDkgujAOg28iH5U5MlDYv3lg53SI5+c5C+0hKm9xPqYA5VdAJrIxq/itaLsqyii792eAjs2HSASSATbcfbsaOCZZht0j847FPi9KX1pwwrCNDm1PW8pFjJzzQfiu3pFRfdj2D4n1dV2+pEvfkfwMKOdohCdtowIbGbPtx12fQQVSaTZPZG2yRmWu2709NWjdKZ3JWODd/BCo6bSIrNtgObuBOmx7VSJ+g5B+ysugRUlR8nxOG1ILIr75VypFxDLYxnvt49tq0AGfRJLNUs7qNfrO45EbhqKSG9rsnY0TC0XTw4MuXDEavCXD3q/Lf0ETKFPTagaVHbiYhGBsKEw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P193MB1332.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199018)(2616005)(31686004)(41300700001)(186003)(316002)(110136005)(8676002)(66556008)(66476007)(66946007)(53546011)(6506007)(6512007)(966005)(6486002)(86362001)(31696002)(82960400001)(83380400001)(38100700002)(36756003)(5660300002)(2906002)(6666004)(8936002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDI1djVzRUJuMjNLOTdPQzR2bE5VSjhuc0djUWFnbVp3R1lGRFVkMW5hUjV2?=
 =?utf-8?B?ZHMyV01tbnVINU9zU2FrUWVMclpwTzZSYnpiM1h4NUJWN2xYQmVtM2RkWUJR?=
 =?utf-8?B?UTdlak04TkVFNkMrRUNPVklpRjgyK0lBNHdsanNTZURCTnpnbzJIa2V2alpB?=
 =?utf-8?B?WDdNV1JYYW9aek8reVVuNktwVmhuWWNjVE0ySmpSbDM1anh2ZHRZRmN2WUNY?=
 =?utf-8?B?ekRRREJLL3RMRm5VOXhjZEk1eDE5S1RUMG5CSGZTVHZNckgvS3VJbUdGM1d6?=
 =?utf-8?B?UUhLaDVzQUNyY1hQZ1F5Yzh5d290UnNyMnRaNUdzWXVUalVXcnBrRmR4dXVS?=
 =?utf-8?B?amtMeVRyRnpqMkd0SjBFNU9Ed0Z4M2ZPV0Q1TW1xdTFZS3lnMVd6R2V0Z2V5?=
 =?utf-8?B?VXJkUUlyUkhsellPTUUvcnZwTFlnVlBrMnFOVW1HV3c2MDNvc3FDZ25TdnNN?=
 =?utf-8?B?RS8rZHo4dm5LdTVydG9TdXl0MTlQZEQvS3FyRW1SbDNmd2FuWm5RTDRTUjBa?=
 =?utf-8?B?dmJGalI0QzRrWTNEMllaOVhqOXBqcCtjNHJjOFZEV0ZKMllTSDl2K2JOeDZI?=
 =?utf-8?B?WG9WYWlkMVRzenpFUFZhRFJmNFl1ekVwQlV6MGlXMDZtYkwvUlhUWlRiSkFL?=
 =?utf-8?B?SUJOV3k0Z1NUeTB6ZTlOZk0xaW5yZTJndDRSeTNVSmdwOWhaNWhkRUNhZTlX?=
 =?utf-8?B?anBuN3dEeXBlaUxUMU5FZzk3QlZ0ZVIrU2I4bmpib2RnQ2xlcEVZMk1ZYzZi?=
 =?utf-8?B?QmUwQ3hQb3IwWWlaRzg1eUN2TzNpeVB5a2pINW92a1B4SjJ2eUxUTWVFSkQx?=
 =?utf-8?B?anZuV3dtc2FHY0ViYlB4UWY3THE5SlNRdmFSaWhMVyttWGhpdnVSM1BMaHRS?=
 =?utf-8?B?ZHJMSnQvaG5LVkNmb3ZvbDAySXRaRWl1RnUyTVA3dUVKeXR0TE5kWjVodURM?=
 =?utf-8?B?djVONFQxOCtYL3BXeXVzNkVKOU8rc3kyYWVKZmtUOUVwVU5jUE9pQmxESDls?=
 =?utf-8?B?ZmN5SmE2bnVCSXlwMXQ5WGgxYm10a3pQNlY1bkp3N2g4clRZTlRMVjJhOVlH?=
 =?utf-8?B?L3RrK0hDVEdLdW5PUUZCRlA1K0NDaUVwaFU4b0I2dTk1U2lscFlSNUpoMnlK?=
 =?utf-8?B?ZmpEbHN1cHQ1aUVPem9mS1VuMnZsMjRrQ0lZWXZpSjBHKy94SXNadGs1SUcz?=
 =?utf-8?B?aDZsK2FINVdsV3ZqZGpCTU05YXJjam84NE5EL0QwdGFmWjF5blJmdk5kdVhQ?=
 =?utf-8?B?TjNUU3RYME1wdnpnRnpoVmhJL1JVcFk3WnNTd1l2R2V1ZEVLaGhGTGNEdEFa?=
 =?utf-8?B?OUFJYUNtRkhXWlBoc0J5cVJ5dWMrTUozY2lnSTNMaHRFVEhWYXM4VkZxS2Z2?=
 =?utf-8?B?WmNBQy81dDJQZlkwengzUUREeGt1czhqbWZESlRIS2lybWM1S1ZpM28ycDg5?=
 =?utf-8?B?di9lTll4djZBVjBMeEh5Tnlzd1pyK01nejIzS1Ara0RzWFo2REdneTBsMHg4?=
 =?utf-8?B?dkpRMll5dS80YUMwbGh1WG9LVnltNWJiOHdwSmNKVmtVNU9pRUVadXdWcW14?=
 =?utf-8?B?VTJQYWw4RkhwRHY0MmpzdVA0RG0wTG1PaXVnWHVuL0xsTExjd0NRQko3aTJi?=
 =?utf-8?B?V2R3c1FpMitZSGRMblE5cFIvSVR6USthdzVKTGRmbXd4aENtS2pKcUgzWlVi?=
 =?utf-8?B?TUdPajVLZG4xa2lBRThlZWJ3djg0Ukh3ZTRjYy9EeWsxSnlZTkhQUmZ2c090?=
 =?utf-8?B?c3lWM0d2MEZBenpLTGZrbUVPdGZZSEFGSjNnZHE5R0I1SmY4Sk1Fa2FSWS8w?=
 =?utf-8?B?VzZtaThmbkhNdW1sb0tMSDVEWjVhZ1dVNzR6RWVVSDVWamJEOEZxMk5ReTVh?=
 =?utf-8?B?OXpiZmF0NG9vOGJvRlNmeWxadElWYVFsSUEyTHc1TWRtcmMwdEFReG9aUSs5?=
 =?utf-8?B?TTlFSUJkUUhiV3U1RnJjd3NTUm5JaHlyc0ZTVW9XWlVTTUo5SEJlYmNOa01G?=
 =?utf-8?B?R0xyTzVFTHJhMUhZVng4S1hZbGlnMTZLUnlxNVJMeHowSU5Id0cxa1NJQi9q?=
 =?utf-8?B?aW1SaHBKWlVpc214UGpOZVFQSkdoN0dGRE1vcU4wYi9aVVZ0L2pvdE9Ib2p4?=
 =?utf-8?B?alVjcGJ3SFhWckxxQURSdWIyM2VKYWdheDJqdWpWWlpSZVRocDhmQzUxZWZs?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SUhXN1RVY1MrQVM1UWlqQlZlak9uSVBtUDk3eCtmT2xqaktwQUc5SGZCUEZC?=
 =?utf-8?B?dmR1dEk0Wm5VN2FRdlE1aGovQmJwUE52NEkxVGNXVzA0SlpJNU9YRERWc0x2?=
 =?utf-8?B?eVgxaE4vd05JZE9wTDV2SzEzbUhYV2pzdjcreC8yVWRIdDRQZ2RTSy9aVnFC?=
 =?utf-8?B?MGNRRHNpa3ZBZlF0ajB3QW15WmxobnNCMmd2TTBMOFNEV0ZtTkkyRE5SSE9l?=
 =?utf-8?B?NnZGV3ZOQXpCNlBydVcrcy9RREV1dzRuQ3JZRVNSK2QwL0Y2UUN0a0dtdUow?=
 =?utf-8?B?Z0tMenZ0WXFpY1A1RGhkM0VXajRZOHUrQng2azVXa2JIbmpyS3VoYTQ0bmFa?=
 =?utf-8?B?T1U0VFhsSVBKQ0crMGQzMm1LbHNlVGdlNlhTNWdvMSt1UFVZMnpFUUhsK2Fm?=
 =?utf-8?B?Y3JtTmZjb1Bpei9lQlRVR2d3LzB5bTE0Zzh1ZkZWaWlTSmRxYjZybTBmUnZ5?=
 =?utf-8?B?OVZ1Sm5wVDFmN1R5NmF4NHp2eDc2YXJSQTVhR0pQMVpaUGpWcFJlNXJXT2dl?=
 =?utf-8?B?YVk2T3J2K1h1YXQzdjJYcENqNmtpcVR5S2hoMjNHWlVqb3B5bUIwMWVJK3Nz?=
 =?utf-8?B?a0RJeExENHZxQkVWMk5zSk45N1drQk92WTVyOVdMb1RTK1JEV0dmQ2tPNFFw?=
 =?utf-8?B?L3FLWDE1VVBPSFVJN1R0ZkZnMGpMYUdqWE5FSFdwWGdvems2ZWsyT09tMUt5?=
 =?utf-8?B?KzFUZjJCQ3BSalBqMWdnbkRHbEVxNm9rSENrU2E4QjJsVlRCU2s2eU1KbTFo?=
 =?utf-8?B?M1N5aDlxWlJjYVFyemtCKytGRHJOTXFlRUcyNmJ5Z0NwaW9HdERqcHdCblI1?=
 =?utf-8?B?SzFzRk9ldVArazEwOGp5OTlpak9QS2NjcE9RclQ5R0NGaENiNHlrdDErM0k5?=
 =?utf-8?B?clZtbndkZTBKVzBvV3diNUc1c2hWcVhRZW42YzRmanMzUkhMbFp4VWdyTjJz?=
 =?utf-8?B?clQvaVcyeE14dEtwU0lac2FhMFBFS1dXWHRiaGFUSjdRNkE0TWNwNHJIMCtu?=
 =?utf-8?B?OEJjZyt0REpaT1k0SWhBWCswWEF2VFpHd3F1ZDhLUWJGeG9KSnVaWTBaM1V3?=
 =?utf-8?B?MEg4RWxDVTBwS2o0aDJ3ZVlaRFhyQ3IzNVNOdUFqa00rQkVwL3ZUOElPYmth?=
 =?utf-8?B?ZWRtQUFhMDdXTjNyc2lzMXdVcHRnNiswUkI2U1pvUVhHamZoSFNRSGNZZlNM?=
 =?utf-8?B?Z25zc1FBS09ET3p5VlU5YXl4ZW9waUNMWWJsM1gvWFpkMFJ0cVZPcGlHK3ZB?=
 =?utf-8?B?ZldhblNKTXAxUVBHUmw5RWJ0dWtSTGthWHJhZGlHVVVGcm11S0pSclFjOFpv?=
 =?utf-8?Q?B6MLmucFlLTPo=3D?=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e773cc2c-02b2-4073-985b-08db1fb1fab6
X-MS-Exchange-CrossTenant-AuthSource: AM9P193MB1332.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 08:49:08.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YUQYPuSBoHq6NJtWCpu6d5JhswuCVJ3Buu6yo/VGpqrn5sZRRnHirwtlRR2Ij41
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P193MB2357
X-Proofpoint-GUID: HGL3CeaDnzKjaB0uy6EucxMczYJLShq6
X-Proofpoint-ORIG-GUID: HGL3CeaDnzKjaB0uy6EucxMczYJLShq6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Sony-Outbound-GUID: HGL3CeaDnzKjaB0uy6EucxMczYJLShq6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_04,2023-03-08_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-07 19:02, Liam R. Howlett wrote:
> mas_skip_node() is used to move the maple state to the node with a
> higher limit.  It does this by walking up the tree and increasing the
> slot count.  Since slot count may not be able to be increased, it may
> need to walk up multiple times to find room to walk right to a higher
> limit node.  The limit of slots that was being used was the node limit
> and not the last location of data in the node.  This would cause the
> maple state to be shifted outside actual data and enter an error state,
> thus returning -EBUSY.
> 
> The result of the incorrect error state means that mas_awalk() would
> return an error instead of finding the allocation space.
> 
> The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
> data end point and continue walking the tree up until it is safe to move
> to a node with a higher limit.
> 
> The walk up the tree also sets the maple state limits so remove the
> buggy code from mas_skip_node().  Setting the limits had the unfortunate
> side effect of triggering another bug if the parent node was full and
> the there was no suitable gap in the second last child, but room in the
> next child.
> 
> mas_skip_node() may also be passed a maple state in an error state from
> mas_anode_descend() when no allocations are available.  Return on such
> an error state immediately.
> 
> Reported-by: Snild Dolkow <snild@sony.com>
> Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
> Cc: <Stable@vger.kernel.org>
> Cc: Peng Zhang <zhangpeng.00@bytedance.com>
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

With the same method as in 
https://lore.kernel.org/lkml/6f674f9e-9f32-dabb-60be-0e757e145b14@sony.com/, 
1000 runs all pass:

linux$ egrep -o 'Failed|Success' qemu.log | sort | uniq -c
    1000 Success

If you want it:

Tested-by: Snild Dolkow <snild@sony.com>

//Snild

