Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB21E4B2B
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgE0Q6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgE0Q57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:57:59 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C04A20787;
        Wed, 27 May 2020 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590598679;
        bh=/sfSkwGo8uIjbuAXvRMgpMum3DCm0KDsUcPPZlHl398=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=SPS8Ap19MY4YJrOvAnLe/jR59kVmsGL4C/xBSTTxdGiwasSVuGT8APnajKudzqVG7
         LisOg9yX5iGvnE13D3A0r2aHB3R2hAYbVWAKaLcpYkbhfwF+S5t+E/g6aZIIDrvo/3
         /5LYIT7n+pEV/jAXnzA9lIhdmNEfRyKqyWWckUDA=
Date:   Wed, 27 May 2020 16:57:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     Stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] b43_legacy: Fix connection problem with WPA3
In-Reply-To: <20200526155909.5807-3-Larry.Finger@lwfinger.net>
References: <20200526155909.5807-3-Larry.Finger@lwfinger.net>
Message-Id: <20200527165759.3C04A20787@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices").

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Build OK!
v4.9.224: Build OK!
v4.4.224: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
