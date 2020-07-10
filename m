Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69FD21B7A7
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGJOC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgGJOC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:57 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18E06207BB;
        Fri, 10 Jul 2020 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389777;
        bh=eM0Ao62YKFdPT0OPwr8aTRMpQDLdKVZ5S0zGdE4uUyQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=mfb/PjeWH3jfrV3TRQDr27G3HNWzfXZH0iuG5/+aFmgGH36w0/2lNSLqWd9dY3Kjt
         Uk/Uv2fO1USbH9aPAeOik5ju2k45A3K/4pxWwG/x6mtAeWzEPBzCqNLcTYGe8FLVJb
         BN9xhbSEOkQEmmMP7pMrwUNu9/bbe6QkhvknM+Jg=
Date:   Fri, 10 Jul 2020 14:02:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
In-Reply-To: <20200630100546.862468-1-maz@kernel.org>
References: <20200630100546.862468-1-maz@kernel.org>
Message-Id: <20200710140257.18E06207BB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.").

The bot has tested the following trees: v5.7.7, v5.4.50.

v5.7.7: Build OK!
v5.4.50: Failed to apply! Possible dependencies:
    29d867e97f7d7 ("PM / devfreq: rk3399_dmc: Add missing of_node_put()")
    39a6e4739c19d ("PM / devfreq: rk3399_dmc: Disable devfreq-event device when fails")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
