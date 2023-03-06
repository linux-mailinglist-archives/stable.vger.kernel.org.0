Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553786AB6DF
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCFHVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:21:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC991C593
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E7A460B6A
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3145AC433D2;
        Mon,  6 Mar 2023 07:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087280;
        bh=kZ+Fe73lvdFrLSPujZT1Iytq/QhLnEvct8Xu5GBTWJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KOWcwKzGvUsEj8EAsJnA13NM7K2CJPOADGqdFY5xrOr1obXGgph6UESvAfzZPDifJ
         rbsG5qYCB6sdiJkEtJr6k91uYvn0TgpXE5+Hkq3QWZKNyIbmy3JbS6OQVB95S2JbtM
         iYSajFHVqwUvsh1uICKV448ELjo6XWAyOAJuaa3w=
Date:   Mon, 6 Mar 2023 08:21:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
Message-ID: <ZAWUbo4HTXl/u8Zw@kroah.com>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAMUx8rG8xukulTu@eldamar.lan>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 10:52:07AM +0100, Salvatore Bonaccorso wrote:
> Dear stable maintainers,
> 
> Please backport the aboove commit to the stable series. Note, though
> as a first step it just applies cleanly to 6.1.y. Due to 9df650963bf6
> ("scsi: mpt3sas: Don't change DMA mask while reallocating pools") it
> does not apply cleanly to earlier series.
> 
> For context: There were several reports in Debian about regression in
> 5.10.y already:
> 
> https://bugs.debian.org/1022268
> https://bugs.debian.org/1023183
> https://bugs.debian.org/1025747
> https://bugs.debian.org/1022126
> 
> https://lore.kernel.org/linux-scsi/Y1JkuKTjVYrOWbvm@eldamar.lan/ is
> the initial reporting to upstream and later on brought as well to the
> regression list:
> 
> https://lore.kernel.org/regressions/754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info/
> 
> Thorsten suggested to first get the patch applied at least in 6.1.y
> but for further steps down we need help. Sreekanth and Martin is this
> still on your radar? Help with getting this back to 5.10.y would be
> welcome, and I'm sure with a tentative patch I can get some of the
> reporting users to report a Tested-by.

It only applies to 6.1.y, I would need a working backport to apply it to
any older kernels.

thanks,

greg k-h
