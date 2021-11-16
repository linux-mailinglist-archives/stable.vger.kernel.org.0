Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0E452C16
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 08:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhKPHr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 02:47:56 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:21573 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhKPHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 02:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637048696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GQsKGv0HALlMmhe4QU/b961BXx1Qzpd9vBXfpctLga4=;
        b=jK8Dlm0mFRfwd7ClviOGcjZ7+PuvkPGBfA/U86W44kKeKLXhgv+9NECaYur86UPPW5L5xq
        g583G75nbhkCAg051qoy/Eu2boX70r1yi3RUf2HKvNpeBMeCgTYXGeo7nd6wLzko+Ydp4/
        sxjw9vTq6qVKqrAaOk7bLLV7fLFTmtk=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-6jLDyKaiNXSz8bPDntMZmw-1; Tue, 16 Nov 2021 08:44:54 +0100
X-MC-Unique: 6jLDyKaiNXSz8bPDntMZmw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvthTJ/szIRW8n5AE6FusWDewALxLjuW/ki7/mIOR2qtNON5E013EvJ2Qlp5XZIjDYuykYDmY9HFt6ORAcA5tOmh6sW+EDQFHSX0V0Noq87PbV0DWb3HauDzpP6U+g2LN6+SXIZ9abxdaaenDgvgpDWpR097Se8iQRsU+wPcYNZoJyr5ZnS4dV63i4pAGBiivZkgOn6nXIHMWTXlehcYLpsYfLR6fzC9+tn191TuahBNR1ZKQJFfQftrYtVzYNHk/cBpqpCXSOdo4y8iZ8F3t+OLcw7bo7o6SkSuV0fi84IwqO3AvQMECcxZVkp17vCTTkADMmWu7drHTSX8DdPs5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQsKGv0HALlMmhe4QU/b961BXx1Qzpd9vBXfpctLga4=;
 b=NmXrxvfCZiQPYaMIguu4UNUp4B1v7Edmg3pYXEPpZWj7yGUlazaGrv7sgmprgfkc0r6olgs8j2bdkxiBWebp21gkwR+0d+NTgm436PQiND+85D5y1JcV7liG0mZvovLoIMpJ+U0KzaonLvtJkGCi48Tn3FWW8DFSU5IqRa4+LEAl6T7lAfzvZ/Urxvt91Z/H0bE2XZ4wD75VHVXPL2SCseI+f43t1UsvOvCyg0sye6TW+3RrEL4WXdaHGfGQiyCddLcGS3NM0mLBrmsDInHlo711LlyR+t+pHsj/SJmpzj2BSiYszptMgrU0XdksjYihhg1MAgTqS5xwzyjF5kgQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB7152.eurprd04.prod.outlook.com (2603:10a6:800:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 07:44:53 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 07:44:53 +0000
Message-ID: <29e1ea87-c2e3-f8b1-b843-a390ad280984@suse.com>
Date:   Tue, 16 Nov 2021 08:44:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] xen: don't continue xenstore initialization in case of
 errors
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org, jgross@suse.com
References: <20211115222719.2558207-1-sstabellini@kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20211115222719.2558207-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0003.eurprd06.prod.outlook.com
 (2603:10a6:20b:462::9) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AS9PR06CA0003.eurprd06.prod.outlook.com (2603:10a6:20b:462::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 07:44:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc90014e-f7ee-4ad0-5e3e-08d9a8d4fa4c
X-MS-TrafficTypeDiagnostic: VI1PR04MB7152:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB7152CB46C4987133A8DE2253B3999@VI1PR04MB7152.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 549VKNUUX9Nez7nfdOoOy8gJS66b0QXimTmGfipRhOlOHRADOdyoiLTUgosheiqMY7Zt27jx8WYlFTz7eu81nfoGcOuyh1t7RIjLfPWQ7gydIfahgCpuwgfzOT3VJymFzcak1pJBW3Ggp68kxBCV1QOtuuyxfdhBsxXbMXHwV19f3iUUNwTWHdqGy1zMuBdkytsei9Ght00s+SFMXghG+/IjavLGu/AoSJN+lRBsvLHrjxFKncp4SNvZwtWhRCjeSGOYQnhC+ywYccUIJffw2Khdfro3I3QxwQkwlbUK5CbyJkXXvaJ554qt2ht3acDC38IM+0SCXxmW27HAutG3pZZqoAs9VpqDp7t85Ze7kszz8TpuhY/1Rr9ctDCQlb66TQSwk26whaPIdTbbWKh9bNid8lHLGDca8j+b8Lwnn7P/TO++WE5oOaCLAow9J/HRlK8++KmOY5vifF3+oOK4mhTFtVG0IlZRXrRjnYI13JljrEVoYpUVgtqTyb4Ptgem5JM2XHqSLII9LveKN97QEMpbgHmRPYc1VX8ladmiwUMH6XDQKiQn86kKTvedE888G/CsuIH+TrF/iCw+oVhwKbyR7h5+t4p5cRz5XgEzxr/nM46FFcEG8TxRrG7l1PmYuV1GqAYkbQJ4HIHh49vR2e4f9htY+HU5WDrRZTDUretm/2mZBw0SHbztGiKpnnw37idek3VGzEu2cGIrY119I9l79aJG3eZ4RBpk6hx8dTb1Sf2Od7zkgrk6yQguujkj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(8676002)(31686004)(66556008)(8936002)(38100700002)(6916009)(86362001)(5660300002)(956004)(2616005)(4326008)(36756003)(2906002)(26005)(66476007)(6486002)(186003)(66946007)(508600001)(107886003)(31696002)(316002)(83380400001)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFJFV2xHNWdrekJqZFFQV0pnS2RJT0piNktuS0FoS2dEclMzMG1ObFdaaDF0?=
 =?utf-8?B?dTN3L09VWTYycVY2THNieUk5STd4ZkU1YjBIbllmQlgzdlFLa051bGIzTVpG?=
 =?utf-8?B?TFBuQVE5OUtheFROODV2SXFEbS9ENVpsKzgyemcyNHJlN3lCV2RLd0NPK0J2?=
 =?utf-8?B?eEF5MlVRczRPYURJUlVYWU9BVUJHbmNIK1VLSkViNUFJd3BKL0lkRkMwVHlh?=
 =?utf-8?B?VG13czJ5UXNDUGFWRDdpR1BDWkRIQy9nU3lqaWJvQ2FpUitGWFJXWlJtTmdP?=
 =?utf-8?B?TDBEU2hMR1RWdDg3T1Z3b2JFYkpTZ0NIUnN3OWMxNCsyU1FMbTFtZ2tJVFVP?=
 =?utf-8?B?VGlKcGNKVkdBTTJIYVpFQVVlODdKNXY5aklXcWJORC95SW9IK1JUY21xcjRO?=
 =?utf-8?B?RGVxSHA5aEFoQUgrZ01aRW5sZDFnNm55bVlDanVpTkE1OUc4aWVUSWt6SUlG?=
 =?utf-8?B?M0JLRW9QRWs4OXMrek9RSVltSXg1b3FvT01hbkRweVpnRCs1RkJGTzBGUE9a?=
 =?utf-8?B?NW1xMldBQ1RLUmJOT2FnZXZuN1VJUCtEZytuUERtM1hIeG1VL3ZtSUUraXpi?=
 =?utf-8?B?NXM4RmVTK1VLVnYvaXpuaG9HbnNGSDErSG83eTVSUzQzZW5wNXpuSlUvbzlG?=
 =?utf-8?B?a0NMR0QwRjk2cmRxb3lmZnppYmIvUlhHRk9EQnNmRXBEc1BvM1dWa1dUVTJt?=
 =?utf-8?B?S2RENlhDcVdFN2xyVzRMcFk3c29aWWNpY2thS0hrNEk4YlM2SlpBdmV6NzNo?=
 =?utf-8?B?MzdYM05YelZKNjZ0K0hPbHdSUzd5dnF1VnppQ1F3ZDVSRzYwbDJYR3VCbTBL?=
 =?utf-8?B?bWZiQTBmYXNTNCs3bFMvTGNYK1pVdEdXZjhBMTRGVStvVWVYQ1N3L3dPaUhx?=
 =?utf-8?B?Tmc4bFgwQmpZYVJQdE93cXZ5dnVQSFJJaUprcW4xa1BjeVBxSGRRek5qbHBC?=
 =?utf-8?B?eC93WG55Q2hrR1loSDR0eUJkZERsVXh6Qkx6dzhjWUtSVkVVeENpd0l6TjZi?=
 =?utf-8?B?OXJjendMKzhYVk5Zb0Uzd1hjaW5tSHBVU00ySjNrMVpwRTcxUFNMaWN1VXBq?=
 =?utf-8?B?dHFVOFViL09zK2pTbnBuMTdjbEVxb0FKNTRSWHpiNVJsQkV6OFFRZUdSQjVQ?=
 =?utf-8?B?a3h4dytFM1VrNDFjZ1Z1REREZ1hRZ0NNT2ltRUdET1RLUUdYZk1sUDhxSVR1?=
 =?utf-8?B?Q084czc2NitUSzVSMytmQUt0eGNvSDB1T1dVbDlXZkcwOU4xV2hiR28xc1BK?=
 =?utf-8?B?UTNCK1lVR2Q1QTJmRnhXTnJmaFF4RUlZYzA3cDltL0d4UnFjTHp5aklnT3FT?=
 =?utf-8?B?Ukd5dFgyWlZlS0YxVVFqWFgyNkcweEtnVUJWTm5vaC9Fa09SSVZicG5GcmNJ?=
 =?utf-8?B?SEZiNy9mOFBEZ3RKM0o1aFV6dGtmZTY1MlF5OCtWdnIraVM0UHFqaytFbDhE?=
 =?utf-8?B?V1YzRXR0bGZiWDgrY09oYmFlaHZTWlRjT1JJeDVEWXZCY3J1QzkwSk5KaGZE?=
 =?utf-8?B?NlM4RTBnYThxVHQxUk1QdmpkVTUrd3lQd0ZkdjdGODJWY0dYYjNEOWlkR0xT?=
 =?utf-8?B?T0hRZEM4S1dpejQwTVFJUlgrRTQxbXErM1BCN3lrdTlmWURCamh2U1QrOVZl?=
 =?utf-8?B?RVdrNTFiM3pvM0J6MTNreHBmNnNuenNKN2w3WlZSbDV6SXR4QklRQW96N2Q3?=
 =?utf-8?B?dnErS2tXczNmWEdUMWtPOXFPWWRZUFpRemtZU2VtNm8vZit0N3AwVU9aR0tO?=
 =?utf-8?B?T3NNdU1hdGRzQ0g5Z0VMekJXU29naytvTm1EOGNKcFdGMlBWbnJvK2JEMWFZ?=
 =?utf-8?B?Nm16MTZ2SEFWZnU4QWlKaGwwUjNCZTJWL0RxdXRta1ludm5lM3BZZVBEWkYy?=
 =?utf-8?B?NmdHRDYxZm9SZm8xbDJHVUtnMU00U2JIc2JQSHcxZHkvNEFaYXFHZEFKakNr?=
 =?utf-8?B?SXFlVjBYSHptbWd0aFhrNERmMy93TGlHR1FyYmtBUDZrMzFoR2dlYUZ4TFAv?=
 =?utf-8?B?ekUrMWRCWW45ekhYbzFCb2x2ZExzUUxzNDVBK0pzRENNVG1uTy90NEk5YjIy?=
 =?utf-8?B?cEh3N3l4NC9IcFgxK1ltL3ZnSGNuRUJ6bUZCVGd0YmZoOENkRnByczhTUVVO?=
 =?utf-8?B?ZHFObldyS1JsSnNTc0wyc3ZzeTV1MVRuYlplVVQyZ3AzTDh6ZnkvMS9TK2FP?=
 =?utf-8?Q?3tJoz5QJYzUNdzyD5q0A9cA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc90014e-f7ee-4ad0-5e3e-08d9a8d4fa4c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 07:44:53.6986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXK+fEfnNGelC7wqM+1teV5BHSRR6x7oaKVNyp08N9xEoO2rvoDuNNAWuTGIs8CZvlOgFPEbWks9HUwzfvL+4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7152
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.11.2021 23:27, Stefano Stabellini wrote:
> From: Stefano Stabellini <stefano.stabellini@xilinx.com>
> 
> In case of errors in xenbus_init (e.g. missing xen_store_gfn parameter),
> we goto out_error but we forget to reset xen_store_domain_type to
> XS_UNKNOWN. As a consequence xenbus_probe_initcall and other initcalls
> will still try to initialize xenstore resulting into a crash at boot.
> 
> [    2.479830] Call trace:
> [    2.482314]  xb_init_comms+0x18/0x150
> [    2.486354]  xs_init+0x34/0x138
> [    2.489786]  xenbus_probe+0x4c/0x70
> [    2.498432]  xenbus_probe_initcall+0x2c/0x7c
> [    2.503944]  do_one_initcall+0x54/0x1b8
> [    2.507358]  kernel_init_freeable+0x1ac/0x210
> [    2.511617]  kernel_init+0x28/0x130
> [    2.516112]  ret_from_fork+0x10/0x20
> 
> Cc: <Stable@vger.kernel.org>
> Cc: jbeulich@suse.com
> Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>

For the immediate purpose as described this looks okay, so
Reviewed-by: Jan Beulich <jbeulich@suse.com>

However, aren't there further pieces missing on this error patch:
- clearing of xenstored_ready in case it got set,
- rolling back xenstored_local_init() (XS_LOCAL) and xen_remap()
  (XS_HVM).
And shouldn't xs_init() failure when called from xenbus_probe()
also result in the driver not giving the appearance of being usable?

> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -909,7 +909,7 @@ static struct notifier_block xenbus_resume_nb = {
>  
>  static int __init xenbus_init(void)
>  {
> -	int err = 0;
> +	int err;
>  	uint64_t v = 0;
>  	xen_store_domain_type = XS_UNKNOWN;
>  

Minor remark: You may want to take the opportunity and add the
missing blank line here to visually separate the assignment from
the declarations.

Jan

