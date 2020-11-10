Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4012ACFB1
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgKJGas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 01:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJGas (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 01:30:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF62D2065D;
        Tue, 10 Nov 2020 06:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604989847;
        bh=mcptvCebsSCjDgKOVGkf81jFMFKnLnqj4ODmHnBc//E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2USH059Sa2/Hm2sqAgOKMxWJpQGEg4mOqGSbq8GP8KatYwy/TYUD23P1PJj62N8m0
         lMMcbwSh25O4ndsQzbYOa45JhQKysidCTWtojPGddE4nKb91vFUCiY+s93L0ZbQV3r
         DHdSMb8hzNUUi2c5i3vB2gWZw7cjnsd2NQ2f8h+k=
Date:   Tue, 10 Nov 2020 07:30:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 53/55] seq_file: add seq_read_iter
Message-ID: <X6ozk98QAeZZ41Fm@kroah.com>
References: <20201110035318.423757-1-sashal@kernel.org>
 <20201110035318.423757-53-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110035318.423757-53-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 10:53:16PM -0500, Sasha Levin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit d4d50710a8b46082224376ef119a4dbb75b25c56 ]
> 
> iov_iter based variant for reading a seq_file.  seq_read is
> reimplemented on top of the iter variant.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/seq_file.c            | 45 ++++++++++++++++++++++++++++------------
>  include/linux/seq_file.h |  1 +
>  2 files changed, 33 insertions(+), 13 deletions(-)

This is not needed for anything older than 5.10, please drop.

thanks,

greg k-h
