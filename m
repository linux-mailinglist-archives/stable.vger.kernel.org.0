Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61ABDBE321
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440213AbfIYRLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 13:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440080AbfIYRLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 13:11:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539DF214DA;
        Wed, 25 Sep 2019 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569431503;
        bh=hQA0aRzeQdHAavPE0eJm3ImQ+tsG1lnWITYrz6O1gxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xl1/PYm/cZ1FBOc6fkUwpuKar8JooHg9Mi4DuDSCS04nQAFFiFU0zX1IqhqVicReQ
         ev8aoteaX1hlm0oTgZIlbdCcyj0A+Qt8j+AtnWGjsSqUljoPnYjtk3SxpLPpiGDgab
         qFCN5P/wK/g+2D7ZtCsIE/F2OFLOj+PY+D4Dq98U=
Date:   Wed, 25 Sep 2019 19:11:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: Request for inclusion of f73b3cc39c84 ("objtool: Clobber user
 CFLAGS variable") in -stable
Message-ID: <20190925171141.GC1499213@kroah.com>
References: <20190925164047.GA471117@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925164047.GA471117@archlinux-threadripper>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 09:40:47AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> We received a report of an objtool build failure with clang related to
> -Wunused-parameter [1], which turned out to be related to the distro's
> CFLAGS. Josh patched this up in commit f73b3cc39c84 ("objtool: Clobber
> user CFLAGS variable"), could it be added to -stable whenever
> applicable? Looks like it will pick cleanly to 4.19 but it can be
> applied to 4.14 with context differences.

Now queued up, thanks.

greg k-h
