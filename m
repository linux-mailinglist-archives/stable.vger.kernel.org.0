Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C4344C858
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhKJTDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:03:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:17491 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233735AbhKJTCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 14:02:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="296180956"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="296180956"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 10:51:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="452422879"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 10 Nov 2021 10:51:19 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 10:51:18 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 10:51:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 10 Nov 2021 10:51:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 10 Nov 2021 10:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgaQeK03QQ2iR5l2pCPpIW6R++bgGpqsnRxaSFQd/Bv1AohAh18X5BdQxqPhdXENqE1kfN5GXBegAW5GnjqVS44K9/+u1I4S6YSBLqo8TxjFSp1jm9QOWiy33BJf0cWiNGBvOge7qrA/XVN27I/Cp8gWHa9dMTZd4NrBM4ByG9gsYwqjOpJ+DyV2uFkAZoGop5fLfS+oO/xmjzznduWFpcnvTiuJah5mkaOJV8tFLFBTrbv38IrpJORanDt6UiLqO+FnewY5IESvdi2jpdOP2Hy8l2NNv+N1jjyXXKyWy8Zilo1zvxbpLHqOUd8kSaqctMuAQ1PGn40+sZ8JYfwbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWvTvr0T43XhBcpf96FqplL2FbZP4JbQD6+/ojJue/E=;
 b=MjISrtyBQgosW9cghcxwE0Apxa7o9cAj3keB4Sn5W93sCC1aBwE+5eF4lymOSXqj2Pi92uP5VlTntOjuIZWwqU1smPYqYtJqulowT37rX3HmAWkQQsSmd450adS6xg3/yhZ2oy8B5HDiQPU22GGkYzvcqsv8b4RBb5TSVD+nPQXbSoEiU8xEdyEtR32CjLeTf2VbIO2GOssASz7X1fwiu5bv8d9KHtQFh3HoWkADeFS+YvegbFM/E8WYlg0NGErT3XQ/4vj8Xd+1oOmzKd2IHvlDA4DtRnetpkjtJzxrRzSN+2rSNcoqibMqxsfbRomC/6OFoQ0QFq38uYG+7AHIvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWvTvr0T43XhBcpf96FqplL2FbZP4JbQD6+/ojJue/E=;
 b=rpu2l4eQ2lQzhGniVBN/tHp+pOQ07p43oErHCob2okXJq4L1XvZZtFe21sBxrU5MKes0pLjBPbgKGBSeR+4i4ROwaYJ/HhX8xRfo/5Mq+EDREBsR7mNZ6/QYiAwdi9YLNgNXTDcDL5Vk1v7mfDu5SEamRryYhjMKolxPCHdSlXU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
Received: from BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16)
 by BN8PR11MB3635.namprd11.prod.outlook.com (2603:10b6:408:86::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Wed, 10 Nov
 2021 18:51:16 +0000
Received: from BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672]) by BN0PR11MB5744.namprd11.prod.outlook.com
 ([fe80::494d:4194:b64e:c672%8]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 18:51:16 +0000
Message-ID: <794a7034-f6a7-4aff-7958-b1bd959ced24@intel.com>
Date:   Wed, 10 Nov 2021 10:51:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <dave.hansen@linux.intel.com>,
        <tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>
CC:     <seanjc@google.com>, <tony.luck@intel.com>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
 <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:300:93::11) To BN0PR11MB5744.namprd11.prod.outlook.com
 (2603:10b6:408:166::16)
MIME-Version: 1.0
Received: from [192.168.1.221] (71.238.111.198) by MWHPR17CA0049.namprd17.prod.outlook.com (2603:10b6:300:93::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16 via Frontend Transport; Wed, 10 Nov 2021 18:51:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ce806d4-e0f5-4b41-abcd-08d9a47b1331
X-MS-TrafficTypeDiagnostic: BN8PR11MB3635:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR11MB3635E181DE491CB783F10322F8939@BN8PR11MB3635.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qflE3c8tpTMSpJpkGJRruxdB4y6lV4yKPvNM6ylWPlmydzs5q/BgNjZTqtQC1YLEG282/0G7O88+3PI8N65OKT4V32bsDKbctwF260bypyLKshXAcv/GCKumaHmcTZqbgur9F1czSqRS+PWZ7u7t4XXnTemalomaK86n/poj1CD86+NDdXhyEYpjftfyDNMnh6xk0EXVubaV1Dp56djBr/d8OG2eHje8OTnYTAX7L8jOLHyd1+b1e4LlI3uc4h/3mSB8WynOzsdehAkEZ4+lfWFq/PIOZmx8/zE2MwuchR/c84ZYSHLIV+9s1FOuMk1NvTLLRbMlJHixn6S8wdXNwxmEtxqHy1/ixfy1YUfkLNtnxqckYlToGcWg7KI1pkHhis6iV2CnswZcEiHS7ZTyjEVR8HdiZc/NTZmD22m1+VBtYAgHjqPmx9JLeeyD5HRXdoHcHAhnDAwNYfbaptM2Mmi/af+BnN9BN7PWHDFN3fXQ8XabASgWx4dLyuM29L58vLM5QCxCOY4OBUF83dq4j3e7mw1u1eZrVCr4A7Ex8Cg7KnbL7Hh0zDBs2lcD9z/CJmTydFKxu7wKZtWfWKofhXGCDj5WNLPBXqMeTVGM4ML6u5/OnnjswPLiCav7Q+6muCQ3rN8Eo+ueRQbxWhxhhLZrgH36FeYPpVGGp0I6sNTM1635ePJIBL752cboOXwAePBgB81hNt5dGAhNlv2UsTbnxNX+QvRQP4oXrCrmVOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(7416002)(6486002)(66476007)(82960400001)(31696002)(316002)(2906002)(38100700002)(2616005)(53546011)(83380400001)(956004)(86362001)(66556008)(16576012)(8676002)(15650500001)(186003)(8936002)(31686004)(508600001)(36756003)(6666004)(5660300002)(26005)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHFVaE45ZUp0akdyUWpQRTJCc1pzRjEvV2gzNWFBZWtqaVdlQTRCTzVpd09a?=
 =?utf-8?B?RGo1RS94RlExZFhhdWMvRmZkcUZacXJ3QTJMYXNFYkxpbzNydmdaVG1UTG1J?=
 =?utf-8?B?aG1uM3ZOSUwranNOK3NFNWxVUXI1VTc2UU5RdWZoc2UyaXhiTk9tOG9KU0lT?=
 =?utf-8?B?d1lPZzZKc1dkUjAxL0M2L2Z0Q0Z1U05VNWJQM2kxa2NGS0MzQ1pvdGFQazN0?=
 =?utf-8?B?MlNNbXhxaDQ2QnRFYTdGRm1VZ09JYXRNZzZvc0RwYWVUcnVTY3NhTHRyMDNO?=
 =?utf-8?B?bGljWmQzL3dITTVZcUVHRURTTXpnTkkxTU8xWnRiVHZmdG5uVUR3Vmg0MEJz?=
 =?utf-8?B?aWMveWJpbnF4QWdDcGxoL3FNY2ZxeEVrb3cwdnFKK1NwdTVMNTAxMnFDcGFt?=
 =?utf-8?B?RTdJa01HeVk2blBHRkFQNUVmL2d3Qkx3Z2NSbDhZQ1luQS9hRE4zVDg4V0F5?=
 =?utf-8?B?S2NKRFpHa0x2Z3ZyeVR1bkRTcmVUQXVkWWYzL0c3U2JnVXZQTlZpZXN4WndM?=
 =?utf-8?B?SGppc3NmY0tQT0JIampQQ00rRGFNeEZYVW92S29Yek9mT3I5VE1GZXI1MDhr?=
 =?utf-8?B?ekdiai9Sd3NKZG9Qelo5T1BobWNhU0poVWVlOTBMOERCRVQxekVCeFNnWkor?=
 =?utf-8?B?WVk2L21iQmMvTFltcm5mN0Q3VElGWEtoU3c0UGV2c254YXJGOFBlWEFHZlJp?=
 =?utf-8?B?aGRMRVdZckV0OHhEM2cxTS9aSEJwUXhrVU9Cblp3YVBRcm52cFduVXFrdnlx?=
 =?utf-8?B?VlF6S1BYV1lGanIzTkJ6bVdPZVhWNDdUL25yZlh5NmhiL1FFU1R2Q2pKbGVL?=
 =?utf-8?B?VDlIa1FocHRhdm1LVmErclpnenNHV1FINGNONlNiRCtka0xKN3BuQmF2cVNi?=
 =?utf-8?B?ZHF5RVBLT0VtNWE5UHBmNzdmRkhyTmxRcFF1bzNiVS9KQVZlMUxpNWEwVmNT?=
 =?utf-8?B?Um9PeS80aDNjWEcvYWlHWXlIU1ROaWpTc2dSQjg2ZDhkMEVaNjdvNldQZ0Ro?=
 =?utf-8?B?cXRFeEZ2YnRQZTlKSzRibmtldVh5RWk2K2NZa2tnMFZjcUlXRWxPREx6aGF0?=
 =?utf-8?B?WVJ4WUZSUkJBZVk1a25IWGtuLzdpK3YxbnNxVTFWOGo4WjVoaXFEUTRqcDFX?=
 =?utf-8?B?TmhXbUtibDJueC9Vd3A2WmdGdG5pSG05SkMrVWdIN3IxY2VMampDTkhUM0Qx?=
 =?utf-8?B?ZEx3N1c1UkZRWTVSazdkeWh0RU5vT2JMVUxrQWtKNDc2QTFhNUpVQWQ0cG5z?=
 =?utf-8?B?UHc0U0cvVXhSSHp2c2N0d0pHSFBvTXQveWRkdlh1R2h0eFA3bDdIRy9pb3BL?=
 =?utf-8?B?U0xsd1JLY2RjZm4xNnUzeElxa1NlSmZyemduZ0xrMmxNalpEN0wwdWNDbmdF?=
 =?utf-8?B?N2x5OFlvMnNMOFJ6VHJEN01lZlhKSWxKVmtCeUVoYU5IdXZYbGZsUkRlL1A4?=
 =?utf-8?B?akVKVlVuS1RaSlFPdE81L2NoNnU2clE3djQzWlNvcWdnMkpSenk5eFkrRXlZ?=
 =?utf-8?B?OEwyZEprKzhNMUN5a0g4YWFQL2g2S3RLUEp6WGVjbDIyRHpqQkcwQmRseE1h?=
 =?utf-8?B?L2JycTd4UjNFeDQvck5KTS9hTGhWZlkrcTd1WjRhajVIMGdRdDh6akQ0R1F6?=
 =?utf-8?B?UVk3WnhlSEpCQlJ0cUYzM2krOFkvSy91cG83K3JjZXNWMkliVDJxaG5XWStO?=
 =?utf-8?B?NHU4cnd4bEx2RmFobTlGTEU3N1RuMlBxcU43M0pEYkFqcjNXQU9BVU85YlVt?=
 =?utf-8?B?V0R1Rm44NGgxclhWOEFtdSs5MncxL2xOdHI5ejEwdTNvSWI3VU1NZ0hwbXpr?=
 =?utf-8?B?VnVWTFhQM1ZiMDYwQ1BHRnRZMVA2QzRlaXJ3c2VwY1NvRWFtUVZPUVNLNitU?=
 =?utf-8?B?eE1pVVR2V1FFUnFGV1RVbktsQ3ZadG1IMUREclBOVDdqUm5HckF5WWhkYkFx?=
 =?utf-8?B?U2wxdzZoUFZPcURTSUtENzVaQzdMUU9MdkMyWk5LdTNMMG95cVc3U3JhRUZy?=
 =?utf-8?B?SDZGMms2QkgvbEtXTVJTWTJtMWV6cGgwNDYyYnNESXRqQ1hWYVhtc0ZCb1RP?=
 =?utf-8?B?SVlYdkVDeWd3dkxHdzVXZlZJRkNzbjBHSks4WnJwbEphYkRoU2I1NXJoUENN?=
 =?utf-8?B?Mk1KYXRXMmJSTHF0bHhVOENTejZkTVZyNVBId29PRGx0TFpKT2Q4UngwYVls?=
 =?utf-8?B?MnJGa0ovZ2xVNGRLVlArc29DbzlMUVdMSWJERWtRL2JzemN6THpjZ1IyZUdH?=
 =?utf-8?B?TzZ6WTVaZEhVZDZTTEJpbStyc0tRPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce806d4-e0f5-4b41-abcd-08d9a47b1331
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 18:51:16.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fOnl8TClZa6+Ezejd9u7jSvxPkLvIEnXYLXq5iVObvW0cIany9lb3EzvP4uwX3g0Y0FowbqbYZaHcEtoeOxUejHQKBMf+TrMuL/H2aFGdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3635
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 11/10/2021 7:11 AM, Jarkko Sakkinen wrote:
> On Tue, 2021-11-09 at 12:00 -0800, Reinette Chatre wrote:
>> The SGX driver maintains a single global free page counter,
>> sgx_nr_free_pages, that reflects the number of free pages available
>> across all NUMA nodes. Correspondingly, a list of free pages is
>> associated with each NUMA node and sgx_nr_free_pages is updated
>> every time a page is added or removed from any of the free page
>> lists. The main usage of sgx_nr_free_pages is by the reclaimer
>> that will run when it (sgx_nr_free_pages) goes below a watermark
>> to ensure that there are always some free pages available to, for
>> example, support efficient page faults.
>>
>> With sgx_nr_free_pages accessed and modified from a few places
>> it is essential to ensure that these accesses are done safely but
>> this is not the case. sgx_nr_free_pages is read without any
>> protection and updated with inconsistent protection by any one
>> of the spin locks associated with the individual NUMA nodes.
>> For example:
>>
>>        CPU_A                                 CPU_B
>>        -----                                 -----
>>   spin_lock(&nodeA->lock);              spin_lock(&nodeB->lock);
>>   ...                                   ...
>>   sgx_nr_free_pages--;  /* NOT SAFE */  sgx_nr_free_pages--;
>>
>>   spin_unlock(&nodeA->lock);            spin_unlock(&nodeB->lock);
> 
> I don't understand the "NOT SAFE" part here. It is safe to access
> the variable, even when it is not atomic...

The "NOT SAFE" part is because in the above example (that reflects the 
current code behavior) the updates to sgx_nr_free_pages is "protected" 
by two _different_ spin locks and thus not actually protected.

> I don't understand what the sequence above should tell me.
> 
>> The consequence of sgx_nr_free_pages not being protected is that
>> its value may not accurately reflect the actual number of free
>> pages on the system, impacting the availability of free pages in
>> support of many flows. The problematic scenario isu when the
> 
> In non-atomicity is not a problem, when it is not a problem :-)
> 
>> reclaimer does not run because it believes there to be sufficient
>> free pages while any attempt to allocate a page fails because there
>> are no free pages available.
>>
>> The worst scenario observed was a user space hang because of
>> repeated page faults caused by no free pages made available.
>>
>> The following flow was encountered:
>> asm_exc_page_fault
>>   ...
>>     sgx_vma_fault()
>>       sgx_encl_load_page()
>>         sgx_encl_eldu() // Encrypted page needs to be loaded from backing
>>                         // storage into newly allocated SGX memory page
>>           sgx_alloc_epc_page() // Allocate a page of SGX memory
>>             __sgx_alloc_epc_page() // Fails, no free SGX memory
>>             ...
>>             if (sgx_should_reclaim(SGX_NR_LOW_PAGES)) // Wake reclaimer
>>               wake_up(&ksgxd_waitq);
>>             return -EBUSY; // Return -EBUSY giving reclaimer time to run
>>         return -EBUSY;
>>       return -EBUSY;
>>     return VM_FAULT_NOPAGE;
>>
>> The reclaimer is triggered in above flow with the following code:
>>
>> static bool sgx_should_reclaim(unsigned long watermark)
>> {
>>          return sgx_nr_free_pages < watermark &&
>>                 !list_empty(&sgx_active_page_list);
>> }
>>
>> In the problematic scenario there were no free pages available yet the
>> value of sgx_nr_free_pages was above the watermark. The allocation of
>> SGX memory thus always failed because of a lack of free pages while no
>> free pages were made available because the reclaimer is never started
>> because of sgx_nr_free_pages' incorrect value. The consequence was that
>> user space kept encountering VM_FAULT_NOPAGE that caused the same
>> address to be accessed repeatedly with the same result.
> 
> That causes sgx_should_reclaim() executed to be multiple times as the
> fault is retried. Eventually it should be successful.


sgx_should_reclaim() would only succeed when sgx_nr_free_pages goes 
below the watermark. Once sgx_nr_free_pages becomes corrupted there is 
no clear way in which it can correct itself since it is only ever 
incremented or decremented.

It may indeed be possible for the reclaimer to eventually get a chance 
to run with a corrupted sgx_nr_free_pages if it is not wrong by more 
than SGX_NR_LOW_PAGES when there are enough free pages available to have 
the reclaimer run when it is almost depleted. Unfortunately, as in the 
scenario I encountered, it is also possible for the free pages to be 
depleted while sgx_nr_free_pages is above the watermark and in this case 
there is not a way for the reclaimer to ever run.

On the system I tested with there was two nodes with about 64GB of SGX 
memory per node and the test created an enclave that consumed all memory 
across both nodes. The test then accessed all this memory three times, 
once to change the type of each page, once for a read access to each 
page from within the enclave, once to remove the page. With these many 
accesses and unsafe updating of sgx_nr_free_pages it seems to be enough 
to trigger the scenario where sgx_nr_free_pages has a value that is off 
by more than SGX_NR_LOW_PAGES (which is just 32).

>> Change the global free page counter to an atomic type that
>> ensures simultaneous updates are done safely. While doing so, move
>> the updating of the variable outside of the spin lock critical
>> section to which it does not belong.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> I'm not yet sure if this a bug, even if it'd be a improvement
> to the performance.

Please let me know what additional data would convince you. The traces I 
provided earlier show that without this patch the system spends almost 
100% of time in the page fault handler while the user space application 
hangs, with this patch the traces show that the system divides its time 
between the page fault handler and the reclaimer and the user space 
application is able to complete.

Reinette

