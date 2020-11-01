Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71432A1D4F
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKAKba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKAKb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:31:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5EA320709;
        Sun,  1 Nov 2020 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604226689;
        bh=DPX6AqOeUcQoNkcotTpifBY//U9/BpeCO3qRgX3yETM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HSPlMPRnh6lZBTO0HHm1VH7uN3qQbhGx6+ZMKKu29QmsNqP0+U2jn3ArQzYfa8bqp
         3/BahxDNmZ8gLeU+N6HWEbUn/ZPpjlK/RBpgOk+GHAzBsvgO3eodF/Nd5/TITb/Rcf
         VDl22aIO+2YZRBk7JDddg9drkKagJEhxScR00uHQ=
Date:   Sun, 1 Nov 2020 11:32:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4.9 0/2] backport some more fscrypt fixes to 4.9
Message-ID: <20201101103213.GC2558892@kroah.com>
References: <20201031231124.1199710-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031231124.1199710-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 04:11:22PM -0700, Eric Biggers wrote:
> Backport some fscrypt fixes from 4.10 and 4.11 to 4.9-stable.
> These will be needed for xfstest generic/395 to pass if
> https://lkml.kernel.org/fstests/20201031054018.695314-1-ebiggers@kernel.org
> is applied.
> 
> These are clean cherry picks.
> 
> Tested with 'kvm-xfstests -c ext4,f2fs -g encrypt'.
> 
> Eric Biggers (2):
>   fscrypto: move ioctl processing more fully into common code
>   fscrypt: use EEXIST when file already uses different policy

All now queued up, thanks.

greg k-h
