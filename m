Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8CF2625B9
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 05:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgIIDOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 23:14:16 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:36866 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgIIDOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 23:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1599621247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DVA/62V3mBnnC57HLA5NZrL+7ojSY0J8lJGwDzLiFjM=;
        b=hPqc+MxzagC2i5GYQzvvWL0HvmjWJfqKcfSAuCeixj8b3WiKR52lhOzrSLuyFJhIUm3pEm
        aq5NA3S/wNbFxviQ6L7XPOCs+QXXM2F2BUk02ulTih8X+FWaMl8naH/J9kRCQFgN6xAqrx
        WKvoaFUKUseUHoIPZHb/74ccvVMttWc=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-swCFV4pPOA2OjnqWlYn84A-1; Wed, 09 Sep 2020 05:14:06 +0200
X-MC-Unique: swCFV4pPOA2OjnqWlYn84A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvCcBxSMk8Cvkji8t8kW7IelOKOPlvnOL8zW1y6oWLxbJhhuxJcp9Dx5e600CfwzPeZIgiHl6xu8ofyUwXpkPguhwcSrGj1aravTFjXluId7H6d89oeb6czhWJ2Gb2XaV8yTM9y87yAq+dYEvJ+0CG9Xpiix6Pe0MdxkWf9iZXYZ7a5UKZE/vbi7vE7+XNQxTn/PA4CsZ5itOjePBxGOli93QJKISNuUIBtgAC4Cd/TDbfuqFi4Ra8vTABeEQKLdP6ngGBiATf+CPgymwbW0LY6cBPHaALPgUeZjhsOAiOW1SDFF1IW/tltWR+6ODTL3koqPEXdRrNdI0fw0/GPiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVA/62V3mBnnC57HLA5NZrL+7ojSY0J8lJGwDzLiFjM=;
 b=ho/QD1oQhutzba7QSMl+0vETZH0A6hR2MDVTXlnaabBujcYfOD9eJUhHTM85Fr56SPf1MAWgcIfU9eFiZK2H/mbMhNFIQX7lBilJ4QmQbYu51vkM1DmjOXkWhby2tHl+LNmv1pJNLgcCDmounj+pN7HmEs1HnF2OaR8KcGInTMFLFQletebKN0Q3U/7ChfyR/npbthtgKvrvX+cCzKFGrXo0HK3IuXP3bKCczqvhxa3TwwTZ2fupsiSrDPky16MDML5ey75Z4hRjMb/cM32dKUMNV59M0BzMq3RpeIT8+3CWQip0AmDcjdIo1lGXmXC8FVVjeAyjLCQ0VD+NzMmtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB6PR04MB3240.eurprd04.prod.outlook.com (2603:10a6:6:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 9 Sep
 2020 03:14:05 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::d108:d229:158b:d1b6]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::d108:d229:158b:d1b6%7]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 03:14:05 +0000
Date:   Wed, 9 Sep 2020 11:13:55 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 41/88] net: ethernet: mlx4: Fix memory allocation in
 mlx4_buddy_init()
Message-ID: <20200909031355.GD3738@syu-laptop>
References: <20200908152221.082184905@linuxfoundation.org>
 <20200908152223.178555420@linuxfoundation.org>
 <20200908195311.GC6758@duo.ucw.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200908195311.GC6758@duo.ucw.cz>
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (110.26.99.192) by AM0PR06CA0125.eurprd06.prod.outlook.com (2603:10a6:208:ab::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 03:14:01 +0000
X-Originating-IP: [110.26.99.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b1b596-f3f2-40c5-c0d6-08d8546e680e
X-MS-TrafficTypeDiagnostic: DB6PR04MB3240:
X-Microsoft-Antispam-PRVS: <DB6PR04MB324040E7F2EB8DCDF261F618BF260@DB6PR04MB3240.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X74Xo8vwdlL0Wo/YQxTCJqAugkthvZbTETGxmDyyJqIsUz5gFRq6+KBy6xxvhladVSmVcTFbt8PNC9w0ShrVxVUq2Wo5kgjva0bBAXBNdHY8APaMaQUoZQQmaYRYBwfSkvC6Qdu1a3ARAYhlRitRWZxSBIzSWSJ9PR0O77PofFoyHE066z1eDMdr4diknkoGpBVk3WfDwE2i5+AiQzZ8hacNZwiFg7h+wLSxGd2TL5mgg3S2OekyCoTNWglfGxfgW6Itp93G/9zrU34sED31druY3kmkKzHIeeDIjYyYapJRFdGKQyq2gY/vecqt92pYVFwRcIZdtW+H9iYkchn5nuuHWlwtiXmmKKLRG+JjDWZXv/rQLMkza+jnhwJ8i2XNdrAMy/4umBMn7/jHqKR+sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(8676002)(52116002)(66476007)(6496006)(966005)(1076003)(2906002)(55016002)(83380400001)(54906003)(316002)(33716001)(4326008)(86362001)(66946007)(66556008)(9686003)(186003)(478600001)(956004)(6666004)(8936002)(33656002)(16526019)(26005)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZI45qtNmPSMBzRjQVYOLO3uV2Ln2baia25iF9jwQ8h5HNEET3MI6W8SlNur2n6tMq78vCSMO/7UeyIEjiLfH8kbw0+myCf8hYaeVHfSbQyblqvQbxvI2a4lRyQyRvhBQ/hoya6IJbDMJXrp0agtMG+d9gNE8iGboPMPtR2e5zOgIsiPG2Q/rUVycuPOShCnAJaU6JGWt3i4RzsZ7GRvBkqbVSr5tFpwTuGPiUqGYspOxDPR4VDArE6guNX0X996UZDl5OJN9gktpE4XVWmXhLJ8JL0zb7KvPgYeMIm4nBCmDXFWiIuO/MVgJ4T2n/Gp0R44MZ2EzZt6tyabDxJkLbUFKP+DCKyIr6aMjuDj3/uAnZdQyhIwBTJ9tfEHRUqAkpZ4DSQYiMhGkG6gsL0j6dXQsnDQqgVYgEK9Op/YBH4vpNY9ElK925/wtMW+65Oca/GCVqFTLpHvXlL+Xq3L5xeuvhHVgGb+HoiuxoLUFl5vKo060RUQ8e2wRxLh8jhN+Q3qIHc9OD6IOlYel5aM3LIU21iN0/ZFWEc3Al36P3bX+WbbW4BTtbwz8RPxm9EAUuB14PEzs69PVmD6J4l6M9vYslE1ZF7ruuuD6OpXSvb6XB0Wka+Sdi1qE4Nd3YAVgXEK49jDLZBdUbAoEVYQnNg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b1b596-f3f2-40c5-c0d6-08d8546e680e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 03:14:04.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vm0xxRburs0FTeyvNDak2NVp4BjMeyqjIfcBgX/k+/e1mm3cAR5MM8NRdfR0pAlJwIb/vN54liTOz9KJfxCplQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3240
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 09:53:11PM +0200, Pavel Machek wrote:
> Hi!
> 
> > On machines with much memory (> 2 TByte) and log_mtts_per_seg == 0, a
> > max_order of 31 will be passed to mlx_buddy_init(), which results in
> > s = BITS_TO_LONGS(1 << 31) becoming a negative value, leading to
> > kvmalloc_array() failure when it is converted to size_t.
> > 
> >   mlx4_core 0000:b1:00.0: Failed to initialize memory region table, aborting
> >   mlx4_core: probe of 0000:b1:00.0 failed with error -12
> > 
> > Fix this issue by changing the left shifting operand from a signed literal to
> > an unsigned one.
> 
> Will we still have problems with > 4 TByte machines?

AFAIK we're safe since max_buddy is calculated as such

	/* In drivers/net/ethernet/mellanox/mlx4/mr.c */
	err = mlx4_buddy_init(&mr_table->mtt_buddy,
			      ilog2((u32)dev->caps.num_mtts /
			      (1 << log_mtts_per_seg)));

Also, num_mtts is capped at 2^31

	/* In drivers/net/ethernet/mellanox/mlx4/profile.c */
	/*
	 * We want to scale the number of MTTs with the size of the
	 * system memory, since it makes sense to register a lot of
	 * memory on a system with a lot of memory.  As a heuristic,
	 * make sure we have enough MTTs to cover twice the system
	 * memory (with PAGE_SIZE entries).
	 *
	 * This number has to be a power of two and fit into 32 bits
	 * due to device limitations, so cap this at 2^31 as well.
	 * That limits us to 8TB of memory registration per HCA with
	 * 4KB pages, which is probably OK for the next few months.
	 */
	si_meminfo(&si);
	request->num_mtt =
		roundup_pow_of_two(max_t(unsigned, request->num_mtt,
					 min(1UL << (31 - log_mtts_per_seg),
					     (si.totalram << 1) >> log_mtts_per_seg)));

Best,
Shung-Hsi Yu

> Should the computation be done in u64?
>
> Best regards,
> 									Pavel
> 
> > Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
> > Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> > +++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
> > @@ -114,7 +114,7 @@ static int mlx4_buddy_init(struct mlx4_buddy *buddy, int max_order)
> >  		goto err_out;
> >  
> >  	for (i = 0; i <= buddy->max_order; ++i) {
> > -		s = BITS_TO_LONGS(1 << (buddy->max_order - i));
> > +		s = BITS_TO_LONGS(1UL << (buddy->max_order - i));
> >  		buddy->bits[i] = kvmalloc_array(s, sizeof(long), GFP_KERNEL | __GFP_ZERO);
> >  		if (!buddy->bits[i])
> >  			goto err_out_free;
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


