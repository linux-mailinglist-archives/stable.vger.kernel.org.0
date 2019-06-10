Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AF3AEC8
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 07:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387681AbfFJFyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 01:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387553AbfFJFyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 01:54:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCDB5207E0;
        Mon, 10 Jun 2019 05:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560146058;
        bh=SdTHp/TyZpsY2HHoAFBFOvkMbdzwPg4g3t/s7P1llZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IMlgVFjyjnXtceUTFfBCKuHy/svWO6lT6BbHXv7JMkg43JBZkqeA/rE0LPbldV1lX
         JGzDs64HZz09AaDFyKmHtObcluRExtZsIWY7gfWxobq84KQiYsM8cgF3yU8usg6hYD
         0o9avCKQZfMZyAGqos8pewoPXYsXKsF0lalC28Xw=
Date:   Mon, 10 Jun 2019 07:54:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Weiyi Lu <weiyi.lu@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Biao Huang <biao.huang@mediatek.com>
Subject: Re: [RFC v1] clk: core: support clocks that need to be enabled
 during re-parent
Message-ID: <20190610055415.GC13825@kroah.com>
References: <1560138293-4163-1-git-send-email-weiyi.lu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560138293-4163-1-git-send-email-weiyi.lu@mediatek.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 11:44:53AM +0800, Weiyi Lu wrote:
> When using property assigned-clock-parents to assign parent clocks,
> core clocks might still be disabled during re-parent.
> Add flag 'CLK_OPS_CORE_ENABLE' for those clocks must be enabled
> during re-parent.
> 
> Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
> ---
>  drivers/clk/clk.c            | 9 +++++++++
>  include/linux/clk-provider.h | 1 +
>  2 files changed, 10 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
