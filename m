Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE373452CAB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 09:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhKPI1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 03:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhKPI0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 03:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A29361B49;
        Tue, 16 Nov 2021 08:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637051036;
        bh=OVXwhI5lQeFB2cyFD7EtpBMvt7F+BFfPHdqIKI8FKiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YENtCLsHCGiCxkEqr+4qPeXGQiR7ecaoKexg9WM4O9gpLETpV/G4Eb1RS4kohz7U3
         Jn0bTF/vbZb3NeJD8NTQ/3rTg+qwXgoiaoBmj2r77i0KiHoX4Q5ApfD4XGNWXoxgZ6
         LhqqKLG3r9cgSRypfbVmoj1izC+SNRqjbVaOg1x4=
Date:   Tue, 16 Nov 2021 09:23:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: regmap-mux: fix parent clock lookup
Message-ID: <YZNqmpUXiub29QyU@kroah.com>
References: <20211115233407.1046179-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115233407.1046179-1-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 02:34:07AM +0300, Dmitry Baryshkov wrote:
> The function mux_get_parent() uses qcom_find_src_index() to find the
> parent clock index, which is incorrect: qcom_find_src_index() uses src
> enum for the lookup, while mux_get_parent() should use cfg field (which
> corresponds to the register value). Add qcom_find_cfg_index() function
> doing this kind of lookup and use it for mux parent lookup.
> 
> Fixes: df964016490b ("clk: qcom: add parent map for regmap mux")
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
