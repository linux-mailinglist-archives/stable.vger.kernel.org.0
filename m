Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C591C497158
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 12:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiAWLr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 06:47:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiAWLr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 06:47:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC3660BAC;
        Sun, 23 Jan 2022 11:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D83CC340E2;
        Sun, 23 Jan 2022 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642938477;
        bh=rFp/yN48cpk/ut0/dbyFyGSEUZAJkEo9wRKhftFT/FE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O1oKMEhCdinMIElAVRgvQhZojLlG+2vl61yCRA5eRACYBv5GGsrruXGcmpe3D2Hsm
         JBpDfbamQcX5tybqmcpeMMgKZAgvXQvcd+fuTjpWBL+lhgDIs8cq3zjYnTb+I+W9W3
         Vug5n0+5/HvYhR7NJFw4GTfq8iKSk94g+li5/4TrYAfIIHE/aYd6gOa72Vofqo0sAY
         +7mPZ1mCBobHGeT5cFI3iTD8aiYl4c42P1dLdLISYeZwix+LCkIFpy/qSbFOe1xOMe
         01M5G8Ep5GWnazGONayBMqiE77QBlhIQ54DUo4dBuoIhePo+I3JrWmdpnVsmawTTkl
         lYiZJ3Em8ARCg==
Date:   Sun, 23 Jan 2022 17:17:53 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Swapnil Jakhade <sjakhade@cadence.com>,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] phy: ti: Fix "BUG: KASAN: global-out-of-bounds in
 _get_maxdiv" issue
Message-ID: <Ye1AaZnnjWFZXvWK@matsya>
References: <20220117110108.4117-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117110108.4117-1-kishon@ti.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17-01-22, 16:31, Kishon Vijay Abraham I wrote:
> _get_table_maxdiv() tries to access "clk_div_table" array out of bound
> defined in phy-j721e-wiz.c. Add a sentinel entry to prevent
> the following global-out-of-bounds error reported by enabling KASAN.

Applied, thanks

-- 
~Vinod
