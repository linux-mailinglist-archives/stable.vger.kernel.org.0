Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4D92B5E8C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgKQLno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQLnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:43:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A755F2225E;
        Tue, 17 Nov 2020 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605613423;
        bh=C7rZjhSJZEXR0vJQjvW+GUKsH6jZR4EusJTYA5cjmSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=laC46FxYp6rrb5K0+AbNbTywV2sjzUu/9GqzpbV3HXtCvm38VqLKjiucf0fPywVTo
         uaAN3Av5Gv2jHOpuvPbmgrWIVoLyHerGLItkFZrZEvD/4L5Is7oDBiHAUyiT+9XxR1
         fsuvNoku/asJD8W7fcNOuL6TS+z4Qbq5RaQSSwrI=
Date:   Tue, 17 Nov 2020 12:44:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>,
        Wade Mealing <wmealing@redhat.com>
Subject: Re: backport of f91072ed1b72 for v4.14.y+
Message-ID: <X7O3nnzKjJHBqfgb@kroah.com>
References: <20201113152542.o6ai3npqaucp425a@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113152542.o6ai3npqaucp425a@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 03:25:42PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> Please consider the attached backport of
> f91072ed1b72 ("perf/core: Fix race in the perf_mmap_close() function")
> for v4.14.y, v4.19.y and v5.4.y
> This will not apply in v4.9.y and v4.4.y and I am sending separate backport
> for that.

All are now queued up, thanks.

greg k-h
