Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699672AB4A4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgKIKTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKIKTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:19:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC70020684;
        Mon,  9 Nov 2020 10:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604917175;
        bh=ujdtjONW6IMNC9nuw+sGKzRyA8g09Lt4MGCnjePFh/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjmKBgS8WrHpIl2O8dJ0a8cIhDE1OYrlZzMEZclXByLig/MGB43JCIt99psN3y3U/
         3hvOTQA1fPAGyHz69hORtqMSiZz5n0ikDRW1hfiITnK5Qpzv9+CogDs8f0k7hgNwdh
         rF0Ia6SgNh0KdwUNsqJRXV+bQXNK8XyQMN2WYvKo=
Date:   Mon, 9 Nov 2020 11:20:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Weiyi Lu <weiyi.lu@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Owen Chen <owen.chen@mediatek.com>
Subject: Re: [PATCH] clk: mediatek: fix mtk_clk_register_mux() as static
 function
Message-ID: <20201109102035.GA1238638@kroah.com>
References: <1604914627-9203-1-git-send-email-weiyi.lu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604914627-9203-1-git-send-email-weiyi.lu@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 05:37:07PM +0800, Weiyi Lu wrote:
> mtk_clk_register_mux() should be a static function
> 
> Fixes: a3ae549917f16 ("clk: mediatek: Add new clkmux register API")
> Cc: <stable@vger.kernel.org>

Why is this for stable trees?

