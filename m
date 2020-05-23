Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C381DF6CA
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 13:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgEWLLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 07:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgEWLLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 07:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A673D206DD;
        Sat, 23 May 2020 11:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590232276;
        bh=l/QwrpczQ1IvAa/Tg9RIUxVo05SBqnU6rqge6ZzAskg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JI+oBvLOMlmNEX9JyQwLCp/Kt0N/wDzw7Pm/gpC5COSR8b3/PdwqEe3TDq2TZhuK7
         od2p46NLCu+28PIN8LRp9BzJ0diNv/OS6yI2nCu7EbI3lReu5bl1HpQjKSegA9hUcu
         MyRtCnjS2ZJuVOIC8AC6cD7sYuMzSRD4jDRz6H0c=
Date:   Sat, 23 May 2020 13:11:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     colin.king@canonical.com, stable@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] ext4: lock the xattr block before checksuming it
Message-ID: <20200523111112.GA3632470@kroah.com>
References: <1490633793174140@kroah.com>
 <20200523031821.501455-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523031821.501455-1-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 08:18:21PM -0700, Sultan Alsawaf wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> commit dac7a4b4b1f664934e8b713f529b629f67db313c upstream.
> 
> We must lock the xattr block before calculating or verifying the
> checksum in order to avoid spurious checksum failures.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=193661
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
> Hi,
> 
> I've been experiencing spurious ext4 checksum failures on 4.4 because
> this patch is missing (which is quite painful with panic-on-error
> enabled). This backport fixes the issue for me.
>  fs/ext4/xattr.c | 66 ++++++++++++++++++++++++-------------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)

Now queued up, thanks.

greg k-h
