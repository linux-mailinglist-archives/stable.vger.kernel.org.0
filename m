Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F8C2A6040
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgKDJJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgKDJGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:06:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19C72223BD;
        Wed,  4 Nov 2020 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604480789;
        bh=Pzy2Gl/WVJi52itRofSV35Yi13CkZA2ZgqpKj8VOYWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IEsjekR5qP1Fp3A8/Ua0KyI34Tc6Zf2or0/hW2IjSLkdSu7BIkTys7+M/HNqVp53/
         SQS2jf4aCgAInW5uBwRwjesBnBoz72YXmSNkILlRVkWWhQBsBV09F60kgXQsKFwE4O
         4kRXvzEtt25wkA3ypP71S+0KLfwmqmyg7fR3cl3M=
Date:   Wed, 4 Nov 2020 10:07:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
        Theodore Tso" <tytso@mit.edu>
Subject: Re: [PATCH 4.19 034/191] fscrypt: fix race where ->lookup() marks
 plaintext dentry as ciphertext
Message-ID: <20201104090720.GC1588160@kroah.com>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203237.143516712@linuxfoundation.org>
 <20201103213552.GB394971@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103213552.GB394971@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 01:35:52PM -0800, Eric Biggers wrote:
> Looks like something went wrong with formatting the email addresses that receive
> these emails.  The Cc line has:
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
>         linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,        Theodore Tso" <tytso@mit.edu>, Eric
>         Biggers <ebiggers@google.com>, Theodore Ts'o <tytso@mit.edu>
> 
> The list addresses are part of display name of "tytso@mit.edu", so they
> apparently didn't receive this email.

Quilt's handling of the ' character in email cc: is horrible, and caused
this mistake, sorry.  One of these days I'll figure out what needs to be
patched to fix that up...

thanks,

greg k-h
