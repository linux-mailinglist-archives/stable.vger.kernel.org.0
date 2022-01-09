Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1A488979
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiAINEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 08:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiAINEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 08:04:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DD8C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 05:04:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC5D60F2A
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 13:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073B9C36AED;
        Sun,  9 Jan 2022 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641733454;
        bh=uJ2vTEct3MNpl4/0EY9AGwMvEyptDbuuDAbEOQeBm64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VWeETtTPoS5fhdpu/142TNOg4AuOuTy2awvlrzpXMn9SxHk+lslLyppWgzdkfOvl/
         9JxjkD+xPIhHKHCpwrXGobqQa1V1WdaYlUTxkq389o8DNo1Mntu3OJ8ZPw6fA2WGmp
         OZ299XPLy2X0P3ZG6iIwixuuOInUDE2cCAHCgdlE=
Date:   Sun, 9 Jan 2022 14:04:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     alexander.deucher@amd.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: disable runpm if we are the
 primary adapter" failed to apply to 5.15-stable tree
Message-ID: <YdrdS4u1jNPho3in@kroah.com>
References: <164165325654138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164165325654138@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 08, 2022 at 03:47:36PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind, there was a pre-requisite patch in the series that this one
relied on.  Next time please mark it as such so that it gives us a hint
as to what is needed to do here.

thanks,

greg k-h
