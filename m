Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201B87F054
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfHBJVW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 2 Aug 2019 05:21:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:55261 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbfHBJVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:21:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 02:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,337,1559545200"; 
   d="scan'208";a="167180016"
Received: from jlahtine-desk.ger.corp.intel.com (HELO localhost) ([10.252.3.11])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2019 02:21:20 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Greg KH <gregkh@linuxfoundation.org>
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
In-Reply-To: <20190729174942.GC19326@kroah.com>
Cc:     stable@vger.kernel.org
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
 <20190726073556.9011-4-joonas.lahtinen@linux.intel.com>
 <20190729174942.GC19326@kroah.com>
Message-ID: <156473767943.19842.6156797142016064438@jlahtine-desk.ger.corp.intel.com>
User-Agent: alot/0.7
Subject: Re: [PATCH 3/8] drm/i915/userptr: Acquire the page lock around
 set_page_dirty()
Date:   Fri, 02 Aug 2019 12:21:19 +0300
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2019-07-29 20:49:42)
> On Fri, Jul 26, 2019 at 10:35:51AM +0300, Joonas Lahtinen wrote:
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> > set_page_dirty says:
> > 
> >       For pages with a mapping this should be done under the page lock
> >       for the benefit of asynchronous memory errors who prefer a
> >       consistent dirty state. This rule can be broken in some special
> >       cases, but should be better not to.
> > 
> > Under those rules, it is only safe for us to use the plain set_page_dirty
> > calls for shmemfs/anonymous memory. Userptr may be used with real
> > mappings and so needs to use the locked version (set_page_dirty_lock).
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
> > Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
> > References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
> > (cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)
> 
> This commit id is not in Linus's tree.
> 
> I've stopped here, and dropped patch 1/8 as well.  Please fix these all
> up to have the correct git ids and resend.

My bad. I was first requested to send an extra drm-intel-fixes PR, and
then to send directly to stable.

Now that the pull didn't get accepted, naturaly the IDs don't exist.

I'll send a fixed series.

Regards, Joonas
