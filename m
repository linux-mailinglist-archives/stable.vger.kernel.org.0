Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C0F2B5E95
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgKQLq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgKQLq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:46:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C687B223C7;
        Tue, 17 Nov 2020 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605613616;
        bh=RA823OMY0e0l8Dusldh00cI9X6HAG6r73svdbVR/zz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Je5xwdy2lkOeuX+MOy2ByeA9N0EKtchoOTeM2cq81PX+b02dJ1z03TSgVC7AchJ3p
         5r9YRUbKL6J01OEx/5Kmf1ydDbYER99Dgjq0l79LBq7IMGsi+rka/DCqtGDwlczpwA
         qfaWcOKRdLFVWSg7Lj/sLllb5cXOO02C7E9zAyVo=
Date:   Tue, 17 Nov 2020 12:47:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ebiggers@google.com, jack@suse.cz, tytso@mit.edu,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: fix leaking sysfs kobject after
 failed mount" failed to apply to 4.9-stable tree
Message-ID: <X7O4YJEK5bkchhlp@kroah.com>
References: <160441916384118@kroah.com>
 <20201116193425.nf77zcflt2zzzb62@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116193425.nf77zcflt2zzzb62@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 07:34:25PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Nov 03, 2020 at 04:59:23PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. This will apply to both v4.9.y and v4.4.y.

Now applied, thanks.

greg k-h
