Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D013F459DB5
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 09:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhKWIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 03:23:16 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:38501 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231821AbhKWIXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 03:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637655601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j3f3fItM/2EEtn6K4PEOh/kZmDblSi1Mgtv0uVR/tZ4=;
        b=cxacPyLsbVogtXpA+kVFTDQg15Wtxw/dOmzb3IPXgh7L6pSk8lEF8fwC5KPNfHd2SYQxfc
        Pz9WI+ojmpw1xtIY1mFxTLsZDThYe/yHz8HVwPtkcW5ffLvBBFuU9K3RLjmWlawL4AjqY0
        qk12IfJ1idKQWzIYfenmbEvd9Wq83b0=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2050.outbound.protection.outlook.com [104.47.4.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-uDH_VCh7PnSod8g6bfowVQ-1; Tue, 23 Nov 2021 09:20:00 +0100
X-MC-Unique: uDH_VCh7PnSod8g6bfowVQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgSnmEbM84TZMSSLL4V4ntxWkzrvMurvT8QZvj7cjkymvxUJGMHnmcMzev1QuIABiajch2jW15SbqObPcpMoE3pIeAELol8UpVQAzA1CywvQDlL/2jfmwExhIsHqnKedzxOk9RQhw/p4/9RuDQKRHbkPT+YliYQw/5urfqdpxQuof7wOXCYN7A5PgierCGcN3Cf6gentux5nwKTLDTAqceve03jBZ5VNBYQKfoxGAkg+yb/OKlVcY1OrKrqgEBM/vYoHJPM24EasqBdznoKiiRkei7qdTeiIxqY5PbH73HKUTIIB8U0C/Vn5uOY4tQDeKkJgAv7ikGzJfBfQSYjFdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3f3fItM/2EEtn6K4PEOh/kZmDblSi1Mgtv0uVR/tZ4=;
 b=dTSctCp/7lGEMyIvbMAhzqKN///TGUu450LWcbzyfCntGz8Ou0D1sxQY6JVe7cWh9FKYel8bJgdz2VPAPZScxG3Lk0kj+0Xb1/api9zQnvn9F85vRzbILPRYHMP1M/Cc4aZ8z/GtOn6NoA0+0aV510qyiZQdx3FUQqzKuTSLyi5Y135vZJaSlnC7ZqfUlLZBCMSnoFZhdCTiCfetyBWPKjwqlm69rD6SXlUj163N9yn5aRY7Jmd8oOCQBVQLEk1ZgTOidMTUMpcxqHyQDXZDZ3qNtcODrchAFa+Ou2v7bOnp8TfFIydeFVuI3DpZFGKNmiSu8qTmJP7/8NqV0vO3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB5599.eurprd04.prod.outlook.com (2603:10a6:803:de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 08:19:59 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 08:19:59 +0000
Message-ID: <799aea46-80de-972a-571a-b0d946178f4b@suse.com>
Date:   Tue, 23 Nov 2021 09:20:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
References: <20211122221625.1473164-1-sstabellini@kernel.org>
 <2533e721-a01b-6659-71fa-24a8d2896e84@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <2533e721-a01b-6659-71fa-24a8d2896e84@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::41) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AM6PR04CA0064.eurprd04.prod.outlook.com (2603:10a6:20b:f0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 08:19:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd2f6e95-cc70-4a9e-9320-08d9ae5a0a01
X-MS-TrafficTypeDiagnostic: VI1PR04MB5599:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB5599F10DBEE4A2A9EF75F0EFB3609@VI1PR04MB5599.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0EaLnnShGJWbRQV9oYzEOtyp7zvj71q2lw6Ts9Pm13vQSXCDxF9z2KemuTjoO7FTO/Iw4mLHgBpU/0G8l6ocb5dfUuMvajPYxDIE033yCjG6u3aCT6c3atuSx80EEPwo/M+uI8rvm1WO3ixuh7KbjfHDaSlAbC5edu3jXr31+gKvOiFLEjF9P7uCBMFWiFc11/4IZ0Xco3UjxtUkMRWeAWkbAOnKqeKciaPamanyqtBX1vuZWaJOrbALfhmRqE+IaabEbFXOIgg66ndkVP6vchuK3jUaNHPrP9UOgrwFLRu+xrVwVmAqjqZECXHR5A8c+8vy9Kn4TLoVyNuZV9v8MQjYSE/XPoZa9r+uGTumuE7cIS42IT5gEm6s79S9tZR+vRPoUJHQtHeJBKO+rNt9CKm0Ej37oZoiL5S8XIaiZARexXCz+7keJIw7d/FyRnqHOTM0UOUk1vGW5w4Jz9fhiOMb3MHedoHLRkcWJsnRNShfxRE5B4qlvpAaHmFZBLuPFwVB2gQ8ctOLX92gTxxtsbZ7tx+Orx7QT2Ft28olcihnaPcRws0vUI7Buq/WChtKL/nZqSP6peW6A7fZRCDMRsZxvpb5trRMBbAPljQSRnxXfXpy93bH/47fG6MAkznyIl5Pc+IjpBnJz2Tz83oQl6zeKjNXhP6Qpy3/FBkkXcgEK0nQlR2/qXVUIsqbsNdqRbOJ44bBdA5MObBo+9FOF4o4cB9KyaJi4S+h/wbdPwvcouFjuekzWQcAtP6RkJD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6666004)(31686004)(110136005)(83380400001)(16576012)(4326008)(86362001)(38100700002)(31696002)(316002)(5660300002)(66556008)(66476007)(26005)(6486002)(956004)(53546011)(508600001)(8936002)(36756003)(2906002)(2616005)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0lZeWFKMElIOWdlVTRWcUtwTDEwelBtdWNmR1VuWGd3eVF1NHE1eU1RZFcw?=
 =?utf-8?B?WEQ4UG5pWGFPc3pFZW1xYTI1RWRFWGwwOW9wNytHbnNtYU5zR0tnWTFGd21v?=
 =?utf-8?B?bitOY0Y0dFNjdGVRSjdSZWh0cnV5UGJBSG9pZU9zNVNjRzdtMURmcnJycnpL?=
 =?utf-8?B?Q3FzYloyWmJqMm5raVZUNDR5RGtlUmVpUnpESi8rcTZrd3hDcmJETzQ0NERp?=
 =?utf-8?B?SVlhQTUzcEFHUEtJZGRoZDNXdW9Jekpwa003bWdFVVlKMG51bEJhcTMyN0hC?=
 =?utf-8?B?eHFkYjlwYy91Z0tjWW05V3ltYk9CeUt2bEY4Qm5vVDBXNGhVWlJKWDlnVVZK?=
 =?utf-8?B?WjQ1Y1JvVHBvcnBIRFVOSWNIM05IckFNT2tJOTB1Y1NpamJma3MrQm1WUTZ3?=
 =?utf-8?B?OHFTYnNrTUdScWpoRGJqNDBZMVhSMW5sMXJpZG9telBHcnIxQVRxRzM4YWhK?=
 =?utf-8?B?TXV4Slh0OS91c2RGb2wyZjRaTTVmS0pWcWt1dElwTG9OL0thTmJLZVBFM0M2?=
 =?utf-8?B?aGlWY1IrRUlTQU9HMzVxMjJUQ2djcXdvd0xFWlRpTE54RGxxQ2E2TWxDanJn?=
 =?utf-8?B?TTQ1L29tOENVdDhacVNZOXpPb3RXN0hNa0g0b1JnN1lQemNNTnVYNlZPeXJm?=
 =?utf-8?B?cDR2ZEZFa2d4RHVZdUc1Vk9JenJ3Z2dXTDR2aENPd2VVUzhMaFFUT01oMkFY?=
 =?utf-8?B?d2FwVlpMbFZhQXFleFRqeHFxVE44R01hZ3ZUSlVJWlk0WHNRaFpWdUhPYVlv?=
 =?utf-8?B?T2o0T0ZwRENUalpDeDI2NHFoVTh3Sk1JYlVKVGt0eHhpNnUzWDREWkhGQytz?=
 =?utf-8?B?dGVwWXdFTzNmVnNPS0FMbFhMK1JMeGI1ejB1U01xazFkR044MlEwQVdsOGw1?=
 =?utf-8?B?QUhPWU5XUzlYMHU5RzUyZUR3Mjd3TWNnYXJmOGZhTUN5QVBYNE80UjdQbGJw?=
 =?utf-8?B?YlcwSEJIdnhuN1BBQVRCc3VObmhRWDlKR1BmeGZXbjgzeXVYSWxtMGxtU2R3?=
 =?utf-8?B?YmhPck9ydTEwdEdrY0JXQ3U0dTMwUVYvRHhTc0ltMXVtaHJlQUlybG80WStv?=
 =?utf-8?B?bkI3QlQ0bUMrM2JIQXNPbXhLekZTN21ta3BHek90YnM3alkxaFhDOXNNNFZI?=
 =?utf-8?B?czhWVTExM2dWV1NXVVppeHhLVjllQ2ZQNHUwc01wYkd3UjI2Qyt4QXEzcUN2?=
 =?utf-8?B?WHJqZVQ3SzZhQ3dDQ3V5djQ1a1dhTno5dWV6YTkvQWRNdXhLQitWdGJNWEc2?=
 =?utf-8?B?TW5iMk9UUjBGbW5DSE0rbTRGTWh6N3BzOXJaRXBSeXNBaEJyZm9OTmxWbVZN?=
 =?utf-8?B?ZlRwaWdpMExqb2czVHZqbDN1Y2hMVVRpcUUrbWlZKzczL2YwdkdyNUVlUDdk?=
 =?utf-8?B?TExXMUdIeXhmMXcwTm16RmgvdVRUTERsVDNNNVZUeDJTSWxyZ0hKcGMrS0Zv?=
 =?utf-8?B?MzZMZFFnQ2c4ekVteFBvOXU4TUxoUTY0b3FwWUFWaVBZWllmblVycmRla21u?=
 =?utf-8?B?cVZ3KzhESEJmV0Vvc2t0MDNIZVFUcUEybGR1U1MrUkxRK1JtQmphU0hIbXVr?=
 =?utf-8?B?alExS3kvTmJjaXlzNHV2Z1RYMk51Q2J4SER1REYvV2hDbUM5RndlWW5iQXhm?=
 =?utf-8?B?VXJ6SVRjM2xxUytWN1JzRU1ZSmlESXFmMkxLYkNyWldRUXR1V2RhZEFGdkR4?=
 =?utf-8?B?UGhKc1I2T3Ayd2hPb2hlV0F1YU5lZlRwbkEySXJyQzVYbVEzRVBJdmVyRk5Z?=
 =?utf-8?B?bmZUNi9XZDIrVFliTUlTRmFOd2ZhODNrWHJZUFNpTXlCN3NkQ0QwTmJVU1RN?=
 =?utf-8?B?N3RZTjZXeVVuRG1JNkNPaHVZMVRxbDRKbk9SNmVWS3FESk1rVldXSDgwazZ6?=
 =?utf-8?B?M01CSXlQYlhHeStiS0ZyN3RLekVic2YwaXBub0xVdlZQNHlVc1RYeE83REh1?=
 =?utf-8?B?RUEzSjBqQTFUNE1VWW9WQTVYRVI4S1VhTEtlS1dzK0tGYjFNbkZEVDdsSXNT?=
 =?utf-8?B?blphWU82a3J0ZnVKWDlMZjU1amZ3MEhaaTFJSUVWV0JWL2pkYmhHUitEOUts?=
 =?utf-8?B?WC90dkl0RTkzUnN0eG1aR2pSNStobk1mUEUwUUFwcFJYVmVtU3o1QkM4bXRv?=
 =?utf-8?B?NVQ2eEErdmRyVXZyL3ZibSszM1NraUdxUkozQjNWOFp6TXl4OS9TdXZLWTIr?=
 =?utf-8?Q?wJuOPdWVsm8rMTiOHlaf1jQ=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2f6e95-cc70-4a9e-9320-08d9ae5a0a01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 08:19:58.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeeK/IwDme97fmBjBYcT1TVnX3Kq5hQIfUTcbZW49CrKYcHfTBoyFfxsnxA/zWWidsV18zpLw05faqCkwtEeQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5599
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.11.2021 06:42, Juergen Gross wrote:
> On 22.11.21 23:16, Stefano Stabellini wrote:
>> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
>>
>> If the xenstore page hasn't been allocated properly, reading the value
>> of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
>> error. Instead, it will succeed and return zero. Instead of attempting
>> to xen_remap a bad guest physical address, detect this condition and
>> return early.
>>
>> Note that although a guest physical address of zero for
>> HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
>> and zero has never been validly used in that capacity.
>>
>> Also recognize the invalid value of INVALID_PFN which is ULLONG_MAX.
>>
>> For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
>> above ULONG_MAX should never be passed by the Xen tools to HVM guests
>> anyway, so check for this condition and return early.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
>> ---
>> Changes in v3:
>> - improve in-code comment
>> - improve check
>>
>> Changes in v2:
>> - add check for ULLONG_MAX (unitialized)
>> - add check for ULONG_MAX #if BITS_PER_LONG == 32 (actual error)
>> - add pr_err error message
>> ---
>>   drivers/xen/xenbus/xenbus_probe.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
>> index 94405bb3829e..d3ca57d48a73 100644
>> --- a/drivers/xen/xenbus/xenbus_probe.c
>> +++ b/drivers/xen/xenbus/xenbus_probe.c
>> @@ -951,6 +951,30 @@ static int __init xenbus_init(void)
>>   		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>>   		if (err)
>>   			goto out_error;
>> +		/*
>> +		 * Uninitialized hvm_params are zero and return no error.
>> +		 * Although it is theoretically possible to have
>> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
>> +		 * not zero when valid. If zero, it means that Xenstore hasn't
>> +		 * been properly initialized. Instead of attempting to map a
>> +		 * wrong guest physical address return error.
>> +		 *
>> +		 * Also recognize the invalid value of INVALID_PFN which is
>> +		 * ULLONG_MAX.
> 
> Adjust the comment, e.g. s/ULLONG_MAX/all bits set/ (in the commit
> message, too)?

I also don't think the reference to INVALID_PFN is appropriate here. Afaict
the two aren't the same on 32-bit. Plus I can't even find a constant named
this way in Linux'es include/.

>> +		 */
>> +		if (!v || !(v + 1)) {
> 
> For me "if (!v || !~v)" would be more readable, but I don't really feel
> strong here.

Oh, indeed.

Jan

