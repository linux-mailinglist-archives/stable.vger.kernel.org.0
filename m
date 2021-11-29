Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D52461BA0
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 17:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343754AbhK2QRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 11:17:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58394 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345105AbhK2QPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 11:15:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCED61599
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E42CC53FAD;
        Mon, 29 Nov 2021 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638202327;
        bh=4CGD3LQcHnrGDtH5gXVxc/KZDOULArNrgMPu2fX1AKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAbWcnasHlGAcjn2zGfaLS9OtspM4arywj9cAeGupxrUHLLn+QVZnO16JXKWXgld9
         xNgwZ2znir31oZgdEdgLvNj2LZPaj+eF9pb96gOK9FXV3m1Fu80lXU5pstp8UIi98N
         ZBCxce3G1G3uLiw5WhFj9JiNv6xIh4vrUrjCNkDc=
Date:   Mon, 29 Nov 2021 17:12:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fuse: release pipe buf after last use"
 failed to apply to 4.9-stable tree
Message-ID: <YaT705/mRSnUUi7c@kroah.com>
References: <163801865313345@kroah.com>
 <CAOssrKdrJgV+m9yFee6SHMFU2W8zs4vrKotkn5kD+s61Gw9jkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKdrJgV+m9yFee6SHMFU2W8zs4vrKotkn5kD+s61Gw9jkg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 04:46:34PM +0100, Miklos Szeredi wrote:
> On Sat, Nov 27, 2021 at 2:11 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hi Greg,
> 
> Attaching the backport against 4.9.292-rc1.
> 
> Should apply to the 4.14, 4.19 and 5.4 stable trees as well.

Wonderful, thanks for this, now queued up.

greg k-h
