Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC58D1150B2
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfLFMym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 07:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfLFMym (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 07:54:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CAC521835;
        Fri,  6 Dec 2019 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575636881;
        bh=NEcjCDyIvlbl97UOsmmudN8sS35eF0UdcQocv0zHXow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F6rrqByBZf5s9BiXwapZUvCbdI+VSnSkQUtnM+EDdccg30jdBu3WNAbwDdDD0zmPw
         1h6p418Mw/4WyEVwr5JT0Gzx65rpaGJ+wsm9mGURB935bW2c0AYL+ZJ+GckEfX5YBn
         OnksWPTkwR6/W5NwPnVl/H6E0b9SVfogihT4OCDw=
Date:   Fri, 6 Dec 2019 13:54:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] perf scripts python: exported-sql-viewer.py: Fix use of
 TRUE with SQLite
Message-ID: <20191206125438.GB1361962@kroah.com>
References: <20191202082150.22290-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202082150.22290-1-adrian.hunter@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 10:21:50AM +0200, Adrian Hunter wrote:
> commit af833988c088d3fed3e7188e7c3dd9ca17178dc3 upstream
> 
> Prior to version 3.23 SQLite does not support TRUE or FALSE, so always
> use 1 and 0 for SQLite.
> 
> Fixes: 26c11206f433 ("perf scripts python: exported-sql-viewer.py: Use new 'has_calls' column")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: stable@vger.kernel.org # v5.3+
> Link: http://lore.kernel.org/lkml/20191113120206.26957-1-adrian.hunter@intel.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> [Adrian: backported to v5.3, v5.4]
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/scripts/python/exported-sql-viewer.py | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Now queued up, thanks!

greg k-h
