Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA06237773C
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 17:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhEIPTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 11:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhEIPTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 11:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A04D6613D9;
        Sun,  9 May 2021 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620573485;
        bh=RE5hqTWTfPSpLz9/0hNBO674+QwAoalqxVClljKRHcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QgSmlfSKMLNfAgJarhy2DpP+3p21+0BW7QvyWUe3uTTZYCcXpTZMyG+d5rnHa8EF4
         vrLCjQOtN2woACNKmSHn6qlsijzcO0n8bIcqnIfYMb6u3qyiCQINZaNJHUaSTQIKF1
         LYKMhZYJ56Mt++wt1URVqvxawq7t1is54mdg/Fk0=
Date:   Sun, 9 May 2021 17:18:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request (GCC11-related fixes)
Message-ID: <YJf9K7+t6IciMJcI@kroah.com>
References: <CAHtQpK6OD1yVkStsmP1d736ipHzk-ycEHQHHNnJEjxjAUQ-eFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHtQpK6OD1yVkStsmP1d736ipHzk-ycEHQHHNnJEjxjAUQ-eFw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 09:58:19PM +0200, Andrey Zhizhikin wrote:
> Hello Greg,
> 
> Can you please pick up following patches to respective releases from [master]:
> 82e5d8cc768b ("security: commoncap: fix -Wstringop-overread warning")
> # 4.14.y, 4.19.y, 5.4.y, 5.10.y
> e7c6e405e171 ("Fix misc new gcc warnings") # 4.19.y, 5.4.y, 5.10.y
> 
> They do solve build warnings with GCC11.

Now queued up, thanks.

greg k-h
