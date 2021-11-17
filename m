Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6734541FE
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 08:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhKQHpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 02:45:00 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:43413 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234016AbhKQHo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 02:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1637134920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7O4IAlBuV7Ht5e46unwQP9LahssvTkosfPU1fu1k7K4=;
        b=BGz+TSw6V76OfZ1Kjvgf56FKJ0KwPepuoAUlDKSedNtAqJ5uNGwHnZfqceKFLkQaBrJo93
        vznRYL1ncCy/nuEPP/D5kJZ6RK5VWZJ2Ip+CCjyTI1eHgredEaOQV5XeUB++RU1bbBbJjW
        TIYUlEzwlPXn10fI68OkF8CiQFuLFcw=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2058.outbound.protection.outlook.com [104.47.0.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-B4RYW2b2NzK08wt8dyY5TA-1; Wed, 17 Nov 2021 08:41:59 +0100
X-MC-Unique: B4RYW2b2NzK08wt8dyY5TA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDhUGzxoqQKXNSnGrEn0zr67IRFXWhtNuFADnWufTi9XS9FMwkHE3fRmUiFPXRDmwjEh50qFQkGBJ5gcg0kZxCltNNi3K2pV2gpjXGoi77cN75Gsni497YO305jwLYAjWsuYL8utx4zxScCJ03ID6ohq2J2d7qqzCcf0dKPMvgKzGdSNl/qqZR8l+k9OIzVltKoi/myEljMSckZrKL7EzIalrbPFh/4n9Luw22ZEoIC8kLVic0n5ZeKgTnXheIZVi9NmKgp+X9cMYlprAZIuVElHcZZsoRcUfy7bHIFLdPW3/6VY9Lfv7nf2FShdKfR0s0jdKEdjUf6ZyniJLyyYlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7O4IAlBuV7Ht5e46unwQP9LahssvTkosfPU1fu1k7K4=;
 b=QkHveLmQDEJaDHvwM413wEVfS7ZKeNAQdoqnyGheoOEKSsvcM3AICa/9wBByCqaHe/Nl3ZG2Ih9hDiRFVibmQ+2I/1qhcT7AFu5402KhLJlnWDZzMybjMMJWwfM747mD1FNgzHvENHnlwNdO8A0Jb56agbeWz0U8i4cS5RlBYI2M3rfxhcPm8t1JFyy85M8W1cH3E6IXJDe8+trFIuhasEtT6KKfzoL5eTz4s2sA7imrUvo/7l555RAeT1nVqRiutLpLH+6axGN6YFYUZPY1V382pFoWw4x+NxH79JvrH9gxHe2/m0vht2F2NVAmw/D+HcHnOGX2KA73kq8+dlORxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR0401MB2607.eurprd04.prod.outlook.com (2603:10a6:800:58::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 07:41:58 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::8062:d7cb:ca45:1898%3]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 07:41:58 +0000
Message-ID: <2592121c-ed62-c346-5aeb-37adb6bb1982@suse.com>
Date:   Wed, 17 Nov 2021 08:41:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] xen: detect uninitialized xenbus in xenbus_init
Content-Language: en-US
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org, jgross@suse.com
References: <20211117021145.3105042-1-sstabellini@kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20211117021145.3105042-1-sstabellini@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0390.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::35) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
Received: from [10.156.60.236] (37.24.206.209) by AS9PR06CA0390.eurprd06.prod.outlook.com (2603:10a6:20b:460::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Wed, 17 Nov 2021 07:41:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d017831-02e2-4b6d-8ef3-08d9a99dbbf6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2607:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR0401MB260718B8CE8F3571989A919AB39A9@VI1PR0401MB2607.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JtZYiXLRyiWlWkLrQXrMO3ozgxNMtlTbsuKJ+grI5xzaSb2kq7e9J4jvuK3o9nDD2ONAxvOmmMXPWahet7E4fo/+63TI3YO4IE7JobevhxvvIp5TURCSk6QXo4a8XKcxJHnkPlJqluDSFpX2ZUKgVX59qaTC65GTadHOqDFwlHik/jyxvXM+BXlrC3dPs3PvkKyurA6Mdfjj5or+NJcnnlWmjeh2qjg0fg7M6KSR57pJSeeC8tJfr7Rk+nUTzt3k3u4Ybkcty+oiCYwKLI9vXDQy6Iwi78i9J1FXXlcDVyuAyq+G16XLUvJ4ouGZFSfePkwP0UawkeMTcymDFrWh6RE6n90ffn1ks81m32UWss1H4ltHdpCLtW8Ba6ADwGhIqIgvHBikrJMswqiN/xONh8+3pGV2eYHJnqVGdhq6HVquxHstpvI5/bxBomO0dsTodh7p6l0sQi9ASNAVysZklHytNeYT1wN6s6lh10iGXcewZFzuKo7uOWe2l2WHy8pcAbCKbN+YXgBVfAdeRBcRbQAy6G4mAvsOOzwd/M4xRzAf7go7Iwz5lysGBgCF4+rEOnSnEgXzw/mq74gDk4GjiyBxFRbGjVM25N1FPqOIneWdtY+4bXx1hXX9CC0Fvqk2NleaoNKDlJqH5UowMZtQ4AF0c+zsG9lCAmw9EA5W1Vc+SOWjh9E9Bv8axYcndcjSC1arHKC/QWMYSwmjwLKASahRFwyIxmyRtnI4HBEfxwDuH/opzehP2VnQuptI4mx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6486002)(8936002)(66556008)(5660300002)(38100700002)(316002)(16576012)(107886003)(66946007)(2616005)(956004)(36756003)(6916009)(86362001)(4326008)(186003)(66476007)(26005)(8676002)(508600001)(2906002)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjVtRUlwWXZxSVJwRitMK0xUYW1QTk5Ja1V2eVFoQW92N2RmektDekIzblVT?=
 =?utf-8?B?TVhjdk5HelpPSXAybU1FTEE5cXRsRUwzeWdtYjZUR0lUUEhUK1oxODVONXZZ?=
 =?utf-8?B?aUs1Q2JNS3cxaHdsdmdyTm02SEJkR1RJckoyTTd1SWk0bUdhRFZBVS96RTRh?=
 =?utf-8?B?WGw1UzlPYXVxdlV5aEFKL3NWQjBhNjhDaXZOSmk3WXUrRnJHcVkxaUh4cjVK?=
 =?utf-8?B?a1NLL2cydjEwRHNuMjk2U3kvbjQyZ1pKa20rNGpjZmlmMFo3Vi8xUnh0eUNC?=
 =?utf-8?B?dStjeGZ0anY3MjA0RXBUamRRMzEzbVVPRWtMOVdpOW4yWFREZDZGQkhXMGxR?=
 =?utf-8?B?OVJoVGZ3RDRMWW9NSGNGL1NYVDJpdWVNS2lDekNvOXFMUmRqa1RlRGhkREc3?=
 =?utf-8?B?TktaM2cwbmlWQVBpd20xNlpINjIvVlI3MTRqb3dnSDJ6VUUxNTIxNTAySlpN?=
 =?utf-8?B?ZS93WmJ4RVIxYTVLczgwemJCOVBOWXdrZURlbmluT0UwcFcyMnFNSmJCbG5y?=
 =?utf-8?B?Q3MxcGJ1WnplSFEzc0g0a002SmdMSTZIdUxXMkVJOFBmRGJrMFN4WVcrRmtZ?=
 =?utf-8?B?Y09qTVZnVENicnU0S2gxUWVhcTFZTDUzR0w4b0JWSTFRRGRjWDJrSWNMeXZt?=
 =?utf-8?B?MTBNRkN5QTgyYWZGcDFKa2xjR1YyM1hEMTI1WERmd3pDaVVQSFBRZTNsOU1q?=
 =?utf-8?B?UnFIbUw2K1dSN21SZUd1amNkV1VodjU1QVhYZlNsSk9QUDlnc1NpUnU0M1J4?=
 =?utf-8?B?TnNpUGhuemY2aHN4LzdZUG02bnhqdjVDdDJzWVRGdWVoZ1hwb08yOFE1R0E0?=
 =?utf-8?B?UWpFSjk3WGpoS2dxUGhwOFZkOENhZWo3N3pSVFpBSkpNQjMvN3FFbFRBdGJU?=
 =?utf-8?B?YzVTbWNGWXVvRzhweXlMRFg0RmsxMnczUzJTOWhGLy9IMEZ5Wi9lWVZtYU5M?=
 =?utf-8?B?N2dPNjVCRGxaZXRiTmdQcmFpMGdkaTZBZFpPZXZiWHBCTFFBUXAvWXhsTDdJ?=
 =?utf-8?B?T1N3Q21QSzN2T0tyZmViTnhvYU0zWE9XZjVnNmxLTDhLSVg5ZGdkdTNkaHpj?=
 =?utf-8?B?Yy84Sk5TL3BUKytuVDVuclcwUm9qTUxtWEJkL3Jnb2h5c0FNUVFnSDBEbyt2?=
 =?utf-8?B?c0xaaFNSdGZXVjNmUE5Sa0ZxSVF4UWtWMTJhc3BhM3RkV0VaUTB0QW9iMm1C?=
 =?utf-8?B?Vmd0NUk1T3Jzd0lzUUJadVVFZ0wrbHd0MHFPT3krdlArbUdFRTh2MWRZNGo3?=
 =?utf-8?B?SjZDN3hTN0ZUanhaczVsdXROOTl2R1A1ZXlia05vbUtMbXg0b25RR041RWZx?=
 =?utf-8?B?Vy9hbmtrNXoycjdiSU84dkpId3FvazVqTHptUld6UzgwdWxPR2pIR05ZOVZ2?=
 =?utf-8?B?ZHNQblRWamFXaWJmN1oyVkVqUmpScnIzM0VrRFQ5UnFoZ1J0MDJDS3Y0by9I?=
 =?utf-8?B?cWt3ZXlHMnphc1poVFR5MERsVGdZejNqUXh1bm54dkNLeTlBRHRlWGRPZnpy?=
 =?utf-8?B?bzJjeFRoSWtvTVB3dysrOCtXSkxJUkhHK2twL0NLR0dZdU1UZWFkN2RWTHJj?=
 =?utf-8?B?M2s2cG5MOC9LUEo3bmJuMVM1UkhVbEZXUDAyNThHdXFPcGdQaWloYzNZTXNo?=
 =?utf-8?B?VlhOay9iYWxPWGRpT0piUFV1d0o2SDEyV0c2aDBRUEpKK1I5YW9IdjMxeUZa?=
 =?utf-8?B?MGdWRGsya0dPcitkZGhpeFpRRkRIS0VrWmxyNWx6MVk3WVkyU0s0UEwxRGdT?=
 =?utf-8?B?bUZEU3FEZ2RVWGRadlAxNU92MXRHOFptRmJQMm96VUo3UkVWcERPMTl5NlFN?=
 =?utf-8?B?RzJCL0dXVmY1enZmZzZsUzkwdVFKbnAzWFlhRksvZ2NvU1Y5QTdDNjZrWGU0?=
 =?utf-8?B?R2JvVS9RcXgyNU1QTWpzSnV1YlpYdFZ3dTdYTHZvUCtOMWIrMTVnNDhSeTg1?=
 =?utf-8?B?TzVoTlVjR0tZQVg2RThOYjRFUHZNY1JldzI0L1dBY2lRQ0Yvb05hUGFsK3BC?=
 =?utf-8?B?bmNncWNSbWRVRnVQalM2dlMyTFkrL0psQnM4czRvdXRCZC9nNHkzL0FzaXlw?=
 =?utf-8?B?eWEybHdXVy9BSlQvYjdQNjAvQjRCbUpDQm8zNXBhanh4L3dxT29rSmdZOWk2?=
 =?utf-8?B?bm0rMGozY0tUNm5sZXg5Y2lzd2tOUDNZenlzQytOSlhKVWtWTktsMzhLc01F?=
 =?utf-8?Q?L/83Lbla6elDm+JZ/ett4Jg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d017831-02e2-4b6d-8ef3-08d9a99dbbf6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 07:41:57.9992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3LW0HC/df3focdKaHLgx5xWTaEoQOnVGrI0Vp81di26VSXgFnRjjtlB1rynTkF8/IKHpfYPTncRidyUvoevJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2607
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.11.2021 03:11, Stefano Stabellini wrote:
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -951,6 +951,18 @@ static int __init xenbus_init(void)
>  		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
>  		if (err)
>  			goto out_error;
> +		/*
> +		 * Uninitialized hvm_params are zero and return no error.
> +		 * Although it is theoretically possible to have
> +		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
> +		 * not zero when valid. If zero, it means that Xenstore hasn't
> +		 * been properly initialized. Instead of attempting to map a
> +		 * wrong guest physical address return error.
> +		 */
> +		if (v == 0) {
> +			err = -ENOENT;
> +			goto out_error;
> +		}

If such a check gets added, then I think known-invalid frame numbers
should be covered at even higher a priority than zero. This would,
for example, also mean to ...

>  		xen_store_gfn = (unsigned long)v;

... stop silently truncating a value here.

By covering them we would then have the option to pre-fill PFN params
with, say, ~0 in the hypervisor (to clearly identify them as invalid,
rather than having to guess at the validity of 0). I haven't really
checked yet whether such a change would be compatible with existing
software ...

Jan

