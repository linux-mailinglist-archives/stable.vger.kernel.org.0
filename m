Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21030B853
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 08:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhBBHFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 02:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhBBHCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 02:02:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E8264EDF;
        Tue,  2 Feb 2021 07:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612249256;
        bh=Sx91zXS5CZ2NCFm3joeQvkrfBaSq7Dz4/hhWtEtu4R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PcVPk7bd6st8hJE1dMfrGQttc63UAXOr22gtcYkwt3I59ZNfBh1Br43xIUol7TVYX
         aqRGj85hYZKxuPp6cc5EMXLVOHCnn2JR7+fIfx6lhKzs0oN890SINZpTXlMK++Xna8
         FMi7Nsqp7GFyTYkbDj9LL01UTUibTBYoalIZprgM=
Date:   Tue, 2 Feb 2021 08:00:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Ikjoon Jang <ikjn@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zhanyong Wang <zhanyong.wang@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [next v2 PATCH] usb: xhci-mtk: skip dropping bandwidth of
 unchecked endpoints
Message-ID: <YBj4pfN7iq+U4zW2@kroah.com>
References: <1612247298-4654-1-git-send-email-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612247298-4654-1-git-send-email-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:28:18PM +0800, Chunfeng Yun wrote:
> For those unchecked endpoints, we don't allocate bandwidth for
> them, so no need free the bandwidth, otherwise will decrease
> the allocated bandwidth.
> Meanwhile use xhci_dbg() instead of dev_dbg() to print logs and
> rename bw_ep_list_new as bw_ep_chk_list.
> 
> Fixes: 1d69f9d901ef ("usb: xhci-mtk: fix unreleased bandwidth data")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> Tested-by: Ikjoon Jang <ikjn@chromium.org>
> Reviewed-by: Ikjoon Jang <ikjn@chromium.org>
> ---
> v2: add 'break' when find the ep that will be dropped suggested by Ikjoon
>     add Tested-by and Reviewed-by Ikjoon

As v1 is already in my public tree, please send a follow-on patch that
fixes it instead.

thanks,

greg k-h
