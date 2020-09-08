Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D41C260AB0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 08:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgIHGQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 02:16:58 -0400
Received: from verein.lst.de ([213.95.11.211]:51470 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbgIHGQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 02:16:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 77E6B68AFE; Tue,  8 Sep 2020 08:16:55 +0200 (CEST)
Date:   Tue, 8 Sep 2020 08:16:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        stable@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ARM: oabi-compat: add epoll_pwait handler
Message-ID: <20200908061655.GC13930@lst.de>
References: <20200907153701.2981205-1-arnd@arndb.de> <20200907153701.2981205-4-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907153701.2981205-4-arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +SYSCALL_DEFINE4(oabi_epoll_wait, int, epfd, struct oabi_epoll_event __user *, events,
> +		int, maxevents, int, timeout)

> +SYSCALL_DEFINE6(oabi_epoll_pwait, int, epfd, struct oabi_epoll_event __user *, events,
> +		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
> +		size_t, sigsetsize)

More pointlessly long lines..

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
