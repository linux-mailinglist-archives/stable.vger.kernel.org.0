Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50B72FFFEF
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 11:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbhAVKOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 05:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbhAVKE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 05:04:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F229235E4;
        Fri, 22 Jan 2021 10:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611309816;
        bh=JQlrgyWJoBer+lrAa369FYvhBQ3gIqF+I58JAjewXQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U4Ff49ELGbOeE0+h4XaIwF7MRwCRemOf7Nhu8YJ6zTYw0sk0UeWqDHH2116LuXXyc
         /CcsdFUF36jjgjnk0XPgf8JbulmeLJEenTJGgE6ZLZSMtkjTHeCZ/uVaEo/uUAcyv0
         99Ffb9Q2OrZaQSYqbHR2/7A8mYPGwKe/Ax5bfkvo=
Date:   Fri, 22 Jan 2021 11:03:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5ZCz5piK5r6E?= Ricky <ricky_wu@realtek.com>
Cc:     "arnd@arndb.de" <arnd@arndb.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "vaibhavgupta40@gmail.com" <vaibhavgupta40@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] Fixes: misc: rtsx: init value of aspm_enabled
Message-ID: <YAqi9nHhERuQnLxC@kroah.com>
References: <20210122081906.19100-1-ricky_wu@realtek.com>
 <YAqMkU4fR5z6aG1Z@kroah.com>
 <c55d960dd9424914b48638afcdfb81d1@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c55d960dd9424914b48638afcdfb81d1@realtek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 09:55:44AM +0000, 吳昊澄 Ricky wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Friday, January 22, 2021 4:28 PM
> > To: 吳昊澄 Ricky <ricky_wu@realtek.com>
> > Cc: arnd@arndb.de; bhelgaas@google.com; vaibhavgupta40@gmail.com;
> > linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH v4] Fixes: misc: rtsx: init value of aspm_enabled
> > 
> > On Fri, Jan 22, 2021 at 04:19:06PM +0800, ricky_wu@realtek.com wrote:
> > > From: Ricky Wu <ricky_wu@realtek.com>
> > >
> > > make sure ASPM state sync with pcr->aspm_enabled init value
> > > pcr->aspm_enabled
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> > > ---
> > >
> > > v2: fixed conditions in v1 if-statement
> > > v3: give description for v1 and v2
> > > v4: move version change below ---
> > 
> > What commit id does this fix?  How far back should the stable backporting go?
> > That's what we use the Fixes: line for.
> > 
> I think I misunderstanding you
> Fix commit id:  d928061c3143de36c17650ce7b60760fefb8336c
> So I need to have v5 and add "Fixes:" tag like below in the signed off by area?

Yes.  See the many hundreds of examples of this on the mailing lists and
in the git log :)

> "Fixes: d928061c3143de36c17650ce7b60760fefb8336c"

It should be:
Fixes: d928061c3143 ("misc: rtsx: modify en/disable aspm function")

The submitting patches document should explain how to do that.

I can go and add it by hand for this, but next time, try to remember to
do it yourself.

thanks,

greg k-h
