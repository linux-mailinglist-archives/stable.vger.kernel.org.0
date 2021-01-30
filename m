Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FCF3096A0
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 17:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhA3QUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 11:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhA3Ptc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 10:49:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24D164DED;
        Sat, 30 Jan 2021 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612020284;
        bh=LwThvucIGjOLsQSrFOF+2+R/stZNcgbNkWB9sGB3MNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zB8KJqu42VGvEtCYwZfH5dPPfnMfxDp+++khYsxBrwOEv1DHvc5FcLFCcNp9Cn+bM
         yS8oZdFX9Id45ebW3iC5YCXo4MqPmdijq1PYSY3hwycnr5GjKLekKsuWi5roPw90Q0
         t3pKcXB9h1R1c/tzsQTEEoAmm8xBFvdp7HaAfj0E=
Date:   Sat, 30 Jan 2021 16:24:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Roger Pau Monne <roger.pau@citrix.com>
Cc:     stable@vger.kernel.org, xen-devel@lists.xenproject.org,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH for-4.19.y] xen/privcmd: allow fetching resource sizes
Message-ID: <YBV6OeEQwG0gLEfY@kroah.com>
References: <YBPlDmlJTK78clC3@kroah.com>
 <20210129122215.19482-1-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129122215.19482-1-roger.pau@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 01:22:15PM +0100, Roger Pau Monne wrote:
> commit ef3a575baf53571dc405ee4028e26f50856898e7 upstream.
> 

Now queued up, thanks.

greg k-h
