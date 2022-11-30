Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B3063D3ED
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiK3LGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiK3LGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:06:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A02A2BB0C;
        Wed, 30 Nov 2022 03:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B6361AFA;
        Wed, 30 Nov 2022 11:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF5C433D6;
        Wed, 30 Nov 2022 11:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669806378;
        bh=jujPM3njpPJca9XyPNWIYHk/sCCLKUbMoZq4AAx7fTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a50kGSlgXYNoRl+R156zaFySm/onNpTsabkLsIaGm28rQNBsLSelMN2MjTcXLUs9a
         9K6zBT0qgiElSmoCe65gTQzq/w9jfWBeg3ss1JRP+Mocqm5wCZjd6B7GMi0U8b9i3K
         KahJppYSkZNjoC+sD3H/KJuUD1MG5ufy5fGEhJvgQ+5nle3N7QV1wmKlv6lCho/YNM
         m56LY4wAK1RycTVxzmqOmTPJ20COzGgUbxM02ziAHFL9Eh2JV/j62WiRJeowimd4z5
         WMehrPenc7WTyYWnzd+jw9VxuaLx6ve7V2nnbIWozDa7h/FM4X25Hu3VBs/tyQB9ru
         xlNBiPducPVXg==
Date:   Wed, 30 Nov 2022 06:06:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, agk@redhat.com,
        dm-devel@redhat.com
Subject: Re: [PATCH AUTOSEL 5.15 25/31] dm-log-writes: set dma_alignment
 limit in io_hints
Message-ID: <Y4c5KSErgaBY/cwW@sashalap>
References: <20221123124234.265396-1-sashal@kernel.org>
 <20221123124234.265396-25-sashal@kernel.org>
 <Y342hZgFQdLfTfdx@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y342hZgFQdLfTfdx@kbusch-mbp.dhcp.thefacebook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 08:04:37AM -0700, Keith Busch wrote:
>On Wed, Nov 23, 2022 at 07:42:26AM -0500, Sasha Levin wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> [ Upstream commit 50a893359cd2643ee1afc96eedc9e7084cab49fa ]
>>
>> This device mapper needs bio vectors to be sized and memory aligned to
>> the logical block size. Set the minimum required queue limit
>> accordingly.
>
>Probably harmless, but these dm dma_alignment patches are not needed
>prior to 6.0.

I'll drop them on all <6.0 kernels, thanks!

-- 
Thanks,
Sasha
