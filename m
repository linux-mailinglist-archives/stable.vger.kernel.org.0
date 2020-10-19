Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6545E292D00
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgJSRml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbgJSRml (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 13:42:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C58B20720;
        Mon, 19 Oct 2020 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603129361;
        bh=RfrTCidALdftT0BtNOmHgEMqPyabobNKzsG38fnWsTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rghtu6+R/BkH6PeKX6wlekyZM8xZT3TTJTJbv8SGmnV+YRZ7fVlIqyaSFuD14ITJW
         ROL1GaHtxiV6RO6MRo5zMPyUI+0Ufv2tP7YUU3vFuSQ6hL5Lu5CN4xUWi8FEVFnGNk
         G72DUl5P5kUClYieO2bVvBqtrQzH18hMQQhSpSKE=
Date:   Mon, 19 Oct 2020 19:43:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Protopopov, Boris" <pboris@amazon.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9-5.8] Convert trailing spaces and periods in path
 components
Message-ID: <20201019174325.GD3327376@kroah.com>
References: <20201017152839.4398-1-pboris@amazon.com>
 <20201018055519.GB599591@kroah.com>
 <B1901644-CAEB-45B7-87F8-A05C70423914@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B1901644-CAEB-45B7-87F8-A05C70423914@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Mon, Oct 19, 2020 at 02:17:35PM +0000, Protopopov, Boris wrote:
> I could not find the patch in Linus's tree at https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/cifs/cifs_unicode.c#n491 or in the commit list. The patch is in linux-next, commit https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=7698a46ed868f03afe1871d7cb63061db6a62b71

Have you read the rules for stable patches:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Please do so, you seem to be missing the "MUST BE IN LINUS'S TREE"
requirement...

greg k-h
