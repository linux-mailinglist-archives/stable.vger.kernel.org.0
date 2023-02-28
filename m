Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADDD6A5258
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 05:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjB1Efu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 23:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1Eft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 23:35:49 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71D4241EC
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 20:35:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNZbcX0wjBllvHwHba26UeM4zVK7aQBTGhv64vUCU66YaHk6XM9rUt8sKQzavADUrkrPNP5o8o4H3ID3XDLgmIu2o3LRH3bLdOQG/p/yrzehDCBvzV/uohPg/JgVTqCzeCp8/9opUlrfQSuWoX8ixkuwqkxOVzN2LLSvuYIEni1kZgpCJkiA2Jf/Xag9Wivr1FPpP0caOS8SCrV35XZ5qz3MekstyhjyB89FnTEOpH/d+T8wzatHmpRDumBBb/iEsHzt18ZZT8lMHzCpakN6opkDhEdSHDgAc3ePFwi0Cl83Ji7duESBrEqbsLEV1MLDBFk8zGCiruuLZie5Zw8Rfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4M0zL/gRVYlp0LJcuUlZXgTbPt3OQqru510/PsHRCc=;
 b=C3eJ7DaI032+7IxBAqyOHYXn30VKsKegu6Y7CQpePRyaqwvo9OIUQLll2sPBQ6fDG7QElLICQU3QhZ919cRRq1jJLFSO+b6JG9jGqx2kXkALmGHOjmxEQVop4FIQZCwNdKZFiWPySYum1nxMlskBAM04Z97h95Sgt5GstlL1IR5anTzjOUtfdlgVz1KkQWB3FrAyzC0dvWe/ur8iSJ8ilgEPRZx9viaAmbuLqwEn/Mo1KmAIm6cNwifTcyWIFmDTVIddoRphEHDoZSzjfIiz7G8oen0KRRgtp4oJ7pQVF/ph1Ygay95YiGa5AtAugAqF4QMXjcV+4CCbOaVHxlPusg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4M0zL/gRVYlp0LJcuUlZXgTbPt3OQqru510/PsHRCc=;
 b=lDfgjeGXJXnC23Y976wN9BMLy+a6Y1SQyQUpivsy59nROFCtjA8EB9D3oWaIOj0k504WdbmwhschukVkf8zGIULoDuH5su9KJmmp7tm6Q/anVjA9druQ32Sa/8fWkOffU8ZWbNN4AWYiX3OqqdjVs32b6+GsC+HEdhJVHL07T84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 04:35:46 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 04:35:46 +0000
Message-ID: <9694aea7-5019-f446-3795-a5cfbe2a634e@amd.com>
Date:   Mon, 27 Feb 2023 22:35:44 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Stable <stable@vger.kernel.org>
Cc:     "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Subject: USB4 DPIA fixups for 6.1.y/6.2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:208:32d::30) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: ad170e4f-516e-42eb-d568-08db19454293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8SqzpZ8RWdHzTMhVi2ihC0ev3XGvUgYK/b+IgdiXGfKAYitVzIJBFFIetlsDUf7C+gkJLljPvlepXpTHogj4JoAnSttFEi2MjOZTOxC5WhaavVZJc4G8qcsLsVKN+0VXe2gGJ5jW5+DOXJYL8hpx7GWFwAMRkhNQD9Lq2XhGkKbPVM2F+jLr5A0+ggzjyyxcc1IFgJcRaWqKzdng3r0YJijZa78O1X1Z6yY7g5Nq0N9PR0ZE8xulc4M4XShLHGoSlRE3Y7tlY8wuwLObM+HlaFld0eq0yTHaYLGI4ggClN86tkHZOc15zqVpm/tcLZDMg3gmQbrTqO1v3kkbau8P9iM3j8NfCoZ52Urx7vfKCHTqXMF/WWZ88cplaCRNj8JxNubmksMOcjtTRua8ZOTKxHtdJKPZIYcb42q4BPW8HJlqxIdum939zK4+SpLiW7n4hIdmXRM9QQGxf4TAWyA6I7v0oIuKWzWdIbJGgNqzrPVevJtFNlLqb7f0cFQCRWTWJPPtf1EnjmsJNc10IubYYxcfZ0PGVXjsOa7SUk4Ob+W4/7GXUK8dzLLohskh86OXjIPiT6UzUwLXILHL4PGg2D3rKofzZr55NwFM8CgDeNHJrswy48NG5QvIlNsi/Kgiaxth4YV4VTy9mEVxeqmdUUmHY9qFb2sgCXTw7YUblBgGYZ+eL3VQBGwY94/nSFB/pnJofP1p7ZY6SelXPnW4BHIqoo517mfUqNQ5JM8o44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199018)(38100700002)(31696002)(86362001)(36756003)(2906002)(4744005)(66946007)(66556008)(66476007)(8676002)(6916009)(4326008)(41300700001)(8936002)(5660300002)(2616005)(6506007)(6512007)(186003)(26005)(83380400001)(478600001)(316002)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3Y5YUpBcmhCQmxIbmxBaHdXL25MRmh6UVNqeHRHZlg1S05Sb2ErOUtRSjlJ?=
 =?utf-8?B?TkZ0ejlYRFdkY3pJWXF6U1JOQkZ3Tk1zU1MxZkk4U05jR0twcS9LSjQzU3N2?=
 =?utf-8?B?aS82U3FnNGdjQm55MmQyUE1JcE1DdW0zWkk3TzMwZWEyd1VtZ21nU2I2dXgz?=
 =?utf-8?B?SE1MWW1jYjFEWGM0cE1pWE5uVXkyVGNPeVdxbHVrYTgwMTBxM3VEVVoyWSsx?=
 =?utf-8?B?MHZwMDdLaHF1d2o2MDZlSjhOQTZVWlFHNmVYRTZwWHZ2Y2ZjU2tKcmlwMk82?=
 =?utf-8?B?YzFYeHR3UnRyMmRZR05EVUJsN29jRngxZXgrTU5TOVFCVVBWNStsMkc1NWFa?=
 =?utf-8?B?WUo5YlNDR1I1bms0dkkzT1QrNklaa1dCN2xhQTJJUDVPNyttTWlxSjdubDBZ?=
 =?utf-8?B?S2pWRGhmT25tR0xOQXRVVGpMdlpWU1Rxd3JEaGJNNHNEV1pxOTl2M0p4TC9H?=
 =?utf-8?B?R2xBTDBOZThWUUhQREFjRC9YTDI1dmEwMVlva0M4STN4b21EY3FCdFhtREYy?=
 =?utf-8?B?VVkvaWNIZjFKTHVWNlJCQ2pOSDkzejZ0dTdEdWZiamhQY2N3dWN5VWFsUk1s?=
 =?utf-8?B?VEkzYTl4ZWN3c1pZYU1ZZUI4VS9xMjgxVzg1Ymx3NFVBWVJPRzJKeitZekFm?=
 =?utf-8?B?WUNPcWp3dGlJN002TG03NzAwZ3I2UW5TdmZFNXFRTUhEZWNoekMvSWI2dlMy?=
 =?utf-8?B?SmY2bGUvRVV3TVdXclJXMEtRdG53R0RDUkhWTnIzS2lqUjVsV1lWNHlLb2Jq?=
 =?utf-8?B?MkN1YnZrd2FwNnlPbkhqWTBWRFRxbzFhU1J3U245YXhJdktLdkpVMTdWbEF4?=
 =?utf-8?B?VDVxTVZybCt2cXVlVlhJaFJvWS93dCtqQ0xmLytYZVMvampjekZOa2dSUG96?=
 =?utf-8?B?bWJwVURPc3haZXBic29XYlhvR09yRVlsUDRoT2R4WTB5N3BzWm9YQjdXdWp4?=
 =?utf-8?B?aTNoZ2k2LytaYWxKbDB6Q2QyYm43ZFVxaHozajlzT2tWNzdkMVh6QVBoSHVr?=
 =?utf-8?B?MGVPR2Y4NVp6clRQNUk2U0tvWHBnMG1BT3ZwaVFiS2RVWTBjNnlEbXVidUdj?=
 =?utf-8?B?dWZCdUVDWExObHJPVStFcW5IMXh2TDdobHFKZHRJUFVmUmoyVkNIbk9SNjlR?=
 =?utf-8?B?azdGblJ4SnRHSW5yKzNGVUFHNk5xZy9Fc1o4YWV4dW9RKytKYy9nYjFXMkt4?=
 =?utf-8?B?Y2YxYWFDNzdpUVpZS2NLa0tqZGFKSEREeGZ2RVJhMndpTm56WEpqd0dvOEk3?=
 =?utf-8?B?VDd4WUxXRm95bkdTb0g1cDZGTmJucEpPL28xRTcxU2pOREgzbHhNei9XUmJi?=
 =?utf-8?B?U0x4eVJwbkRlY0hVTVRqcm5HV1JYTkIwekdtTnVvYmxjMFpNWkQwK2ZFbHBG?=
 =?utf-8?B?OW5ZUFRTRDNMcXRBa1lFSXp0N3pZcWtpWjFkTzJlSUFtU0g1RlViWFpiSTRO?=
 =?utf-8?B?TkZDMVRFMTl5VmkvWG9lMkVTY2hWMFpzY1p6MTNvZDBEZmt4Wkt6WFVWaUtB?=
 =?utf-8?B?YVZyMzdZaWRiTTdRWlQ2UStLajdQWTZ0Vi82MzUrYmp2UTdOdWFDMjd6VzRK?=
 =?utf-8?B?UEZGSkRwWStPRWhBQUllaHpzSllzaVo2TGhhRkwwNzdwcUZkLzVreFlvMjE5?=
 =?utf-8?B?UTh2ZGRuRTMzcDRPZjlkR1oxNGNBVUZUeTcybnNNdEpEeU02N0tCS2lDbVUr?=
 =?utf-8?B?RURFREJ1VGtlQ28xdWJnVlByNnJyRU4vbUtNVzBjcEFyVFlpZ3pLTzBmck9l?=
 =?utf-8?B?UXJJcnFWdGFsVnNhZE4xRHFsNHNYZ0dDQTdOSGk0MGpCOVpXMWxidWtsQXdZ?=
 =?utf-8?B?c0VpMWRSODdqV0luUGFxUFQ1d3lZNkNDampsQVc3NzVvZXhEREI3RFFXb0Jp?=
 =?utf-8?B?eDgycW8rMmczM2RWMitxSzF4eXE3WkdYNzNabThicVZReWp1VXRNL3BGUGFV?=
 =?utf-8?B?UjhNdktlMEpIbkY3K0Vjc0hvcXlra2tTNlZYWEFxcGNtU0lYdDFKRXNaV3E2?=
 =?utf-8?B?dFY5QkNxSWVQYmVOZ0dqT21LcC9Sdm5rR29OTzFlWmZFNC9jUjVEaWUwNEVv?=
 =?utf-8?B?YkF1TVh1b3U3bi9md1ZicEdKRDdyb0szUmpabURrU1Z1eDlxdmM2NTcvMUpp?=
 =?utf-8?Q?TLGElSU0xpSfRlpSKvWMLVgXC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad170e4f-516e-42eb-d568-08db19454293
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 04:35:46.4573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7SYjtGrbKUxsPeTrVhUZLsmhSnIXdCvfY/p5ia/+yK6UmEHAh1H5bPQ83j+SeTmeK+vovGbN/Al5yqnb9Pbog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The following two commits help with initialization of DPIA which is used 
for DP tunneling over USB4 within amdgpu.

Needed for both 6.1.y and 6.2.y:
ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
0cf8307adbc6 ("drm/amd/display: Properly reuse completion structure")

Needed just for 6.2:
0cf8307adbc6 ("drm/amd/display: Properly reuse completion structure")

0cf8307adbc6  was actually already tagged to go stable but it doesn’t 
apply cleanly to 6.1.y
because of the above mentioned dependency so it didn’t come back.

Can you please bring them back as requested above?

Thanks,
