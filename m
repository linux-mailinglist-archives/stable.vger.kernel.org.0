Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E638B34945
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 15:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfFDNqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 09:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727343AbfFDNqD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 09:46:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E476824B46;
        Tue,  4 Jun 2019 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559655963;
        bh=LtSvqYH8an6VF1cCj0CBuVgDNrHYIrirEcn/2xRX6Y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUrmC8ErV9sQ29ImyU0qfSCylhpz6TZEHSKdxI5fsBqjzwbOJEheOYJyRy69IL45P
         B3gAaTgJcW6RUWmFZVSmL9Sg6gRXAFBQnQukNcbKV4neNbRvN8Xo2S4wf3LWRr8dpT
         mp6Bp6+a0yTxId97adwZiTU2Tpb/+R4C3OyHKPYc=
Date:   Tue, 4 Jun 2019 15:45:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Zubin Mithra <zsm@chromium.org>, stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
Message-ID: <20190604134559.GA8083@kroah.com>
References: <20190603223851.GA162395@google.com>
 <20190604123432.GA19996@kroah.com>
 <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 03:39:15PM +0200, Ard Biesheuvel wrote:
> On Tue, 4 Jun 2019 at 14:34, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 03, 2019 at 03:38:52PM -0700, Zubin Mithra wrote:
> > > Hello,
> > >
> > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > >
> > > Could the patch be applied in order to v4.19.y?
> >
> > Now queued up, thanks.
> >
> 
> Given the discussion leading up to this, I'm slightly surprised.
> 
> As I alluded to in my questions to Zubin, I am concerned that the
> testing carried out on this patch has too little coverage, given that
> a) Chrome OS apparently does not boot in EFI mode
> b) therefore, Chrome OS there does not use efi=old_map
> c) Chrome OS hardware does not implement 5 level paging
> 
> I have done all the testing I could before merging the patch, but I
> would prefer to defer from backporting it until it hits a release. I
> know some people argue that this still does not provide sufficient
> coverage, but those are usually not the same people getting emails
> when their EFI systems no longer boot without any output whatsoever
> after upgrading from one stable kernel version to the next.

Ok, I'll go drop it.  Can you please email stable@vger when it is in a
release so that I know to queue it up then?

thanks,

greg k-h
