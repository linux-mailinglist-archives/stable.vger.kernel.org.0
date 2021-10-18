Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601BE431FAB
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhJROcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhJRObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D03DF60FC2;
        Mon, 18 Oct 2021 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634567379;
        bh=LwAYPvH8iNXekufOplxrIYp7b6iQyhawXmBd/s6B5uI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cqqMVoQbv1CLgE14UD9kMrf09PfP66hR8ciP5oWvxK4TuIPeaETO7nDAaWe2UnfUN
         VmwVDW1YGKQ9aUq2WROaFft8h2Rh1ZISpdJViiMypOiRM1WQ+WckL890EwYySw1sjm
         J3WB1HKQArcIQY0U4m9TQVf3S72SdtbhYxW9Ggoc=
Date:   Mon, 18 Oct 2021 16:29:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: Queues: mdp5_crtc.c:1058:31: error:
 'mdp5_crtc_get_vblank_counter' undeclared here (not in a function); did you
 mean 'mdp5_crtc_vblank_on'?
Message-ID: <YW2E0cOi6Ya4T3TD@kroah.com>
References: <CA+G9fYusztaOSJJxr5WuGOueDBaAxmerU99FSjh4Pf6JOFOQfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYusztaOSJJxr5WuGOueDBaAxmerU99FSjh4Pf6JOFOQfg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 07:30:47PM +0530, Naresh Kamboju wrote:
> Following build errors noticed while building Linux stable rc queue
> with gcc-11 for arm and arm64 architecture.
>   - 5.4.154 gcc-11 arm FAILED
>   - 5.4.154 gcc-11 arm64 FAILED
>   - 4.19.212 gcc-11 arm FAILED
>   - 4.19.212 gcc-11 arm64 FAILED

Thanks, I'll go drop the offending patch from both queues now and push
out a -rc2.

greg k-h
