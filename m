Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220FD5E387
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfGCMLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCMLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE759218A0;
        Wed,  3 Jul 2019 12:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562155881;
        bh=QaUR8U0G+HmOgXfWvA5EAVTzuHbIVxHbrd6B6PihJpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZI2Qufq/o9t0mFmMK5PvT8M+jMKW9Dkd6CUqyFsyN/6QFsF6ZoHScMSWMGNmYmsL
         VGTlnoWjLSprwYcC1kw917bTR/1kbyRxrY6PLGFjM7znrvvp6MNBofuBGGo7s+Yqck
         v7KvPW7q1nAHjh3rAz5/h0JMV9CC97LrBJt1AVoo=
Date:   Wed, 3 Jul 2019 14:11:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     astrachan@google.com, maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.4] um: Compile with modern headers
Message-ID: <20190703121118.GB7784@kroah.com>
References: <20190703094627.50424-1-balsini@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703094627.50424-1-balsini@android.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 10:46:27AM +0100, Alessio Balsini wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> 
> commit 530ba6c7cb3c22435a4d26de47037bb6f86a5329 upstream.
> 
> Recent libcs have gotten a bit more strict, so we actually need to
> include the right headers and use the right types. This enables UML to
> compile again.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Alessio Balsini <balsini@android.com>
> ---
>  arch/um/os-Linux/file.c   | 1 +
>  arch/um/os-Linux/signal.c | 2 ++
>  arch/x86/um/stub_segv.c   | 1 +
>  3 files changed, 4 insertions(+)

Thanks for this, now applied.

greg k-h
