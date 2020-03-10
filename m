Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7892917F677
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJLk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgCJLk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:40:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC80F24655;
        Tue, 10 Mar 2020 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840427;
        bh=4hYBcU3i6dKgsy091MxtGqMqaXH1dDeDNBEQghaFA1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=olS02qY6wJMifL0OxEz1kWv7+W0O8QjE8b9NX6AZWEZeY1MKPuo0ilctNBt7Nb/8H
         YvojZ1orgDMZIO2H+CCPSeOe5v8xbngZgQ0791Z016thDpF/a0V/47jLggCjW/KhzX
         iwA80Kn1FU6CKAMf2Xj6GStQtAc04uu5zF8kdfbg=
Date:   Tue, 10 Mar 2020 12:40:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     heinzm@redhat.com, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v4.14 v4.19] dm integrity: fix a deadlock due to
 offloading to an incorrect workqueue
Message-ID: <20200310114025.GC3106483@kroah.com>
References: <158378432418151@kroah.com>
 <alpine.LRH.2.02.2003100457020.7499@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2003100457020.7499@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 05:00:16AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 9 Mar 2020, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> Here I'm sending the patch for the stable branches 4.14 and 4.19.

Now applied, thanks.

greg k-h
