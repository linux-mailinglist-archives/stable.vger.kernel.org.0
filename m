Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6164696FD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 14:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhLFNal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbhLFNal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:30:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87DAC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 05:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB02B810AB
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB5FC341C2;
        Mon,  6 Dec 2021 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638797230;
        bh=YR2GAznDiPBtGcnqJAJ4FF3tUdCZQqnBxG3DdtZ04YM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZg3pYPMLo8yuio9mPplq5Qxgubsf8GqP4fl2TlMxiZxurnerNOm5i2+9hNN6JheG
         bJ90FVpga8e8dVWYL1EVwcGBhtVULbHZ5GgPKXNDjcMm0xp0/IiJKgm6Ky066vkhgm
         xDFHVkwqw8qHSV7T8R11/XL/BRlbwiaXSozY7HCI=
Date:   Mon, 6 Dec 2021 14:27:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Lindroth <thomas.lindroth@gmail.com>
Cc:     stable@vger.kernel.org, keescook@chromium.org
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported
 to 5.10?
Message-ID: <Ya4PqyRnxqB+5VaV@kroah.com>
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
 <Ya4KYD9lpKaQI9G7@kroah.com>
 <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 02:24:29PM +0100, Thomas Lindroth wrote:
> On 12/6/21 14:04, Greg KH wrote:
> > On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
> > > Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
> > > Gentoo and Arch apply their own patch to fix the problem in their distribution
> > > kernels but I would prefer if a proper fix was applied upstream.
> > > 
> > > https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
> > > 
> > > I've searched for any upstream discussions about the problem but I've only found
> > > one message saying the backport needs an additional fix. That was almost a year
> > > ago. https://www.spinics.net/lists/stable/msg438000.html
> > 
> > We can not take a patch in a stable kernel release unless it is already
> > in Linus's tree.  Please work to get a patch accepted there first,
> > before worrying about older kernel versions.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> The problem was fixed in Linus tree in commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470
> "gcc-plugins: fix gcc 11 indigestion with plugins..." added in v5.11
> 
> That's the patch that needed some kind of additional fix before it could be backported
> but that fix never materialized.

If you have a working version, based on a distro's use, please provide
it and I will be glad to pick it up.

thanks,

greg k-h
