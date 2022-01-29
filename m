Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF14A2E91
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbiA2L6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:58:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38256 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243290AbiA2L63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:58:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B1F60B65
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B5BC340E5;
        Sat, 29 Jan 2022 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457508;
        bh=8L4SOKwOWJOB0yh9y8nQmTaTBRWlj7GnNp/7dNgG5QE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5yowya7EoBp5yXhafCrKalk1UD7nsSAzAWjXwTKoHnxJCJ11DHg53gGORq1sSu4p
         YLtr3qzLw9ufbZxcpFpmdvFKwPbKubpff6Df3+87nm2Iot59mokpo7owiDVboOh47Y
         3wPhRgoK/74XT4/W8MDWXBybxoV2fELRMNv3w44Y=
Date:   Sat, 29 Jan 2022 12:58:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Btrfs fixes for 5.16.x (from 5.17-rc1)
Message-ID: <YfUr4fP5Oe6ddbhq@kroah.com>
References: <20220128143703.GF14046@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128143703.GF14046@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 03:37:03PM +0100, David Sterba wrote:
> Hi,
> 
> I'm not sure when patches get picked from Linus' branch, just in case
> please add the following fixes to 5.16.4. They fix a few user visible
> bugs in defrag, all apply cleanly. Thanks.

We normally wait until they hit a public release in Linus's tree (i.e. a
-rc release), but if you ask we can always take them sooner.

> 6b34cd8e175b btrfs: fix too long loop when defragging a 1 byte file
> b767c2fc787e btrfs: allow defrag to be interruptible
> 484167da7773 btrfs: defrag: fix wrong number of defragged sectors
> c080b4144b9d btrfs: defrag: properly update range->start for autodefrag
> 0cb5950f3f3b btrfs: fix deadlock when reserving space during defrag
> 3c9d31c71594 btrfs: add back missing dirty page rate limiting to defrag

I'll go through and queue these up now, thanks.

greg k-h
