Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E995E8027
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIWQxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWQxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:53:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866B21252;
        Fri, 23 Sep 2022 09:52:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl0UpJe7Fx+H8LppBuEYd7wNen5WrpG2D+MooW3QfJJcVHABacyvuQcPSQXhBrtvzL/ghjtgEBkiMXCJUqB37/AAEeLZXqxWL0mMdDlqYyTqB+AeHqs5Ap+KeFFuy0Y4chBT91/eguo3ASuvgTnWgYZoz4WmSVzDWJYee9l0ekycHHYtsOPx7YUSrOU6gryRkviYBV5N2IlM6zkqOEK9hxIhUCkhXlNKLDawRrTLBYPQCmDFE8am/f3JSGejBxm4hKTBifwbxDKc/MWmHDGsJC90Y5Z3Hv3Dh89uLwNo0xeZNWIcCMmkFe47cKBfB01U0/isj2gA2LtcWg/SToQqRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfJJh+53OHXQmVqpa+M1QZoHNXMtOOFDG12UuEBgFU0=;
 b=jdYVKiNbH4mwVnNfEI5q5HN189Y50eVEg5a3GFHhxVYKdFcmUdV/KGNZSJJBlPZwFFig5oG6eR06i/Kpya7+ZvsuoOfvFgQ6CubfJI9KiiSVxrmGUjLyNlktvQ8/dR5L4Tv9nbtzbmaLuCqNG+NnzzzC3VQYxHH1nQhFzIjCio5NpFr/+WGxaWDeG7//9IWsclbjh13rqVRrZ3ncY47XCITYhgAJt8qGnZR9B8wT/Xshdghi1XbenCcbIkvbuZZ00p3qHd/ya4bwAMk+zDiEILyZn0iVFxhUV4SYDOmLoZ/dvsKICP9fMB2xEIRD2a8z8tQn707+Zwhh6xo2LM/bMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfJJh+53OHXQmVqpa+M1QZoHNXMtOOFDG12UuEBgFU0=;
 b=S1Rm4Jp1fN3CQmsDBFw/3SaMsQ57HlLlKQ4h1gS4IUi6z8I796EU26oomTytBAYN+IOXdSWik7JbB49wcpKgmbwjgEqTjuZCPNNNrjBooF+Mcy9fLuoG2Dad3j360bAi0MhCGx9MbHrKcNjisfzqYGgtQxumtkqUK3iWaqkzbps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by LV2PR12MB5775.namprd12.prod.outlook.com (2603:10b6:408:179::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 16:52:56 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:52:56 +0000
Message-ID: <0d0ecaf5-c186-8a17-99a8-a732dc716b19@amd.com>
Date:   Fri, 23 Sep 2022 22:22:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] x86,acpi: Limit "Dummy wait" workaround to older AMD
 and Intel processors
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
References: <20220923153801.9167-1-kprateek.nayak@amd.com>
 <Yy3U0fQ0GZYZnMa1@zn.tnic> <f020defb-df73-35ff-5d97-c07773bafb67@amd.com>
 <Yy3fFciusHZ2h1GW@zn.tnic>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <Yy3fFciusHZ2h1GW@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::19) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|LV2PR12MB5775:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a64ad4-3b9c-4059-2184-08da9d841022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8oKfMb+M24+hbh/h9qtBCPoKLsl24hHB2MEGlB6ie+IpNphKtVKXgaRbR+H/Shu56bzxf+5329KE2ZSgajFUo4F3GL6tgOI/TLW3H04qp5ngBkNVzElbCvNa2s0Wwm0gt5IkeTnx93EMK19cKi7uHeSyDvwqdLj8j9zFiRodkJeiaVOA0S7NkDDBTIuFRNGIwJQl70bPNgklwTYZFFcMk6t7S7FCQYwS3Zq09IoDcRd+Dezru5nCq3NZ1G6JuXkAL+YwjEpkPh6gslE4/22pkuIcC9VfUCI74BDa6bTXv3g9bh3kkkL2BSM4tYemJm60xLaGPXjWZTiNdHvT86K0ZEA7lKfZf57iI3d+ZayrPGeCkIGkoiyH4TSx1u9aYRiJzrvfK+7aTnCr1JNIxcRMdghQ8x9pt+RXX+Q8KAhlWtRHD0gTuv8KDphwO3fZIYbLq0jdFDmsXZZ0FU0ZYT44hlgDijMkIjhM7akqZJcx2fhAOtjWM3UDLB8ARSzQEfsYNrZknoUoe4QAZyUpNfPMOUkkCJuN2gYkq/PxHilSyNdSS49iudfYRiab9zoohSwScqVgy+0sqRLWvi4wxxzrjy21dT0jGgR/WC2OWZcaZ+evmChDC1TxutxuZeXRL8vvPvqU9R1skRHptwFhvxqDTWGTWPMlhkIHj7M3AYY05dpyFjpI4lP0zzZknTYj/wGPgkXG3e7CGS72wwvmp2RXWLYd7jMeY/Z/U/56RJtR05HY0ye3hb5/sfepDDWp3N+CEaTJufGGBl8GqRa/KnCbnimZViCW9Yubq1HR78oiqa7eMIJE5WYHm4s6hceaH9z9GuuoHvEMmNaOF4DD3Cw8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(31696002)(7416002)(4744005)(2906002)(53546011)(26005)(6506007)(2616005)(186003)(6666004)(38100700002)(8676002)(4326008)(66556008)(36756003)(66476007)(66946007)(8936002)(5660300002)(41300700001)(478600001)(316002)(6486002)(31686004)(6512007)(86362001)(54906003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHE3bDFXWDhVTzAwUmpOdWh6NnFscGEzKzlKYmJ5Rk1pVGUvUWFGYTNzV3dM?=
 =?utf-8?B?V2QrK0FlMkdSbm1wbW9yNzUyYmcxcFFNTHdFcVlDQlU2SmxqMHVlTW9WYXY4?=
 =?utf-8?B?N2FOOEM0cnZRU1JXZnhWVzRzY1pDc2lQWWZ2cFIvWE80NThaVkVuNzNyR1F0?=
 =?utf-8?B?clVBeDJBY2ZXZmFwUGY4WDh6STRlTE44Z3ViTVZNS2xtaUhQdmg3SWtHUFR2?=
 =?utf-8?B?MFMrM05zRCs0UTV2NXJYaFI4K3lEY3g1bXMyamZwMnRoSm1tZVJGV0hOQ1Bn?=
 =?utf-8?B?akl1RmMvaExnZWwxSGVoNUkrcWd6eVhOQWRnSms5NitaZlU3dzlaN1ZXb0VN?=
 =?utf-8?B?c1FJR2lYcmpjcUoxK3FGMHFMVDV5RzBNVThoZXczRXlnamVkOWE1d21sQmJJ?=
 =?utf-8?B?Mklhd0VYT2lUd1NRSFBwNnVjL1YxOEVpZWNFeGh6cnNmR0pkSGpUaGVORzJ1?=
 =?utf-8?B?T0hIZlpvWWphN1piTjU0Sk9ibmlGaEFjZEJJNXEwQXJmUGY2V28yMUxnbFZm?=
 =?utf-8?B?azJtc3lNOUxJblVLU21MOTNKQmNWK2ppUkN6YmxvZ29JOUt1QVhWU01ReU5M?=
 =?utf-8?B?Q3RQcEVXTG4ybHpMMVp6dVpLM2FSVEJwK3dwVkRNUkdhS096NUltVXhpZ1Ry?=
 =?utf-8?B?WGdvdThSaFUzbzFnNGlhbElBV252eVRBaTRXeFB1NnAzUHVJSW9tWGg1Rklr?=
 =?utf-8?B?cHVKSDA1emlZREdsRldLZDcweU50a3pSR2RlUk5kT090WW1TQUdNM3NEUGJY?=
 =?utf-8?B?VExvNVJBQ0QzMWhMazBUMVRES0VhZHhyN3pQTTFhMEVmRkdBNHYycGxYQThp?=
 =?utf-8?B?em9sSjZVTUd6VVJFbjNEbC9WNDU5WlZXOGtROEZnN3NwMGNyT2JkYnBLejNU?=
 =?utf-8?B?SkIwbjZrNUsxQjViei80VjFySmg5VU9UMVp3c3NDTThzY2l4bHprdFEwczVv?=
 =?utf-8?B?TFhxV1JrMHA0ZEYxMmk0VU9NNExFenJnWk0vZU1jMkg0OER2YjhFb1ZIYVBa?=
 =?utf-8?B?M1o3NWhBUnBteStVQnVqWlk0WDkxYWNVSVFXTzFGZHZ6NUN2ckJRVjNtUkc4?=
 =?utf-8?B?djk0b25nSWRPOVhaYUQxTXJ4dnhMbmtvQUN2MG0yd0tFdjkzTTBDckJtWFBK?=
 =?utf-8?B?NVN2Qm9rNkR1dVpFem9QWFRZUUtCWnQyNUpPT25LM2d1NkhNT1BPckVqdVJB?=
 =?utf-8?B?MHp4YlpkSGx4QVBjdFppbjB5SjllTFB5d0JINVpnS3ovRndsYmVqTFNQTE41?=
 =?utf-8?B?QTdqa1RzYVdOU1M1ZVdOUFZvVnlvbTgrK1ppZzlxdy9YaWkvWm1hQ3NuUEJ2?=
 =?utf-8?B?MjBVTGtQT2RrSzlnNEtoYk95RWYxcXVWRVAyRDFKT0poV3FsUGhTZ0l4RUpy?=
 =?utf-8?B?MTNWaTV2VW1XdDBXSFZiODNKZWU5dDZQYitMV2w2NnJsZlhIa1R1OVh6aTkv?=
 =?utf-8?B?RWlySlpJb2k1SlgzZHRqeFpxM1YwY0tLOVZ0MmhvMTYyZjlPVUliTlBTZG1E?=
 =?utf-8?B?L1BmbUgrd1ZjSHlnR0JHclJhaFF5MGNZaDl2aFpyK1V6cHJBdFZIWGpZdWlD?=
 =?utf-8?B?SndvMFB4NmxBMW4yRldtQVVKZVplMWtLdHBuZ2ZxKzV3ZTJ5ME1IbHdvNGhF?=
 =?utf-8?B?RkVIVGk5WnR4QU5mdXpVUlNFYlZyQkZTOXBzRFVPcS9JRG9XWVlEeHEzcDgr?=
 =?utf-8?B?ZHRnZXlFNXd5WWRhbnFlYU1nR3FRdUo0UjJacnJ1YVY2cHNmbWhNeVFXZnpF?=
 =?utf-8?B?SzdSZFpxZWZDUzVLUmhLc1orNy9UK0VYQ3NFdHBLWFQ5d3F5YVdtTkE1NHJy?=
 =?utf-8?B?Ym56cVZMVVk0K0pBV05aam9meXZsWE91cTZFdG5qNFJWcDFDSlY3YXh6L0xT?=
 =?utf-8?B?dmNZZDNWTnVkUzhwdWhIS3RaTzlqaVdPQlBrSmJxd0E3Z1NrSmVvSXdBRDdw?=
 =?utf-8?B?cXErWjk4RmZzbG1LUVZXNUdXWlJobm9ZSmY3a215Q3V2MXNFejJIUFNmNWpa?=
 =?utf-8?B?Z09uM1RGMnhNRDRMR2RRR3lYSU9OQzNPaEljUVNDRnlZUFcyMXpLa2xTdWNo?=
 =?utf-8?B?U3ZLQVNmYnpWeHFFVXRYdXNsYjJPc01UWGhmSk5mcVBxelA0dDNjeFdFSnFy?=
 =?utf-8?Q?xPPOus6pxsT0VYqhOQqmmYUVs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a64ad4-3b9c-4059-2184-08da9d841022
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:52:56.2168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4d+jJEliIHsgtZJU6VCmNiLbuwehZey16GFnMliFr0OCagCAfEV9o9ZOU/YMUAZ9WN1+qlVKOT9xVPnZAHWyGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5775
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Boris,

On 9/23/2022 10:00 PM, Borislav Petkov wrote:
> [..snip..]
> 
> Well, AFAICT, that box is old and dead. And I'm being told that the AMD
> machines which we care for and which are still alive should not need the
> dummy read.
> 
> Which means, we could try the simple fix first and see who complains.
> 

That's a fair point.
--
Thanks and Regards,
Prateek
