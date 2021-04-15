Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6029A361047
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhDOQiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 12:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhDOQiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 12:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC7CA610C8;
        Thu, 15 Apr 2021 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618504664;
        bh=C013CLRGjesu91Hpqsx1Pn/MxiLqA+upkZig7b6GAqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klq4qcanacJy3QF5p/8LcTmVcrV5Cr1JyoaLada2VaxDJbscW7gfSrUfRMGQINroV
         V63qErgUaLrrerjxj42RbjHVK+dUFYXbw/D+GUBvAvKDN49h8ryXBzP4NYa5LfMs63
         TPrqpGS/TztXSykNwb7Q0neYeo3AICe3+kIiuCyg=
Date:   Thu, 15 Apr 2021 18:37:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
Message-ID: <YHhr1WuX4/0l+9lP@kroah.com>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
> 
> 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
> 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")

The second patch here says that it's only needed to go back until:
	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")

Which is only backported to 4.19.  So why do older kernels need that, is
the fixes tag wrong?

thanks,

greg k-h
