Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6DF3250B1
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 14:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBYNpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 08:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbhBYNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 08:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E62164F06;
        Thu, 25 Feb 2021 13:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614260700;
        bh=EHaa57Mq515sZhmJpb1e3H18aBjdFZQba2opud+5bW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L3GiawtVDRvs5Q/beMG15ARLJrbFLkGZvTzXGHBOiNUsWIewa9ph61pnG16hYRV49
         fjtm4xUV0+724nnSol07PcfyG326bmTa/DmW2h8wX+u0Kg1pSFGLf8VwND/C8kwXp9
         D4NvxXInO4jqGkEvlRAe6KHH8p+NEjgGLv/iauY8=
Date:   Thu, 25 Feb 2021 14:44:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 0/1] Bluetooth: btusb: Some Qualcomm Bluetooth
 adapters stop working
Message-ID: <YDep2EFvaTwFpbVN@kroah.com>
References: <20210225133545.86680-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225133545.86680-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 02:35:44PM +0100, Hans de Goede wrote:
> Hi Greg,
> 
> Here is a cherry-pick of a bluetooth fix which just landed in Linus' tree.
> 
> A lot of users are complaining about this:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=210681
> 
> It would be good if we can get this added to the 5.10.y and 5.11.y series.
> Older kernels are not affected unless the commit mentioned by the Fixes
> tag was backported.
> 
> I've based this cherry-pick on top of 5.10.y, it should also apply cleanly
> to 5.11.y.


This is already in the 5.10 and 5.11 -rc1 kernels I released a few hours
ago :)

thanks,

greg k-h
