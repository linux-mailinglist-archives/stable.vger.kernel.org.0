Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F352FB913
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395417AbhASOSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:42 -0500
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:3322 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389658AbhASMiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 07:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1611059893;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=gqKoBsp/d6hf77m4T+BKKq05C3ONcUHSMVz1EG6HgFU=;
  b=hPi1YNWShiQ8vQI1koQ3+FdkbP0HDssvZb4pnf+D55QaZKT8myqwLifM
   v65Cadeg7sDMSEbV2hlJFyjVk3NfOgI2Xtuqz2pT3bbxLQfiqYF6Coboj
   C3KHOzbzI0/bUfXZgOwpdzCzMfVmLgvlAUGZqu1zBJ8TULW6yDcYmo47b
   g=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: qdR1QlMhc1X0qGfzlM7yiCeJmw8+lQQ7b1b/dyJL9c6pFtAJebzg6o1wAI/XrLP8VNMQmXZbfl
 gvTBBiszFVNAE7wjtbsGx+EXVKHSR9wyrCv/Rte5eHUkR3MjR4TGM6bib39ZDrlsra9aGDIyM9
 Ug+uxMBq9K7PZpJZHq8p5fjAIZXFNqBQDC8xs4kAoAYicT89aoBgxYtKSAL0D2Qe5PdkPmbmb4
 rNY8OZqcDDuV4FxZQhVUSf5phM+F6hMZu5YrI073kdv83xmEuVfN7qDBG/hqzVE+8Iser8DtmZ
 tEQ=
X-SBRS: 5.2
X-MesageID: 35365372
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.79,358,1602561600"; 
   d="scan'208";a="35365372"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmwEwBjblmtA8nvnrXS0t8IjgLm/8qZqayyyBAplxXuSkaDcdz18K368UcV4oCQFaD1iVHFy8MSCT6p9fBbgzcwMMxaezSWkogf/292i9p0TyVfrKltQFgIQHnvFE44ahQnht9Z6VVKx4/dGJE+X80RBpyUIdmN/wk3W+S85PUXH9Sd1+wupzUjVjhydSG6c7uDYELrpxQbeynDQe25Bc9zF9J0+n5aCz/pmKBjcpSQa6ziQ7UUhdLFCDmxzh7qxKP3NWgTMGcYzH1ngpy+3aPIFSlNteareGUb2fLII7Ezcuw/w+ekL4MU7gWCCn/yEeED9yRdnOgY1wD+krso/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFPsOAnU70E2xyKto+FlF8WZfChgs7qL+Toh6ErifDE=;
 b=i42r9NcE521M019cfFKcLMR5DYHX8j4L3JP4TDjkBV5gmm5ANV+12gQj7NivkbxtGAiscgIaWGFimznDtM10gR/zuyLNcL/3EPDgZoksUJ2fgjL8SMdkcqsw+6qbPpo78jLru6Ye38RSBQqbfAdyG7wYwCMEoi85UK6WaMdAkmzJVYx9u8pFCLFpYP2i2IoCuJXBzFerYEukjMpBnL60p9pMzjdN5xLg7w+BlYh6GSx3cLOUvNBgcMg+6uRKob/lXS4KYzAbqXeWG1pJTsgB9YynRNbO8Idt9kJDvgoP70Uv/aeWrJZOi1f6sWFj9DaWLvEn4ayX0mknDpIoMEbhIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFPsOAnU70E2xyKto+FlF8WZfChgs7qL+Toh6ErifDE=;
 b=kuDsNN0GMSfumleJnfCD9YNFoSnTM0qiukdh+e3IecGtfdluBTWyMQRgAAiTVZrBrFHzjzVrh/KKtrHhpEmZnIrR/tdomTecEL57QEYDKv8Kuoqe70qDIPG1qjUtf8FH1M6f8NL+393zG/sW8Qr9+2+N7QfcHKBM0qw08Dyd9pQ=
Date:   Tue, 19 Jan 2021 13:36:22 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <xen-devel@lists.xenproject.org>,
        <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2] xen-blkfront: allow discard-* nodes to be optional
Message-ID: <20210119123622.zweul6uqfg54erj3@Air-de-Roger>
References: <20210119105727.95173-1-roger.pau@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210119105727.95173-1-roger.pau@citrix.com>
X-ClientProxiedBy: PR3P193CA0045.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::20) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 728d56f7-715c-4a9a-d3b3-08d8bc76d857
X-MS-TrafficTypeDiagnostic: DM5PR03MB3065:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3065965B71F7FCCD3B859F338FA30@DM5PR03MB3065.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LjxlylMIPTiIbxQN9756Y1X7xzWVGjEwRdUDGY2NX/FyVlMPg3bi+I3S0qB3Y/auZ0+k3AaZXXbkxpGWKyQXuP+WZYSYK6kHMhnGb4USmTp8OjZajLpWqBFEzlfXJj8nIp73c5rgTrm1zQoSdN8W6A8crWo6XyDmLNke/51ii02Vt0eSvXOxTEcfYkOfcAJw1mtKF6DJ8GgBZdoY/QTJt75Awa4XTu0iH76YCVo+I1F33imf6GuhjxB4LFVMp5JWXdb3RkEtg/2cshP2mxi2/A/w4vUdyCAgnVLEoiXb5j7ZYFRNLY82B5DnjszvPuG8HYB9q4fe8PfvA4dVqr5VZsTeNec9v3kx8R2Qjgm04UJgMGH5kQGSAtR9Gsja7mbw7qC+Z+IxAQaIfkvabT8iqKel6jgKoalvFX8ldTJeFD/qhS3FyECwoRDb7EdPlfCm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(366004)(136003)(396003)(39860400002)(346002)(956004)(6496006)(8676002)(6486002)(9686003)(16526019)(26005)(7416002)(2906002)(186003)(66476007)(54906003)(5660300002)(33716001)(6916009)(66556008)(316002)(85182001)(6666004)(8936002)(1076003)(66946007)(4326008)(83380400001)(478600001)(86362001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHoxK2ZGQXU0aHhSdXFacDVuRiszNmZjU0RxSitxSjA2Tzg1Y1gxYnpLS2Rj?=
 =?utf-8?B?N052bzQ5WEp3ODBUL1NxMVZqZFM0RkFNTTc1bUlhYnBXRU03QVpFOXE5Njd1?=
 =?utf-8?B?dml6QWx6d0xzMjBlOVVrNEN5UThmME02RlBNSWxYOHNLbXNCM2pLelZxWTNE?=
 =?utf-8?B?MGM4UUJLVlUrcDNydW5acThJNlFmZTFnTnhoU0luUGtmSU5zTjlLeE51NTI1?=
 =?utf-8?B?MzVBWTg3Rms3QzJHQzU2QnBrdHBSN01RVyszYXc2MmZ0cW5aczRMSUdWMzY4?=
 =?utf-8?B?N3FBQmFWam00TDdsblF1UEpReWVoYUhFdlVldHM5djdkZS9NVm5ucGN1M2NV?=
 =?utf-8?B?T0JlWElWdHI3Wk04NDN4UDdVSngxQ1hYTytlQmt3cllBajFTNVFVb0ZwSEhK?=
 =?utf-8?B?Z1lPbUZpTTcrSS9ZTlNsb1BUVDJvWDI3Q09HRWhWOVZXdS84bW1Oc2ZKNjJF?=
 =?utf-8?B?TndlU2NodVlvZ2QwQlorZmtxWFQ2anppSFczc2lJeWMrMG5hQUtIL2w0YU1G?=
 =?utf-8?B?K0MwelRXWWp2RFpvelNkeUpjcWxtUkJnSUVYYkIrc0JLenh5ZC9pWmVKT3p3?=
 =?utf-8?B?K1NyTHpkZ3hYQjdTaVkxOUpiQi9hSlFLajFqZlFUOUVRTHoveWFvRDhxQlB1?=
 =?utf-8?B?VStEUVRXYTg3TjVpdXBxYmxSV0NwV2t2YW5QQU04SmlUcGc4dE1KK3BUSXEz?=
 =?utf-8?B?R3ZJK3ZYaEJSZXU1YWIzZEhSaE9VSGZhSktGYXhwL0pFaWNwN0FCZ0k3VDg3?=
 =?utf-8?B?MmNIOVB2c0lhcjhHNmJxTEZjckRnQmZkUGlTMHY1SjFPSlcrMEwxYzVLZ1Zk?=
 =?utf-8?B?ZjMyNGRJKzNJWlJvTWpmWHRLSFVBUnZGbm51K2JGbnZxOGtvSXM0R3UwSTM2?=
 =?utf-8?B?RG1oMUkrSlE1MkI4aTIzaWoyZFpJR01Bc1NuZUd3eHJoamUzRHpjbnBwdjM4?=
 =?utf-8?B?cVI2THBkNzZFT2dhazJRNkRjNjJLdHpQK0YzbUxZNGhDTE00M3NMUnNFZVBO?=
 =?utf-8?B?ZmRTNENKMnp4NTJPOUZsTE16ckFaeWRQSCs5WGpvNm9nN3hBeE4rR20xSjhK?=
 =?utf-8?B?UU1qTzMzbTlGdGhYcDZVQTdKb2NzamJ6azBjVHg5bkJRQW5qWnlLZEJPUlIy?=
 =?utf-8?B?S1hVTmFIOEtDQzI3c2ZMWG5uai9VcmVmZjQ4QzdZZEpuTXBBTmFvdmZCNjg4?=
 =?utf-8?B?ZEpPWGNaU0tmRUFtMys4eENDMmtKa1N3ZDFqMTgrTVJmZ0FVcVJQTTVZYk5X?=
 =?utf-8?B?c215b0xuQkMrQk1uRlFJaHUzQlVzSjNoTmV6NkRkYlJHMXA5MlJiQWFpSnBk?=
 =?utf-8?Q?JxF3QsBZ77KjSUP8Nm2ioD22yaSHBZ/vH5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 728d56f7-715c-4a9a-d3b3-08d8bc76d857
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 12:36:29.6235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqriUnlJsikhTPJraEDvCfPcqzSpS9TdaJyLoN/N9Y63B1OxzlCeSn8B26p/NHBDNT6pscoLYcgzhATTNirJWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3065
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to Cc stable for the Fixes tag. Doing it now.

On Tue, Jan 19, 2021 at 11:57:27AM +0100, Roger Pau Monne wrote:
> This is inline with the specification described in blkif.h:
> 
>  * discard-granularity: should be set to the physical block size if
>    node is not present.
>  * discard-alignment, discard-secure: should be set to 0 if node not
>    present.
> 
> This was detected as QEMU would only create the discard-granularity
> node but not discard-alignment, and thus the setup done in
> blkfront_setup_discard would fail.
> 
> Fix blkfront_setup_discard to not fail on missing nodes, and also fix
> blkif_set_queue_limits to set the discard granularity to the physical
> block size if none is specified in xenbus.
> 
> Fixes: ed30bf317c5ce ('xen-blkfront: Handle discard requests.')
> Reported-by: Arthur Borsboom <arthurborsboom@gmail.com>
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> ---
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: "Roger Pau Monné" <roger.pau@citrix.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-block@vger.kernel.org
> Cc: Arthur Borsboom <arthurborsboom@gmail.com>
> ---
> Changes since v2:
>  - Allow all discard-* nodes to be optional.
> ---
>  drivers/block/xen-blkfront.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 5265975b3fba..e1c6798889f4 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -945,7 +945,8 @@ static void blkif_set_queue_limits(struct blkfront_info *info)
>  	if (info->feature_discard) {
>  		blk_queue_flag_set(QUEUE_FLAG_DISCARD, rq);
>  		blk_queue_max_discard_sectors(rq, get_capacity(gd));
> -		rq->limits.discard_granularity = info->discard_granularity;
> +		rq->limits.discard_granularity = info->discard_granularity ?:
> +						 info->physical_sector_size;
>  		rq->limits.discard_alignment = info->discard_alignment;
>  		if (info->feature_secdiscard)
>  			blk_queue_flag_set(QUEUE_FLAG_SECERASE, rq);
> @@ -2179,19 +2180,12 @@ static void blkfront_closing(struct blkfront_info *info)
>  
>  static void blkfront_setup_discard(struct blkfront_info *info)
>  {
> -	int err;
> -	unsigned int discard_granularity;
> -	unsigned int discard_alignment;
> -
>  	info->feature_discard = 1;
> -	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> -		"discard-granularity", "%u", &discard_granularity,
> -		"discard-alignment", "%u", &discard_alignment,
> -		NULL);
> -	if (!err) {
> -		info->discard_granularity = discard_granularity;
> -		info->discard_alignment = discard_alignment;
> -	}
> +	info->discard_granularity = xenbus_read_unsigned(info->xbdev->otherend,
> +							 "discard-granularity",
> +							 0);
> +	info->discard_alignment = xenbus_read_unsigned(info->xbdev->otherend,
> +						       "discard-alignment", 0);
>  	info->feature_secdiscard =
>  		!!xenbus_read_unsigned(info->xbdev->otherend, "discard-secure",
>  				       0);
> -- 
> 2.29.2
> 
