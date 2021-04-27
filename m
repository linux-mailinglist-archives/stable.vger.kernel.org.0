Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF0736C5B3
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 14:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhD0MBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 08:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235570AbhD0MBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 08:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E2460C3D;
        Tue, 27 Apr 2021 12:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619524840;
        bh=39+t0rsOHthwOpjrgh0xXcdXrqwITUFi00USMiuLJTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xh/mqjxx4CuvABUzlj3q5P9QvgXWv1I+3DoIK9TED2nAmzH/daXj6c9NxxZja2YMD
         pvUZUztniPER9cU1Kj4sAwIQZZvnHD97gdf9uwAJZG6uZQIxV+hjUa3s86zB9XW4dM
         6EwmV0viSOlYgCtrvLVa2z4FPaYfFvNjRdiN5O4g=
Date:   Tue, 27 Apr 2021 14:00:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH 081/190] Revert "tracing: Fix a memory leak by early
 error exit in trace_pid_write()"
Message-ID: <YIf85WityBIzMtgh@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-82-gregkh@linuxfoundation.org>
 <20210421092919.2576ce8d@gandalf.local.home>
 <20210421093343.2c52786a@gandalf.local.home>
 <YIAt/0Fb0QjpNubP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIAt/0Fb0QjpNubP@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 03:51:59PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 21, 2021 at 09:33:43AM -0400, Steven Rostedt wrote:
> > On Wed, 21 Apr 2021 09:29:19 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > Just to clear up any confusion about my tag above. It was a second review
> > of the original patch, not for the revert.
> 
> Fair enough, I'll handle it, thanks!

Revert is now dropped from my tree, thanks for the review.

greg k-h
