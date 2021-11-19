Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63612456B98
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 09:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhKSI1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 03:27:24 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:20766 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234226AbhKSI1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 03:27:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637310261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=flmX9PFhQZs53xscWkDSqgKIyEAwpQZmabzx+s9Uz58=;
        b=Qu+F2MTVJW46WFL2175bMjJUkZoUjVBVndjrUGEUeP7B9IbHhNb94jUdzY7tCA+NBHrv0s
        XkVRtJl+EPgmib3021TejkLLUmTQAJlnZSEhkbfylsxhh83gbpe+kWXFw5j0dbc2qVf7lz
        hXsg14GhkZ0c1PmMZ53L8YyKXLUEWGc=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-mon7UZqdMJ6BW8djFTm3Dg-1; Fri, 19 Nov 2021 09:24:20 +0100
X-MC-Unique: mon7UZqdMJ6BW8djFTm3Dg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdDdY7pqUei2F7/o6ys8IghU6gytgfUFDzFJOjZatPMMzgv27Pzms7oQEdnib4UEHaPf1+JzloH+m9pbgSrInE5EoKOv/tjCwhUBmrUzyCG7zUumibxnL2u9dR25oDsyVqchnWI4QwjvROjFfeXd1Wtb2fixwlIbMAmKD7XISFWW5LH87BtAa09BDnWxrtOTgSUPrcizFZuwU35dsQBmCHMSv2QPnuk/K4DrZOfVKJrlIElyelaeooopH49pptc7+ZEx6WQukdud+nPMjZtGwQOAUdN/xGdHBW8A5NUR1KSi6X8Va5ZLlmvb8ek1RIcE3oPrK/zpQD/Dmn+iSH5W2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flmX9PFhQZs53xscWkDSqgKIyEAwpQZmabzx+s9Uz58=;
 b=j3LG7Dl+38wNYp1XUgO1MjhGN8/MAm5Tvd1fydoVES89gxEioCDHtATbgkLHQXMPRIiCZbMmP9in+dgQFyxl5Z5Zlolv0rEjNc6oa/f+YmjgClzrGrQdtcn2GsCa429ATxnS9nA581OaAEQPxiA4KrnRkj2Pc81wFgVlzobo5eVLiI2kZhcbTvcQVUsbX2QRoJfCgNxH7h/ysyd9i7Xi9A3tlskn53xgw2e76J8oSdf7ZUvxzPUoqpBKf2XJWll+9Xr7nM8gTZn6yWVXmGtaWIMli8OVBugZm0NxvgBWZdf48u6RN3dSX5GohgJVak0/IhClfWAPCGqs1Fua5m6yEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0401MB2605.eurprd04.prod.outlook.com (2603:10a6:800:57::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 19 Nov
 2021 08:24:17 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 08:24:17 +0000
Message-ID: <79a85431-a505-795d-1e72-76628df987af@suse.com>
Date:   Fri, 19 Nov 2021 09:24:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>
References: <20211117021145.3105042-1-sstabellini@kernel.org>
 <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
 <alpine.DEB.2.22.394.2111171823160.1412361@ubuntu-linux-20-04-desktop>
 <44403efe-a850-b53b-785f-6f5c73eb2b96@suse.com>
 <9453672e-56ea-71cd-cdd2-b4aaafb8db56@suse.com>
 <b0cd6af9-66c4-3a73-734a-3a51d052fac2@suse.com>
 <alpine.DEB.2.22.394.2111181226460.1412361@ubuntu-linux-20-04-desktop>
 <fdfe4ba4-8f5f-47a2-98df-3dfdb50d8f6f@oracle.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <fdfe4ba4-8f5f-47a2-98df-3dfdb50d8f6f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0053.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::30) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AM6PR10CA0053.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 08:24:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e084f8d5-e7f3-4b0d-6c34-08d9ab35fa93
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2605:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26058AA559D64214A5B5A69EB39C9@VI1PR0401MB2605.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKyRmn4zLbZREv6yIrEdcTLiSuEVvyCsW1qcl5DJ4Jy25Iv5jgWgZAdCxf6VreUy8Sw0SxCmeEgtKrLAVah+VtHYRW2eaixW6kfLjjrzgoRm5/1jY0Q4j+gRTT54gDGh/stMd8VsKII44gDZ2jkr5ENbYHZqMuPkSd/cB5W6uZ/ThuIiH2+xsz1o77sh5dNIYBBa6Mw57uHyddu6hUqXJRbfgXNqEmjxZrRuNvRytM8J42iNhqhClPDuMpEK/ZSFXPFjAbF6ameZMrsIOu5HlNcKiV7IiunHb/k/KOpcPGpotDuPkZKS7g5VCY0261de+BQ23r4uHywbH0ng36VoFg2Bm/JsxhqHhjLJa9IbUmpzF7+qU3ELBAbyop3YZ6zG7x3cqTJFIEdH6RfbRK+WW84P9o8eKB539QcZzHwLsXUzzH3mmHi0jSCuNu3crLjHP9XB82TfvW7hbwX6+bfwHXubG2opqvfhtH52I8gf5qnaXSvnLj4r0BpBJWyYkBr3nzxG6LPf3AL0TgLkPMcdmdRFXGkjgkxZbnd2pk0APmxdasIH1fwO3beSpx+O/LBeA3NldpNmjtdQJ57xucxzlPAW5T+bN7edhHRz03yOBlg8PjBcAHNrE/W8F9xXQJPgHqe9sCwcsH6vmvMuw9S0Uy14GV9Hx6DmI0uEk9HhlPrj8o5XlXVybg/9ZRrOAr63cNAT0uAdPiq9LUu8EIYBKM/KFFXTx7wlc9mnjsG3YyY/YptLY54frmWh3G0Z/uyF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(110136005)(2616005)(66946007)(316002)(31686004)(8676002)(36756003)(508600001)(5660300002)(16576012)(26005)(4326008)(6486002)(38100700002)(956004)(53546011)(86362001)(2906002)(186003)(4744005)(8936002)(66556008)(66476007)(107886003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVhLOE5ycmxnNmd1eVhUa2lhYlZTVms3Z1lBNlI0UXdzK2dldFZraExLaUl6?=
 =?utf-8?B?ZlhrQjdWZVVSM0NOb0J2elp0SEhyTzFKWThqSktKMzQ5NEx1ZkNGNTJ6WThu?=
 =?utf-8?B?R1lZTEhqRXpQOGZIampTSFg5dHJ4UWxPRVFmK2Z3RmwrOHVMQll3TUxpVjZa?=
 =?utf-8?B?eUgvME9tQXhTOFFuNXFVdG4xMlJCajFUUnVLdDRKdi9IZFhzbFhZQlBlbnpl?=
 =?utf-8?B?bXA1V0gvektXeDYzSmtOaG4wZjB4N0MyaU5HYko4VmNHUDJOQUNWSVp6SlFT?=
 =?utf-8?B?N25iSGo5WkJIUzVZYVZZb1VoM2tHQkpuRzRqaHhtU2N4bnRPc21Xanp0MURG?=
 =?utf-8?B?S2VvZXVNYXd3ZXFuVDM0Mi9rSnM4cVZHc3FrS2doSlZqeTQrbG5FQWpmL1h1?=
 =?utf-8?B?SVh2cWtLYjN4bWFaTjlCcEswV0R3UWsxM0NVUHV6cGdjYUNsdlJqZXdWdUI3?=
 =?utf-8?B?YXNlRXVhdXpvYXRmelhoQ1RyUnlzc0ZUU3VyL2xxNC9CWVhQYXJVQkdLamJH?=
 =?utf-8?B?eWg3d0pBQWJNWDA5cXc5MGJHWGd6RzB0NnlSOEtSTXVvcDAyRVZhRElmYXA5?=
 =?utf-8?B?TzF2Qy8xeGFZZkFERkppdmZyOEdPN0ZwMGZOOWJZREZyb2lLV0I2dXQrL1J6?=
 =?utf-8?B?bDlzRWpSU2pjWFRSQkcxOEFBUVBEOGt4bytmcFNxajBQZU4yS1h0d2hsZG1D?=
 =?utf-8?B?YXBwejFwSGhJM1diQ3ZkSXUwWkJteXlrVVZTOFMySFBjZWloVkJaSy85eTND?=
 =?utf-8?B?cllqMVRmWlBPVlFsM3BodHNFVkR3dFdsUHBSdCtrdWkwUFFKZnN2UStxWjZL?=
 =?utf-8?B?YnZQT3NlWXM2U1JJZ1pTNDJnZmJUd2ZuQ2U2cVM3WHczT2Y3Q3hqU0tPSE1T?=
 =?utf-8?B?ODBRZXR3UUlUcnRNVzlveUEzZU5YK01uQlBML0xiT0dQZUpXaEl0YS9Ndyty?=
 =?utf-8?B?cUs1eVV5VUd1eGt0UFdpUVREcCsxa3NNUlNFK25rcmx3Vll1THgybzRVcm5I?=
 =?utf-8?B?UVVuQ0VWOVVvRnNSLzMxQ2lCeTM2Ynd3eU9TMmIyMWF0VkR4ek9MMWFIdEZ6?=
 =?utf-8?B?NER4U01BNDJIS2t6UU1PelZpMlcxTHkwMzFiV3o0YmVpMktoZlpHWlJNN3Fh?=
 =?utf-8?B?WmhzbWt4T2RUWGZ5L1lwL1B6SEt5R3JXV0luSy80R1Y5SnVJV1NjRHFCZm5W?=
 =?utf-8?B?K1Mxa0FlcjVMYUJ3bVVDRjR5OWZIS1ppUmdRM0t5NTg1REllV0lWTldGMi9z?=
 =?utf-8?B?ZmljRHBVU2tXeThCUG5qWFlFZTNiNXZCRU9qcGRLNXZQVm40NStMNzBQWWFM?=
 =?utf-8?B?bFZqZ2dpNlk3U0F6OGpSWUtOS3JMbytZOXV4MDgzVXJFWnZpclFDRzhtNUZT?=
 =?utf-8?B?VG9LNDJ1bVl2RWlrRDVlaXVpMlZrSUVNeDdZT1pKejd5QmJzcldqYjIvVnJ2?=
 =?utf-8?B?WWRBdjRuUzNuZ0I5cjhjNDhtemtTQlRpNUhJUW9rLzdZYnhWYndhNU1rc3kz?=
 =?utf-8?B?QXVFTW9XMFM0MTFDaWtmZTZ0RlRMcElmOFlkQkh2WndYbnlSYURvR1VndHNi?=
 =?utf-8?B?TFBlZ1J2cHNQWjFYOFI0L2JkcHVubmt0T0RCdVN6SWpnM0pCZXlTa2ZaU3Jv?=
 =?utf-8?B?SWNHUTJNT0dkL2VPbGkyYndjZkpPRmdtSlBxekpFWlMxbmxVSjZPTTlmMHdO?=
 =?utf-8?B?Vll1M0VCWVZiSlJDSnBzY2RMKzdNSE42bHhsVkp1VzFDbGtSdU4vbnpoVnlB?=
 =?utf-8?B?TTI1a0JMU05kYXFTNFAwWndNalZveHo4RW5MSUlUT2FTVlZXZGlMS3RuMVFp?=
 =?utf-8?B?WFlGUER2bW1ob3pqQllxTGVLclFSNHFJcWEzNGUyMzgrQmVCY0hXQWtXNWFt?=
 =?utf-8?B?R0JnQ1czRkJvQmRFdDliUTl5Yk1zNUl2UnFaeCtqTDUvS3U5VWVtbCt2WE5U?=
 =?utf-8?B?VWhHYXNNWC83clZTenJEaDZ2QmZIeGFBNUdxekhiMTBaZmEwa2tHMTEwRHE3?=
 =?utf-8?B?OXdTOFl2Q3lUbEpBNkFaQmg1RGcvOENwaHVUY29oMkt1TkZMTVpYUUFqQmF0?=
 =?utf-8?B?R1BETjBtUUl4bjlqSHRseDkrV2k2dDlMdmVOMnNWb0xUUnZBYVJyend1Tm9C?=
 =?utf-8?B?TkNrZ3E2WlVGaWxiaENlcXRFWXZEUGtNTjZCUitKVUNieldMMGR3M0hSTXd3?=
 =?utf-8?Q?2+rsOquMPiK95gVHGSl2+1A=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e084f8d5-e7f3-4b0d-6c34-08d9ab35fa93
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 08:24:17.6427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vH8EFefdX79ndsHb1/12Zt/LD4c72JZtT20dsWJsdhx+ekSNYGni0Tb7GlFB9B/YZQROaRZd3ikeORush++daQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2605
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.11.2021 23:24, Boris Ostrovsky wrote:
> On 11/18/21 4:00 PM, Stefano Stabellini wrote:
>>
>>          /*
>>           * Avoid truncation on 32-bit.
>>           * TODO: handle addresses >= 4G
>>           */
>>          if ( v >= ~0UL ) {
>>              err = -EINVAL;
>>              goto out_error;
>>          }
> 
> 
> Since this is only relevant to 32-bit kernels then "#if BITS_PER_LONG == 32".

Plus then > instead of >= (thus also making the comment actually decribe
the code) and ULONG_MAX instead of ~0UL, I would say.

Jan

