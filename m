Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEEA34A950
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 15:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhCZOLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 10:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhCZOKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 10:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E98BF619BF;
        Fri, 26 Mar 2021 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616767832;
        bh=tg6wqpUQLTq0MVUDEswX9U7R74oCgx7H2mv1qSOusbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svD1ak7iD7YvJ7T2ll8CXZkE1vdrnBje0/WGabaR9Y/OWFRp5odPvbwFTlzqr0o9s
         kr99FSf/b/Gb1wPwKtYC0cCYMfcfo4EDlXKCWA8SpIKOmHprD47myu8fF0jowEp7Il
         En3CVjzYODoiFTWZHJfWghyjspuop4CDXItkx6IU=
Date:   Fri, 26 Mar 2021 15:10:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "#@synopsys.com" <#@synopsys.com>,
        "4.18@synopsys.com" <4.18@synopsys.com>,
        "5.2@synopsys.com" <5.2@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH 0/3] usb: dwc2: Fix power saving general issues.
Message-ID: <YF3rVonRVVRs7NQN@kroah.com>
References: <20210326102400.359EFA005C@mailhost.synopsys.com>
 <YF3ihMf3cHESK0cq@kroah.com>
 <d8f33c04-8632-ee13-a056-5f7b706fdcd3@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8f33c04-8632-ee13-a056-5f7b706fdcd3@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 26, 2021 at 01:45:40PM +0000, Artur Petrosyan wrote:
> Hi Greg,
> 
> On 3/26/2021 17:32, Greg Kroah-Hartman wrote:
> > On Fri, Mar 26, 2021 at 02:23:58PM +0400, Artur Petrosyan wrote:
> >> This patch set is part of multiple series and is
> >> continuation of the "usb: dwc2: Fix and improve
> >> power saving modes" patch set.
> >> (Patch set link: https://urldefense.com/v3/__https://marc.info/?l=linux-usb&m=160379622403975&w=2__;!!A4F2R9G_pg!Icyuillfz_Iy_FrHe2RmVP0zFNTYupWQYmma2AX71Jsqg4cwSaw4hKokDSvIBxrAdsRmUD4$ ).
> >>
> >> The patches that were included in the "usb: dwc2:
> >> Fix and improve power saving modes" which was submitted
> >> earlier was too large and needed to be split up into
> >> smaller patch sets. So this is the first series in the
> >> whole power saving mode fixes.
> >>
> >> Each remaining patch set have dependency on previous set
> >> and will be submitted after each of them are integrated.
> >>
> >> The series includes the following patch sets with multiple patches
> >> by below order.
> >>   1. usb: dwc2: Fix power saving general issues.
> >>   2. usb: dwc2: Fix Partial Power down issues.
> >>   3. usb: dwc2: Add clock gating support.
> >>   4. usb: dwc2: Fix Hibernation issues
> > 
> > You only sent 3 patches, not 4.
> > 
> > So this makes no sense to me, what am I supposed to do?
> The 4 items that are listed are patch sets. The first patch set that I 
> have sent is "usb: dwc2: Fix power saving general issues.", which 
> includes the 3 patches that have been sent.
> 
> I wrote the other 3 patch set names in the list to indicate that I will 
> send them after this "usb: dwc2: Fix power saving general issues." patch 
> set is integrated to mainline.

I'm not taking this first patch as-is, sorry, see my comments on it
already.

I took patch 2 and 3 though.

thanks,

greg k-h
