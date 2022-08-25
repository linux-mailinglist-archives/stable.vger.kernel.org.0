Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABF15A1022
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHYMQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 08:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241486AbiHYMQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 08:16:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2065.outbound.protection.outlook.com [40.107.20.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A5EABF2E;
        Thu, 25 Aug 2022 05:16:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxoLbjgY4+FKTcPca2QvY5N6LOAPJuPXGIu4PlkydHdZUEZ6YkYmVlKSDia3IlZS7104tH69sF4ZtRfPRsl1GGgbGrtej5FaAINArbkIRK/LBOqysZO+2hhpvdS4AfEkfu4d3xjbCKu4IvjdJgiiFihzkYDSvTn+VhAtrb3xegJCkyBCbZ4WDQQwg6xSfQ50uQcpr3Ce+ptKXAxMkK7Ii27AiVpfH3agqkEGI/RQTVF22K8FBHXa0cOfdf/x33Wkg/OzW2NzlMyCjC3b+BzEevCTlP0vyL7M4A07mAt+IHAIibk1XNY1rwJj1Wpvxp/bNJOE2zP9Z0sOfy0IJ92iww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXr/kIxs5MFrdfZ0vbIbMooer7uXNe3YgL3e1rWZLJo=;
 b=he9xbj4L1S8MjntZ7lNgPUjbHiy+a/tbJJEihxpy+XJni5oVgzaZYOPSneTSRnYsFLj0vUPbl1LXPGPWJPnZrgXAjiiPADko+/632S9qISeblxljTzaJ91b6xJ3eXr4xehDuW4l7A1A8gDjpy+scrEBivyO4kVwOtU60LCSQP6yjqZOhgUlg16Z2dTCJHrXrr7jcHN5uEXRWBQ3dOE+99tlzCcHnUuxBoOW+cXSV2C8K/KWoTDq62sXnFJhUlciCFmpRrgFcPvLL5BPG7NqKBBHpXlRjiOuZ4RsnSbRIRLAo0hed9HsG5gIRbmhyToCjEqxMWK66vMVcyretdri9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXr/kIxs5MFrdfZ0vbIbMooer7uXNe3YgL3e1rWZLJo=;
 b=PUL9A3YWUdeG+AEvy73kEN5JgLtSpwfOUWdGa0HBSx00WphNDSjR6Sv6qHQD0g3u7MABP27Ij+CrOA1rHF8tebN3sbkpWrqTZxcW8GLmFd0udu9od3mSnwjaS9sGGpsF0I3twkW/WHeEJED49ykIquUwzUIzqVS2DPhoNtU+ggZviNI/+WU6XqUtaEvykCESiYaGmk/D+4dBm5KJxx5bDC5+I/xh27mHuakBtkMRA5NrtVRNIk81PS1r79AgXR+8nKotOVOWRgkYxCiNt/catjpvs/UbKjuFa/bMpeJ5aepJOeM9C/HMHhC52z6wJYoqhbUbNulNZKeUv0p3MF6YnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by VI1PR04MB4608.eurprd04.prod.outlook.com (2603:10a6:803:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 12:16:15 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 12:16:15 +0000
Message-ID: <0ffb0d35-c1cc-69a9-b42b-e183756e0f03@suse.com>
Date:   Thu, 25 Aug 2022 14:16:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825114004.24843-1-jgross@suse.com>
 <744be7c4-8e00-7876-5819-a1d07d3d423f@suse.com>
 <6aa83215-49fe-56c7-1a77-0a63a663c99f@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <6aa83215-49fe-56c7-1a77-0a63a663c99f@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR04CA0014.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::27) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 008a4a19-faf4-4006-c41b-08da86939b65
X-MS-TrafficTypeDiagnostic: VI1PR04MB4608:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6hZREYf93e8JKx8t3JwgEyN3YwGN/qgDpqHqgrA+9LHMcU3JRkrf6s7K/T5DTf7cpJ+s6SDsSy7wKpWYRT7mK/OwJUI6tY/EDtpYlOYAM5nAjzChWLTS3bXySYpTbmDT2Wjyf197Gt9GCP1kigH62C6JkmwicOG8yjUfrkcjWIfidjIStqsnQvudmc1g7XRbo+pqGLwjV27+/EIKPRWtP01zNjQevMbe/+ohRDqI7iZYDOotfe/JXwK8eM5kWldom7pSTYx2Kpe47ZIA4f6Q/9TZ8wQsfxdzdhCZXB+gQWJFO81wzXA0uF8SMjli/H3F8kLdwmHshODdOYiwi2TSIguuuyNvaiRTaE08u1KTtfeFljiGyS99bKwBrlsX+qZJXvi5FbWnykGwWecoRrhOeullNbDos7oS2topnyQM8GD6eUPV2wAMBaKR1LCC9fKBlL0hyKpXENDdKD9ySoPQVIoDbdkXWYfKSGGMgKr3NP1prMb5CyW6hVaVqdVoCw0TStR2Lvi3rQWXl7PUT+B8/4zIC48z/9w4qP0SJGN3tA6JYvPx7MxAo3RJlxp+oPFrvG9kAJggnkubMqxf0MPkI2WPAVEzwCgvCuD9EqdMpTfgzg3MI656C6fuDHC8UAdFlknbIq7DqD0N+CuCUk0zX2p/8KDeZiaXMo6wtFsfSGQuRu40Yd5i5VE6CG0lJlHCyWdIZ57BS5tLZa+oEovvuPWZUA1zVbtTCPcoOf9uYq877rKs7OohY2pTbAMRDn+hZZLeTt264tQX21vxdKlG+1ZFBJqR3CzLXnUdha/Hgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(376002)(366004)(39860400002)(66556008)(38100700002)(86362001)(31686004)(66946007)(36756003)(31696002)(8676002)(66476007)(4326008)(186003)(83380400001)(53546011)(26005)(2616005)(6512007)(6506007)(41300700001)(478600001)(6486002)(316002)(37006003)(6636002)(54906003)(2906002)(5660300002)(6862004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHliTFNiMzloMjdwYWt6S1ZkSkdUTzZqd2FjM0E5akh3UlBlUXZhdVBMRDlN?=
 =?utf-8?B?L1htS2xKQVB1Z1V1enh0dmcvK1RXOUphOVRLVGNtYm83aW9yRk1pNGNIanhj?=
 =?utf-8?B?cDd3dWlLWnhpVGU1R2FYMGUzU0ZvU1UzRmY3S1h6c0h2cEltbzh6OVBwWlk3?=
 =?utf-8?B?dTRGcDBhUVR0aDRrQlk4S3FwM3ZXSWFjRC94NG11aWNiR3UzZ09walhQMHh6?=
 =?utf-8?B?eGx4UkNqUFJEN3cwTEdEY1ZZS0NJdDIvUEdWRDNUU1B2aE5lNmg3K0x3emRI?=
 =?utf-8?B?aW5leEFIK01TTE1FZ3RhbzhvMnFwUEpSUU85TVJibWVPdmdOSDh3cld3Rjl2?=
 =?utf-8?B?dHBVVTNqaHlDUkdTNmJWSTdHd0N5bkRLNktZTTdWSmc4ZVBUYXpOU0F0aUV3?=
 =?utf-8?B?V0dyRHhIVmNCVWlnNkhockpJOFlPeEJQdXhzMktSS2hwN1JJSkhWMHR4clB1?=
 =?utf-8?B?eGpZaFZzdDZUZDQ4NW8rWDA2K3ErZXFBVjBDUE1BRzhXcUlHMnF2cXlDbFRm?=
 =?utf-8?B?alBQWHZQTVRlSFdlTTAvdGhYeENXVWFJQmVGUVc0VEdnZjU1cnduVkJ3U3d6?=
 =?utf-8?B?K0d0S2dEM3FOQ3VhcEpKamI3ekJnMkJPeUxlcFJNK1RFT210Z01MNHNZd0Na?=
 =?utf-8?B?RjhZaC83ZUhoVis2UVJodXNkeFZsY0tpWVF2UUN5a2lnaHlXUm9hNFM1OW9E?=
 =?utf-8?B?RitqVFJqVFJVbVlvUERPUzBLcitSMllZVUV5U3JFeHd1WDc5YW1mOFFRU05w?=
 =?utf-8?B?SElKY2YyQW5lRkhTM2wzTm41bmg2cTJsSnpzR3BvSGdLT28rUHREbWlGRCtC?=
 =?utf-8?B?bHhVMmdIZGY2dXJWQjlyVFhCZUtLSDdLU2Q3eXpxV1JJZHhCcGgxaEtuQnYx?=
 =?utf-8?B?TVVSTUZhLzNLVk9mVjVwOHk1djhuZjZjU2RydGM3Y2N5VW8zSXZHYWIxaW5S?=
 =?utf-8?B?alBhcStBSzh2aTNZanBHS0pKamc2bExsNHN5Rll0d2k3TXNQTzVVMlpqQjhB?=
 =?utf-8?B?RU1CeTZqcElOTVVlOWlpb3V5OTh3Q3d2dkR4dFFyR2RGRTlHcnI0cnppNTRP?=
 =?utf-8?B?MkkzQjkwR2E0dTBnQnFsdFVsZEhvb3pUK2s1ZkYyaGZFREprVWlOZXBaUUxW?=
 =?utf-8?B?dmhSNVBkemdWaTJFMGNmcjE3MGRoUi9USlBOV0JmM3lFaVNnbDk5T0pSdzdQ?=
 =?utf-8?B?WGV0ZHBrY0JaWEtVa3Rtakk5SGQ0VUZXK3hmaGFvVW1hdmZtYVEzUE10dnF2?=
 =?utf-8?B?ekw2ZjBja0F3Ny9jK3M2K285TThKbDdtRkZ2ZlloKytPaVRwVlNvRWhmd3BN?=
 =?utf-8?B?bkpJeEtPZ3RHamRJNGhrSDQ5QVppSnZVWDhtRk9LVjhOOGpoRWVXdm5qNmlY?=
 =?utf-8?B?c1dNSTl1UW9ZNEs3VDdiaXArWWFhTVV6SGc3QVNwRjRYcm5uSmNYa0JqV0Qv?=
 =?utf-8?B?ZnNKKzk0SEF6TXM0dmJEeUM4bG5UTnBQQk5KUGgzb3B2bDZKNS9obURhWXJm?=
 =?utf-8?B?WUd0RzVwOVhmRXpXV3k3OFU2am1hU0VYWlArNjNBV0tCT2RxZS9hczhQdVNu?=
 =?utf-8?B?ZFdDT2kwdEk2REtMYXZwSnE4cmhNUzBSZlJIRkJRQ1dPSS9hSFRCOWpSNnk5?=
 =?utf-8?B?TEJRQ1licHNBTFcrTzM0OXllbEl2bnJyL21melB6UnE2cTRPYUJOa3lTbmt0?=
 =?utf-8?B?ckNKUFdJeVlBN3MwVmU2T3BJT3BtMG43MzZQeDlITjZWdi9GdnphZ2RBMmFa?=
 =?utf-8?B?RTVGQ3NrZGtEOENzMStmTHJoKzMrYXFLTlBCUWFjMkIybnNheFpTZUdQeHdF?=
 =?utf-8?B?eXdDTVlLVmJXeHVScVIxamxlUFhYdlZ5Z000REhIK0c1KzNQOHdKTU5pZU9a?=
 =?utf-8?B?djFtOWVoSE5wcTdDeHAzQWorWHdkTEF4UG1VQUQxQTQyOHQ3VlBWbVZaakVR?=
 =?utf-8?B?eUViZXBhK1lDYWQ0NGczTVhTNVdURmlodnFnWm5TNXAvVFptWGRuT0RqY2Vv?=
 =?utf-8?B?MXZ3aGZ2TGVkSUR6QTI5M3pSMGJqMmE3eWx3bEhLTytkMUYxTkYycmRwZmN5?=
 =?utf-8?B?OGl5NXNNVnFhcEhBYmIwckhxWitxK0lVQ2c3ZGlvYzNhMTY2ZGxaeXd3NWpW?=
 =?utf-8?Q?Sv22AYramazmBlV4OmPeRzlbn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008a4a19-faf4-4006-c41b-08da86939b65
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 12:16:15.2892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IByAxW6AbYr5u+SYrSp5ovdjNjMPCOKdLvqMOTBCWBe/ZbBm+MVdgsK0iFiqMvK8Fz6DzvmIFTVJ0buBfYccA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4608
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 14:10, Juergen Gross wrote:
> On 25.08.22 13:58, Jan Beulich wrote:
>> On 25.08.2022 13:40, Juergen Gross wrote:
>>> --- a/drivers/xen/privcmd.c
>>> +++ b/drivers/xen/privcmd.c
>>> @@ -581,7 +581,7 @@ static int lock_pages(
>>>   	struct privcmd_dm_op_buf kbufs[], unsigned int num,
>>>   	struct page *pages[], unsigned int nr_pages, unsigned int *pinned)
>>>   {
>>> -	unsigned int i;
>>> +	unsigned int i, off = 0;
>>>   
>>>   	for (i = 0; i < num; i++) {
>>>   		unsigned int requested;
>>> @@ -589,19 +589,23 @@ static int lock_pages(
>>>   
>>>   		requested = DIV_ROUND_UP(
>>>   			offset_in_page(kbufs[i].uptr) + kbufs[i].size,
>>> -			PAGE_SIZE);
>>> +			PAGE_SIZE) - off;
>>>   		if (requested > nr_pages)
>>>   			return -ENOSPC;
>>>   
>>>   		page_count = pin_user_pages_fast(
>>> -			(unsigned long) kbufs[i].uptr,
>>> +			(unsigned long)kbufs[i].uptr + off * PAGE_SIZE,
>>>   			requested, FOLL_WRITE, pages);
>>> -		if (page_count < 0)
>>> -			return page_count;
>>> +		if (page_count <= 0)
>>> +			return page_count ? : -EFAULT;
>>>   
>>>   		*pinned += page_count;
>>>   		nr_pages -= page_count;
>>>   		pages += page_count;
>>> +
>>> +		off = requested - page_count;
>>> +		if (off)
>>> +			i--;
>>>   	}
>>
>> Initially I thought this would go wrong only on the 3rd iteration, but
>> meanwhile I think it's wrong already on the 2nd. What I think you need
>> is
>>
>> 		if (page_count < requested)
>> 			i--;
>> 		off += page_count;
>>
>> or with the i++ from the loop header absorbed here
>>
>> 		if (page_count == requested)
>> 			i++;
>> 		off += page_count;
>>
>> Plus of course off needs resetting to zero whenever i advances. I.e.
>>
>> 		if (page_count == requested) {
>> 			i++;
>> 			off = 0;
>> 		} else {
>> 			off += page_count;
>> 		}
> 
> Yeah, or:
> 
> 		off = (page_count == requested) ? 0 : off + page_count;
> 		i += !off;

I wasn't daring to suggest something like that ;-)

Jan
