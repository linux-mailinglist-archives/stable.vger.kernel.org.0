Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFEF817AC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 12:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfHEK5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 06:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfHEK5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 06:57:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A280E2087B;
        Mon,  5 Aug 2019 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565002624;
        bh=X7hImIlrZjdhW+FN4I1aEpWqZHGvzKMyyDHXfMP3yUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UjslKoL+NzitFCxRXuY81v9WZTbwy9IVtGcuLwsmE9I/TtBmmlyElFu8uQDkH+006
         3VPKEhxIKT3thAEcs9LFxqEEXNHaeh6hl2v30MtGcg9r6FUwgHShLepbOUw/LoBh6b
         ika82Ok1SUJkT+B8wbrXsBVSbekVODPf8TiXElNU=
Date:   Mon, 5 Aug 2019 12:57:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Schnelle <svens@stackframe.org>
Cc:     deller@gmx.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] parisc: fix race condition in patching
 code" failed to apply to 5.2-stable tree
Message-ID: <20190805105701.GA1157@kroah.com>
References: <1564983055189121@kroah.com>
 <20190805074524.GA10502@t470p.stackframe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805074524.GA10502@t470p.stackframe.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 09:45:24AM +0200, Sven Schnelle wrote:
> On Mon, Aug 05, 2019 at 07:30:55AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.2-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
>  
> The reason is that 5.2 doesn't have DYNAMIC_FTRACE suport, so this can be
> ignored.

Then why did the patch have:
	    Cc: <stable@vger.kernel.org> # 5.2+
in it?

confused,

greg k-h
