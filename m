Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FA3E574F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbhHJJo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238155AbhHJJo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 05:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D28B8610A3;
        Tue, 10 Aug 2021 09:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628588645;
        bh=xNDvJ5YIPvPp7jetsYBXNcbZz7/GYxtHNQTLzKuC7nA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GTL1wYw9GIKEOPr/B1VaDlOuMNqfOfCO863rTmik7L+pVKFqXQ5tRa4+mxyBY9yMk
         zPbrvWDgULEz7PXZnNPcONq38Ad5oqQwhlH8YBfNtb3W3dotRaLxKBwx1Q9b3mIon9
         LH68D5vGuwDs7LlimvMQOGZ8TWBm9cp0RxV8zlwA=
Date:   Tue, 10 Aug 2021 11:44:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] staging: rtl8712: error handling
 refactoring" failed to apply to 5.4-stable tree
Message-ID: <YRJKYEFtqi8Ztm+J@kroah.com>
References: <162850253410956@kroah.com>
 <77187907-8eb3-8c19-5cd2-0e31a4bc6c71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77187907-8eb3-8c19-5cd2-0e31a4bc6c71@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 12:10:33PM +0300, Pavel Skripkin wrote:
> 
> 
> On 8/9/21 12:48 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hi, Greg!
> 
> Should I rewrote this patch to make it applicable to 5.4-stable? I believe,
> that following patch "staging: rtl8712: get rid of flush_scheduled_work"
> makes no sense without this one.

That makes sense, please provide a working backport if you think it
should go to this tree.

thanks,

greg k-h
