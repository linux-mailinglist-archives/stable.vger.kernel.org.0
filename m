Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4148C2218DE
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 02:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgGPA1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 20:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgGPA1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 20:27:44 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E8C207CB;
        Thu, 16 Jul 2020 00:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594859263;
        bh=IsjXNncpCmOZxn1tiAp8sUEXyJpV2KJnumjDXnmqtGo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Tw3SlP66GNyX0XahdpspfhLpuGCoHL0bgZmWwRDQcdlbDBSaUTlPfCms51vJ6ncUV
         3rzXQ9BIwRHOoKPoZGlGy87lGzSw7wMsnjpum2cYVsJYYH/RCLKFQeByLugEY0dC9p
         t5svy4G0IwVCLzf+y6CpCLCmI3C+SFMHLJd9VFNU=
Date:   Thu, 16 Jul 2020 00:27:43 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Cc:     Frederic Weisbecker <frederic@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [tip: timers/urgent] timer: Prevent base->clk from moving backward
In-Reply-To: <159428908623.4006.8962643860352985536.tip-bot2@tip-bot2>
References: <159428908623.4006.8962643860352985536.tip-bot2@tip-bot2>
Message-Id: <20200716002743.A0E8C207CB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: a683f390b93f ("timers: Forward the wheel clock whenever possible").

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Build OK!
v4.14.188: Failed to apply! Possible dependencies:
    30587589251a0 ("timer: Fix coding style")

v4.9.230: Failed to apply! Possible dependencies:
    30587589251a0 ("timer: Fix coding style")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
