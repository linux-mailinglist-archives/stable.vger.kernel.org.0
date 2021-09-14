Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA740AF85
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhINNuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 09:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhINNt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 09:49:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 112DE603E7;
        Tue, 14 Sep 2021 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631627320;
        bh=KYHZTpIvKU/66lbK6TP6E+zDK1KHMPJVu8a7HN6J6ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=okYiXIJndd4OYv4sTXkeay9J4mgvjlp5iAC+R0hE8uk/PeWuOeDAl2tSnrYf5KHFQ
         5G5cM91z5F1Ew4msIXW9mEAQONYxJka3OARK/sONCLuiSO/1876z1UZiwMjyMVEUet
         wGv5Gb6G5StVcvRFjLQT5uKgVWgSlH/1WbarDmsssmN42W2Z+J5fswfhisfhPnRkRa
         c9Sn/UWpC++A7RZKOpqfQ+ioMUS77vpzbj0dv3pn14dZeaWxWXda2B6gwv2sXH2jIW
         jVUqBFjwBwda1VICAdQzMXTh//EtkrkEL0X+x7arfC01bA9Ua2p5pJZg2im+jgP/qn
         Mv2ow23PizmeQ==
Date:   Tue, 14 Sep 2021 08:48:38 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Quan, Evan" <Evan.Quan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Message-ID: <20210914134838.GA1420852@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB514448B91AEAEAADB521F427F7DA9@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 12:59:08PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Tuesday, September 7, 2021 1:35 PM
> > To: Deucher, Alexander <Alexander.Deucher@amd.com>
> > Cc: Quan, Evan <Evan.Quan@amd.com>; linux-pci@vger.kernel.org;
> > bhelgaas@google.com; stable@vger.kernel.org; Rafael J. Wysocki
> > <rjw@rjwysocki.net>
> > Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI
> > and UCSI controllers
> > 
> > [+cc Rafael, beginning of thread:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.
> > kernel.org%2Fall%2F20210903063311.3606226-1-
> > evan.quan%40amd.com%2F&amp;data=04%7C01%7CAlexander.Deucher%4
> > 0amd.com%7C48f3a6f7639343fcad6208d97225da95%7C3dd8961fe4884e608e
> > 11a82d994e183d%7C0%7C0%7C637666329177869121%7CUnknown%7CTWFp
> > bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> > I6Mn0%3D%7C1000&amp;sdata=k%2FgSHhtLiS8xS5hNkaP%2BOWWMWqiM
> > 4tgQk4bybfumvfM%3D&amp;reserved=0]
> > 
> > On Tue, Sep 07, 2021 at 04:09:40PM +0000, Deucher, Alexander wrote:
> > > > -----Original Message-----
> > > > From: Bjorn Helgaas <helgaas@kernel.org>
> > > > Sent: Friday, September 3, 2021 3:55 PM
> > > > To: Quan, Evan <Evan.Quan@amd.com>
> > > > Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; Deucher,
> > > > Alexander <Alexander.Deucher@amd.com>; stable@vger.kernel.org
> > > > Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB
> > > > xHCI and UCSI controllers
> > > >
> > > > On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> > > > > Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add
> > > > > device link support for them.
> > > >
> > > > Please comment on
> > > >
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgi
> > > >
> > t.k%2F&amp;data=04%7C01%7CAlexander.Deucher%40amd.com%7C48f3a6f
> > 76393
> > > >
> > 43fcad6208d97225da95%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0
> > %7C63
> > > >
> > 7666329177869121%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> > AiLCJQIjo
> > > >
> > iV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=0yxZbS6o
> > P56
> > > > rXpA5j1wvlMpkp9Ern%2FcSRCPELtv47lM%3D&amp;reserved=0
> > > >
> > ernel.org%2Flinus%2F6d2e369f0d4c&amp;data=04%7C01%7CAlexander.Deu
> > > >
> > cher%40amd.com%7C9fa0d66e5f29424df36b08d96f14c710%7C3dd8961fe488
> > > >
> > 4e608e11a82d994e183d%7C0%7C0%7C637662957313172831%7CUnknown%7
> > > >
> > CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi
> > > >
> > LCJXVCI6Mn0%3D%7C1000&amp;sdata=6IlPLWlcO7iptbTqfh71fe5wmHN7RN
> > > > 13OvScyYaWyI8%3D&amp;reserved=0 .
> > > >
> > > > Is there something the PCI core is missing here?  Or is there
> > > > something that needs to be added to ACPI or the PCI firmware spec?
> > > >
> > > > We want a generic way to discover dependencies like this.
> > > >
> > > > A quirk should not be necessary for spec-compliant devices.
> > > > Quirks are an ongoing maintenance burden, and they mean that new
> > > > hardware won't work correctly until the OS is patched to know about
> > > > it.  That's not what we want.
> > > >
> > > > I expect we'll still need *this* quirk, but first I'd like to know
> > > > whether there's a plan to handle this more generically in the
> > > > future.
> > >
> > > The requirement here is that all of the additional endpoints are
> > > dependencies for powering down the GPU.  E.g., the audio controller
> > > and USB endpoints need to be in d3 before you put the GPU into d3,
> > > otherwise the non-GPU endpoints will be powered down as well behind
> > > their drivers' backs.  On newer AMD hardware there is logic in the
> > > hardware to wait for all dependent devices to go into d3 before
> > > powering down everything or power up everything if anything enters d0,
> > > but this requires additional software setup in the GPU driver as well
> > > and older versions of the driver didn't set this up correctly, instead
> > > relying on software logic via dependencies.  Earlier hardware didn't
> > > have that logic and needed software help.  That said, I think all of
> > > the relevant drivers expect the hardware state to be powered down when
> > > d3 is entered and they may not handle a wake up properly if not all
> > > devices entered d3 and hence all of the devices never entered a
> > > powered down state.
> > 
> > I'm not sure whether this answered my question.  Will we need more quirks
> > for future devices?
> 
> The existing quirks should cover all devices unless we add some new
> endpoint to the GPUs in the future.  The quirk for the audio
> dependency was added years ago and hasn't needed to be extended
> since.  The USB stuff was added more recently and requires adding a
> similar quirk.

Oh, I see, these quirks don't actually have specific Device IDs in
them; they are generic for *all* PCI_VENDOR_ID_ATI USB devices (and
pci_create_device_link() checks for a PCI_BASE_CLASS_DISPLAY function
in the same device.  So it's only when you add a new *class* of device
dependency.  Thanks for clearing that up!

> > You said "On newer AMD hardware there is logic to wait for all
> > dependent devices to go to d3 ...," which sounds promising, but
> > then it "requires additional setup in the GPU driver."
> > 
> > So maybe PM works as per PCIe spec, but only after the driver sets
> > things up?  I'm not sure what, if any, PM we do before a driver
> > claims the device.
> > 
> 
> I'm not exactly sure what the expectation is with regards to the
> spec.  There is a single power rail that controls all of the
> endpoints so all have to be in d3 before the power can be cut.
> 
> > The above suggests that if we put some (but not all) functions, in
> > D3, the new logic will keep them from entering D3 until later.
> > That doesn't really *sound* spec-compliant -- if we write D3 to a
> > function's PCI_PM_CTRL and then read it back, the function will
> > remain in D0 indefinitely, until we put that last function in D3?
> > 
> 
> It will read back as if the card is in D3, but the power rail stays
> on until all devices have been put into D3.
> 
> > pci_raw_set_power_state() does this read then write, and it
> > expects PCI_PM_CTRL to change to the new state after the delay
> > prescribed by the spec, which of course has nothing to do with
> > sibling functions.
> > 
> > And if all the functions are in D3, and we write D0 to one
> > function's PCI_PM_CTRL, *all* the functions magically go to D0?
> > That sounds potentially confusing.
> 
> The will all individually report the correct D state, it's just that
> they will be using more power than if they were all in D3.

OK, that all sounds fine, I think.  Thanks!

Bjorn
