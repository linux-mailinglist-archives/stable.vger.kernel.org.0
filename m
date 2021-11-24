Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12145B7E0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 10:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhKXKB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhKXKB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 05:01:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DF460FE7;
        Wed, 24 Nov 2021 09:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637747929;
        bh=b3eKG/rQ7FZOGT31Dkme1e3OA8hFVQ82fpm34TJCNtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oHSc2IkJMIaWDYqWxkYxeveN9vsXuWHttXOZX5e29Df0rbqweK+UcXREjnIEbS/6o
         wckC6AHYJlLyNeBoYJFcc1R2GFBtZadj+/zfHFjsLJxbev75IxsQD6H7ZRPgkv2Vox
         FONL/QyVPJfhgLf9K30B1IrBOFR6XlnMLfH0I/rg=
Date:   Wed, 24 Nov 2021 10:57:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Paul Moore <paul@paul-moore.com>, arve@android.com,
        tkjos@android.com, maco@android.com, christian@brauner.io,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] binder: fix test regression due to sender_euid change
Message-ID: <YZ4Mm9ux0zVurjQk@kroah.com>
References: <20211112180720.2858135-1-tkjos@google.com>
 <CAHC9VhQaHzrjdnr_DvZdPfWGiehC17yJVAJdVJMn8tOC1_Y+gA@mail.gmail.com>
 <CAHRSSEwUUUxXOnb2_fg1qnEXbCtD+G7KW8=xwKZFA5r-PKcPBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSEwUUUxXOnb2_fg1qnEXbCtD+G7KW8=xwKZFA5r-PKcPBg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 03:39:59PM -0800, Todd Kjos wrote:
> On Fri, Nov 19, 2021 at 3:00 PM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Fri, Nov 12, 2021 at 1:07 PM Todd Kjos <tkjos@google.com> wrote:
> > >
> > > This is a partial revert of commit
> > > 29bc22ac5e5b ("binder: use euid from cred instead of using task").
> > > Setting sender_euid using proc->cred caused some Android system test
> > > regressions that need further investigation. It is a partial
> > > reversion because subsequent patches rely on proc->cred.
> > >
> > > Cc: stable@vger.kernel.org # 4.4+
> > > Fixes: 29bc22ac5e5b ("binder: use euid from cred instead of using task")
> > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > Change-Id: I9b1769a3510fed250bb21859ef8beebabe034c66
> 
> Greg, I neglected to remove the "Change-Id" from my Android pre-submit
> testing. Can you remove that, or would you like me to resubmit without
> it?

Sorry, I missed it too.  It's already in my tree, no need to worry about
it.

greg k-h
