Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492EA434B4D
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTMlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhJTMlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EF06103D;
        Wed, 20 Oct 2021 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634733539;
        bh=NoKWHvHLJQLAaGVE33Y+gFJ9QQ/lAemyGHGGvGySsVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mVJnQvn/WvcfQaWDTjUpIVDBKzdLtLOiJEWUtexqV8M+raZeBCUXy7D8RdaOO0Zny
         VgGi1Gx56hcjWfnib9aQTrtTqpjZR5NHDMY45hz4Z2FEW9wgRSN+1S83T9+AxqYbr7
         eAppGOtVOiBq1R3GYNYgD12CCy22cfe1YZInuU8g=
Date:   Wed, 20 Oct 2021 14:38:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-5.10.y] io_uring: fix splice_fd_in checks
 backport typo
Message-ID: <YXAN4O/hbwA285iN@kroah.com>
References: <20211018171808.18383-1-kamal@canonical.com>
 <056adbd3-62eb-4aca-113e-f80c27c94a3b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056adbd3-62eb-4aca-113e-f80c27c94a3b@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 12:47:17PM -0600, Jens Axboe wrote:
> On 10/18/21 11:18 AM, Kamal Mostafa wrote:
> > The linux-5.10.y backport of commit "io_uring: add ->splice_fd_in checks"
> > includes a typo: "|" where "||" should be. (The original upstream commit
> > is fine.)
> 
> Oops indeed! Greg, can you queue this one up?

Sure, now done.

greg k-h
