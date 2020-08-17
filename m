Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8D246CA5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgHQQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbgHQQXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:23:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2522054F;
        Mon, 17 Aug 2020 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681385;
        bh=ZveC/QnxD3CYdbZGPgyGMPM23kz51W6BSt6a1YP7hJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsZz3o5q5ElgMyt/tcGtwXpCAPtDzpmmm44dvujnqMiFfQZb4V80n1UwumhHyk0cz
         btqZE7RKZEj4fhPCVNcZESN2VJlffK49LvgNOiK1T3KOx5NzV2aDxukabsyvzJ0N5b
         PBQsDrlbVBvptderi0TLGBgJd3qSMaHhpJbp+L4Y=
Date:   Mon, 17 Aug 2020 18:21:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     jan.kiszka@siemens.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        pedro.principeza@canonical.com
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
Message-ID: <20200817162156.GA715236@kroah.com>
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 12:36:25PM -0300, Guilherme G. Piccoli wrote:
> Hi Greg / Thomas and all involved here. First, apologies for
> necro-bumping this thread, but I'm working a backport of this patch to
> kernel 4.15 (Ubuntu) and then I noticed we have it on stable, but only
> in 4.19+.
> 
> Since the fixes tag presents an old commit (since ~3.19), I'm curious if
> we have a special reason to not have it on long-term stables, like 4.9
> or 4.14. It's a subtle portion of arch code, so I'm afraid I didn't see
> something that prevents its backport for previous versions.

What is the git commit id of this patch you are referring to, you didn't
provide any context here :(

thanks,

greg k-h
