Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD5457039
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhKSOJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235173AbhKSOJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39AF761AD0;
        Fri, 19 Nov 2021 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637330761;
        bh=D288cLKxjK6+XYbGmY+v0D5nfZgCgFd4U6FCaexEwhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=URAi5jSNWrhokiIrK4Hr+a9OJAWBIkF2SM3qFESN/E5eNsg9EaPXf2cAWz72RlsyC
         hFeP3IBVqnkxTO/PWTzoxKd1wNMDXmeXr2LD9gvyZQWV08DNYbdkJcqH6tnDiJidfT
         BxUf/S8JEfzdP+UT78IY1gn9J3X14S0mXUwAloB4=
Date:   Fri, 19 Nov 2021 15:05:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rui Salvaterra <rsalvaterra@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] PCI: MSI: Deal with devices lying about their
 masking capability
Message-ID: <YZevR+LnK2Fbk4Jh@kroah.com>
References: <20211104180130.3825416-1-maz@kernel.org>
 <87ilx64ued.ffs@tglx>
 <CALjTZvag6ex6bhAgJ_rJOfai8GgZQfWesdV=FiMrwEaXhVVVeQ@mail.gmail.com>
 <YZOKV6z+6pDjjvcl@kroah.com>
 <CALjTZvaeujHJw-EV1Y=+npjXzYFiiQ9sbu6tE6do63F9R4dRqg@mail.gmail.com>
 <YZOOYN6x3NCaC3qH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZOOYN6x3NCaC3qH@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 11:56:32AM +0100, Greg KH wrote:
> On Tue, Nov 16, 2021 at 10:47:23AM +0000, Rui Salvaterra wrote:
> > Hi, Greg,
> > 
> > On Tue, 16 Nov 2021 at 10:39, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > What is the git commit ids of these changes in Linus's tree?
> > 
> > 2226667a145d ("PCI/MSI: Deal with devices lying about their MSI mask
> > capability")
> > f21082fb20db ("PCI: Add MSI masking quirk for Nvidia ION AHCI")
> 
> Thanks, I'll queue them up in the next round of releases after the
> current ones are out.

Now queued up.

greg k-h
