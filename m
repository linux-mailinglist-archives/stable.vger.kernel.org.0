Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21452A54B5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbgKCVN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388530AbgKCVN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA43206B5;
        Tue,  3 Nov 2020 21:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438036;
        bh=93ZExvM+6bmjvOPadcQ5VBQMS3/9d1fs67z2XBaxVzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ApCaW4UVijB0Abbg876PS3Vx3ZfKvASLkwfweLdV2BJ8dQ1efX1FQ+r7SCQh0unrs
         EJu4FnlT5JqNe3D3aIvm066VDnch5yX6YTXA/Akh71NNJ9G64GoS5aE+QzLxVj4spr
         4wTKkXwHqmnklfKJ0KHe3snmys801+/ORQ7+jZJ4=
Date:   Tue, 3 Nov 2020 22:01:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Costa Sapuntzakis <costa@purestorage.com>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: Fwd: remove ext4-fix-superblock-checksum-calculation-race.patch ?
Message-ID: <20201103210100.GA666918@kroah.com>
References: <CAABuPhZKJncNoVb3-um8WTdyvffvcYqPKDUA_AcpmEZQrMshTg@mail.gmail.com>
 <CAABuPhZZG13uxa-NpiH1k1HbNYx2QDLEOLURsVnBmu8ynZcaig@mail.gmail.com>
 <20201103183028.GB83845@kroah.com>
 <CAABuPhb-mRsrFjPLeXaObbCEDQX0XWYFOO+xJVTcbQ1W2tqosw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABuPhb-mRsrFjPLeXaObbCEDQX0XWYFOO+xJVTcbQ1W2tqosw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 12:45:24PM -0800, Costa Sapuntzakis wrote:
> On Tue, Nov 3, 2020 at 10:30 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Nov 03, 2020 at 09:24:57AM -0800, Costa Sapuntzakis wrote:
> > > syzbot found https://syzkaller.appspot.com/bug?extid=7a4ba6a239b91a126c28
> > > which shows we can try to sleep under a spinlock in an error path.
> >
> > Do you have a patch for this?
> 
> Sorry, I put too much in the subject. I received e-mail this morning
> (Pacific Standard Time) that
> ext4-fix-superblock-checksum-calculation-race.patch had been
> incorporated into various stable branches. Yesterday, I received an
> e-mail from Hillf Danton (hdanton@sina.com) that syzbot had found a
> bug in the patch.
> 
> Hillf Danton (hdanton@sina.com) has made a patch for the patch and it
> is being reviewed.

We will be glad to queue up the fix when it hits Linus's tree as well.

thanks,

greg k-h
