Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FBC79293
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfG2Rtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfG2Rtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 13:49:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126EF21655;
        Mon, 29 Jul 2019 17:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564422584;
        bh=kUjabzzm8akMz5ZnqpPMhsmdp3Rt8NQCmeiQ1XFVGa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxB3E3D2qw8+317O24pvuMCRUWC+BQqsRMyRTkl261PJQ/uvS6++7Zw/eUUK0JHHL
         gxB9SWL3fGI7g/8RCUon/mCShfDcCR9Wk7Gt1mvb9BO+1mTzILKoGGwJVlifZVtwer
         T5WkS9WVqMm9fHE/QwIcrdOuFMYY+7WNYgr9Oftc=
Date:   Mon, 29 Jul 2019 19:49:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/8] drm/i915/userptr: Acquire the page lock around
 set_page_dirty()
Message-ID: <20190729174942.GC19326@kroah.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
 <20190726073556.9011-4-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726073556.9011-4-joonas.lahtinen@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 10:35:51AM +0300, Joonas Lahtinen wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> set_page_dirty says:
> 
> 	For pages with a mapping this should be done under the page lock
> 	for the benefit of asynchronous memory errors who prefer a
> 	consistent dirty state. This rule can be broken in some special
> 	cases, but should be better not to.
> 
> Under those rules, it is only safe for us to use the plain set_page_dirty
> calls for shmemfs/anonymous memory. Userptr may be used with real
> mappings and so needs to use the locked version (set_page_dirty_lock).
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
> Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
> References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
> (cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)

This commit id is not in Linus's tree.

I've stopped here, and dropped patch 1/8 as well.  Please fix these all
up to have the correct git ids and resend.

thanks,

greg k-h
