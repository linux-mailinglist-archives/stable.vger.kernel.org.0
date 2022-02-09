Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2B14AF24B
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 14:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiBINE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 08:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiBINE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 08:04:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C631C0613CA
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 05:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33BAEB820FD
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 13:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1BAC340E7;
        Wed,  9 Feb 2022 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644411897;
        bh=YnUUWyk2nTjYbbeZ80UorVPqrC1WUjlD5h/jYG29Ips=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yNrkUqfJIBKAUjNLIWWzu1R4X87G4USax8f24JxDJw7nKLFY9IfaN+L9DKcWhu2CU
         cdOdp+3pzf4gxVtVeizDDH39t6AG8EkO1xnReT7U4zuyuHJi/FZ/+U89/nP4EudIpK
         z8lw2kDJziyyFue4sZfUpPAVhCXkV48zDzak9y6Y=
Date:   Wed, 9 Feb 2022 14:04:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     stable@vger.kernel.org,
        "Justin M . Forbes" <jforbes@fedoraproject.org>
Subject: Re: [GIT PULL] ata fixes for 5.17-rc4
Message-ID: <YgO796xekEJ5f+bK@kroah.com>
References: <20220207140450.1072531-1-damien.lemoal@opensource.wdc.com>
 <13bf2b16-9a7a-9e6a-4c40-cb5e3a8ca061@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13bf2b16-9a7a-9e6a-4c40-cb5e3a8ca061@opensource.wdc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 04:48:08PM +0900, Damien Le Moal wrote:
> On 2/7/22 23:04, Damien Le Moal wrote:
> > Linus,
> > 
> > The following changes since commit dfd42facf1e4ada021b939b4e19c935dcdd55566:
> > 
> >   Linux 5.17-rc3 (2022-02-06 12:20:50 -0800)
> > 
> > are available in the Git repository at:
> > 
> >   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata tags/ata-5.17-rc4
> > 
> > for you to fetch changes up to fda17afc6166e975bec1197bd94cd2a3317bce3f:
> > 
> >   ata: libata-core: Fix ata_dev_config_cpr() (2022-02-07 22:38:02 +0900)
> > 
> > ----------------------------------------------------------------
> > ata fixes for 5.17-rc4
> > 
> > A single patch in this pull request, from me, to fix a bug that is
> > causing boot issues in the field (reports of problems with Fedora 35).
> > The bug affects mostly old-ish drives that have issues with read log
> > page command handling.
> > 
> > ----------------------------------------------------------------
> > Damien Le Moal (1):
> >       ata: libata-core: Fix ata_dev_config_cpr()
> 
> Greg,
> 
> Could you please pick-up this patch for 5.16 as soon as possible ?
> The bug it fixes is affecting some Fedora users, among others.
> 
> The commit ID in Linus tree is:
> 
> commit fda17afc6166e975bec1197bd94cd2a3317bce3f
> Author: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Date:   Mon Feb 7 11:27:53 2022 +0900
> 
>     ata: libata-core: Fix ata_dev_config_cpr()
> 
> Thanks !

Now picked up, thanks.

greg k-h
