Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D36023C2
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 07:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJRFaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 01:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJRFaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 01:30:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68998A7C3
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 22:30:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bg4sEtT78zMyLR1REFDgLf49uK8onPMCUDx/UdwNi6sS3oLBtmaWBIdbgy3G16HwcotHr4ESEXExENlB0Umvz9yFuqT9pzsufp1svWIz/lJtORJk/Zrxunp5WaHMBEGaqfZMPUgbxK1Y160dVQAjDG0K7iIzyvfSyK3ID5qUlQa1up+yR1iwoMx8E7WiHCwwDrKC8Hi3j/Pmv67dZT9SIyQ2jJsjP6wyBa+G8FuerO7P66r66FJbxCb8ulqiO5duDK5CIq5lG95BRtvsX42mb/+3V2hnj4kTPqTIEkkaLAigw+T4px3KVhTgnAg8d0rG4rHj2Na17Q/egMULnV6i3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAGtzp9vyYnZ3ehi8S5wbvuOPeT64oVLOkTyWSHq7ug=;
 b=iuaML2MmefRgSMxiTnhw0asbg592BIOAgorJmpPWOdnhPI8uMy7X+JSaQW5ccOqNT0J5Kukk1k/CIsyy6Zb3qr5+pmi95JHtJxgrkmxbAeK+vR2QRRuUjOrq9wecHldhy1qe8Qg6hFnaQGZ/TDh9WliQMx9vU0JG02iDO1t8NJ8gBLRKId19tVxY4WMpG22LwJP0qrulTiXTOSGLYzCzv9tm3/WS6dg7AAPDff+x3dDB+EeNTkhA5Vg5KH+FSPbeMH1dAl+6kOmyKNKGww7WBYtzaKhd5t/WLkEa4tPLNf98wc64E5ZpScYNdAbV1jPPSIUPrEPbh3e5JmmEUL49zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAGtzp9vyYnZ3ehi8S5wbvuOPeT64oVLOkTyWSHq7ug=;
 b=CaIdMQguQ5JGNkcLPo0HQUo9QaqJVJbun1V5ji+g8/UjPl0erFB2zrAs1nrzrxGN1lxkL0tIxWSAQR5FeLEXLmZtIaw3h2gPeGsyLobJax9m2rJ5anlr6Evhi3lvzPk/LHUomlFd5uersCy4RgROR0smnetZPuokUNvvuXm4bcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by DS7PR12MB6022.namprd12.prod.outlook.com (2603:10b6:8:86::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Tue, 18 Oct 2022 05:30:04 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::992b:b2b:80dc:86cc]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::992b:b2b:80dc:86cc%4]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 05:30:04 +0000
Message-ID: <42171ff0-2ad4-0b44-de18-a01f62862352@amd.com>
Date:   Tue, 18 Oct 2022 10:59:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     amd-gfx@lists.freedesktop.org, Hawking.Zhang@amd.com,
        Alexander.Deucher@amd.com, helgaas@kernel.org, Guchun.Chen@amd.com,
        stable@vger.kernel.org
References: <20221018044724.86179-1-lijo.lazar@amd.com>
 <Y0433bWlP9OE/Hm1@kroah.com>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <Y0433bWlP9OE/Hm1@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0216.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::14) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|DS7PR12MB6022:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ab4ee8-4591-43bc-f2a6-08dab0c9cf2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gK40k5vKGnFZSSrJcLc7je9ihF2+uqfybbKhgc8az5BQVmjokTNgOjFQb07UPCITsGn9IDyZcJxmU2Ib1qkdnEf0zFY5zz1whX0Qv/fXeqDdwe9TGJAv817feB6yJbUSgu+IPIn89gMconjHf/SpIfLuH8U3VJCjmu1+f08G1clIBLyJ7+nN6ojAgxiXwd5vLQrNdDafJ7AAFlu/owaFYb+tsvEeU53edz0P6iMN/OcDrKxlSWRUzPlxpd6CbwWltNgVmxZ7lA1/TyitgNkoRzV09FXUqO67FkAEeRRj3sAEJv1e3U5WQopCJDc+9txgXAt8cuXGSfEPQbDl2atI2juR/wyO0gHHBYbkpRE2DOKvGEjYtYKsGXOG/RG8Zw6agtVhpGb3fv2lI5k41PnR+FgaZldi4BBSrGm19Nv6/5imP2gjErcF+APrmd+OAm+YWK3kS0+UD1pk5gFSID7RkEgQo4n1Z7zO/+ip/hiLq+TbUiB6KsWkRxRcBHBc49IP+V0/hF05ijnDyF70gNLVdFVzuNhUx6ApIxUX/sVEwdd7SgEDFLNEA7QUpU9QtyJ/3y7JEtOretPtUYMiS9gXOY/sRfILXfEqWsZUe6J2+5SOC5cSPhy25Ajh2hkwSqC2f+IXpG/CAl7I4bT2vrDO1oX45Zw2yr/LgrJS9T8P2IaM+zy9+/sLxLW0VhF6nb45BiQsSeJlRZxV8vwWzbtrHfDc+5JmGDCfK6NUFkgzJ94sJKRJyGRMsAfHabdDowRaMU0iLRhBVox3jwmtaFJW3pFtSOPFLp28CB86eVC49Xcbz6IjIeICTBawPUSmtIFElRI5ZrjqoSniFRhUpa0H+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(31696002)(86362001)(966005)(478600001)(6486002)(316002)(6916009)(41300700001)(8676002)(66556008)(66946007)(66476007)(45080400002)(6666004)(38100700002)(2616005)(186003)(6512007)(6506007)(53546011)(26005)(83380400001)(4326008)(2906002)(31686004)(8936002)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVZrODduVHB3U3ZHNnFqR1BoYWh3ZE1PRkErV1BpZTh0ekFOWDlMd1hsekUx?=
 =?utf-8?B?RE11Y3IwMDZ4Y1lFY3lhOGtucmNiQlowT1lIbEdpdCszQmlnSjdFRmd5WFBy?=
 =?utf-8?B?Qlkxamhnc0xpTXErQlRldUprbVpjK3FhYjYzNklMbFROR2xaKzJDa2VPRkxr?=
 =?utf-8?B?ZDIwWTBlU1NJNEQwalFCTlp4SWNIbnVvZXBPMmRJRWowVE1tbjdxZzlKcVpH?=
 =?utf-8?B?YisxdER1RCs0NHZaY293ZTFhRVpVVXlLS2liRTZFL04yV0l6MWlsUktEaElD?=
 =?utf-8?B?Uk9ERjFheCs5b25JOE1aQ2hyUzQyN000cWRpbDA5UnFhQ0RRY2tjMHcweksx?=
 =?utf-8?B?d0ljd2twNCsyMEFlRXoyYWRIbVZqb3QyYzl5alc2ME81U3VidE9OU2NYTzZS?=
 =?utf-8?B?S2luZFp1MmJ5VktaRWZwMXRRSzlEc1FZWjFiV3lNWE1VSktFSDN5K1hkZDNT?=
 =?utf-8?B?RUF5WWpjU3NsSjVsZ2g3cW1DR0NCWi9GeTJaNStzMnM4MmpSNmlJSUkwSG1O?=
 =?utf-8?B?bkxrSFBtYk42QlVLOFdwOVZPbmlyS1lXVnVUWDc0bDFYenA4YWVWVU5ZVnpP?=
 =?utf-8?B?VGR0eC8wVlhKYmJLZlNXK2dYKytqNXV5aW4yUG9NMnhKZFBpM2dUSlV1YTIz?=
 =?utf-8?B?TUt4ZVBTS1hUZ05ydllGUjdkWGFzVXRrMEcwT1ZxVzJIV0xtajdOOVBITEtM?=
 =?utf-8?B?ZEdOUkJIYmxrdFFaT09QQmhrOXdVd0c4R3U2U1pYcXppcnVVWk9IWTVpdDR1?=
 =?utf-8?B?aC9YeHprdFZsMmVvREpCTUdXMDBJTzl1QlVaV3Q2YUJRYWlpbERlOUlxWUw3?=
 =?utf-8?B?ZE9vc1h4eklQcTZ1T0dMOStUWFZGM3A1Z3g3VnBCMlhHNW1HbElISDFCdGVJ?=
 =?utf-8?B?QjZXMnVlaXR2RXh3TnB1KzY1UURLcnZKUVJhVFJ3dmlnb2NrNC9aaEFJSFln?=
 =?utf-8?B?UUhXOFBUUEJKZ2Mvc1g4VWhpT1ppNEZrckhjV0FQbUxKcEtqMVlJTmRkRDJ3?=
 =?utf-8?B?R3Yyam10M0I2V0U4R2o4RFpTNTF4clZFampOSTJtNHZSZThoUlBkNUYveTF5?=
 =?utf-8?B?ekFRc0h2TEM3R21FcW5SdGhBVFRjTjlna1hDRWRnL1ZYN0F3YUdmVXl5dVFO?=
 =?utf-8?B?Ukh5R0VQOFBRWXlXa2k3MW5FVVBpaTFiUlN0YnI1L2RuQWFmeHFzbXNaekg5?=
 =?utf-8?B?QzBCTU5Yd1RoOHp0QmVwVFRvd3RSTS9ISGFEMmpxaWw2ckl6WGRubHlSOThV?=
 =?utf-8?B?RUV3MTFhaHo0akRlTTdRbHB5WmtPQ29nU0ZrWnZXKzUzb0Z0ZzVTNmlpaG9l?=
 =?utf-8?B?eE03Q3hQKzdHUmNWRjhPRWUxYXlQTEc1MGkrN0oyVUxDc0FjZXdjTWpNR2dq?=
 =?utf-8?B?Uk5TZnh3VndJN2dnYmtmWWlBbWtxRllMQXZxaHd3NVB1b01EaVVmOStFYjh6?=
 =?utf-8?B?bllBSHZ1NXZyeFNiTEdDcHpFRFlsTDRMY1RlczBhTDNFOVQ4OUlxemNQOVpy?=
 =?utf-8?B?SG5IWW0vT09EUEFZRTd2SFgzQ1MramRXQ3NzZkRYZGJSQk5oSVBUNjRtM1Vr?=
 =?utf-8?B?R2N5TUJZb3FtVVdxQmFyQTBaUnJNNGwrNXo2VUk5WjRTOGlGN3I4QllUUHBs?=
 =?utf-8?B?ZnlYNGlLblFFV0pBd1Z5enI0Q3Fpa0N1d2VCZ0t0RytKL1NrZFdIdTk0U0Jw?=
 =?utf-8?B?WVZVYzJCUHMrZGg5c0xOSHRNTU1La2R6Rm5GSTFsVy9VaEs1eFBlMGgrUHpX?=
 =?utf-8?B?NWJnbENYQWhGWnhjWHlVeWlEbDQrbnpJTlRxY3IrSmhIWVQ5T2JKTzYzeDNG?=
 =?utf-8?B?OEZBUi8vYUdBWmR1eXZZaTRrY0NrQ2srU1RxWXd2VE5zWVk3MEE5ZE91emVI?=
 =?utf-8?B?cFBnNXBOdVVrUVM0a0JWVXJDcHlTSGtBbS9RRXdMd2RpKzhVTnF3RlpFSGE5?=
 =?utf-8?B?VVZ3OE1YT1FKQ2JpV21vbHNxVHBaVC9Td2dMU1JKQi9tTEw2QnJsMGg0Syt3?=
 =?utf-8?B?VWdCc3VOU0VLVU4yWld0eWFPRGlUMHVXZVRSTEF0aThxVFRQV2RvNWU4Mmti?=
 =?utf-8?B?MitvWXVIdHVtOXIrQk8xa01LbGtQM3YzSW11djNJOVNjZXhDMlNhMk92V3Zn?=
 =?utf-8?Q?tpQGu9e0gSG5EqypThF4mJMhP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ab4ee8-4591-43bc-f2a6-08dab0c9cf2c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 05:30:04.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1yq0pLEd3JSPwfp8SnEhGgi/06mJN65PM1q/wMqnyrEN6vGSe3LGwk1lueyEAL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/18/2022 10:51 AM, Greg KH wrote:
> On Tue, Oct 18, 2022 at 10:17:24AM +0530, Lijo Lazar wrote:
>> MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.
>>
>> Since they are non-existing registers, read access will cause a
>> 'Completer Abort' and gets reported when AER is enabled with the below patch.
>> Tagging with the patch so that this is backported along with it.
>>
>> Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
>>
>> Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c | 28 +++++++------------------
>>   1 file changed, 8 insertions(+), 20 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fstable-kernel-rules.html&amp;data=05%7C01%7Clijo.lazar%40amd.com%7C63359dc806f44c7ae23208dab0c883b7%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638016672500798597%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=LUBCEuSA4yhBrdnBwBHHvt0ewxAcw6c7j6BPtt2nPhg%3D&amp;reserved=0
> for how to do this properly.
> 
> </formletter>

Thanks for the pointer, will resend.

Thanks,
Lijo
