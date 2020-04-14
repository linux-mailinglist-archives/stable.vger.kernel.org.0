Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1B91A87B7
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgDNRky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 13:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgDNRkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 13:40:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F852054F;
        Tue, 14 Apr 2020 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586886052;
        bh=wifdIhHBXcBKo+z7JFNY3dNgAxQamyKVML4OkIclRLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqNIZMy/CJO8IlBNaoE4yafQcughMM/ou6rFRxyye6ssQ/QDZgQ4r46N+Rgrjf8Rh
         vMQq3+DYkSW7ymX04fjQI3hftHodeNJlFR7Lj24O0RGIPDD50Tx8yn6Vbaf7xAozjZ
         jm9sVOMz6gvdEIhu+509DvGCKsGXKgv073jbk3K0=
Date:   Tue, 14 Apr 2020 19:40:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH 4.19.y] erofs: correct the remaining shrink objects
Message-ID: <20200414174049.GA1035385@kroah.com>
References: <20200414153820.29012-1-hsiangkao.ref@aol.com>
 <20200414153820.29012-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414153820.29012-1-hsiangkao@aol.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 11:38:20PM +0800, Gao Xiang wrote:
> From: Gao Xiang <gaoxiang25@huawei.com>
> 
> commit 9d5a09c6f3b5fb85af20e3a34827b5d27d152b34 upstream.
> 
> The remaining count should not include successful
> shrink attempts.
> 
> Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
> Cc: <stable@vger.kernel.org> # 4.19+
> Link: https://lore.kernel.org/r/20200226081008.86348-1-gaoxiang25@huawei.com
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
> ---
> 
> trivial adaption, build verified.

Both backports now queued up, thanks.

greg k-h
