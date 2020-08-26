Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71CB25309B
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgHZNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:32910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgHZNyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:54:09 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B8822B4D;
        Wed, 26 Aug 2020 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450048;
        bh=JuAqmymlXknxnOT5ovSp9OFN7ov13jz91HXXbBOr4g8=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=hhGmH5XAIVa/ngoLWuqQRgDVirjHEIrPsd661ZtCQ2tdr4NME4jcd1UaG8C4zUP4u
         CdYWcx4Bs0EZlmOzGikPtSt7p2BNdy10HAKMoLVdE/dF7plGaS4oUB13H4/NjLbtmT
         rqTmT4Vo3ZNtYLgHujAXM/pLSOjz5oXxFLSwwhJc=
Date:   Wed, 26 Aug 2020 13:54:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
To:     Rajendra Nayak <rnayak@codeaurora.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V2 1/4] opp: Enable resources again if they were disabled earlier
In-Reply-To: <c6bba235a9a6fd777255bb4f1d16492fdcabc847.1597292833.git.viresh.kumar@linaro.org>
References: <c6bba235a9a6fd777255bb4f1d16492fdcabc847.1597292833.git.viresh.kumar@linaro.org>
Message-Id: <20200826135408.54B8822B4D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59.

v5.8.2: Build OK!
v5.7.16: Build failed! Errors:
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'

v5.4.59: Build failed! Errors:
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
    drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
    drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
