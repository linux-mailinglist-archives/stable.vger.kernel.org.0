Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E452E30F7
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 12:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgL0LmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 06:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgL0LmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 06:42:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7192250F;
        Sun, 27 Dec 2020 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609069289;
        bh=IG0AJFLNl2ql8ev+cer6CWAdCIZ4Psx8OjzIt2HKuiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMjYwQSfDwI3mbftgN1L2s2beBF04cuKfHky17Wfwlz0XGKiJj7UvWv2lp97wjdNA
         irCJQMWbuGHW2fJrwAXI5IYSSnzDzvFMsbffe+qFZPRMESyB0W42IvqWMvaHQxaxWf
         wb445s7TWPDiUMBx8m2yn8fD8wKLu7S6QIeDTqK8=
Date:   Sun, 27 Dec 2020 12:42:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH 4.19.y only 0/2] Fix perf build failures
Message-ID: <X+hzPfhC4RCNCsU2@kroah.com>
References: <20201227092745.447945-1-carnil@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201227092745.447945-1-carnil@debian.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:27:43AM +0100, Salvatore Bonaccorso wrote:
> Hi Greg, Sasha and all,
> 
> This is a resubmit of the patches already done in 
> https://lore.kernel.org/stable/20201125201215.26455-1-carnil@debian.org/
> and
> https://lore.kernel.org/stable/20201125201215.26455-2-carnil@debian.org/
> 
> The issue can be explained as this. In
> 
> https://lore.kernel.org/stable/20201014135627.GA3698844@kroah.com/
> 
> on request 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global
> variable from header file") was queued back to 4.19.y to fix build failures for
> perf with more recent GCCs.
> 
> But for 4.19.y this was wrong because it missed to pick as well a dependency
> needed, and in turn it caused build failures with older GCC (8.3.0 as used in
> Debian stable in that case).
> 
> The commit was reverted in a later in 4.19.159.
> 
> It as though requested to try to allow as well compilation with more recent
> GCCs (while obviously not breaking older GCC builds) and found that the cause
> was just the missing dependency to pick up, namely pick 95c6fe970a01 ("perf
> cs-etm: Change tuple from traceID-CPU# to traceID-metadata") before
> 168200b6d6ea ("perf cs-etm: Move definition of 'traceid_list' global variable
> from header file").

Thanks for these, both now queued up.

greg k-h
