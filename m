Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27891316E9
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 18:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFRj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 12:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAFRj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 12:39:58 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068D02072A;
        Mon,  6 Jan 2020 17:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578332398;
        bh=mp3njqqWaDnYVqjwsBT3p6zCZ56gkals5HKkvF6a1ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5aT7lm7/MMoXmgtSNrDVAYvbnTlbzOYE6saqA0AgNlMeuNCeTzGj5whxAdMe1qdN
         +RatoW1NGYV+jvMO4EFxd2Y9JH6qwTO0F9UHmiEe7DBQXlV9dfJSMtHgi8DjjtJ3RT
         5Oe5KfeWEkkG9GYhvpBfYnKCb9xE+4loWw800cFA=
Date:   Mon, 6 Jan 2020 17:39:53 +0000
From:   Will Deacon <will@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Amanieu d'Antras <amanieu@gmail.com>, will.deacon@arm.com,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
Message-ID: <20200106173953.GB9676@willie-the-truck>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-3-amanieu@gmail.com>
 <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 07:01:33PM +0100, Christian Brauner wrote:
> On Thu, Jan 02, 2020 at 06:24:08PM +0100, Amanieu d'Antras wrote:
> > This is required for clone3 which passes the TLS value through a
> > struct rather than a register.
> > 
> > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: <stable@vger.kernel.org> # 5.3.x
> 
> This looks sane to me but I'd like an ack from someone who knows his arm
> from his arse before taking this. :)

That's *ME*! Code looks fine:

Acked-by: Will Deacon <will@kernel.org>

I also ran the native and compat selftests but, unfortunately, they all
pass even without this patch. Do you reckon it would be possible to update
them to check the tls pointer?

Will
