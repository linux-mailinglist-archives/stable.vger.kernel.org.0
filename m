Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5027D34259E
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCSTCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCSTCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 15:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8D761979;
        Fri, 19 Mar 2021 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616180551;
        bh=Qo6NtGkPWLqTBwrJb5r2FaWTF8WoF7RDUE8gTCFbhtQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fYc5MAfjjzohdvHSd+gSARwoR7yCb7qVsm652ZV8m0FdqyYUXEXYMT+yXh6oWHgzN
         D57pN7OyjHzMk1Y5C3S7IfaNm57BTH3bMbkNCAhhGdSspScIR66KCsXcT64Mr2fXhy
         EGiO9ZBugAUvG02G8NaAviLxLvsJjOEcorJgGJARRsRSfQaon1pchAOUcGKyOmE6w3
         3Gwcaa660fNmKl4ikimTu9/AfCBBI372oFg4MYeGR3PC6TNzTqlgVwkD4m5vyyg7WU
         P9WixCvPQIqvEeWQirMJ/NC8Nk1MHElYXFEwR3RQIxf2YM1hSO3PYvyTF8Lh8HIlHP
         4uxrRwH+4jrKg==
Received: by pali.im (Postfix)
        id DE6396FE; Fri, 19 Mar 2021 20:02:28 +0100 (CET)
Date:   Fri, 19 Mar 2021 20:02:28 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org,
        =?utf-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        stable@vger.kernel.org, Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA
 controller
Message-ID: <20210319190228.xdejimfdpjch6de4@pali>
References: <20210317225544.fm4oyuujylsxa77b@pali>
 <20210317230355.GA95738@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317230355.GA95738@bjorn-Precision-5520>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 17 March 2021 18:03:55 Bjorn Helgaas wrote:
> On Wed, Mar 17, 2021 at 11:55:44PM +0100, Pali Rohár wrote:
> > On Wednesday 17 March 2021 17:45:49 Bjorn Helgaas wrote:
> > > This quirk suggests that there's a hardware defect in the ASMedia
> > > ASM1062.  But if that's really the case, we should see reports on lots
> > > of platforms, and I'm only aware of these two.
> > 
> > Do you have platform which support MPS of 512 bytes? Because I have not
> > seen any x86 / Intel PCIe controller with such support on ordinary
> > laptop and desktop.
> > 
> > These two (A3720 and CN9130) are the only which has support for it.
> > 
> > Has somebody else PCIe controller which Root Bridge supports MPS of 512
> > bytes?
> > 
> > Maybe they are in servers, but then such "cheap" SATA controllers are
> > not used in servers. So this is probably reason why nobody else reported
> > such issue.
> 
> I have no idea.  My laptop only supports 512 (except for an ASMedia
> USB controller).  If the device advertises it, I would expect the
> vendor to test it.  Obviously it still could be a device defect.  They
> should publish an erratum if that's the case so people know to avoid
> it.  So I would try to get ASMedia to say "no, that's tested and
> should work" or "oh, sorry, here's an erratum and we'll fix it in the
> next round."

I doubt that ASMedia publish something...

But has somebody contact to ASMedia? I can try it.

Basically these ASMedia SATA controller chips are present on more
"noname" mPCIe-form cards and I guess ASMedia is not going to support
them.

Note that we have also tested Marvell PCIe-based SATA controllers which
support MPS of 512 bytes too and there were no problem with them on
A3720 nor CN9130.
