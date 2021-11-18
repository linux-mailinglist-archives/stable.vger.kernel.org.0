Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74032455743
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbhKRIut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:50:49 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:58916 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243077AbhKRIus (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 03:50:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637225266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iya6b1bQoAJ848Se32DLvKbaTbi3hYCcvLKUjFP3Yr8=;
        b=Y0duF1c+a980hD33UwQet2iexHxRqjzTMqLCIpuDs/fcDqXkDEkzUgg4nDw3M8snj/JxsM
        DU70aIjse08IhbzB6q5+5N6Hk87H/tw03kMK2vOaM1wa06YNnIt36BBg8nx34Bx5OHjfaa
        4i3WmHBQiWytvTZjAhC5YP9r0xadSfs=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2109.outbound.protection.outlook.com [104.47.18.109])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-3-bMOJcId7PFCZNywFiwAwEg-1; Thu, 18 Nov 2021 09:47:45 +0100
X-MC-Unique: bMOJcId7PFCZNywFiwAwEg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ci9UAXQnQuRyURYz83cDPaecd6Tc1ztE4EhAW3iHIglrEctqOZhvAt+x4x7rtz0oQN2KI5nLb0YRmjAT563Ow7FhODnoF2hgPGNscM5vlLdCeY2lmDxLiUqXCNqtvWNGj+zycSBbfOaQEPZcV/RBoEV3HgCQatjhbBNxvsqAi414X9o6UIXIEtg9kpfD0FWhheAALG9PlVQCzGu5N7OkAwL22h5mp5DyRN3ee+/iZhdfwd6CLjhOAFFxxrbnX6vgpqgbaDCuJxFUM6j4giCB3RFRFx4QxcBVhRXCyjYnx7CwGvZpe9Juy+ApaQaH1A3cmIkuMIKUdG5PQBXO2ByGrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iya6b1bQoAJ848Se32DLvKbaTbi3hYCcvLKUjFP3Yr8=;
 b=UEw2ypKus0m9XrDt7qs1jhWcN95WRL34tkoypveQx1wZeGSFPrxt1hAWVHoy0fazBExkvJAbWUF6YRkMjiqJOsuBLCJeiaVVQfFhAvNOctMsjD0jGsSLevwG92S5wfBdp0okkGFZElFiosEDPfCTfZKpsGAFKZwow5P1D2EpwAn6tLIgcMVMgJRp3MB22jC3i7PPwGmry3HNYE6loakkOE+UzyFxF3s6JVw7Ud+YbCj4BSqlu+RtmCaFe8NkaJiJa6nEdQEvVcxDdS8umfphhauCLFfzJYB8Nog1m6JSkZFccNMD/b/H8XFvzv3AAVFcimDtHwPbj2Mv8j3TG2u8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB4382.eurprd04.prod.outlook.com (2603:10a6:803:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 08:47:42 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.019; Thu, 18 Nov 2021
 08:47:42 +0000
Message-ID: <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
Date:   Thu, 18 Nov 2021 09:47:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0379.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::12) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AS9PR06CA0379.eurprd06.prod.outlook.com (2603:10a6:20b:460::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 08:47:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98615384-9711-40b7-97ba-08d9aa70157f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4382:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB43822D3C1F16B096A9984FE7B39B9@VI1PR04MB4382.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfaC0yFCzpEqn0CTFrW7Pu+c47RSzXMbrKxtiA/AIMgktUxP/95EWAZSaZT7yGsWQJ6uSh/UBLSQoWIcc/Vu7Vu7zbhH14QDdPdFxWnKHrrot+8aoYrSA/F0+93wnfbFB4+bxIFO5vZTSOassSFoq3Pi6+MELx/ia8dpF24G8gfv+PnJzhQDSMFkWbmE+kmlT4udy86tBEW7UfB8TCTlQtWULExlFu9DTKjgBlju/pb63/5r5v+4IeQNerquQ6AGYydP/0kCgPy+s6OShAnwMhgQynsZnDwoorm+c8jL1nY5cVJls0KgzJZw8vbZ1h7dqjKlbEmFTn7OhGpDRJvWQS75WJvZc8QPZJM7lCZxuWoLq5RIkHBeVliyGatw4gFFwLBLt9BwYtHVNgjPtHCU6wdFDGX2iEL9DUyecuXc3wHYN0QtM75gcGtIH4s1NesgIjBMD4bRjAjzwgQ47mObPw+S58ArslVjbv4wz9mhZkACA9ZCR0DGBs6xDvVFMlEQPM5hEefQEdE09Ee6PdhmihCTCw1iEoaOojn5gAX3v3AONTW+8G8KTqwvu/RQLkCAOkdrLAw0HLExCohX42bPP4M++OP+0jN3+kd28cm5PPl8lTRNhKrqgLJv5zs+gl94xqFfcOl7y6xWqVJLFqBXgmplcBWbMRXkp6wpzHw9XQSXWqSKSiSKffZNNaTKcw9zZIrTSG0/0N+eBvKE4JDgVsXKXCVOLNBFXXYJXDCqdzb8hUApYw3FZDx9uFYoVep4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(2616005)(956004)(31686004)(86362001)(54906003)(316002)(37006003)(508600001)(6636002)(36756003)(8676002)(31696002)(186003)(2906002)(5660300002)(53546011)(66476007)(4326008)(26005)(8936002)(6862004)(6486002)(66556008)(66946007)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjJ2dElnTk04eEY5UFdyTGU4MGZRczJiS3pZV0w2WnVlVUx5T0lyajdZSHh2?=
 =?utf-8?B?RUZhdytUTnBLUktUVnUwbzJzRVVwYmVWemtaVEFpaFFrV29xWXpPS3NuUFBj?=
 =?utf-8?B?OVB1RUw4MEczdUM1M1VFV01JSm9qd2hFTFp4a05ManFZdTB3OWc5MFcrZ0pC?=
 =?utf-8?B?bzA3Y3ZiaHFiWGV3N2UzSkVSWDNuZ1NnMUZRSHh4TEFkYjVmcTgxeTFNd1pv?=
 =?utf-8?B?RTQ5cmptVE9XQ1QrK1cvMHVjS0VING92aFVIdlU3K3V5b25FZ0hwMytwQyth?=
 =?utf-8?B?cTlnb1RTNkZKbGFMSVp5Q0FHS2ExaURYWWx5ZEs0bG1RWjBSWGtuWlFQS3c2?=
 =?utf-8?B?NUNLTG5NdUZwUGZFbDdWcEszemREeGtWWHc1YjJsWnd0QXRYZ20vYVlJUGpi?=
 =?utf-8?B?eitjVU9vQmo4QWh6eHUzbWI0alRhUE0zZ0oyRUc2VHpxNE5YaUwvbDZhTkky?=
 =?utf-8?B?emgrR29SamZkbTJLSXRqNmlkd1pOWEhBWm5zMU9jeW1TQUtwV0JRUXRKaUN2?=
 =?utf-8?B?NE1JbUxNUzMrNjlyK05jQTZ1b2l1NkZBTktNakRMWWVLRC9nQkUvbHNsQTFV?=
 =?utf-8?B?Wkw3T1E5RkNob1g3THdLY3NxTWlickk1SmlKTWxlYThxWnAvSUljRDdmVHdo?=
 =?utf-8?B?WVcyeU1kUGN1bTl6RnZ0cVpxS090S21yNTAxdU1MOGpsMHdPdm80MWM5ZWhn?=
 =?utf-8?B?SGFkdHNra25naG1oWmhOTXYzbks2VzM4cW95d2tSTjh1czh4VDdSQ21KOUFm?=
 =?utf-8?B?VFlQYWdQVlF0TDlqN3FMWWgrNnBGcHplZHRTRWRLMmE0RTdHMUN3RGR1MlZo?=
 =?utf-8?B?VU5GV0VXa2lwOE5TR1dwVmFIcUNySG9xUDZoZUhzUFBURWtvR3llOGtpYVpy?=
 =?utf-8?B?MWcvaytJU2JVRGRsQUFJRWF5YWtZUjRLWlY4SkR4Tnd6MFhlV0lPTllqa1Y1?=
 =?utf-8?B?VHdqdTMwempHK1ZtaVlabWFKYWdPS1NGME82REQwdDJvWnRwZzRFWEdabjFu?=
 =?utf-8?B?OWd4UDFlS2ZmYTQxNzQyN0k0VEJVdlVwcnJtVDFKUFVlWmlvVE5KRzBqcm5T?=
 =?utf-8?B?enI4ZFNhbWFWS0pMd29uakZkb3lzeHlaT1pVb2ZvQStXMzdVOEMxcStjQ05y?=
 =?utf-8?B?cUx4V3dTcEwwbCtrYnFpN1hFYXRtSUZkaC96a0sxc2pDZjZVSEI3dzdaaWlp?=
 =?utf-8?B?UHZCT0xEVjFOZjc3RzI3SnJ3YW5BclhSUTAwaXJuV3orRTlKbEZ2dWt4WEli?=
 =?utf-8?B?b2VnOGdYQUJKNzhBcTZJbWh1cVNzcHNSendiTGJVNDg0QkoyVE1mWUVhdENS?=
 =?utf-8?B?Vm1TQml3cUwwN0x1aS9ZY1B1OTNQVHQ0Tkh0L3pGMGpFTVJJcnM2ZjZVVnpy?=
 =?utf-8?B?NlA3Q051R0tpTTMrWWQrZXU1Ky92N2dIcjc4Rk96WDVTN0NaRXJSSEdlVStH?=
 =?utf-8?B?N3l3cG5VeTRUeGllVURXVTB6SzlMRXZSWEwreFN6dXBKK3lRekhXenpUbHdK?=
 =?utf-8?B?TngwblhSTkpLRmVJdUJla3h5Z3oxQUF5aEMvZkZOT010Vld6b2FRdlUweDZN?=
 =?utf-8?B?THhhYk1VTHdGdGljREtIU09UUE0xL2psUFgyMm9RQ0VDb0RuVnhWKzhHZGp1?=
 =?utf-8?B?eUNmcGNXM0FGNjRMT2l0TFBaY1poYkJaWmxlY3lEZS9vcmMxUXZDbGZBMTNi?=
 =?utf-8?B?QmtJTTdBM0xRQkpsUmxqMlp6S2NHelVqOTlWdEhwRWZoVjBscDU2WThjdWVl?=
 =?utf-8?B?cUxwTFA5K1cwSTRSR2Z6V3o2UjdQbkFCbDFnMERFQXJ2Tm1WeUQ0SnBPSVlt?=
 =?utf-8?B?ZTJVQjlUcUNaRmcxOU1wSkxqa0VEMVhxakJ0dVNOZktlQnVsSU51UDBRK0dB?=
 =?utf-8?B?bXZuMFpTYklJaW4wSjZMdGhVT2g3aTUycHRBTnpwcEFxR0VHZkFiVWgrMHV5?=
 =?utf-8?B?QW9HaVBrSE5hRVBGcm5UY1ZobWFkSDFOZFJWR2xYVzhuUnlVb0VqZjhaSFIv?=
 =?utf-8?B?QmxkV3Q4em9EelRROVFRUWpUbTQyQXdTeHNnWVV4azVVdWxQL3dGdmdTMTc1?=
 =?utf-8?B?TGtCSlJjUTNEUGtEYk9OaGwwMEk3SU1JRWlLcks1TDNjV1pRdXQzSE13dkph?=
 =?utf-8?B?S1QreEI5SHByeXI2NUtZODlnMkhaZFNoSlAyanpQemF1bUdnclgraEQxZlNv?=
 =?utf-8?Q?4K9qwkXE3TG+tYIzopqLkQU=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98615384-9711-40b7-97ba-08d9aa70157f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 08:47:42.4297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UG9Wk6pItAaaLU9iv3+KOvK38P/0dlt5hDKKhvuVC1fv5Z0zsHfdwWW8Z6AcyM4HWcw8uQRnoIVZFDXSA/KsHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4382
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.11.2021 06:32, Juergen Gross wrote:
> On 18.11.21 03:37, Stefano Stabellini wrote:
>> --- a/drivers/xen/xenbus/xenbus_probe.c
>> +++ b/drivers/xen/xenbus/xenbus_probe.c
>> @@ -951,6 +951,28 @@ static int __init xenbus_init(void)
>>   		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>>   		if (err)
>>   			goto out_error;
>> +		/*
>> +		 * Return error on an invalid value.
>> +		 *
>> +		 * Uninitialized hvm_params are zero and return no error.
>> +		 * Although it is theoretically possible to have
>> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
>> +		 * not zero when valid. If zero, it means that Xenstore hasn't
>> +		 * been properly initialized. Instead of attempting to map a
>> +		 * wrong guest physical address return error.
>> +		 */
>> +		if (v == 0) {
> 
> Make this "if (v == ULONG_MAX || v== 0)" instead?
> This would result in the same err on a new and an old hypervisor
> (assuming we switch the hypervisor to init params with ~0UL).
> 
>> +			err = -ENOENT;
>> +			goto out_error;
>> +		}
>> +		/*
>> +		 * ULONG_MAX is invalid on 64-bit because is INVALID_PFN.
>> +		 * On 32-bit return error to avoid truncation.
>> +		 */
>> +		if (v >= ULONG_MAX) {
>> +			err = -EINVAL;
>> +			goto out_error;
>> +		}
> 
> Does it make sense to continue the system running in case of
> truncation? This would be a 32-bit guest with more than 16TB of RAM
> and the Xen tools decided to place the Xenstore ring page above the
> 16TB boundary. This is a completely insane scenario IMO.
> 
> A proper panic() in this case would make diagnosis of that much
> easier (me having doubts that this will ever be hit, though).

While I agree panic() may be an option here (albeit I'm not sure why
that would be better than trying to cope with 0 and hence without
xenbus), I'd like to point out that the amount of RAM assigned to a
guest is unrelated to the choice of GFNs for the various "magic"
items.

Jan

