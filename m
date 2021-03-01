Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E502329235
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbhCAUlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:41:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243436AbhCAUdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D1D64DA3;
        Mon,  1 Mar 2021 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614624790;
        bh=3ELhbjMqRRzMMMCjxYb3jrE9yCN1/eAHw8TPFwAgK1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v1zW3X8zlY6cj6ucIok+Ue2b/pCILK0xYZxkFeRkWrNV1K0VYuvvdsicmN9sNP18+
         WPaszXpZaxs3H1RkXTkQN/dKdB56MEepPLiy2UMokAaiUromuwEQzYTIZ+5up61rx4
         IOJSxlOX927LiLJfpHveSSVc7PvEth42ftYMyBZ8=
Date:   Mon, 1 Mar 2021 19:50:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: Re: [PATCH v2] misc: fastrpc: restrict user apps from sending kernel
 RPC messages
Message-ID: <YD03ew7+6v0XPh6l@kroah.com>
References: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
 <YCeM+0JUEPQQkGsF@kroah.com>
 <CAA8EJpo-U74KAyoHY=9wutk=iCOBMv6T1Ez-MEogYdPE6X1yCQ@mail.gmail.com>
 <YD0M4JyBbUrYjFMD@kroah.com>
 <CAA8EJprTwqFWfPMjLrA2T0rJ=D3btLFHwY33VVJka1Og-9UeAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA8EJprTwqFWfPMjLrA2T0rJ=D3btLFHwY33VVJka1Og-9UeAQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 08:45:34PM +0300, Dmitry Baryshkov wrote:
> On Mon, 1 Mar 2021 at 18:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Mar 01, 2021 at 06:34:10PM +0300, Dmitry Baryshkov wrote:
> > > On Sat, 13 Feb 2021 at 11:25, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Fri, Feb 12, 2021 at 10:26:58PM +0300, Dmitry Baryshkov wrote:
> > > > > Verify that user applications are not using the kernel RPC message
> > > > > handle to restrict them from directly attaching to guest OS on the
> > > > > remote subsystem. This is a port of CVE-2019-2308 fix.
> > > >
> > > > A port of the fix of what to what?
> > >
> > > I'm sorry for the confusion. It is a port of the original
> > > Qualcomm/CodeAurora fix to the upstream driver.
> > >
> > > See https://source.codeaurora.org/quic/la/kernel/msm-4.9/commit/?id=cc2e11eeb988964af72309f71b0fb21c11ed6ca9,
> >
> > So this is a fix from 2019 that you never submitted upstream causing all
> > of these kernels to be vulnerable?
> 
> It seems there is some kind of confusion here.
> Srinivas and Thierry have developed the fastrpc driver. It is not the
> same as the driver developed by Qualcomm. However in this case it
> suffers from the same problem as the original adsprpc driver..
> We have submitted the fix as soon as we've noticed the issue.

Ah, that makes more sense, thanks.

So really, it's not the same CVE issue, aren't they fun?  :)

thanks,

greg k-h
