Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2327D17F670
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJLin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgCJLin (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA4A24684;
        Tue, 10 Mar 2020 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840322;
        bh=MfdUmdCBIhywpxpVGeaPAL5NyQ/8GeFExnH0oxhrKEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IO8dBclOhNWH0EsM42WxpyzDxYSbhvqVBhfeDDoTt8NH9eoqqTArGLCiCUYhZNyJW
         j9VF7gwBTkiz1FSTehtmfvZkIKa8JDGmTkYrAPUCORaZcLYd3oKdqMVuYFYAIN8+Se
         I6ECWdUXKrZ85t/JZ5BV2DY51n3Aa5kBl5W8/pcw=
Date:   Tue, 10 Mar 2020 12:38:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v4.4 v4.9] dm cache: fix a crash due to incorrect work
 item cancelling
Message-ID: <20200310113840.GB3106483@kroah.com>
References: <158378436239197@kroah.com>
 <alpine.LRH.2.02.2003100505050.7499@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2003100505050.7499@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 05:06:39AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 9 Mar 2020, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.9-stable tree.
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
> Here I'm sending the patch for the stable branches 4.4 and 4.9.

Now queued up, thanks!
