Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFABC3B58A9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 07:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhF1Foq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 01:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhF1Foq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 01:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B02A61C17;
        Mon, 28 Jun 2021 05:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624858941;
        bh=8kPsxiKplIOG09PMS3o+imfXElGS2OAMUTIFSFHl+bQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZfEtWKPjkYgMZ782UBxpDRZlxYzzttgNA0UB/9kRluRXTKWkRiNKM7uiNxJ1plVT
         oTwVczFMi3LCRB4obGsID7LVHRh91dG+nSoSeUnrh8CNirqP2fUykRUYx7AE4rioze
         OKpTKrbWRoIfM/7I0NJNQFHy9vrUUB800k9n5rcKbxSeBr3PDUXHLp3hL8eU9bmGqf
         SsfX+HY4712dlylqiRFLd9RQKF4Tq8NS82lhNjcTbtdyriAPYQZiOVi3Hib5h/HF51
         e0khV/aOYhN+AU8KDHwLyYXB3LSBJadLvI66z30jls4wd9KAlv7/NLRnYuOHhpJSoz
         xde4A/PoZGHCg==
Date:   Mon, 28 Jun 2021 11:12:17 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, dmitry.baryshkov@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: gdsc: Ensure regulator init state matches
 GDSC state
Message-ID: <YNlhOelUfJwfbHCd@matsya>
References: <20210625225414.1318338-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625225414.1318338-1-bjorn.andersson@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25-06-21, 15:54, Bjorn Andersson wrote:
> As GDSCs are registered and found to be already enabled
> gdsc_toggle_logic() will be invoked for votable GDSCs and ensure that
> the vote is matching the hardware state. Part of this the related
> regulator will be enabled.
> 
> But for non-votable GDSCs the regulator and GDSC status will be out of
> sync and as the GDSC is later disabled regulator_disable() will face an
> unbalanced enable-count, or something might turn off the supply under
> the feet of the GDSC.
> 
> So ensure that the regulator is enabled even for non-votable GDSCs.

Reviewed-by: Vinod Koul <vkoul@kernel.org>

-- 
~Vinod
