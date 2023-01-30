Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63356805AD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 06:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjA3FkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 00:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjA3FkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 00:40:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490C41DBBF;
        Sun, 29 Jan 2023 21:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E257B60C55;
        Mon, 30 Jan 2023 05:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8B5C433EF;
        Mon, 30 Jan 2023 05:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675057202;
        bh=Gj3CoWpxMRs986P27Jmp/+SlgrHYUEsIRBz84LyFW4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmmaklQUms+MCNtp/BKJUneaEQIq4p80mYC1xSXL6c32OECg5fpVIeYF9WUwDYI3u
         VNNmpS5V/JYwhSwEcjI43JzcPuXRVQTApRrPqLwd+6YuZb8PWUYYOhpfTHai7LrPZc
         2KN9dQ8V40G3O5fFzgOn9iUh6UsdykZ1LoiBjv/Q=
Date:   Mon, 30 Jan 2023 06:39:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: Heads-up: one change merged for -rc6 that might be good to have
 in the next 6.1.y release
Message-ID: <Y9dYL2/Ynahsc+Qu@kroah.com>
References: <73f7aba7-1533-ed16-fc76-97a758aaaf1d@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73f7aba7-1533-ed16-fc76-97a758aaaf1d@leemhuis.info>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 29, 2023 at 10:13:25PM +0100, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
> Hi Greg. Just a heads up that likely isn't needed, as the change
> mentioned below has a proper Cc: <stable@...> tag, so you scripts will
> likely do the right thing automatically. But just to be sure:
> 
> I'm pretty sure Vlastimil would be extremely happy if you include
> 95e7a450b819 ("Revert "mm/compaction: fix set skip in
> fast_find_migrateblock"") [was merged ~2 hours ago] in the next 6.1.y
> release, as he in [1] wrote:

Thanks, yeah, it would have automatically gotten added, but I picked it
up now just to be sure it's not lost in the deluge :)

thanks,

greg k-h
