Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE63EC8D3
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhHOLoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhHOLoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C5261038;
        Sun, 15 Aug 2021 11:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027812;
        bh=hEhPaJjW7ieAIe+T1TNBdywiuYr7OTXX5D713RIxwo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8a9l5wBdZq/mgbbziPVIzyGFU2mmN+Cl9zFT0VzHjdNpdpMvlxHBfY+dl3CdhqG9
         CtNjy/jK36ejlIPvb8hEoYvG9SkvKr62xJuaN/UMCFJ3NHrSxJes7XD4zx92N1v8n1
         qzJI7xg6AFiCVlJSTd0DiwvkIzWuN/A2rgJgFo6c=
Date:   Sun, 15 Aug 2021 13:43:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.10 12/19] vboxsf: Make vboxsf_dir_create() return the
 handle for the created file
Message-ID: <YRj93JpbfFgAjVyu@kroah.com>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150523.032839314@linuxfoundation.org>
 <20210813193158.GA21328@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813193158.GA21328@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 09:31:58PM +0200, Pavel Machek wrote:
> Hi!
> 
> > commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream
> > 
> > Make vboxsf_dir_create() optionally return the vboxsf-handle for
> > the created file. This is a preparation patch for adding atomic_open
> > support.
> 
> Follow up commits using this functionality are in 5.13 but not in
> 5.10, so I believe we don't need this in 5.10, either?

It was asked to be backported, so I'll leave it in for now, thanks.

greg k-h
