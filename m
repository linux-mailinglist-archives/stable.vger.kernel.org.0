Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AE4327F26
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhCANNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235282AbhCANNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 08:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45AB764DF2;
        Mon,  1 Mar 2021 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614604347;
        bh=D7VwOQJqgKMmQHDWVFAr8nAnfEFpFFmoYDfbrvFtRdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EIM2b8yGpBZAmLETzNM3B0LNFoSMWmMW/Fcx1vkoxl33OrKo6Okz9Pd5RqXxeXZeJ
         nZRj/Mjj7J+L13kH3wB814DzqpZRkZyJSm9HKFeytxTGK9Qyq+OJvfSbABar0Nb15d
         nNFIqMPtK7DiPegKiyH5mj/VevGVzdfmjPHpXgLQ=
Date:   Mon, 1 Mar 2021 14:12:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     lazlev@web.de, mchehab+huawei@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: smipcie: fix interrupt handling
 and IR timeout" failed to apply to 5.4-stable tree
Message-ID: <YDzoOBI3lzNxtBZu@kroah.com>
References: <161459748923477@kroah.com>
 <20210301130558.GA27665@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301130558.GA27665@gofer.mess.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 01:05:58PM +0000, Sean Young wrote:
> On Mon, Mar 01, 2021 at 12:18:09PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> commit 6532923237b427ed30cc7b4486f6f1ccdee3c647 backported to 5.4 follows.

Now applied, thanks.

greg k-h
