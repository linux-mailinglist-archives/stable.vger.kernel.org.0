Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5DC47A039
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 11:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhLSKk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 05:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhLSKk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 05:40:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B983C061574;
        Sun, 19 Dec 2021 02:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF83B80CA8;
        Sun, 19 Dec 2021 10:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E80C36AE0;
        Sun, 19 Dec 2021 10:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639910455;
        bh=vSC2BJyhnf6Q1CVJ13NrRvcfJTkRhr7dQpxqqDwXIvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoyK0JYVdZskNUm33a0xe5yTc4u8nllKzGjR4JTvwtLoc4i659gpry64XOzAMTZEG
         0W5JBHy3Q7LkzBrcQ7BDg6JRqLh+vf63s+4YtVKCwnDXMb3+wszNTrN//EpLuYZO+B
         Kq07EAeTByK4dZYe6WgNg4jKYdYG3S7G4wBH1Z/I=
Date:   Sun, 19 Dec 2021 11:40:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>, stable@vger.kernel.org,
        Yuwen Ng <yuwen.ng@mediatek.com>
Subject: Re: [PATCH v2 3/4] usb: mtu3: fix list_head check warning
Message-ID: <Yb8MM2zL2Ecfzv1/@kroah.com>
References: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
 <20211218095749.6250-3-chunfeng.yun@mediatek.com>
 <64b9453a-84c5-8d41-26d5-698d1ae9d473@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b9453a-84c5-8d41-26d5-698d1ae9d473@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 19, 2021 at 01:14:25PM +0300, Sergei Shtylyov wrote:
> On 18.12.2021 12:57, Chunfeng Yun wrote:
> 
> > This is caused by uninitialization of list_head.
> 
>    Again, there's no such word as "uninitialization" (even if it existed, it
> wouldn't mean what you wanted to say); please replace by "not initializing".

We are not English language scholars, most of us do not have English as
their native language.  We all can understand what is being said here,
there's no need for any change, please do not be so critical.

thanks,

greg k-h
