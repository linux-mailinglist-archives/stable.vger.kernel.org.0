Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748605AB652
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 18:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbiIBQMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 12:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiIBQMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 12:12:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DA03AB2D;
        Fri,  2 Sep 2022 09:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662134912; x=1693670912;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AVXg1ENwRPPeZ+SYwlZcjxc+rEaI4LIkkDiAWrJNe8Q=;
  b=PtemiuIvTj01UkoeIg+v7RcM75vCYcsz0GpQTBkdR4crwuORZsmdtypl
   fZBHkYN09WCEaYI7/cm/NF52O18fRSrjemF/YOb4HPiIfM5dsOPXRVflM
   VPf5pHxHcosGcDJZIDePh887AcqbuZIn6xZ2cL4IT5bltVZ24JcD5fKvs
   IV8r1OPRmKCWt4+FQF30EsNKuGx0GBN11B+lQDeaBoZSNvcmyvciszIWj
   t+SahI4klfG1dBeJ29IFxB7huQdOPYL5DIuiZl4UZuwKIcqHxfEdcDHhF
   AEOXXansGu/9GdFIirgs+uFCdxiyXCYy+3kW5lJhqdRcCDiVqhmTTzdvD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="279026961"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="279026961"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 09:08:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="674406710"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 02 Sep 2022 09:08:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 09:08:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 09:08:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 09:08:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 09:08:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ic1FE8UCCLYVZIA+bzrFdP4n3hbWpMLyJ8o8Ek461nPJnZ4cdKC53iNPK/IWcdopZ7AmglORN/iZoYSAc+6wmjxSmW834y0ICIIwNvR3pdM9D4ZlhIleNUxGxILUQC0+RJJnYPHL/w9knKRGxinROwsIbHe8qW/S58zv9TDXZuXyCEK4ZIRBHNxCBl2ggfkvQHxc26Wb/tors0ifencvkYFiq1h1UPIJDJHpTD4B/Enrwnp7SuIjG8WlfOOdz/sJAiqVKtYJiS2bmvFnKsI4/bTqusml/LUvSWZA3cPrxivIYIHKzpruM66yPWLRi7f754pJ+OyIcZo3kDDL8MBWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XU6rUVWaijV1l0Cq8KYDXAUCz7CCF01fKuBHDGSxUzg=;
 b=YkipRoRFdw0uzMiTL6WVILk1JooDKucgN95JAuP/zIPsMvlNj3AFN0DT4clP884s/3ObdjHPlp6JmjK9ZNqk967oE9ftxV9aghFsQqxHPnL5aTSlgiHhZ6tRZdC2lyvD0CpP9l8w3B2A+bR1ApYnDTE81l6DZ48y/fwDPgMcF0KEpM/T6ZnxW0E7/JED5o9FodUr0/t0H2JyPRpVWYdD+S7Fjyl+BAc0CJHhyt2HbnRbpf7rXD0ss5UDEGEk39E2LeMojvLOkelIloftmQ3QWp5vk720zOsy0o99uiB8Gdtoq1fNAPe96A3B6/J/npz9Bw4H3CfwJ90Q2lAErykfZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by MWHPR11MB1935.namprd11.prod.outlook.com (2603:10b6:300:10c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Fri, 2 Sep
 2022 16:08:26 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743%12]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 16:08:26 +0000
Message-ID: <b418161b-2613-4bb9-9269-b4995de65794@intel.com>
Date:   Fri, 2 Sep 2022 09:08:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.0
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org> <YxIEm4uHVvUY/rv6@kernel.org>
 <YxInD1m7rEnQ/yxW@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YxInD1m7rEnQ/yxW@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::45) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41c999a6-0275-4985-6a53-08da8cfd5e23
X-MS-TrafficTypeDiagnostic: MWHPR11MB1935:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95In9CSUcJBsEPqa25URKEI+hlJ0hB4Ftm4iPDovtvdbxKW7NVNehr3zqiXpc8YMlehI7H8urLKi4vgOT8cgDskco3FWrlfFRR5toRBmM9e2vpOPx/5IDxf8N0l5JDkj4x6dIKtRzDflRaW2EVEp/ZHA7B4cCGWKRi4z59vIubo33cuEhQZEl6kLdc0k/3J0EzLkA+0hwYZFzmaGprb5ajVGofrNMIHzc4qKVdz5XB9Mlk0F96F4QRxGTG9eRsDE4jhN44PyaeW32RGj08QpYIVkpAvtYOZzdNEuiCJXNG6UXMDchSQHXBgKVIFMZ5t9+EUGBs4iy1RQ7D/aGpzkA2z6fUHE7QGh2Ur9RqCes5bLJcQLiy3Nji26ZDK43Gz/biOLg/QxSXmr9pRLyOf0tTvVwY+q8Avms5RZzZR4ur9bhptoiKaP+A3tpnFnd4tzY7vWXTvgQRLQIEYcbvGeqCQ0FieSiV60ptWc145H8c8JggVmncYEEvgDhv/bqW3xxLVDLtNRsVoIEmTAEoTv/R5rOWOLa6u4P7yVb68gXbeHguHjs1JHiQbHXIdxhGpWDiXnbz34jY+iEOmAd3lS6V6Rt6Vdhwj36MpsgwbU20Z/2zAZ+Zj6a0oZ5sHxbPJ42r6A9l86zdkAmCLOhzK2AkY5Nd2SpXl/WMd/mig3PYQ2/8Ez26FehK4kNtq7LJAtAOw0bzHvQrnKGrb4tMIJRmrOxlCS8KIBnr0/KDBSxmQBsZjKu9mMkdCPsexV1gCLUQcQYXupYmtf8+TpEXWyRsaxsGPA1QZY0eVYDH2fg+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(376002)(136003)(366004)(38100700002)(4326008)(26005)(66946007)(8676002)(66476007)(66556008)(82960400001)(6666004)(6512007)(6506007)(4744005)(5660300002)(53546011)(7416002)(8936002)(44832011)(41300700001)(186003)(2616005)(6486002)(478600001)(54906003)(316002)(6916009)(86362001)(2906002)(31696002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXdaanVRbnFVMmdNMTJ1QXE5K0FtR25kb0F4Mm1OaFFDVm91STU5KzZ3K0s5?=
 =?utf-8?B?dXJTQXgzcWNFMDFVcEpvQmxyeVhLV2Fva28zSVh4Z0FqbzRJNit6Yy9LVDhk?=
 =?utf-8?B?WmpydVA4VjQxZ29HVEZkTWY3eURFaTV4OTAvcXdtMisvM25LbzdFWXJSZ2ha?=
 =?utf-8?B?YW4rY1A4MGpsZ2VIS1daTldWTzFlZEo5N0IvbFF4Ny9CMGxaWDF4WVN4TjIy?=
 =?utf-8?B?akc1eDRrdENIb0Nsajl6RUJUbkhmd3JFNVhPR1FJZU5PSGJwdStPNU9BSVYw?=
 =?utf-8?B?Y3hLR2c1YVhiYTFrdDZnYWFTRjNIMXVQMng5M0oycCtBV1NxVGlkMlp1eUR6?=
 =?utf-8?B?cWsxa1E5aG5pbmNLT1RYRmJMQ09iVGN5dWJpblpPSGh6alF1L28wVXJKdmdq?=
 =?utf-8?B?a2p5ZlZSM0xoOENkNTlTc1JSTnlDOC9FUGl1czZtdW9oTmxnVVZuTit3RWVl?=
 =?utf-8?B?SG9ORmN4SlpZTFd1MlFad0ZKdS96MjR6WkRQd3N2VG00V091aVY2b0V3WGlG?=
 =?utf-8?B?aGZuNEpaVmJNSDh0dkNYbGlhSzRNa3YvMjlMUVFXbWNSNHVkT1plMER2WGZm?=
 =?utf-8?B?Y2paR3dWaHMwa3crU25ZUWwvS0huOVJnQ1RhUlptNTUzMmw0T1VnRkVSUXly?=
 =?utf-8?B?TWtTQ2lSM1AwanFGTzl4K3M2TGVhNk96Umg1UTJhdjIxVkVOTVNqQ1VLZkc0?=
 =?utf-8?B?YzByOXpVZE5ERlM3UzRWM0ZsYXV1bGVGbVh4dTJ3N2k4eTc1QVZDcmFBaGRm?=
 =?utf-8?B?Q0pJcGh5ZHd2T29Bd3dZdTM5K0FmSUIrWUx4VGNjNjAwZXFocXNHTE5icGFS?=
 =?utf-8?B?UTRiRVMrUFdUUjBSWjJiZTdQL0RtTlIvdXJnMmtqUHhzQXdVTkRmbGwwVDM0?=
 =?utf-8?B?czFKNmhqbW14Wk9IcnpmTmR4ZzFVT0VudWlTOHZWNHplY0RUR245ZHJnbVpI?=
 =?utf-8?B?Skh1dVZFZnpnQkhFKytGeXRXSUNjNUhiM2thVE1WV1ZQNFN5Q0FaNmNiOVdv?=
 =?utf-8?B?bXp0TGtvbnRvcGkxYU1XQTB0Q1BlcXhtVnVTM3BEbS9uODBtYmhGUnArWktV?=
 =?utf-8?B?VTAwYVF1aTN1WFJZREZHclpnQWg1eXlDR2xMV0ZiNnhZZkhUczl3b1dNdjVl?=
 =?utf-8?B?alVBbjI2VWgxc0hmUzQ2Y3NlZjVXQjZOU3FQSklkeWhSeVZDR1FBSEZmVDBj?=
 =?utf-8?B?SmNiYVFSdGVzRTl0UDlhRk1jeGtYWkJXbiswNTkrUHJhK2U4ajVSemk3SFBl?=
 =?utf-8?B?OWVEKzVOQ3N5VmJGN0paTHJhMFRva0R3RkFoaWVMUjNKUXhCRHFNcm16Skhu?=
 =?utf-8?B?ZHVkR2dZYTQ4T2VlUWFpUXVjUktnMWpMQmhlR1hDZWhwR2hjNWlTcHZwN053?=
 =?utf-8?B?Y0h5U1hFdE5TSGFuVEYvaUVXTTYzeEkrL2dkTFdaejM3dXF4b0d3YURVVkpV?=
 =?utf-8?B?L28wZGg3d3l3bW82cmpGRVZhNTJyWXlZbGV3VGNPWi9YbjlNTG5CeHpkdUVJ?=
 =?utf-8?B?R2N4R0lmclVmOGh0amE2RXFsbVJRVTg0NnJYYXFyaGVyQkNlTTQyUE9JTGJV?=
 =?utf-8?B?dTJMN01URzk0SjJuanZOaStwemtNQ0FpekNySjNTd2VhbXdLa3hSWGpqMGp0?=
 =?utf-8?B?UEJtTWFoYTl6bEg0RFpKeUZMU0pmWnRoZEdWU2hLTmZNSFN1WDRzN0F4V1hx?=
 =?utf-8?B?czJRMysyOUNsNWRPYThxY0JMQ1hwNlZhdnpFQ1ZwdGc3MXdVUUFoczJCN2x2?=
 =?utf-8?B?bVQvaHR5YnBSZUVYNmtlWlVSR2hVa2JRL2Z3Sm1SclVaeFptYXVXWEwzQ3p1?=
 =?utf-8?B?TlYwaWlrOUF0blBWOWFpNHlYYWFRTUlPS0sya2VBMmM0MFM1VVZ5eFFmZnBs?=
 =?utf-8?B?SWxJVTFHQ1ZxUWQwdEcxeFR5eWxnQ1pNdjk5MXhDQUxnYllBcjZ6RU5SbXFW?=
 =?utf-8?B?TXZRWEg0NS8yM0YzM2MwQy8yN0MwSm9qaXZ4OXFqL2dLZkNKemh6Y0lRZm9U?=
 =?utf-8?B?dllkZlFzNlZIWTdBc2dvdGRheGRyS3B2MTRHdEtXRk54dEE3czRocHEvWTV0?=
 =?utf-8?B?YXk0RzJNSFIwOGZYM1Q4ZEdIU0ZST3JPdE0wWi9RR1VJQjJya21WMkVLSkxU?=
 =?utf-8?B?R3RLZ2VYejlMeEtlQmVTNTZqbkpDYUk1WUNUb0hJTE5wRW15MkxsWmhLdWs5?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c999a6-0275-4985-6a53-08da8cfd5e23
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 16:08:26.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7rhXuRqbPaWA77gcX7a0acFkfLax7KrzgT1Nfh54dpF3JJQ2vyimY1BA40Q33fC+EZIY4KgwLaNixm4gaFdAbcEw3511UbJwj+sxFZYYwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1935
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 9/2/2022 8:53 AM, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2022 at 04:26:51PM +0300, Jarkko Sakkinen wrote:
>> +	if (ret)
>> +		pr_err("%ld unsanitized pages\n", left_dirty);
> 
> Yeah, I know, should be 'left_dirty'. I just quickly drafted
> the patch for the email.
> 

No problem - you did mention that it was an informal patch.

(btw ... also watch out for the long local parameter returned
as an unsigned long and the signed vs unsigned printing
format string.) I also continue to recommend that you trim
that backtrace ... this patch is heading to x86 area where
this is required.

Reinette
