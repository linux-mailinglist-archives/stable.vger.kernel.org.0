Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65CD04D5
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 02:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfJIAkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 20:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfJIAkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 20:40:13 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C7120859;
        Wed,  9 Oct 2019 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570581612;
        bh=jeumQEEYtKwWj7qBx4yIZ1yzV5MYEDEXaPah+wn/xW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJVKM1ZbuuF9YFaZ45ZyOOjAcghN+cZIiJA/9d9BUeZWxfxF4cWPWcpW/ZJYvbo+4
         dSMF2yFk2Mmoma/frpzxUKlyQsfORz1rgmmGxpkM1hH67BnYxlPwdBzj6Jw9I7fWYu
         idIjK2F2dXaUl++NTaBNRem5RXbCnJqakLnWHI2E=
Date:   Tue, 8 Oct 2019 20:40:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915/userptr: Acquire the page lock
 around" failed to apply to 4.19-stable tree
Message-ID: <20191009004012.GP1396@sasha-vm>
References: <157055550499113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157055550499113@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 07:25:04PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From cb6d7c7dc7ff8cace666ddec66334117a6068ce2 Mon Sep 17 00:00:00 2001
>From: Chris Wilson <chris@chris-wilson.co.uk>
>Date: Mon, 8 Jul 2019 15:03:27 +0100
>Subject: [PATCH] drm/i915/userptr: Acquire the page lock around
> set_page_dirty()
>
>set_page_dirty says:
>
>	For pages with a mapping this should be done under the page lock
>	for the benefit of asynchronous memory errors who prefer a
>	consistent dirty state. This rule can be broken in some special
>	cases, but should be better not to.
>
>Under those rules, it is only safe for us to use the plain set_page_dirty
>calls for shmemfs/anonymous memory. Userptr may be used with real
>mappings and so needs to use the locked version (set_page_dirty_lock).
>
>Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
>Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
>References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
>Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk

File got moved around. I've fixed it up and queued for 4.19-4.4.

-- 
Thanks,
Sasha
