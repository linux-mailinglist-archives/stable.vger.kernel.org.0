Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E545A458A38
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 08:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhKVIAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 03:00:46 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:55849 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238863AbhKVIAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 03:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637567857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSrjxTO3Zk74IiA4WrlnuH/o0Q/G0RuOQGIcY/f0Tro=;
        b=AgOkzMsJAUUCdIJEUPiuK6TvvcsKqxBUTFVtGGoIcZHHR3LzhsoZBuh6riCkI1pXe2kU+J
        pklQQ7itIiCjck8JVFKxqr7nMAoG0e34VQwjS0Xt4PMk227P3UsY2d1P2gzUvmgyJg3QCc
        CXmUJt5kuJZeB4cn8htmHgY7RrePXWg=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-zDR-jhd6N-OrsXoQf-f41w-1; Mon, 22 Nov 2021 08:57:36 +0100
X-MC-Unique: zDR-jhd6N-OrsXoQf-f41w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqsjxoFRlLtJu4jSpKEgyWitRybWozri5RixnDRQ62E55Tsfz0uuWy6CiaRrdB4tcw/q+Ia9UYEqP7Rpvl7x+gy1NHxZx+hoZGja0+vaq7SosChP95eK36OYJ5mQnf+3YiUVItrFe/3tAZA6jHEVyX211Fw0ooFuLWbCEJBgqfHENVKyt4yU9S6m6EHy1UkGYJp6h6DQceYNKSD+9WyuGOV2j7AdErRrDPxoU3s9jlgX6KiMRy0TeFoNt2A7xFJiYQIwz8nLTpZXXR8EMaN1PxvuwFlhYO3oIT0EaqjLVkZxuhqLf8h3WkTmyyL/QPuZWiyLuxsUls/UExCe1/qFVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSrjxTO3Zk74IiA4WrlnuH/o0Q/G0RuOQGIcY/f0Tro=;
 b=jCgz70GQtqZuF1U3NHS6KNGkBpuCrTS8ZH+rCv5QU70tW6gDXVicrLh/pCaqxc1VkVfqIEjA/+cvctWlObpRNbdM0qg8rdBDexM78Q2bgQkzaeMFc9ji5mxDrRvj6JHdJMImSrJJoXlWfG3fvlXnx0e9MaBJX/7sZHBuVn/WhSqm2tl/Y5o+JBpZNNE8Myl5v/JFJjn+QCfNZMcjyWnKTe943B85UOP0iGtPnc6ruri3kRSM+gjyBSgCDsff1GS92OpJHcfztIRyaC4deatmfihXst+XgckBZZLrNJHfgIgZhxTlOz2onSF4hBN6U++FpBIcFUNWDfLmJmjOI3rXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VE1PR04MB6383.eurprd04.prod.outlook.com (2603:10a6:803:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Mon, 22 Nov
 2021 07:57:33 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 07:57:33 +0000
Message-ID: <bc47bbe2-b330-7744-8d6b-869e3c7523e4@suse.com>
Date:   Mon, 22 Nov 2021 08:57:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, jgross@suse.com
References: <20211119202951.403525-1-sstabellini@kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20211119202951.403525-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0176.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::31) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [IPV6:2003:ca:b712:7ba9:201a:362a:8f72:2ea6] (2003:ca:b712:7ba9:201a:362a:8f72:2ea6) by AS8PR04CA0176.eurprd04.prod.outlook.com (2603:10a6:20b:331::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 07:57:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce01e611-baa2-4c54-8d3e-08d9ad8dbdb4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6383:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VE1PR04MB63838CB521C558E8400D8CA9B39F9@VE1PR04MB6383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdmSD8ZE3t+1ES8WYmq1FxEkjGQOXMUfECDoc3DrxGKfq3A5ilfTzmZmYwJNrCRDd57Dy1Ms0FaDjEqHGvXtZrmvKfXmrBlRlhOWBnqf+K1vN5xdskHcLlIXdCR7ItfSLMjMCGrFMEeyO2ByhQBrXz12AWpxzI9CxrQdq5WIa8rn+Eajga9tGmSr5dXjsypZQMC9g8O3ix/vQ3IKRjp3ho7mdV1g1F5BbfWRERbhJrD8zbn0F3AvgYZCjZ/zs87N/7YoGDnsDN+48kal2FMTBrDWqxv3MqAeylINptqUSlBuDj5+F6Ldsu3bdHamfJDrruXFp8GhUT6NP4ZcGe9nuP6WxPw4mE77r/+ou4Q7HQrdb1VEl6+/gJ2s9VeG9xDGCZrEPpzdJNbH+/SrEQUD+CGiaczXxxuVGCpkvmJo2k/1EPLy89xh7RE8+/fbXebJ6cGPjcqEEy8Xc3sWdf4hHeKCzq3IovBMjtAH4DdRucuwJv8H1COgf1nndGS/FD7IfAE8f7sz1b9sZnBLIeJ3RO4NUwd8hI7JUXQa7PcechHK+v2cO2Rq+DrgRxYhl6RG3LLZTLexd8ua8gtgvUlr3Pjf0QmvudYspqVIadDNxsQLygEHM7bgoQndB+BhDP52V3p+gPLfazrV2POEPc5JjyTTwGXGvsmQFLwRbFh+eLX9yOa38aVGQAit6KI9qm5B4a2vHV+w5cwYlD0f+VaY/MzgiJAtS0CUn8gI05H1u9qwf6g2tFz4RHwxYSfnfFzu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(8676002)(5660300002)(107886003)(31696002)(66556008)(53546011)(38100700002)(36756003)(8936002)(316002)(6486002)(31686004)(2616005)(66946007)(66476007)(86362001)(83380400001)(6916009)(508600001)(4744005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0pPRDJjV1NtcEdvUStnR1VWUi9jSnQvRVVkYkpEMU9UcEprU2kreWxFR080?=
 =?utf-8?B?c09ITk9MYmtmWnhBU3E3aWRXeWZIT3lPckMyM3R2akdZdEZxV3VsMWJ4TEFR?=
 =?utf-8?B?MDRtUHM0Y1RxTUxSbElDMEY3TU5CQ2dvanBiTGhSMzhOa3dDa2wweGZiVjVW?=
 =?utf-8?B?a3FIUmNMQmtKM3duMVVqa0tpNlIrbTV5cGd5MnFhSHBiYXRVSnN4djFLUHRv?=
 =?utf-8?B?eXV6ck12NXJxLzFkeGtuQlYrc3A2Q200aDhiSHdKNFNJWVhhL1VmNW9HMDVF?=
 =?utf-8?B?TngvODFQT0NuRVY1Ym9qUkZWM1M4Q0FCSTJoSHNTV1Jma0RpTmZmcEFEaTVH?=
 =?utf-8?B?NHYwQ0VRVjNEalFZd1ZiNWtGbk81S09LU0F4K1VyS2lPU2lQVm9yTktzT1dZ?=
 =?utf-8?B?azd0TjZzU051VTIyVkFnN2hSS1NrR3lNbHZHL0EwRUZxbVQ3alEzaTVDTXFG?=
 =?utf-8?B?Uy9qa0ptRHR4Y2V0dTNRNDdiQWhKWDVzbWdIOUdMRFV3ODB6YitoVzhCOEhR?=
 =?utf-8?B?RzU3cUQreXAvYTh4b1RYblBCRlYramkwQWc2T1cxMG5RQW1YVGpxYklMaHFC?=
 =?utf-8?B?UkljdnljcDV6Qi93aEh3VHlYUHZpOW9tY2xaSjJxZzNBeXdTU3ZVK2U0bGpj?=
 =?utf-8?B?UmFJZ3V0UWVXdFFFV282d3lPQmV4d1kya1dKcmIxSi9ha1B3MldOaEhwbHRL?=
 =?utf-8?B?amI2OE4rdnJiQ0xISFpNSTFrZ01vbWlhRGl4Ui90bmphSE1oM2ZDRFQ5MzVW?=
 =?utf-8?B?MS9pZVhubHlkK2sxVFJnYm0zdDRmYkZ6amxhMnJjS2xrQXpEZ3VKK3h4Q08y?=
 =?utf-8?B?TlRDM0l2RHB4d0dUMUdoUDVENlR0YldRWnhZQjFDVGRncmNKWjJheS9OMlJ4?=
 =?utf-8?B?N0JKeE81VjdZV25JYk1ONW5nTi8xQlFvTUdpTjE2MUZtTlVRQ0NLQ29qMmlh?=
 =?utf-8?B?ejFmalJuSzJBYkMzeVdVVWd2RUgwUHY5eHR1U2tJRU1HQ0dmajYwby9XU3lF?=
 =?utf-8?B?eEhGQnAzcWM4anYzUE83eVhvZmlxU3BEQWx1bjNjRXpTRW5xV05iTGh6aU5n?=
 =?utf-8?B?Y1dzS00waXhwTEtla0RXL09hNnJ0VTIzTG9hQk95VlZ1Wkc2SjJrUitMRnda?=
 =?utf-8?B?aEhnSlQ5Y09tWjVHclVvNXU4ZnhDMko3TDIvUG5kc2hiWitnMEV0VDVtdkF5?=
 =?utf-8?B?YmVENzBPdHNqY09HWG1xNUEzSTFGN1ducnJvVHF3M1g4cXEyQjRTVUVNMUFR?=
 =?utf-8?B?U2dHSEx4dDkrR0duMmZUOUpQUFJNSi9BT210Nm9uNElZZ3h4TTI3bDNKMGt6?=
 =?utf-8?B?NTBzUUtrTVpXcTd0YnEyWWM2aVFLK1N0TFJUR0dhRnROSmtOUmh0OTU4SU5J?=
 =?utf-8?B?NWZHR2pPVkJCT1hmUHo4MHVBMTBvc251UjMxUHdOeW45MTYxSWdxN0FkdHox?=
 =?utf-8?B?TGh2aDMyQmhXYTBqSEtvY3VsY1BWcjNVTy9CMEEvV1gvZlN3VnlBN2V2b3d4?=
 =?utf-8?B?SWpBQlZHTzNXYU8wenJhQTF3MlMyQnNKTmloOHkrNnpGbzFrMmtLK0JEZVlk?=
 =?utf-8?B?Y3Z1dU5TM0FhMitOWTFqcVF4V1JybkxMbVNXWWVzRWxldmtTM1ZwN2FuVGtF?=
 =?utf-8?B?bnN2eHRZVURRUW9IY0dGZkpNSExQTTg4L1Y1cUt1TVIvb2J4cit6dllJbUZw?=
 =?utf-8?B?R2FZU2FvaTdmd3pRNitDZ2poSEJKc1VIR1RxdXFlT1ArZHJzdm9jdUUyOWU2?=
 =?utf-8?B?N295Zmp2OUc5WHdFNXJNc1FHRC8xUzd4M0FJOXBBZWx3WlRFcVhaM2lCTjRj?=
 =?utf-8?B?L05pRmZFQlVSMnduZllhTWQ3YVV3UTllZGV0NFV3QTk4V0E0bzhZN2FhalNK?=
 =?utf-8?B?eG1KU2x3endZMHFkNHplNHMyS0piT2pVa1k1S3BlcGhZb3hlZ0FjMTN5eGti?=
 =?utf-8?B?YWkvWU9PZm43emhDZS9XaEg1WU5YdlhkUXo3Vm5ZaGJiN2hTM3V0UGhFNm8r?=
 =?utf-8?B?TmdKVmtZNDJ6dzN6T2VtZitIQklvMUFqelgxQWZtcjlwSk1uL2JuMUxCVFA3?=
 =?utf-8?B?WjNiRkJXUjhsd3NldGErbkdjMlRMSHhxdzlNVXZHbE1LaTNIdnJ4dWVLbVpl?=
 =?utf-8?B?OVR1Nmh0aG1YSEJYMGFsS0Q4Q2d6Vm01M0ZnSklOdFh2eTV5Y04vTW5WZlAz?=
 =?utf-8?B?OFB1Y1hXa3FDcDBvOFRPcEpmQmR5N2RzZEJSZ3cxVyt0STR2SUMzbWtpZjdm?=
 =?utf-8?Q?+bW+VYKM1pyhIAMulOQot91l2G5Hm7hw++A8hh9IPA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce01e611-baa2-4c54-8d3e-08d9ad8dbdb4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 07:57:33.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/gh0m98UAzlJOFPJrVDp5mtE+RfoiXfJqOvLpObK2UujR/Zs69LlbbmmNo2187bwg8+M65CGWXjZ29EYblaug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6383
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.11.2021 21:29, Stefano Stabellini wrote:
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -951,6 +951,20 @@ static int __init xenbus_init(void)
>  		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>  		if (err)
>  			goto out_error;
> +		/* Uninitialized. */
> +		if (v == 0 || v == ULLONG_MAX) {

Didn't you have a comment in v1 here regarding the check against 0? Or was that
just like now only in the description? IOW I think there ought to be a code
comment justifying the theoretically wrong check ...

Also, while I realize there are various other similar assumptions elsewhere, I
would generally recommend to avoid such: There's no guarantee that now and
forever unsigned long long and uint64_t are the same thing. And it's easy in
cases like this one:

		if (!v || !(v + 1)) {

Jan

