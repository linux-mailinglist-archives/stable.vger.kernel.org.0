Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3C292807
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 15:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgJSNSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 09:18:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgJSNSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 09:18:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603113524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v7WfNYUczwmH5kd5aVp7TEjtwO+BlARGhkxvUJGVTF0=;
        b=GD0WHEFrCzHMg5Z0lQPfieggrhYlzjuX855mHBK97YmlA1j7G7uzqYtkKXsUj9o8vOwWe3
        yhdqR/DCHUPH/woBF0h8XxL8eXKaMXFmKfS/KJh6IpOzs8dDshVhrBGIyVDAcqXvMSLeDv
        NrL90hTRKpHYke2rvNy4kyQHhKoflM0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3006FB7F1;
        Mon, 19 Oct 2020 13:18:44 +0000 (UTC)
Date:   Mon, 19 Oct 2020 15:18:43 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] reboot: fix overflow parsing reboot cpu number
Message-ID: <20201019131843.GB26718@alley>
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
 <20201016180907.171957-2-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016180907.171957-2-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2020-10-16 20:09:06, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Limit the CPU number to num_possible_cpus(), because setting it
> to a value lower than INT_MAX but higher than NR_CPUS produces the
> following error on reboot and shutdown:
> 
> Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
