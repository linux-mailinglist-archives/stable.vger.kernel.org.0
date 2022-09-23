Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F355E81D2
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIWShA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiIWSg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:36:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D0A11BCFE;
        Fri, 23 Sep 2022 11:36:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhfMI20PId2JGRjA/y+JmwBBywuruBCHKpalMmMwOgxzllD6OBiLkq6GwVyNKptPb7J8dOHer8+Ouz1NjWljp02r2Mva+SHXb3x2xIjX8OPdlcRvaVpav5S4bIs06truE5pTzwMDPJG7qhAWx/gNPw3gtngmVEen5BjBGRMEdwdOtfuxa+JaE/Aon4hp0oSbrRedcy7ru8167GUVV7oL5utigqwiM2vbKcWT4qZe8y/9M0zDUclPeuhHjb+8L6bq5WzFHEp821BIbkdNLwkmAdA1hQJtIzpLHJIEZTg9HZas21w2UC9tkkVB7ouPbE1rjt88Fq92zDbaPg82yZiI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOGOG1oJvjTTOywSm/PSKnuPwsZdeHEZRIYy9EjQedU=;
 b=W5uuPQDri97sXjyecUoP3+x+qornVjOWC+2I1ZcVXlaPxMikLGCrjpwqkdfRSKgTJtTCtFY8OE5/sXgc6d1pcvOcy6F+hhlhwKmz3Yv2E4npxjfQb3V0ubDkBaazks5AbDb+iIhX7qyh+VF0EKQjHa0dvvwkY2orPMGq9L0ZAf0hkTFxSnP2bZ8/t5b9TYYNmOtg4YrlUzZbtfwcrZaOI4COtqJl7/4RMSkjtEePalWnDzJ8qREAPXIYU8pop0fRBP86U6DvRKYAtgT60v+Wc+v5FbSd1oL7oeuV/F7G8Uzq3PxZNDemCNtpEvYmLLmi/Pq+X4Ue4lXsXuqHZS3/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOGOG1oJvjTTOywSm/PSKnuPwsZdeHEZRIYy9EjQedU=;
 b=QHoiWfiJZdWusehDWEEZjBpEnA2+2dQM03Kt3bmJul9KtkObFwewQa/KsTm+lmxqivTR1lyIPqV+5CWsvpIYFpXVVqvIqgs/LIZ+5EqReg4FZwWHHfa4WzSUY190363aV+d6MSuq6Ff8MbaRdzdz/hKYyDmEzBS/3T7ztjEe7n0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SN7PR12MB7322.namprd12.prod.outlook.com (2603:10b6:806:299::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.20; Fri, 23 Sep 2022 18:36:56 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::c9e:adf9:5c3d:baa]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::c9e:adf9:5c3d:baa%5]) with mapi id 15.20.5654.019; Fri, 23 Sep 2022
 18:36:55 +0000
Message-ID: <edfe5f4c-70fa-5fcc-868f-497c428445f1@amd.com>
Date:   Fri, 23 Sep 2022 13:36:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor idle: Practically limit "Dummy wait"
 workaround to old Intel systems
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-acpi@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        stable@vger.kernel.org
References: <20220922184745.3252932-1-dave.hansen@intel.com>
 <78d13a19-2806-c8af-573e-7f2625edfab8@intel.com>
 <54572271-d5ca-820f-911e-19fd9d80ae2c@intel.com>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <54572271-d5ca-820f-911e-19fd9d80ae2c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SN7PR12MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 652eaf86-a3de-4463-8f28-08da9d92975b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AF3J7GKH8msVMIZzMMZeJfY0bek6l7ybElzIA/AgDb96Fe2bxJUgfxqxXmbpPLI2Km5gnbBKrMtYVBfz1PqlnBDvL3OiLAPkgAR0GPcFGx9R3hWIShmwPgr6yqQqmub/0KgldPhtD+ohx35saNgUz+btWeUGywLxHNBopVfQieH4tuVwqoqiNnhe9iAaoW6q6T1OZnv670a5FO5U9FOvQoVe0laStJ4+bcEc9OTa1y/h5Or2xdGd4Y5gXEt3x14aOHst/FyRcOYcLg5lTxX6AcX3qoYUXR3ZvyJOkH8bn85Epr8Fs3Ye6IfeovzNVjuaiXxzIMFg/o587HDgbNKzmlmLY51zHP8dheHaLYbTYZpweHAkD3ZUNkKSX2hhVKhR31kpYTfCd27w/V1B8E+lYSl02sKD9EuAYn6txgk4ya8j9BfCAkfbsLUBqQ85gtME3MoMQH0KSocrHmg64vgBHbutCXa3n5gbg63gO98aolONGZYApV45B8MRDAlYey/NduYe7RFAb7cnZQut961WOs90omdl6ptZDbbxiknqAdiQtDE+iL7XxyfNaP5xj2JOy1HsmbGAdgRR7+0lM6Bdcrpbm/VsuZZMMJYiRob9a8xR7x4jM1yWKympnWvzVHURVnZR8mkaW0migq+XZp9DUZI5zXNRdVcWqtejvYaB1f6ntoKRw3EnOCQ3ntcasV6JA1aoYgN5nzVwbxUQRjfWKWVEq6UOOSMR4JLFFHhjPhMg148gdMdpVLYgAd9/27s5pujMunU5fgbIZjEtdczje4Xb6PN94cW25ZpoWoD+Rr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(6486002)(36756003)(31686004)(41300700001)(316002)(54906003)(2616005)(4326008)(38100700002)(66476007)(86362001)(31696002)(6506007)(36916002)(8936002)(53546011)(110136005)(186003)(83380400001)(6512007)(66946007)(478600001)(2906002)(8676002)(66556008)(6666004)(4744005)(5660300002)(44832011)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTE5ZzNSdkRReUtlNm9GNGd1M3pLeFE5TnBIK2kyMUFreXF0Mm1UZnAvZzdD?=
 =?utf-8?B?VGhIODczSzZKNy9jOFYvODQ3d0x4dGRxV2hwdUZUQ2JBamlRdXNRcWdFTXlZ?=
 =?utf-8?B?b0VUZy94aUNqRXpJb21DZW55MWYvbHV3YmFpRmZDUlg5bDZoRzZ4clc3NlRj?=
 =?utf-8?B?QXFlMWt4RklzRVhGQlAxaGdwQmZoMUlOOUhoQkV6MHlyRS9iREpTYXJGRURk?=
 =?utf-8?B?LzcrQjN1b1gzemhZMW5pRjJ4WjR0WFl6MVpKbjRPcnhnMmR5UkNQM0k4b1Ja?=
 =?utf-8?B?eVRpdXcvN3RvaTY5MGMvMnJ0NEdGVStiQzQ5N0ZiWDRMaVlPTUF6WU9uNG1m?=
 =?utf-8?B?K0VtRThhakRQd1FjelNQNUJUekU5Tm5XZXJNOHlycUtIMFFRMGVpWkU0bUts?=
 =?utf-8?B?ekVxUU5KWGplT2lMUVBUUFFSdmZPaHZOQmNjWWYybXh5aVJ6NlZySTQvRzgv?=
 =?utf-8?B?KzBjb05zWFllK0hNTzdBVW42MVFlYmV0dnBqQkZGdWRRMHRpY0t6bHVqbE5s?=
 =?utf-8?B?R1pJN2JqSmJlOS9QNG5rZW9peStTZ1c5WDZpK0xtUzZkZDZBbm1PcElUTnBu?=
 =?utf-8?B?Wkx1SW4renJLdFRzODJ3K0lPTzRNQW9ieFdCRWJsdERaOTN0VGNoM2V2UjVS?=
 =?utf-8?B?K3Y3S0g2REY5UVhCU21QVFFSVGdyclNxU1dYK0RRYmRONmRnNU55bzZtRGky?=
 =?utf-8?B?dkw1YjhKZS9JR1o2RVJEVGtVQ0NoZ3phWm11U0YyWXh6b1lNUFNRUVRKT2x1?=
 =?utf-8?B?WWhkbUhMNGwyOVVWT1V2NDJtTVdINjBtYVg3eUxwUTF6VVRtKzR3TmJYY3NG?=
 =?utf-8?B?RmZmYXdWNDR3ZlVKdUNIbDZ3TzFZSmkwY1p0TDlkZy9QS2RiS29KT01KN21V?=
 =?utf-8?B?UnI0UU45VmJVZGF6ZCtHREVFTFRydFRuR2dGS042eTBodDh6cFdyTExVL1Nr?=
 =?utf-8?B?SG00dWVRZVlTLzBIM1FubzluS1F6QzZxT1l5ZWw2THBVN3l0NktlZ2pqMnNa?=
 =?utf-8?B?QnFCaS9HUVowRjBqQnJyVmpNNG05Zk5XOG5PMWlSc1hoa1hMUXVSeS9MVTlY?=
 =?utf-8?B?eWFaT0RGUXA2ZzRMY0U2dm84SktFVmp1dXFaMEMwQm9mdmNFNFkrRWZEN0NZ?=
 =?utf-8?B?ZWRzNkFPRktEbEtHbVpPLy95cHBYeVBWRTk2VW1HRyt5L3VBa2pRdHArZW5l?=
 =?utf-8?B?SGl0UHBNNS94TDJ4ampQc3FTWUplVGk5UXdZTGhlckljMERnWml1VTdkUFBW?=
 =?utf-8?B?YnBhWE82ZnhpWkdFa2gxS0tQd2plZ0NRMW5vMjZGS2N1QzFta3N4eFU5Z1d1?=
 =?utf-8?B?S0JQSUYzMmRYWDBpVEpGMDk0NnRHNU9yaXYvcVZCOE43aXpiTUpvZmN6dnFk?=
 =?utf-8?B?N3B4akJXZE1TT0FobFo5OTNicG9aQkRyYkdFbzZDd3JFY0N1OVhtVmIrWGg2?=
 =?utf-8?B?bFFKMnY5WTJheW53c1B2UXdPM083bWlIS3BEODZ2NmMyY3BLd2Fwa3YwUFpN?=
 =?utf-8?B?OTBPUVJpYTRUYUdYU0xYNjlVZFpTWUgwOEVkdE5UOW1Rd3lwN2RnRFZaM3VC?=
 =?utf-8?B?N1JhYk9jZXp5UFZkMlF3d1ZDUkQveGZiR0RjYy9LaTM0bDhQUG9lQlpTWEQ5?=
 =?utf-8?B?bUtwcXBPOUN3VFo5c0Z3Mk9WYmdnWjdsR0h0VStNYnQ5NDRXL3JxWkpUN25L?=
 =?utf-8?B?TG52dnY5SnYzUS93a3JSVStTT2hLSGYyd0tLck94NTZ3cGo0ZGR3VkpxYldJ?=
 =?utf-8?B?bVkrU0ZhWUxta3oxVk5BU2p6alVhS3hKTHA4Qmx4RVJDOTZtb0tub3JpQnA1?=
 =?utf-8?B?akF2bUVzN0xqWEJXWFpOdEx2OFJtcDVtb212ZzA4RUI3aFlxU0JWUjVDTk5l?=
 =?utf-8?B?a2lzcXlYTjRwR1FVOTQvc0w4WE56NWFldFhlS1JiRklJTzlWZDhUVUt1YStm?=
 =?utf-8?B?WWMyZkZWUnZ0OE5mMXI3dGFSbzI4TEdEeHViVVhaUTBVdDl4cHdaM0lLTHVZ?=
 =?utf-8?B?NkRaYlNOdy9ySmpyeWdxdEJ4YXF6WHl1WGdpRERKNmtKWTYrOXRXNEo1WFpN?=
 =?utf-8?B?MWljMjgxUWVwV2VFZFZUazFhSWFjRm5jSWg5OGRoRUQ0QktDOHZFSkV5d3o2?=
 =?utf-8?B?UHFKUXQ4SzdpOTJRb2dGNSt1VkRqUUJvd0dDYW0rMlhIa0lXOG5TclR4aU9J?=
 =?utf-8?Q?8iThLzHYm0QsMoQfc6ADbjStZuEBQGNec3qPp/JcSY30?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 652eaf86-a3de-4463-8f28-08da9d92975b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 18:36:55.7898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPplG5AgqszgT+fhyVVfugMVjHCjKnC6MdMytggjBTmhJg8ntYwrXB/b3FxO7qGukCIN5IyS1m/4ZgLEtakiUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 2:01 PM, Dave Hansen wrote:
> On 9/22/22 11:53, Rafael J. Wysocki wrote:
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> or do you want me to pick this up?
> 
> I'll just stick it in x86/urgent.
> 
> It's modifying code in a x86 #ifdef.  I'll call it a small enclave of
> sovereign x86 territory in ACPI land, just like an embassy. ;)

Can it be cc:stable@vger.kernel.org, since it applies cleanly as far
back as this v5.4 commit?:

commit fa583f71a99c85e52781ed877c82c8757437b680

Author: Yin Fengwei <fengwei.yin@intel.com>

Date:   Thu Oct 24 15:04:20 2019 +0800



     ACPI: processor_idle: Skip dummy wait if kernel is in guest


Thanks,

Kim
