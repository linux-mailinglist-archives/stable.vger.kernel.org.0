Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC2D2501C0
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHXQKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgHXQKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:10:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A912072D;
        Mon, 24 Aug 2020 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598285403;
        bh=0gWHk87xcbVBllUJKQt0YOJrPLVaKT8GXW9QXecvXGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Scgpb744nC6We6ULD4ryYR1ZO2SoL3xuRTFsiPR56Sp6eCS4Py88EfvxtKFP6rd63
         HMVbNjK2yxRjNa5+Dnss3AvOb2Z859AXtcfqE06iVnag5yorNgHuZOZE9AOvfupnTu
         XVmU+rk5N5hfYux1Uzk/awYkCcHpMKKThy5oPSLc=
Date:   Mon, 24 Aug 2020 18:10:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - for v5.7 stable] opp: Put opp table in
 dev_pm_opp_set_rate() for empty tables
Message-ID: <20200824161021.GD435319@kroah.com>
References: <e7e9f887328c06800a79f3b48feb623fd15aa3d5.1598261323.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e9f887328c06800a79f3b48feb623fd15aa3d5.1598261323.git.viresh.kumar@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 03:00:03PM +0530, Viresh Kumar wrote:
> From: Stephen Boyd <swboyd@chromium.org>
> 
> commit 8979ef70850eb469e1094279259d1ef393ffe85f upstream.
> 
> We get the opp_table pointer at the top of the function and so we should
> put the pointer at the end of the function like all other exit paths
> from this function do.
> 
> Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
> Fixes: aca48b61f963 ("opp: Manage empty OPP tables with clk handle")
> Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> [ Viresh: Split the patch into two ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> [ Viresh: Update the code for v5.7-stable ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/opp/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This is already in the 5.7-stable queue, why add it again?

confused,

greg k-h
