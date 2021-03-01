Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B2B3282CC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbhCAPth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236819AbhCAPtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 10:49:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE0164D5D;
        Mon,  1 Mar 2021 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614613731;
        bh=+Bxis+ONYci93egO14cf82r4FRYtcyZFGUGkTd/7a0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1QlyahBJyzsO9LGwNjoXnhqOSu3UMh/jh/e1koJSq0tAKQ6dS6cWG46cf1F7eBSeM
         Hz1g5gysEEfzP6wGrAcRNYVFS6MPaPh14IU1yRG6IQyIqPZfHmCt9swGo6jaCgyuX3
         OyfWOZMz3s42VyMW23uysBwsWh/qeGqzTvyArUpw=
Date:   Mon, 1 Mar 2021 16:48:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org
Subject: Re: [PATCH v2] misc: fastrpc: restrict user apps from sending kernel
 RPC messages
Message-ID: <YD0M4JyBbUrYjFMD@kroah.com>
References: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
 <YCeM+0JUEPQQkGsF@kroah.com>
 <CAA8EJpo-U74KAyoHY=9wutk=iCOBMv6T1Ez-MEogYdPE6X1yCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA8EJpo-U74KAyoHY=9wutk=iCOBMv6T1Ez-MEogYdPE6X1yCQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 06:34:10PM +0300, Dmitry Baryshkov wrote:
> On Sat, 13 Feb 2021 at 11:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Feb 12, 2021 at 10:26:58PM +0300, Dmitry Baryshkov wrote:
> > > Verify that user applications are not using the kernel RPC message
> > > handle to restrict them from directly attaching to guest OS on the
> > > remote subsystem. This is a port of CVE-2019-2308 fix.
> >
> > A port of the fix of what to what?
> 
> I'm sorry for the confusion. It is a port of the original
> Qualcomm/CodeAurora fix to the upstream driver.
> 
> See https://source.codeaurora.org/quic/la/kernel/msm-4.9/commit/?id=cc2e11eeb988964af72309f71b0fb21c11ed6ca9,

So this is a fix from 2019 that you never submitted upstream causing all
of these kernels to be vulnerable?

Shouldn't the porting process go the other way, upstream first and then
backport?  That ensures we don't end up with 2 years old bugs like this
:(

Ugh.

What's going to change in the development process of this code to
prevent this from happening again?

thanks,

greg k-h
