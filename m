Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A922A4C9
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgGWBmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGWBmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 21:42:02 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD487C0619DC;
        Wed, 22 Jul 2020 18:42:01 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a21so3261684otq.8;
        Wed, 22 Jul 2020 18:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8M4Xkkh6oONnSId9T7Db7jDYkgAvaARFQjrwk9Nrj6Y=;
        b=Q5Ii6hPyJ2G0aEmGCO00OiA5rSM5q1/oqcCcR4WKeTegYbf9rHBDDvJPG5XEsBsIHA
         QfYycgqaOmYulO53hzYMlRp0wjNb0HdwmogsVWTj50kB+vnyd7clAEEpjUo99AubWaoP
         PXVeSSO2BCQt6RDtEUDG664m/5VjTRMxraKSvhub0f1Z4f34d/F2H60qb9jPsRwabndc
         kz9Ajtbba/Yf1R3YLtE/rJt4lUgcjFcjqPSK1nSXl5IaB5gWWsUeFY2kRW4yhKlhGPN1
         H8TleEGj856nuHfBpcT4ChusnbLMAyaEb0GcZyqbhh9luIoqnc2qHyHB77G3r5PBqNAi
         ZZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8M4Xkkh6oONnSId9T7Db7jDYkgAvaARFQjrwk9Nrj6Y=;
        b=d7yjgcWjc/xmzkQJ9CmB5RJRdgyDSLaPwQxEAPJHFcGnXPsTlejL1fZ9YAoISp5gAb
         o4lNFkguKHBVyjp/LbO5cEAqtt5iLgoL/vjADdnbY3GcljnMWeClJ7hXENjKyDC66IEf
         MFTyyI7mh9PCbgUfHvXNzAjoUT6Mal486DOoxVhNSZikvxcNNXBrD2P1gfBeoOon2bAC
         dyBbWjSPguPAHhq0ewUriVXlml1uqKyL7y02UzT7AdCYh2kjc9thSeRNUMIGuGcKzg2S
         XAJ6ttKBbQOorIMVx1txIBVsaShgT5f9ieKuyipVqWGoBG73xfaZoZj6Mt/8mEiEYqMZ
         VE2g==
X-Gm-Message-State: AOAM532CmN4MHCzHD4wKwuUxrxk1sA6VZ+ypDeVJzRbwCnDajjkKmBVv
        G+j+Lya1OjGQosRKfAq9nqdUawfNgTeO1aAe9s4=
X-Google-Smtp-Source: ABdhPJy4b+57zr/ei4gtWpjlioxvHvFFbfZJy9/UeAw4TppwPaZkiKmaXCPX0TB50LLhw8Dnut6Bbg7mk0MQ2PWYcYo=
X-Received: by 2002:a05:6830:1301:: with SMTP id p1mr2108063otq.357.1595468521163;
 Wed, 22 Jul 2020 18:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <CADLC3L0b8zqJoHt7aA6z6hb3cYC2z-32vmQsQ3tR0gGduC8+-Q@mail.gmail.com>
 <20200723010435.GA1334095@bjorn-Precision-5520>
In-Reply-To: <20200723010435.GA1334095@bjorn-Precision-5520>
From:   Robert Hancock <hancockrwd@gmail.com>
Date:   Wed, 22 Jul 2020 19:41:50 -0600
Message-ID: <CADLC3L1BRToNyqPV51++JOySgfaEs1YAWM5vCjSTZctuvqNyug@mail.gmail.com>
Subject: Re: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI bridge
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-pci@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Puranjay Mohan <puranjay12@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 7:04 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Wed, Jul 22, 2020 at 06:46:06PM -0600, Robert Hancock wrote:
> > On Wed, Jul 22, 2020 at 11:40 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Tue, Jul 21, 2020 at 08:18:03PM -0600, Robert Hancock wrote:
> > > > Recently ASPM handling was changed to no longer disable ASPM on all
> > > > PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
> > > > devices don't seem to function properly with ASPM enabled, as they
> > > > cause the parent PCIe root port to cause repeated AER timeout errors.
> > > > In addition to flooding the kernel log, this also causes the machine
> > > > to wake up immediately after suspend is initiated.
> > >
> > > Hi Robert, thanks a lot for the report of this problem
> > > (https://lore.kernel.org/r/CADLC3L1R2hssRjxHJv9yhdN_7-hGw58rXSfNp-FraZh0Tw+gRw@mail.gmail.com
> > > and https://bugzilla.redhat.com/show_bug.cgi?id=1853960).
> > >
> > > I'm pretty sure Linux ASPM support is missing some things.  This
> > > problem might be a hardware problem where a quirk is the right
> > > solution, but it could also be that it's a result of a Linux defect
> > > that we should fix.
> > >
> > > Could you collect the dmesg log and "sudo lspci -vvxxxx" output
> > > somewhere (maybe a bugzilla.kernel.org issue)?  I want to figure out
> > > whether this L1 PM substates are enabled on this link, and whether
> > > that's configured correctly.
> >
> > Created a Bugzilla entry and added dmesg and lspci output:
> > https://bugzilla.kernel.org/show_bug.cgi?id=208667
> >
> > As I noted in that report, I subsequently found this page on ASMedia's
> > site: https://www.asmedia.com.tw/eng/e_show_products.php?cate_index=169&item=114
> > which indicates this ASM1083 device has "No PCIe ASPM support".
>
> How nice.  According to your lspci, the device itself claims to
> support ASPM:
>
>   02:00.0 ... ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge
>     LnkCap: ... ASPM L0s L1 ...
>
> but the web page claims otherwise.  That would mean the device is
> defective for claiming something that's not true.  Or possibly those
> capability bits can be set by BIOS.
>
> > It's not clear why this problem isn't occurring on Windows however -
> > either it is not enabling ASPM, somehow it doesn't cause issues with
> > the PCIe link, or it is causing issues and just doesn't notify the
> > user in any way. I can try and check if this bridge device is ending
> > up with ASPM enabled under Windows 10 or not..
>
> If Windows *does* manage to enable ASPM, that would be interesting.  I
> don't know whether Windows has a similar quirk mechanism.  I suppose
> they must have *some* way to work around defective devices.

As I posted on the Bugzilla report, based on lspci output it appears
Windows does have ASPM L0s enabled for this bridge. However, it
appears to have the exact same problem: there are correctable PCIe
error entries showing up in the Windows system event log against the
root port the bridge is connected to. So I am thinking this hardware
is just broken with ASPM enabled.
