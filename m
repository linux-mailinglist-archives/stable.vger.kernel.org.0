Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277471C3433
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEDISI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgEDISH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 04:18:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9FB206B9;
        Mon,  4 May 2020 08:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588580287;
        bh=0iDTsnT6P9dDd1+lVt96UqPw8ErMGMFT3i80zddno2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=leh00orGN9koJl+6GBRjT48HUJLUdiTxC6H824N3AU4a4HO9ulHUSMDgwwDhwZiiO
         Xsz2iTq4iepdmliTK3nzS/yYpzlOQTBnQb/zGrZdLoMmmIY8Q1DLfniGbh3l5tcreh
         +vd9v7XJC8iVmyFDRa3S5NnzkD0hBeg4hcRRzl2o=
Date:   Mon, 4 May 2020 10:18:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     olga.kornievskaia@gmail.com, kolga@netapp.com,
        trond.myklebust@hammerspace.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] NFSv4.1: fix handling of backchannel
 binding in" failed to apply to 5.4-stable tree
Message-ID: <20200504081804.GA988720@kroah.com>
References: <158857979623126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158857979623126@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 04, 2020 at 10:09:56AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind, I fixed this up by hand.

greg k-h
