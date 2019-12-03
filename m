Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19370111F7C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfLCXJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbfLCXJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 18:09:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDE320684;
        Tue,  3 Dec 2019 23:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575414586;
        bh=E3ptEOI/BhHIrvcybGtueDR7SHabN5hEzTUmSWFgbOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AndqiRODMpIVbQopESLTjZHoJy9rPaJHgGd685pKFUQb93wHXFDrTcqp/uj+QJYF5
         TFj5Bq6lKKAwNx5rXTcEl7gqtA3g4WGAhDTFEs/6Tg9ehUSzuDZCfJ8e7cJLbK9WPE
         r8KDc5yzZfmygIJMJcivZMVb/qiXev/j/V7T/2gw=
Date:   Wed, 4 Dec 2019 00:09:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
Message-ID: <20191203230944.GA3495297@kroah.com>
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 02:54:57PM -0800, Xuewei Zhang wrote:
> Hi Stable kernel maintainers,
> 
> I want to backport below patch to stable tree:
> 4929a4e6faa0 sched/fair: Scale bandwidth quota and period without
> losing quota/period ratio precision

What tree(s) do you want it backported to?

It's already been backported to 5.3.9 and 5.4, is that not sufficient?

If so, can you provide working backports to any older stable kernels
that you wish to see it merged into?

thanks,

greg k-h
