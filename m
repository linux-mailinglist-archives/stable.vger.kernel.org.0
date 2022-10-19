Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC161604655
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiJSNHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiJSNHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:07:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909A81CA585
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 05:51:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFynE095FiTz/1SEvgkmS2R7PO7flKFu2i2ClLZZdrjXKHajT98fVx2aQ2Hkn2VKvByPmqRYyXxapZQWxsqbhsJtUICszgSMJ25cW0l0vftYVKwKJPIsPqC6hHYT18T5UZDXQsXKIjS2xpfSzjht3Na+n4pRcbWdgmFHMqc41VzAD78WApZ87QiOec2eZrtbO1BuzCnml3RnZlgFOoLUJQE66KOkMwNAZrv3pqVQ1dza2cSgn7ottciV0g9TNZFnhQuUx+aoU7RLQJgH/vD+Y1hnJ3AoSRrtkoRLWk5/J7CHlGYqubDr7RdR5IOLkEcCdcMTBTIg9AwXjAZrkEfHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBVqCCItrh6uMJDF1APIDtAUq/nP/6JmJobEZ8yvcck=;
 b=BJGj41t+Zytflw+OhZbraGdsTMZfzqW+q4jAkdwL+baQ68RDK557fPVX+UjA+BEVUDSU0tOVwmJ7ni2b+WL8bNfthQkE3Y0rv+tR1m8NUvjfr6kbJvpdCaQCuMgmO0x7/xUoFFX3PlGoAynVFUbT9AAzJlizruRidI+eMynMfQ7DgQKIHWisTrddUTMx2tBJXSRjsSFhMz18/Pv01C3BTKsAFRtwF/Z9AEXQIMQMk6JzfA74g1hYbWO1X6fLKeI1SmyfwHuvumV7CG8Puc87rTvprWl0L4Xt1xIWRjpBRWIv4Y3qxWpCacqZfCNzA2PFULseeIzdwLHmGraoJZNDWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBVqCCItrh6uMJDF1APIDtAUq/nP/6JmJobEZ8yvcck=;
 b=cgkltxHNmTgWPxgq04wNWvllD3/jwVBI5a1P80sglKnRv09tVLnRg4COy9icwDuFJO91hShDl/w3rCgfsksRdAQIyQGM+28PKnXIO0cEorSCjGvNqJ1fWv5bSzKsd/+sxN//kp377FrCC9CgchsmTHqhLC/6ube/V3uTBiSx54w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5102.namprd12.prod.outlook.com (2603:10b6:5:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 12:49:52 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::76ec:6acf:dd4d:76a3%8]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 12:49:52 +0000
Message-ID: <0dc9d84a-6afb-4d5a-f2a5-3d44646ea5c2@amd.com>
Date:   Wed, 19 Oct 2022 07:49:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Mario Limonciello <mario.limonciello@amd.com>
Subject: Fix pinctrl-amd warnings introduced in 6.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:208:32a::13) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|DM4PR12MB5102:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bc348f-8bf7-44d5-8e4e-08dab1d06a8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CziAB96g1S5L2KeDcnvicTYGFLTYdZJ+GkW7mNaySnnsb4PQyosHQ99YVta+QsxZr/sHK9AHDJwBUTynl3nU5FFfw7jHOjHXThPlag3UNhGqY7ohh6ev33+fRP0+PxVzUpGkZkbj7s4knAMRoRN8FbUfRc1jhFf+GzeQq2qJAPPhHYoMobOZN39ku5UMU6mrcPmLP1yxiwB6pwAKS4zlaupz23Vhejg5B9a9JQrEIQq65pS38W1UL8I7vjmD6K5l6Jhxis0KlMAYssjGuyxyZHOy/tGFDzP8WeRs2iHeoHo/NVpIg8qdlTE4H28JpIXD89XrVXo7tDVvfyrOfzKk2XevFjD3L/0jvuILdtT1atusL1+qhy11F4e9Rliyzoi8WvaDMYllb6/sIZV3UL+LTwBLMXjDYnUywEYBJ9CZWkVNPl9VAG1im9u8rsrOnYhpoIOO5CTFf95c+cxfuHTmbaS9MEGqd9rJZn8kYn5y2DxLIBRnvW5u5ZApV+Q08I03leZSlVxvBJaV0M8DoSWI9T9y50U/AHbPJ0SQQRA2mSCLgHdoq4NXHw6GXIQa2FyzrrVidW8yK+dd1kuxmGkokJ4/o2gBKHo6wi2tj7SyAkF9OCnRJkhl5aLXb6WWdD39EA85ECu8DMq7cJ7GdVKZ/GDMszHliHn+gNSMDc32UQsM5VIoozuhqGQ6fJVGADxvs4wiQd8Upug+6BqWllm6rGvVK3V909XnDyBXIdZJ7WOLCHsF0mw5YFRMSunPri0bw/Qrm3W8AVdqgBLZ52lEpnfgAOymTK7nQC4stNj5O+BrfieEc6R3Z/X5qHn/IihjCWkDz+BXeid7Vw20VuWtAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(83380400001)(86362001)(31696002)(38100700002)(41300700001)(66946007)(66556008)(66476007)(8676002)(6486002)(4744005)(44832011)(8936002)(966005)(5660300002)(316002)(6916009)(26005)(6512007)(6506007)(186003)(2616005)(2906002)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekdacU9iQjF1dVloNW11VGU1RFVBTlNhV1ovaUpramhpbkpwYVRiOHVuVld5?=
 =?utf-8?B?MVR0RGQrVTB4WDYxMm9pUGtkWDBVZFNXb3BGTFpEa1VKS3gxaWs0R21sZlVW?=
 =?utf-8?B?WW8rbjdsSXJXUVFsb2ZOb3E3UnAxNVdhQzRGZ2RLVFYvUm9sNHFNSkdEU3dR?=
 =?utf-8?B?WTBoZ1hqWG00YVZwRGwySHRFTlB5TWtDZzNsQzRlM0RHdmtBV1Nta1lrajc0?=
 =?utf-8?B?Zk5hcW4rOG0zRitLeXhYbENNTHFvU0hmNTl4aXg5N3ZFVGt3SVA1dGtMbklq?=
 =?utf-8?B?RnRHdytvcU50ZmNWRVE4VHR2OFluTWhSdmdDOTI4MUhXVWhDSHRibWlNL0pp?=
 =?utf-8?B?bDdSWVp3VVdjUFlVVDh0Q3NJYXYwS2RsWER6ZzQvUC9CZE1uMEFkUTkxUit4?=
 =?utf-8?B?UWxEbVVUTmtwcUFjNzQ1enMzdUdzYm80Rjh1RGNWYjducVFuUy9LMkNGNUFP?=
 =?utf-8?B?Z0hyT1g4OXlUT2JVakh0QmdMSzZkYWdYSk1vM2d1UklxRWR6RDhuRjYwNnRo?=
 =?utf-8?B?RlF1b2pUNUN5SnhuTk5JRUtUSktjWXhoWUxmR2R1bDRJajQ2aTQxYWltaksw?=
 =?utf-8?B?UjdmMjNpdGdtRVhwaGg3MlA1S3E0djBGcVZxaU9LdXM4QmtnWjFjclQ2MVJR?=
 =?utf-8?B?RlQwSEprSWFUYmwzZ2NKZ3lMNW9FZ2VETWlCWmhENjJWWENaSkZKRllpU3li?=
 =?utf-8?B?L0VGaGhhMkQxb00ycTVReFhPaXhadWpRWFc5MmtGeTZ5cTdSZVNJa3JXSThG?=
 =?utf-8?B?SDJqVjkzdWFYd2FIU2ZkTXF0OEZxM1hyMWlsZkhtQXI1emlNbUhhVERTNk00?=
 =?utf-8?B?WC9MSU9hVUxFYTkwak5JOUxpdE9XNTNEeGVhTFVuUGpqS1VoSDhyZGNiVmxr?=
 =?utf-8?B?TUlFcDB3UTRlOVJjaXNjdGJmb210TGZuWXdvOWlFNUNIOExobndXN0lXNnND?=
 =?utf-8?B?TnFyekw4Wkx2azJ5YlhFY2FkSUF2alEyYmtreW01OFFuS3NZSUR5YVkzK2dU?=
 =?utf-8?B?bGtCZ2Fud3BlbHRTcXU5UWNuc1lCS3UyU09ZYjE5YzRCV1daME5mVVk3VTZs?=
 =?utf-8?B?eGd0MUlrUTFkckFUR2NFd0ZDUGlOMS9qZU9EWWR3Y1ZKOXNtQXRtRmdvZG1Z?=
 =?utf-8?B?czNXVVNNKyt6ZlFIdEhtM2htOUpuYWt5aVVna1ZvcklNWXVZeG83dC9QZjFK?=
 =?utf-8?B?bHdPTXJnZkowS0pjcEVtdk5NMDFlSi82YytjQm0rUHBaM01jZnl4M0IzTUNn?=
 =?utf-8?B?dTJ3dUxPdzlNazhJMjVxUER0bEZkZkZOUU5CR0thQmFDMkh3d0RWVE80dUxu?=
 =?utf-8?B?Ymw0YmNJRGNIWkZDUHlLNFNXUEpqaitLTXA5Mmtmbm5RVUtRTlNFK09ZZ1Fo?=
 =?utf-8?B?UmxJLzkzVVg1R2ZXaUg0akowazllNzh4MGtBYWx2QWVLOTQvYVR1TENtdjgw?=
 =?utf-8?B?Q2lVZkZTS3dHNmtHcWprM0l1a0E0WDMwK0tCMHFNMEZGdVp2NWZUMnlZbFN1?=
 =?utf-8?B?eGdEK1BWeWxxQzV1R2o4dHVJM3JONTZBYVJJaElIZFkxZFE4bDl6aHJqNnpP?=
 =?utf-8?B?T04xQW53bnJrZDRzamxFdlpabTV0d3BDa2RQME1uL1dZTkJRT0hDQTBIcTJY?=
 =?utf-8?B?M0dPaDE1dVV6Z2VqQmRLeHQ5UXZLeTdYTjBUSWNPNGkraU9Fd2prSVIwVE9F?=
 =?utf-8?B?TUIxQkc1VU5IcFFQWFBXcFJLUmtJVUl1N3V3bFR3U0tSVVRlL3ZINnFiWHl4?=
 =?utf-8?B?ZEdVVkI4UFdESWx1VGtkeDltSU5VZHJOc2xEb1FEbHlYL3dhYm04RWV0ejYv?=
 =?utf-8?B?UklqMWpXcTI1bTFYcHFDejVjMTR1NlczNmJ2NE5FNm8xMU5jbUlBbVNFWXNJ?=
 =?utf-8?B?b1hnd2RueUxOc3h0NTNZY0plZnI2R2xWZFM1Ulc5RktGQVVjRkE3aGJ3Q2hD?=
 =?utf-8?B?YXJ1MzBiUkF4NXhBb05LTWpJbjFFSGlRV0NwNWR2dkJ5V2JOMVpWT2FhS1Bh?=
 =?utf-8?B?TzFIbnRia0RiTURnblM4RmYxdlZIRHA1cFFqbmV1eFdFZVpmeUJDN05xSGwy?=
 =?utf-8?B?NnpBc3JIMnp0bllyUTdCNHhtNVNaMEwwTGhRUEl1V2FFeENQWlgyUnh5dHUr?=
 =?utf-8?Q?9uSz3GdqycnlAj253xAVMxtJZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc348f-8bf7-44d5-8e4e-08dab1d06a8d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 12:49:52.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: izvEBTFO0wDWzW2wGR+w6M4KPpu/bCCnAlxaAHxvUuj7F4GFZPN41S553xb8y7w8DyjSdhNe8Rt7+0CRGbtXDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

79bb5c7fe84b3 ("pinctrl: amd: Add amd_get_iomux_res function") 
introduced a new possible warning for pinmux resources.  On some systems 
that didn't support the feature this warning popped up and users have 
reported it (IE https://bugzilla.kernel.org/show_bug.cgi?id=216594).

The warning is downgraded to debug to not alarm users in 6.1-rc1 with 
this commit:

3160b37e5cb69 ("pinctrl: amd: change dev_warn to dev_dbg for additional 
feature support")

Can we take that back to 6.0 too?

Thanks,

