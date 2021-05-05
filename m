Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40D373903
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 13:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhEELIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 07:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhEELIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 07:08:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13772613C3;
        Wed,  5 May 2021 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620212869;
        bh=5CK/VGEIs+HuCMd+YDSNi0UJmbnO+p0BXUbR9qLmRo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/k0g0iGAQuwrqWjCwDgBTyu65sP9KnE1654U0qwOspFx67J4OZ1seZ50SRQtT5uP
         bofLbuPgnd3/kkSFlSdo0aj7yxr+CrzJamOcO7HKDgkCFt+XkOliJaYfhQnN59mmj+
         YMuNtVM7Rm3QzwxjuoaZol1dcfSFnC77f/X5v1Bo=
Date:   Wed, 5 May 2021 13:07:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: Stable backport request - perf/core: Fix unconditional
 security_locked_down() call
Message-ID: <YJJ8g0IKSz1UkZ/Q@kroah.com>
References: <CAFqZXNvt-ezC2hwLC1zOVfgkRwd4483=dXw3k2ALkuRYfR4okA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNvt-ezC2hwLC1zOVfgkRwd4483=dXw3k2ALkuRYfR4okA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 12:58:24PM +0200, Ondrej Mosnacek wrote:
> Hello,
> 
> please consider backporting commit 08ef1af4de5f ("perf/core: Fix
> unconditional security_locked_down() call") to stable kernels, as
> without it SELinux requires an extraneous permission for
> perf_event_open(2) calls with PERF_SAMPLE_REGS_INTR unset.
> 
> The range of target kernel versions is implied by the Fixes: tag.

Now queued up, thanks.

greg k-h
