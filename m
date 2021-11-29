Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189154626CD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbhK2W5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbhK2W5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74614C03AD6F
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 10:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E4B3B815B0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 18:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77001C53FAD;
        Mon, 29 Nov 2021 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638209638;
        bh=F+WfkWfrxxnIhMlyNpExanRvNwfWDNap8xamGA8a5cQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UsVPD6/9hEJi2Btrc/oHhwFMXnhqB/92eu2VqHUUMVsw0cp/4CJYCiDQA5nb+N0q+
         VWOWgLa1XeFLdpQ1SA97eCHCPazkXapcTUGfJLYCpE523uX2W4W6dfBSCk4bL6vTID
         YZQ0tkYoz3gfOb3KGP29UVFxdvcBir/ONFif0FWY=
Date:   Mon, 29 Nov 2021 19:13:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: Stable backports of Xen related patches
Message-ID: <YaUYYzzPR5p7ePZU@kroah.com>
References: <bb28bab1-eb2e-0dde-3a59-6b5c25e3744d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb28bab1-eb2e-0dde-3a59-6b5c25e3744d@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 04:15:31PM +0100, Juergen Gross wrote:
> Hi Greg,
> 
> attached are git bundles for some patches you merged into the 5.10
> stable kernel already this morning.
> 
> Naming should be obvious, the patches are on the branch "back" in
> each bundle.

All now queued up, thanks!

greg k-h
