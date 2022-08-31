Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D75A879C
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 22:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiHaUkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 16:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiHaUkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 16:40:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F7389A;
        Wed, 31 Aug 2022 13:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661978401; x=1693514401;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tx24K+V28BYwBQoCGmKr9FjGsrYYmOy+QbjT+AhKERs=;
  b=DYvJUqfZqoLpPyZzQ5/u36MF6qy3eBqcDhk7Bw6RLeHEU5dajqm0Mpox
   prA38TNImcMEK39/IuKbP0/tpBxfM50Ku28SsJN0SJHDHr038KP86QIIj
   qhd3FAe8RVmIDt2ItGCKBeMenu1CIuH3c1J/2ie6I+jmJD1tyocJrnuAQ
   ziscJeGjFYcFhixPqjQB7ttdQBIFkMq5x2N5u2prpUVxBGqqFZFYnLxhv
   gwZzsdP9XPW6ZuxN8IOANFy+aUJIE/WglABMEU1T4Iqhl9Nz2AGes4AR3
   qFr7E01Mvcnqc7dzBdHN02ZFs8r1MlaXrOd+6Id4MRRzqeKbBdxOZc2tW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296323222"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="296323222"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 13:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="612222803"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2022 13:40:00 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:39:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 13:39:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 13:39:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 13:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IH9rQZC8vTeKABdYtyXzviGMYLzzIxWpTGtu46wrncb6ep1pwoKES+pfWE43AX32n6Z56FdoYZDyjtG2plqw8vBZIRvHKEVkKq9Z3Fn8jTjFNzJNSUMYmTfg3dYTWvWYcgeBl71nADqQgujLzpvGfiNzdj1Sn3TVqY+mdOdL7szEgvT2pLQkCkux5pAuqJlpsUJjJkSH6wCzmSx5r9KdYZ5ZYV5ciMwJLnmnxlzeDOXCZ+smXUrVSpe981MissD5IJpovlF4V7kFfZHw1wvi/aQI4x+MQ6VRMQAxZIKPdifpjtF/GfhOwSG+/jUfxvEku+wM9YTPrTuMLyRZSX6OAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TgK04jsTNUJqycZCxh6KqTZCdiYyQFZvxUvvRB3QMA=;
 b=JsQHxv5SR2839HmPECwz56HpWOOSoFzZl8Dso5askj1UPeaW9qbFaCCM27eVNdkklXSLhvDty9N4liYThC3LJfBY5NndZIBTaT6GzYX/V/lLV0FXp3n+6v+LfqWr+p0W8WE+uyuOIyonbjjZf48Tizp5EkCMx3lJBw9aCLR1aMfykKHV/qAPPh1WjjUzk4jxnvzMdZWQsQFDM/YolL+xVSIMay/5eGVva9T/pQw2GGFWA55bYuL8W+d+3LXgVhyP2UasenNoC74uCNsctfD2qqiz7UP9xBzLfDWwuyzXI8ZDBTKxG8GdPI7cPgpJ7QIz874AY43o2/G4+5DfZB7Q9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 20:39:56 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743%11]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 20:39:56 +0000
Message-ID: <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
Date:   Wed, 31 Aug 2022 13:39:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.0
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20220831173829.126661-3-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d03ae3ba-d653-4758-3324-08da8b90f731
X-MS-TrafficTypeDiagnostic: MW5PR11MB5812:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmwyh7MaOP2rtIejzDjBnENP+PxUHFMWlNmjKhcBb0inSgn6aMw7+Xr+sQQVSYsdE1+WII9tNr5PiG8gCDLF2SVrJ0JsaW8Z2zl8FAf/v0ZlV2oYWk62khgaqZ1KeEcdHHcSB7MFYlbSrhrzX4cFeOlSBqqpz5mi00hcvYrmxjlMdbgU8UmA8rs/Y/LTUk1xW9Ueml0sXt6cyuLBWuBGy1ergw7PsPEh0i1rSZl7oo1j58SpajMHE+4QjsseAO/9INCCmhQUH5mL6xLfBF3az+sL2IEQI0PBjfrG2VcfFJKtIg2VLyhtiKCn0+rPxOxnQVv4kmJEItmrWV/NqDyFzzTW23wfvofXzg5Ni5S7ERnJ9+Ai19++KnjoJ7rUIgIsFshZ2aMqSZfvAoZXhdBLrMyW0fEiuyEBZEa+yvuRxejq0AgmsESJWNlRUFfut+rQzoodLQ/sRcQlEBcK84gsHMi0ef9BdbB72QpIrQ5O3wD31peQjns5qSAuDwvO1jndbGSvQVoQXS28Oq/FRHKvGVCEaV/tCNQS01TyVBihHLmBHoVaU3ctQmvKidplpKE32LFGRveFAYADwdDamYmop9frXRMcF2IcuT8QPlI8/07povvXS10rbBIfwya0OeILEZsuMcNtRLhuORJvDuV8c46XsQrmSTChfk9hU/Okw+5rgtZT33gbY0k9t8w3olq93h89evfdnP3qLnJoX1v1Am70EfDLz0F2BqGQKpoYcSooMnY1Y2gSmveXRtNR9hcnIUKUT+a98aClfdnWbqRSx9SdXmOcbbe7r4Wn7URp+q0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(136003)(39860400002)(366004)(53546011)(6512007)(6666004)(6506007)(26005)(54906003)(45080400002)(41300700001)(316002)(6486002)(86362001)(478600001)(31696002)(38100700002)(8676002)(2616005)(186003)(83380400001)(82960400001)(2906002)(7416002)(5660300002)(8936002)(31686004)(36756003)(44832011)(4326008)(66476007)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkVNbkpuZncyL1VBbHdiR1hRcExmWUN6UjdwVkFmcFRROHVNZW5GM1Fhajh3?=
 =?utf-8?B?UVNYUGdlYUlsMDZ0M2trejQ3QnQ2Y0YzUHRnS2RBcEFTVWN3ajRyU0F2VWpE?=
 =?utf-8?B?YmRvVUNiY1loL1NaN3JYVm82ejF5WXFhbTJyUGFFazJsSEJ6Vm9yNFFOaHNB?=
 =?utf-8?B?NUl4dXZ2Ums3Qlhwdmxac0YwYWMwOUpTMmlIemlyeUlmaWxSSmQyaG5hWnNh?=
 =?utf-8?B?RnMvdWt6M3NEbENlaGJYSzBWNWdQSkN5b0hxbEJDRDZQTDltaXhUYWVkSG1Y?=
 =?utf-8?B?UG5XZGtmeDZWYmRqemRrWW1jU0tON3BGRHR6Y2g5RzdWMTBFZVFxUUg2QjRT?=
 =?utf-8?B?VFQzUTlKTGtUbXlHUW5GR2R1ZEJvME42WmR2NG1samVTQUFVYklGbjdKRkhM?=
 =?utf-8?B?RFJLb3dydHBDdlVrWGxiQnY1Skt6RmNpQVE4dEpGUExWYzNjU1NTV2w1NHE0?=
 =?utf-8?B?K2grZzkxdURMdUIycE5yY0hvWTZTUHYxL3NKN1U5NFo1a3ZQTkYwZkhhMm94?=
 =?utf-8?B?S3Z0MHNBVXFRNkVsanJkVFdBdDJCbzExaSt4NUxjeklxNzIxZmpLVXZSY3ZT?=
 =?utf-8?B?OUZEV0Q1NUtJbVN0ZEc2RUd3ZWpKUHVlN2pvcmpza0xKcmhQbDlIeVN3bTFB?=
 =?utf-8?B?cTkrUkRmZ3NZYitHMnZGYkZHV3d5eW9xNTFBeVh4bytzelJtMzRUODNOYUdF?=
 =?utf-8?B?Q2p6RmZtSUtCRmd0UWpzTXJTSjFhY05jbGZHY0lRWjdGRDJ3SmhPVDU5Umdw?=
 =?utf-8?B?L3JzSkovNHBzUFpvUUM0TVJKNVh0RkNYYU9OeTFIUzMrWC9GQVJpaXMvMlhv?=
 =?utf-8?B?N2xlZ2pXems4K2FhQmJxcnVvUDQwd0VuRFV0UzhLVmx4c0hxVkJiUjd5ZDJz?=
 =?utf-8?B?QzhZMDI0bHdHTVl0blN6T3VDUk9HV1hwVmFpVUZaTHR1aUtuN3BXcEJidzRR?=
 =?utf-8?B?azBzU3djdEVZM0tvdy9IT2JPMEhubys1cytyS3ErRjhUVXNValF2ZWg4RitN?=
 =?utf-8?B?NzJIN2ZTK0FZQ1IyVTk3bjE0a2l1R3FXdlgxYVFjd3ZQd2xTb2U5Mk93YXJh?=
 =?utf-8?B?cktCWFBmL1JTemZlWEREMDZaVFZSZzZKMXBCR3JaR2N2L0pFNG1kNGx0cXlE?=
 =?utf-8?B?UXRmUUtzVmJsSnpOZ0g2eTdycGdlQkdXd3FzdHJSSlJId2IzQUdvSUNzYTd1?=
 =?utf-8?B?RnNGL1lNSWNPUFV1S3VmV3U1QzdobHZUQkpVZkRCMzhGNEVaUUdzdmNJMEIr?=
 =?utf-8?B?Tm5LOFZuM2RSc2FHRUZEYkhyK0w2RmdnNzIweVRXWE4wL1gybkRnMGY5RHRF?=
 =?utf-8?B?TmpTZmtZcUVBQ3FNMGNSQW5iMTRjeVNDSm5DWXhrQUgrVDhoeDZrS2ZoM1FV?=
 =?utf-8?B?WnByYWJqd2NxUXV6cE1OTHNuSDRySkxYTjJ2TVJ4SERRQkFsYzNBZGdYUnVx?=
 =?utf-8?B?N3ZkMWw1RGNUbUwzc2dZMWxaa3JBamFteUp5MUlTeVpDN01iZFpxY0lKTE1y?=
 =?utf-8?B?S2F2WXdrMUgyai9sbkF6d0hDV3FaYXBWNm5PeUFlSHdIbHBLY0RzNjk2Q0lK?=
 =?utf-8?B?bmxsSThMVXpsVEZQVkRyTVlOLzNJYXFlazh0VmpycEJiQ3Ara0VZeDlVK2Zy?=
 =?utf-8?B?N3k1UUorbVlPbFd3NWdyOXpHWDVKYjhrWTdFMm5Mb2ZmWUVmVUxlNGp4RGdq?=
 =?utf-8?B?anYrQ0Q3OGxKNVFkd1g5NFdPZjNKUEZ4VnZ5SUlSdElvVlFTekVXZHdXM3o1?=
 =?utf-8?B?S1liVjFTQTNOY3RLclJERDUrb200ZThNYU9lcnRHUzduL2lkM0I0QkZMeFFZ?=
 =?utf-8?B?TFIwc1BQYnF5Y0NTWW5EcFF2VTNURHpmcndhRzY1RkJFVENRbCtwTERUc2d4?=
 =?utf-8?B?NzZNbElWdmhlM3RwV3RsMDN2Q09kNEkyeGF5Y0lNOERQb2VONkNVMUZxUHd5?=
 =?utf-8?B?bkk5VVhjYkVOb3RkK0NZZENrMmZySEVhRnprNGFmNVJxdGtCUnRaaHlHaUFn?=
 =?utf-8?B?SlhXZnVia0lJaUFMcTRCalBtRDNheGFBek1paUpGbjU1OTJ5T2JuYks4cGhl?=
 =?utf-8?B?b092a2dFV2FhaHYrKzYzTFhiQ3dhZG5IeDAyNHBwYmYzazBuQnpNeUFzdTBQ?=
 =?utf-8?B?NEI4d01wN2VicS9Dd21lbDhQaFhnRGFhaHdHUW55cWdHOEEzTWxobitaZFFw?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d03ae3ba-d653-4758-3324-08da8b90f731
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:39:56.6813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgN5vz3hpDDk4IEjuQjGzYTod7IY07T8/8q0wxuYLCSW7dLikGkdnOa7zfKY03voRR5SybeJZpSw7GlDk2t5fnEndElQCSfGMduD14GlTJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 8/31/2022 10:38 AM, Jarkko Sakkinen wrote:
> In sgx_init(), if misc_register() fails or misc_register() succeeds but
> neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
> prematurely stopped. This may leave some unsanitized pages, which does
> not matter, because SGX will be disabled for the whole power cycle.
> 
> This triggers WARN_ON() because sgx_dirty_page_list ends up being
> non-empty, and dumps the call stack:
> 
> [    0.268103] sgx: EPC section 0x40200000-0x45f7ffff
> [    0.268591] ------------[ cut here ]------------
> [    0.268592] WARNING: CPU: 6 PID: 83 at
> arch/x86/kernel/cpu/sgx/main.c:401 ksgxd+0x1b7/0x1d0
> [    0.268598] Modules linked in:
> [    0.268600] CPU: 6 PID: 83 Comm: ksgxd Not tainted 6.0.0-rc2 #382
> [    0.268603] Hardware name: Dell Inc. XPS 13 9370/0RMYH9, BIOS 1.21.0
> 07/06/2022
> [    0.268604] RIP: 0010:ksgxd+0x1b7/0x1d0
> [    0.268607] Code: ff e9 f2 fe ff ff 48 89 df e8 75 07 0e 00 84 c0 0f
> 84 c3 fe ff ff 31 ff e8 e6 07 0e 00 84 c0 0f 85 94 fe ff ff e9 af fe ff
> ff <0f> 0b e9 7f fe ff ff e8 dd 9c 95 00 66 66 2e 0f 1f 84 00 00 00 00
> [    0.268608] RSP: 0000:ffffb6c7404f3ed8 EFLAGS: 00010287
> [    0.268610] RAX: ffffb6c740431a10 RBX: ffff8dcd8117b400 RCX:
> 0000000000000000
> [    0.268612] RDX: 0000000080000000 RSI: ffffb6c7404319d0 RDI:
> 00000000ffffffff
> [    0.268613] RBP: ffff8dcd820a4d80 R08: ffff8dcd820a4180 R09:
> ffff8dcd820a4180
> [    0.268614] R10: 0000000000000000 R11: 0000000000000006 R12:
> ffffb6c74006bce0
> [    0.268615] R13: ffff8dcd80e63880 R14: ffffffffa8a60f10 R15:
> 0000000000000000
> [    0.268616] FS:  0000000000000000(0000) GS:ffff8dcf25580000(0000)
> knlGS:0000000000000000
> [    0.268617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.268619] CR2: 0000000000000000 CR3: 0000000213410001 CR4:
> 00000000003706e0
> [    0.268620] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [    0.268621] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [    0.268622] Call Trace:
> [    0.268624]  <TASK>
> [    0.268627]  ? _raw_spin_lock_irqsave+0x24/0x60
> [    0.268632]  ? _raw_spin_unlock_irqrestore+0x23/0x40
> [    0.268634]  ? __kthread_parkme+0x36/0x90
> [    0.268637]  kthread+0xe5/0x110
> [    0.268639]  ? kthread_complete_and_exit+0x20/0x20
> [    0.268642]  ret_from_fork+0x1f/0x30
> [    0.268647]  </TASK>
> [    0.268648] ---[ end trace 0000000000000000 ]---
> 

Are you still planning to trim this?

> Ultimately this can crash the kernel, if the following is set:
> 
> 	/proc/sys/kernel/panic_on_warn
> 
> In premature stop, print nothing, as the number is by practical means a
> random number. Otherwise, it is an indicator of a bug in the driver, and
> therefore print the number of unsanitized pages with pr_err().

I think that "print the number of unsanitized pages with pr_err()" 
contradicts the patch subject of "Do not consider unsanitized pages
an error".

...

> @@ -388,17 +393,40 @@ void sgx_reclaim_direct(void)
>  
>  static int ksgxd(void *p)
>  {
> +	long ret;
> +
>  	set_freezable();
>  
>  	/*
>  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
>  	 * required for SECS pages, whose child pages blocked EREMOVE.
>  	 */
> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> +	if (ret == -ECANCELED)
> +		/* kthread stopped */
> +		return 0;
>  
> -	/* sanity check: */
> -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> +	ret = __sgx_sanitize_pages(&sgx_dirty_page_list);
> +	switch (ret) {
> +	case 0:
> +		/* success, no unsanitized pages */
> +		break;
> +
> +	case -ECANCELED:
> +		/* kthread stopped */
> +		return 0;
> +
> +	default:
> +		/*
> +		 * Never expected to happen in a working driver. If it happens
> +		 * the bug is expected to be in the sanitization process, but
> +		 * successfully sanitized pages are still valid and driver can
> +		 * be used and most importantly debugged without issues. To put
> +		 * short, the global state of kernel is not corrupted so no
> +		 * reason to do any more complicated rollback.
> +		 */
> +		pr_err("%ld unsanitized pages\n", ret);
> +	}
>  
>  	while (!kthread_should_stop()) {
>  		if (try_to_freeze())


I think I am missing something here. A lot of logic is added here but I
do not see why it is necessary.  ksgxd() knows via kthread_should_stop() if
the reclaimer was canceled. I am thus wondering, could the above not be
simplified to something similar to V1:

@@ -388,6 +393,8 @@ void sgx_reclaim_direct(void)
 
 static int ksgxd(void *p)
 {
+	unsigned long left_dirty;
+
 	set_freezable();
 
 	/*
@@ -395,10 +402,10 @@ static int ksgxd(void *p)
 	 * required for SECS pages, whose child pages blocked EREMOVE.
 	 */
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
-	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
-	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
+	if (left_dirty && !kthread_should_stop())
+		pr_err("%lu unsanitized pages\n", left_dirty);
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())


Reinette
