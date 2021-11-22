Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1838C458E54
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 13:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhKVMbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 07:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhKVMba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 07:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E36AE60F8F;
        Mon, 22 Nov 2021 12:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637584104;
        bh=TVR6Nh/vbmDh/ra0zteGnlY8GFMetWTqliUpH7032kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eR1nP3cLEUgrE/0me9c4FPSkDQIhXc38fWgQzlJs4MjdZHwsll/qwPW7Vi7UoMLpA
         ytCxDKjs3BvCfOquk4pushj8I06KLvl8L5Y9ue9jqCuWlGFFVyG+xL2OAdPYEWeend
         F1PSNQ//7TaeOS96mp6HX6kJz3epV7Qm1d2RBM4k=
Date:   Mon, 22 Nov 2021 13:28:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-5.15.x 0/2] DAMON fixes
Message-ID: <YZuM5QYbgjbxAR49@kroah.com>
References: <20211121110211.17032-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121110211.17032-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 21, 2021 at 11:02:09AM +0000, SeongJae Park wrote:
> This patchset is a backport of DAMON fixes that merged in the mainline,
> for v5.15.x stable series.
> 
> SeongJae Park (2):
>   mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer
>     allocation
>   mm/damon/dbgfs: fix missed use of damon_dbgfs_lock
> 
>  mm/damon/dbgfs.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> -- 
> 2.17.1
> 

Now queued up, thanks for the backports.

greg k-h
