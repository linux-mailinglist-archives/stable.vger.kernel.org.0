Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C8132E3EF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 09:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCEIuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 03:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhCEIts (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 03:49:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B66AE64F59;
        Fri,  5 Mar 2021 08:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614934188;
        bh=qaMrYDe8z5Me54q4yibSeWrMuvbYeOMpC3KWLRnRU3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h50lT6rg8IDHa6LJGNjGB0yZ1xE3c3xViOwR/XxAk6TaA9agJf6bMA7UtQmRGj2VT
         XteaxVcU7RlIgj4faI6JFatuqx1Lo0oH5UNq+z5Qga+uwLSm+9vxCIxru5StG+DGIY
         dylK93eW0JZ/uYkBZX4G3KNQ8CLoeCvHotya0/cU=
Date:   Fri, 5 Mar 2021 09:49:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 5.4.y 0/4]  dm: device capability check fixes
Message-ID: <YEHwqdEgMJI/ly3L@kroah.com>
References: <161460625264244@kroah.com>
 <20210305065722.73504-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305065722.73504-1-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:57:18PM +0800, Jeffle Xu wrote:
> - patch 1/3/4 is from upstream
> - patch 2 is to fix the code specific to 4.4 (has been removed in upstream)

What commit removed it?  Why not just take that instead?

thanks,

greg k-h
