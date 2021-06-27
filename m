Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E563B5423
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhF0QE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 12:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhF0QE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 12:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5028C6142D;
        Sun, 27 Jun 2021 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624809754;
        bh=AxQauYgmrm/T5pHkeadigJ3zU1k+ZQ7GsxE2noIUiag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CY/N+oir6V281OB8MC0+TjNyeeqFwPkEbs6K+ZTj/5vkNbLs+hCHpYRxruZTBZNcx
         I09UQRViv9Yqsut4RslZLShFanbJzKCM2o82d+OBppM24jWWqXLhf350Uj/BWzUz+F
         mTKBmWrmPI+WqnDc+Angm1m/VjW4yW7WKTEKWpug=
Date:   Sun, 27 Jun 2021 18:02:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     stable@vger.kernel.org, dhowells@redhat.com,
        Matthew Wilcox <willy@infradead.org>,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] ceph: fix test for whether we can skip read when writing
 beyond EOF
Message-ID: <YNihGOegQtLR3Adf@kroah.com>
References: <20210625175951.90347-1-jlayton@kernel.org>
 <YNiJsmqZRDlFdnIa@kroah.com>
 <460106c8619ce7575f84f6fb387453b31204185d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460106c8619ce7575f84f6fb387453b31204185d.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 27, 2021 at 11:41:45AM -0400, Jeff Layton wrote:
> On Sun, 2021-06-27 at 16:22 +0200, Greg KH wrote:
> > On Fri, Jun 25, 2021 at 01:59:51PM -0400, Jeff Layton wrote:
> > > commit 827a746f405d upstream.
> > 
> > No it is not :(
> > 
> > Please fix this up and resend it with the correct git id.
> > 
> > thanks,
> > 
> 
> Are you sure?
> 
>     $ git log --oneline origin/master -- fs/netfs
>     827a746f405d (tag: netfs-fixes-20210621, dhowells/afs-fixes) netfs: fix test for whether we can skip read when writing beyond EOF
> 
> "origin" is Linus' tree. I'm not sure what I'm doing wrong otherwise.

Commit 827a746f405d ("netfs: fix test for whether we can skip read when
writing beyond EOF") is just that, yes.

That does not match with the subject line here, or the patch itself.

So I do not understand what you are trying to do here...

thanks,

greg k-h
