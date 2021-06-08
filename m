Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8848639F9C9
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhFHPAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233475AbhFHPAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 11:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C490461183;
        Tue,  8 Jun 2021 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623164330;
        bh=Rko9zOLDsqdYcZOkT0K37pGxicqfRWlz7uPLuW9AA2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tin/F90kD/NQtf9KaZhzUTAsVzozy0sIBTVcTs/6RHER0X6yjWqXKkf0Cja8spYrQ
         J5OKk7gBFMZCQ1h3UCZIkqXk0itxK5PmylIHWUeykTz94Zts3MtYRQtP3q1aN13I0i
         0Ms7a5zjBDBrkL02FO1A9ciiHamDYSCt8Nj6YFzk=
Date:   Tue, 8 Jun 2021 16:58:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     stable@vger.kernel.org
Subject: Re: [5.4 PATCH 0/4] Fix a CONFIG_READ_ONLY_THP_FOR_FS bug
Message-ID: <YL+Fp7LjV8SHcq4T@kroah.com>
References: <20210607200845.3860579-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607200845.3860579-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 09:08:41PM +0100, Matthew Wilcox (Oracle) wrote:
> This experimental feature has had a few bugs, but it has enough of
> a performance effect that customers are actually asking for it to be
> enabled.  So we should apply this upstream bugfix that needs a little
> massaging to backport.  The first three patches enable the fix in the
> fourth patch.  I've run the XArray test-suite after applying these
> patches, and it continues to pass.
> 
> Matthew Wilcox (Oracle) (4):
>   mm: add thp_order
>   XArray: add xa_get_order
>   XArray: add xas_split
>   mm/filemap: fix storing to a THP shadow entry
> 
>  Documentation/core-api/xarray.rst |  16 ++-
>  include/linux/huge_mm.h           |  19 +++
>  include/linux/xarray.h            |  22 ++++
>  lib/test_xarray.c                 |  65 ++++++++++
>  lib/xarray.c                      | 208 ++++++++++++++++++++++++++++--
>  mm/filemap.c                      |  37 ++++--
>  6 files changed, 342 insertions(+), 25 deletions(-)
> 
> -- 
> 2.30.2
> 

Now queued up, thanks.

greg k-h
