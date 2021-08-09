Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D823E4250
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhHIJR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhHIJRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 05:17:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A48A60EE7;
        Mon,  9 Aug 2021 09:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628500604;
        bh=DC1sgYd8g+svyFDZ2shrVuDPwl4OLRGnqOXNK6k07wU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2KI0vnokfw5q6l9wan1a1ZJeQlpx5tky7/FrAJuH4fRpd4tKx7CJtm5iqE67MjtD
         ySHiz75VSMw10Y7pV+1scLcpGAQiIvdULDfTKofJX8+/0NSbe90zei9VC+5PG6iDUJ
         ugtCe4m0GsUauhlKEcwEHMKba8Cw2/LeHFdpv01g=
Date:   Mon, 9 Aug 2021 11:16:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        namhyung@kernel.org, zanussi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing/histogram: Rename "cpu" to
 "common_cpu"" failed to apply to 4.19-stable tree
Message-ID: <YRDyef4mVHpdYjaQ@kroah.com>
References: <1627289097126136@kroah.com>
 <20210806202155.20445a11@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806202155.20445a11@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 08:21:55PM -0400, Steven Rostedt wrote:
> On Mon, 26 Jul 2021 10:44:57 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The below should work for 4.19. I fixed the conflicts and tested it.

Thanks, now queued up.

greg k-h
