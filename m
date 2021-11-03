Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADE144441C
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 15:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKCPB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 11:01:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38621 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S231359AbhKCPB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 11:01:57 -0400
Received: (qmail 1524263 invoked by uid 1000); 3 Nov 2021 10:59:19 -0400
Date:   Wed, 3 Nov 2021 10:59:19 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        chris.chiu@canonical.com, Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
Message-ID: <20211103145919.GC1521906@rowland.harvard.edu>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
 <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
 <5c95597b-289b-ea1c-4770-8be9e8511ae0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c95597b-289b-ea1c-4770-8be9e8511ae0@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 08:14:35PM +0530, Kishon Vijay Abraham I wrote:
> + Alan, Chris, Mathias, linux-usb
> 
> Hi Hans,
> 
> On 03/11/21 6:18 pm, Hans de Goede wrote:
> > Hi,
> > 
> > On 11/3/21 10:07, Greg Kroah-Hartman wrote:
> >> On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
> >>> Hi Greg,
> >>>
> >>> We (Fedora) have been receiving multiple reports about USB devices stopping
> >>> working starting with 5.14.14 .
> >>>
> >>> An Arch Linux user has found that reverting the first 2 patches from this series:
> >>> https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
> >>>
> >>> Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
> >>>
> >>> See here for the Arch-linux discussion surrounding this:
> >>> https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
> >>>
> >>> And here are 2 Fedora bug reports of Fedora users being unable to use their
> >>> machines due their mouse + kbd not working:
> >>>
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=2019542
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=2019576
> >>>
> >>> Can we get this patch-series reverted from the 5.14.y releases please ?
> >>
> >> Sure,
> > 
> > Thanks.
> > 
> >> but can you also submit patches to get into 5.15.y and 5.16-rc1
> >> that revert these changes as they should still be an issue there, right?
> > 
> > Yes I assume this is still an issue there too, but I was hoping that
> > Kishon can take a look and maybe actually fix things, since just
> > reverting presumably regresses whatever these patches were addressing.
> > 
> > We've aprox 1-3 weeks before distros like Arch and Linux will switch
> > to 5.15.y kernels.  So we have some time to come up with a fix
> > there, where as for 5.14.y this is hitting users now.
> 
> Is the issue with PCIe USB devices or platform USB device? Is it specific to
> super speed devices or high speed device?

Look at the bug reports.  They are on standard PCs (so PCIe controllers) 
and some of them involve full speed (mouse and keyboard) devices.  
Although it looks like the problem has little to do with the device and 
a lot to do with the controller.

Is there a good way to get more information about what is going wrong?  
For example, by enabling tracepoints in the xhci-hcd driver?

Alan Stern
