Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE574A401E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbiAaK2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiAaK2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EDEC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 02:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D963E6137F
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA60DC340E8;
        Mon, 31 Jan 2022 10:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643624886;
        bh=uxkfgI/QM530ovJw3K1EFaGsFJK+GcvLvIa/6V6fPPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TkSI5zrx6h/mEjIdI15j2ybDQ+L/N1qD0SpLRvYrmsOthKu4Gz6vE6K4yHo6NNvIt
         noW8/c6ztAUKaUZLTjczGfnyrvwEgy5OP+PjkUlX+iO/lYKjjgZRMtK84Ft0xmu78G
         Z3dNu/+8hffhz+QPPeZ5mt5csrhqlpJeqXxt5QuQ=
Date:   Mon, 31 Jan 2022 11:28:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Ivan Delalande <colona@arista.com>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fsnotify: invalidate dcache before
 IN_DELETE event" failed to apply to 5.15-stable tree
Message-ID: <Yfe5swDkt3y3s7YI@kroah.com>
References: <1643460962165139@kroah.com>
 <CAOQ4uxjxcrQ9FdDQBR5pVPJfnkgbWaG8bqXWDbi_g1eOxE6tGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxcrQ9FdDQBR5pVPJfnkgbWaG8bqXWDbi_g1eOxE6tGw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 10:05:00PM +0200, Amir Goldstein wrote:
> On Sat, Jan 29, 2022 at 2:56 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> 
> 5.15 backport patch attached.

All backports now queued up, thanks!

greg k-h
