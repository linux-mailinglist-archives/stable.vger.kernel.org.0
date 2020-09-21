Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D34F272442
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgIUMys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUMyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:47 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F825218AC;
        Mon, 21 Sep 2020 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692887;
        bh=/j/ViP8gdyjK4n8PeZDIi6lk1/pg4bbkLNZVq1siCgA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ltnnPfyQQa4w82Ia1HFQ1DlP5bt9AwTDHIDJT3GHeIKJAvOnjerEieQDkCq1YPApk
         zYAoHAwTll3lXuCf8OgsRsMjEzeaznaVdvx+ee9Ibzqfr4gk7B5Yqp/2S0CbHByJT7
         pM8KsHQi0Fg+FIPl9odBxaszxHY2R86jPd37PElU=
Date:   Mon, 21 Sep 2020 12:54:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/7] crypto: sun4i-ss: checking sg length is not sufficient
In-Reply-To: <1600367758-28589-3-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-3-git-send-email-clabbe@baylibre.com>
Message-Id: <20200921125447.2F825218AC@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Build OK!
v4.9.236: Failed to apply! Possible dependencies:
    a595e60a70c0 ("crypto: sun4i-ss - remove conditional checks against 0")

v4.4.236: Failed to apply! Possible dependencies:
    477d9b2e591b ("crypto: sun4i-ss - unify update/final function")
    a595e60a70c0 ("crypto: sun4i-ss - remove conditional checks against 0")
    bfb2892018ca ("crypto: sunxi - don't print confusing data")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
