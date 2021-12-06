Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540E646963E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 14:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbhLFNIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:08:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57376 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243759AbhLFNIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:08:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A008B810A9
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BCC341C1;
        Mon,  6 Dec 2021 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638795875;
        bh=NUSiVGSOX/Gjrz6o2BTwAEoia4KORjAG0nnFsCCpYB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YLXD1dOlR/mb6HCcNCft8NGBHJ3BzLu5kpVY5SEvd+DBfcdN9TauI0+wAI35VGoCm
         PUKYZT0iuwsWel9olujWIItWlIRju1cInCIVmLRYKUwYPjEPphV2/Inid9KF26zng9
         2K36vKoJfaOVn2XCV+ygFCBtvh+XOd1V8ZQWtqmw=
Date:   Mon, 6 Dec 2021 14:04:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Lindroth <thomas.lindroth@gmail.com>
Cc:     stable@vger.kernel.org, keescook@chromium.org
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported
 to 5.10?
Message-ID: <Ya4KYD9lpKaQI9G7@kroah.com>
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
> Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
> Gentoo and Arch apply their own patch to fix the problem in their distribution
> kernels but I would prefer if a proper fix was applied upstream.
> 
> https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
> 
> I've searched for any upstream discussions about the problem but I've only found
> one message saying the backport needs an additional fix. That was almost a year
> ago. https://www.spinics.net/lists/stable/msg438000.html

We can not take a patch in a stable kernel release unless it is already
in Linus's tree.  Please work to get a patch accepted there first,
before worrying about older kernel versions.

thanks,

greg k-h
