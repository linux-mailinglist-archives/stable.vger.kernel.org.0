Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F231C4160F5
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 16:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241467AbhIWO0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 10:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241308AbhIWO0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 10:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17A946109E;
        Thu, 23 Sep 2021 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632407081;
        bh=i+5Z5W+ysrmxGWA8QlaVdyJvIyc+RACrUSbmAAuM9JI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AsHupSQO3swWI6AW3NmlJMfbKDCM9laOb0cxc+SozOYm0Z7TnLkXszimpK/PnwCEE
         0BiZscdIbsZYxlW50OE4mmZdFq2hT5zyuj7p+r/CNHKGv1xzjyCsPVkH4a1pkWD+ai
         I6whh89dqTvNl5ihf0zWQmSCcILYmhz8SzjoZDCg=
Date:   Thu, 23 Sep 2021 16:24:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng Chao <cs.os.kernel@gmail.com>
Cc:     labbott@redhat.com, sumit.semwal@linaro.org, arve@android.com,
        riandrews@android.com, devel@driverdev.osuosl.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9] staging: android: ion: fix page is NULL
Message-ID: <YUyOJ/TPelF7r5Va@kroah.com>
References: <CA+1SViD_my-MPyqXcQ2T=zxF8014u6N-n2Fqcbi9BJPfo3KaTA@mail.gmail.com>
 <20210923141814.1109472-1-cs.os.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923141814.1109472-1-cs.os.kernel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 23, 2021 at 10:18:14PM +0800, Cheng Chao wrote:
> Fixes: commit e7f63771b60e ("ION: Sys_heap: Add cached pool to spead up cached buffer alloc")
> the commit e7f63771b60e introduced the bug which didn't test page which maybe NULL.
> and previous logic was right.
> 
> the e7f63771b60e has been merged in v4.8-rc3, only longterm 4.9.x has this bug,
> and other longterm/stable version have not.

<snip>

thanks for this, now queued up.

greg k-h
