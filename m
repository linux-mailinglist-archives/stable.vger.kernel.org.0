Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3382949661E
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 21:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiAUUA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 15:00:27 -0500
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:12513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229482AbiAUUA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jan 2022 15:00:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox/vAlh9p0i9s3oL1dp2rC/D5201R+HzDepjZ8/CmMn8qMfFZqNysSUd0N3lC+WiK+srS3BJc4vsBM8vcBgf8kBmkrrd8yUn4208+TeT11VQF0Z4FQga60Y5eh4NZPh4URT6XdhZSizxATk17DxeTWG882pGQBKSb3aMIHtrTpmQLijnJ+kkfz5eFViZXEN9BvgoHZeW8fPzXv0HnVoUTp6/lOXw00ThTlxR5FDDvHw84woCP0medvWXBntztcdtO72fYYfau5QVCeF8UX3ndEUkuu8GCn8jruZwrL0nU9+RZSZe0+OsgTca1M7pF5In/WTfPXJKR/pPSaSlAvyiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xUvy9MoB7FmBMdep959lQDkeQ9XSX9EzYCUJ1f3XS0=;
 b=d+/zbAKaGqNCMGflk0iLO2Y9ZjRjbmJKoUr97yZOhCfj62KNLKXAcVBSKanz50mGZ1XRTRvKM5I6x9HE3ZDiaWbLb0iztQ9Nf2+HCr3h6sAxuHdoJ0RPbw2ofVAQfs6fhhyrFp+0ywJTalZgf8ZjnAsGq/QRY9SEqxhgUtTdPXm3o0xaCaahTJ+aoRlTVkxyxm3emOLrA1iPVN2k0cxE/zef45rDDf0GX0fInN4DprBDvH6Es8J47UjZfLBtfu8IOi9RVMlGLz0T7Y5peLAmbyeG8FAiBCh9nI2dzuZb6xyWcfp4rtYZ0zzHiDW5QhH4YV4Ywq5nWV7AKmqsdvIwMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xUvy9MoB7FmBMdep959lQDkeQ9XSX9EzYCUJ1f3XS0=;
 b=Cco8TmCwrCWELflpMkO5vSJ0dm5WkkV2GGcDuy39MqUy+np27RwwWXCG8aDIDzbg8bNVBfvsh0AKTZDdWkVG5baWJLT/DNtqdfrpXMAVXE2CS6f7eqvA1bm6tHHXr8lILOT0wFBuVLsMVo80pJieGOKC0Cv9Oub7UrMevYfW8Us=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by MN2PR12MB3247.namprd12.prod.outlook.com (2603:10b6:208:ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 20:00:22 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%6]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 20:00:22 +0000
Message-ID: <148cc640-9cab-02cb-2390-7930d19c0024@amd.com>
Date:   Fri, 21 Jan 2022 14:00:20 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Subject: Backport ath11k fix to 5.15
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0058.namprd19.prod.outlook.com
 (2603:10b6:208:19b::35) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1151b63e-dd1b-4054-dffa-08d9dd18a875
X-MS-TrafficTypeDiagnostic: MN2PR12MB3247:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB32473D996ACFFCC14CE89E12E25B9@MN2PR12MB3247.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zh5t6KGkUQiL60JbeLQpkqf020MZ+iKf3KMzNhhYN7wluwhLYZWdf/ZA4omE2iowszSLD90/ZWAyi7n2kKbMH0igCLtU9U0IdCf/8B5/7QvYwkwoaYHU0Cq5c9dfZjm18+DcBbu90hNqyv2FWYlnxAaQ2OIZIg69cOLYQgMZm+EskCfAk3wxkY+ZpKqXk5p5gjCB1wFAigwK4NW3ad88ZTq3RFmpWkG+CCWGbk7GakDFf+g1KfRYfKwnxFQESNPBJYfmOffk2d6B9CFyVBBqIHoes0BN7dJhoa6dmZAPKZEjstApsmqKOe1j+QTX5NY3Sirbr/6ZsTkHQ1KBd6epjq2BYMRo/wZFUqEhlVCf49gwH2gS39xfYGZ1H91EL0Gg/J7jlzY7YfE7EA/GZkxM6Tqs1bbkIg+BaxyxGaPfQZc3rO0ojjshwRZMCeEywHeAQTYxrEZ6fraJuAyAkykeJgvvvUcalzfzcM7BtkpjtPRs1RlWOsBR5Hw3blVuJExMuZ1YPVoRgma32SPhhK7y99rW59PRvpMsabuLb6M9n0V88ApCwBzmd8VGYN6TSZ1ZSkVTw9d8Hl2wBJoPbIv9UPWU2KFUdD6KkhsXhj2nO6m0YepQnCs9mxdkD0RaZ+5xw4KoimLVE0T3cBUA4PsdGUtuZLSBWTbjYE7M5odlgg0bViQTMe3tKmYB/Gk1hEho2Yf+D3I/rKLSds7UY31d76RYtGwKV1Bw93wPPZg3kxHsZ8Es3raBBqiRL1ZIH0UB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66476007)(26005)(86362001)(31696002)(66946007)(36756003)(38100700002)(6506007)(508600001)(66556008)(8936002)(6916009)(6512007)(8676002)(4744005)(316002)(5660300002)(2616005)(2906002)(83380400001)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1NHcUMyZ3ZBZDhLYkJpVHpZWkwveWRZemZubjk1ZStrZkRsa0RRTXJ4ZlJq?=
 =?utf-8?B?ZnEreVZsOGxsSkpVajhMTnA0RnhILzdnb1plYjlVT3RLL3VqRndUY2F3WFRC?=
 =?utf-8?B?ZXdZc09Td3gydk01bEFQRVk0K2R6MnhLNzNYK3JpQXp1ZTI4Nnk0eEsxRGF6?=
 =?utf-8?B?WE04VTVCcVg2RXZzZXZMVzFrcGJKcmxvdU5YdVlUVllDaGNDUTF5bXlNYmN1?=
 =?utf-8?B?MUZoSzhTajloNExoeGJlcHRsOUx6eHNWRnFwMWlTRlBibTJ4bVVlOS9qK1BB?=
 =?utf-8?B?cnFYRUt2UmlhS1JWZVJMTmE5VEVqWlprWC9PaENCdnQ0a3VxMTUvOVplT2Zx?=
 =?utf-8?B?YXd4N2dWcjlVNnUwT3k5WFNrUGFYYk9VeU5sVytZRFRLK2pNWUlZdFZUZDU3?=
 =?utf-8?B?cWUxeUdLN2JPcTJuUjR2cEl2azZ2YkVjandiR05DU0QrTERBcmF1dlNZSHUv?=
 =?utf-8?B?aUJjMlQ3bjNsMEYwc1NmeGl1Q1hYVTRPbmpYak0zdmVVN1BOWmV3OVl1SFBi?=
 =?utf-8?B?SXhYRHM1bjhBNnlaemtsZWpYU3pZN3ZsTVpuZ3pDTWk0QXlJQ05qQURUeVBv?=
 =?utf-8?B?ZlVHMFNxOUt3ZGw0Mk5lRmFNM1RCWU04L1MzWGZEaVYySXlLN2NlTVpuLzVr?=
 =?utf-8?B?VHA4MThxOEM2TFdoOTNNMHNodkdKL1AvSTdTY21BVUtRT1V1b2xHSHFZL1JH?=
 =?utf-8?B?d1RaTUU5bWtJY3hmb3d3Q0xFYitZbmliaW9ZZEY0OXlVSld5cXhCVTFsOEFZ?=
 =?utf-8?B?YUNBWUExWkJFUFZjTWF6VThOOWtNQ3pYbklFamdwZ1E0MzltNndvbEI2UjFQ?=
 =?utf-8?B?a3NwSXdWK09iSjd2eE4wOGw0NzdGWFhKWmFLcjBUUk95bk1oYUVNZ0grd1RC?=
 =?utf-8?B?Y0MyZnQzZTEzV0JKWFBYTGpPejc4WFpZSE1VR2ZURDBob1hCbU9Hb2NFQXEw?=
 =?utf-8?B?NnRiRXNzUWd2clBMTDd2ZFhxckh1YnRGTGUvMThHdFJzVDVsbmZJcWl3VTYz?=
 =?utf-8?B?R2J2WkZTMjZzT2ZTUjc2TXc2YzMwaHBsTlZqQ1pMNWRZVTF5WWNrcFpWbUZ1?=
 =?utf-8?B?SGkxeTNOajhGNWNTZ1A3Tng0aENiSEIwbGhmQTJHZVlsY2NnRWNZK0xMMzli?=
 =?utf-8?B?aVJZOTIySHFpaFVDYUFrRi9oMkVpTlJnaGtkcWpwb3NIdHdkVDNWWUxPZkI0?=
 =?utf-8?B?VSswWmtpVTVGS1Zkd0VJd2pyNUZDekhZZFEvZVJJR3VzYUNSbERPU3ZOU1A0?=
 =?utf-8?B?LzZvZkY2NzFsVzRQaFFSeWxYMDhidExCdmg4Qk1QeFc5SW4xUnhneURraEFy?=
 =?utf-8?B?RHZmVjF3ZXVQTlh2WWw3MFhrOFNBYk5hbG9kWmVjM2hoWXNER00rTktZaG9J?=
 =?utf-8?B?WFhDRVpPVUIzMUQ3VDJQaTJma21uQzlreHFZcEI5Y0x0b1dPVitERy82OUFm?=
 =?utf-8?B?N2VvVzZsbUFtaHI0R1plWkEvSWFHd1RCeDVnS2xsb0FGWDVLSkYzVmE5M0Ez?=
 =?utf-8?B?UzFTcU96eXV2dmN2MHZsenl1UE1kVUdBZzhzU3hURW9kWk9mVWhuT29CRnFq?=
 =?utf-8?B?c3J6cDJ4dzJlUXcxVWFWWG5zdldkRkkwUFlGMU11RFZjY0Q0YnE1ZGVIbCtD?=
 =?utf-8?B?bG5KUWYxcVU0TXFSaE5pL2FMUzNNQklhTEN2eVY1VGt5SXdoVW05eXhjRUVY?=
 =?utf-8?B?eGFyYytMVXdEZUU0VzhwamxGRjBMZzdDUWtpRWJuZzg2ODJ3dkxsaWwzRkEz?=
 =?utf-8?B?QkYrbDdpT1N1VVVobFVGWmdvQjMxd0x6VUdUeURaTTBYcnRCY2x5aDhVb1Mw?=
 =?utf-8?B?ZE4vQWRXQjRjSVNCczlWTVFhWmRaNWUrZDRmT29KLzJXZG10SlAwY0JQd0lI?=
 =?utf-8?B?a2h4WkFPV2RBRmRNREUvWGtiQ0pHZy91N3YvdzZyNVNybmFqTlBNSU4yNHh3?=
 =?utf-8?B?M1FyL25CWjhwRVlucVljNlI5SHFIZzZlK0dSTnh6TnB1Qm1PRVlZQTAreDRW?=
 =?utf-8?B?UFV3MVVjekNGOFFaWUtYeTh6a014NDF4RkZxYjcrMCsxQ2N2KzNZWElQK3dh?=
 =?utf-8?B?OVlaMUxnbmRKSlZWbDZBMXJacXR1UFFYQVRZSVl4dnhxNUdDY3BEaFg2UHMr?=
 =?utf-8?B?bE5sUy8xOUNZSjZiSXZzSEVrVExRV3pDNkREUG85MTJaOXIxQjhnUG1TRTJw?=
 =?utf-8?Q?bNahKReoNR7LoUSff/Fubko=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1151b63e-dd1b-4054-dffa-08d9dd18a875
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 20:00:22.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ul6vg3X26JSXQXBt0ZPcavP9Wx85aN54Q5AjWG6Nxim5ZaAHKgAZKkcLqM9J6zZVd1UIDdWnHPfqKMTJzua70g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3247
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I've been noticing this on a number of Ryzen machines that a traceback 
comes up when allocating memory for ath11k.  It's not a fatal failure, 
as it retries with smaller slices but makes a lot of spew in the logs.

commit b9b5948cdd7bc8d9fa31c78cbbb04382c815587f ("ath11k: qmi: avoid 
error messages when dma allocation fails") fixes it, can you please 
bring it to 5.15.y?

Thanks,
