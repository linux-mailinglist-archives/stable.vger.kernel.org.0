Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18B7969FB
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 22:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbfHTUMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 16:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTUMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 16:12:00 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C5322D6D;
        Tue, 20 Aug 2019 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566331919;
        bh=ExTpjxl95BHuIeXr+si/zsfmI/OB5NNAjcUN69LdO0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OlafGnXY8kaSlj+9HWDShnKdg+qe9Fmo33iDVe99/qfigB5U/wJGR7ffY45gRHL/9
         cYvv3DfSubrjY6W+eWZBlXgvJzMEUXGs8x1AU7JmpSlBv2ObenuK0vPKDpB2PgSL8Z
         D5hPN4E2//gb4vEk6TaEX7rKpGJuNDXYq3pvDR4g=
Date:   Tue, 20 Aug 2019 13:11:58 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: Please apply commit 3c047057d120 ("asm-generic: default
 BUG_ON(x) to if(x)BUG()") to v4.4.y
Message-ID: <20190820201158.GA19134@kroah.com>
References: <79c1d071-b13a-455f-bc7a-b32387a002d2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79c1d071-b13a-455f-bc7a-b32387a002d2@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 11:36:25AM -0700, Guenter Roeck wrote:
> Please apply commit 3c047057d120 ("asm-generic: default BUG_ON(x) to if(x)BUG()")
> to linux-4.4.y.
> 
> The commit is somewhat related to commit 173a3efd3edb ("bug.h: work
> around GCC PR82365 in BUG()") which has already been applied to v4.4.y.
> That patch assumes that commit 3c047057d120 is applied as well.
> 
> Commit 3c047057d120 avoids warnings such as
> 
> arch/x86/kernel/irqinit.c:157:2: warning: if statement has empty body [-Wempty-body]
> 
> which are reported randomly by 0day build reports. Besides, as Arnd
> points out in the commit, it avoids random behavior with CONFIG_BUG=n.

Now queued up, thanks!

greg k-h
