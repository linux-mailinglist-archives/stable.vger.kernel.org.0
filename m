Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1174C3278E3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 09:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhCAIGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 03:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhCAIGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 03:06:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0981664E04;
        Mon,  1 Mar 2021 08:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614585916;
        bh=q8jHwbTzLPmQcFeLFrcLZ6Ix/wp39+V4bv5MB4EqdmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GKLg2MjH5tylmc68AycOp7OjVZrUMID/bXIYoAdh/PoweVVJfHdqNdgNOr/gabdXa
         4cp+ih4qCZPxhlSLx7X4bOIcd3T8IvDrVYqTJ0uPYlItspS2NItEoD7Nap8xPbH1Kv
         yc+fNmTjN7vCUNUOWMZt1+E3X+ThR+bTEKd/MP1c=
Date:   Mon, 1 Mar 2021 09:05:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peng Tao <tao.peng@linux.alibaba.com>
Cc:     alikernel-developer@linux.alibaba.com,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Ma Jie Yue <majieyue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eryu Guan <eguan@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH CK 4.19 1/4] fuse: fix page dereference after free
Message-ID: <YDygOH7MGVOAYk+H@kroah.com>
References: <1614569779-12114-1-git-send-email-tao.peng@linux.alibaba.com>
 <1614569779-12114-2-git-send-email-tao.peng@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614569779-12114-2-git-send-email-tao.peng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:36:16AM +0800, Peng Tao wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit d78092e4937de9ce55edcb4ee4c5e3c707be0190 upstream.
> 
> fix #32833505

What does this mean?

And why are you all backporting random stable kernel patches to your
tree and not just taking all of them with a simple merge?

By selectivly cherry-picking patches like this, you are guaranteed to be
doing more work, and have a much more insecure and buggy kernel.  The
opposite of what your end goal should be, correct?

good luck!

greg k-h
