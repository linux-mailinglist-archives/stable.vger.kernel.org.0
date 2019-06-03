Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5EF32F26
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfFCMCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 08:02:55 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58161 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFCMCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 08:02:55 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hXlfj-0002pR-CU; Mon, 03 Jun 2019 13:02:39 +0100
Message-ID: <1559563359.24330.8.camel@codethink.co.uk>
Subject: Re: [stable] xen/pciback: Don't disable PCI_COMMAND on PCI device
 reset.
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg KH <greg@kroah.com>
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable <stable@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon, 03 Jun 2019 13:02:39 +0100
In-Reply-To: <20190603080036.GF7814@kroah.com>
References: <1559229415.24330.2.camel@codethink.co.uk>
         <0e6ebb5c-ff43-6d65-bcba-6ac5e60aa472@oracle.com>
         <20190603080036.GF7814@kroah.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-06-03 at 10:00 +0200, Greg KH wrote:
> On Thu, May 30, 2019 at 07:02:34PM -0700, Konrad Rzeszutek Wilk wrote:
> > On 5/30/19 8:16 AM, Ben Hutchings wrote:
> > > I'm looking at CVE-2015-8553 which is fixed by:
> > > 
> > > commit 7681f31ec9cdacab4fd10570be924f2cef6669ba
> > > Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Date:   Wed Feb 13 18:21:31 2019 -0500
> > > 
> > >      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
> > > 
> > > I'm aware that this change is incompatible with qemu < 2.5, but that's
> > > now quite old.  Do you think it makes sense to apply this change to
> > > some stable branches?
> > > 
> > > Ben.
> > > 
> > 
> > Hey Ben,
> > 
> > <shrugs> My opinion is to drop it, but if Juergen thinks it makes sense to
> > backport I am not going to argue.
> 
> Ok, I've queued this up now, thanks.

Juergen said:

> I'm with Konrad here.

so unless I'm very confused this should *not* be applied to stable
branches.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
