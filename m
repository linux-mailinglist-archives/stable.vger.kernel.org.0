Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3531E4B2E
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgE0Q6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbgE0Q6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:58:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 881A720787;
        Wed, 27 May 2020 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590598681;
        bh=8Sy4SGFy9WOB7rPR7XK0WJf25jfeyvcDfaCkmDkOQcY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=AF6ryynabKsEYO3hngGvgiNlC90+DQNQrRYz2J4gHPe8169ly0IRsa9ZL97tex1Dj
         YjuO5foOhUtaEVobRsWFDMEkksY2M6f77Vws/T7zsL7g+LrW7fABo10VYJcnC58cxY
         iNj3xvpiaZgT/awOGP7POl8yo7eqEsBAEjgidIaM=
Date:   Wed, 27 May 2020 16:58:00 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     Stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] b43: Fix connection problem with WPA3
In-Reply-To: <20200526155909.5807-2-Larry.Finger@lwfinger.net>
References: <20200526155909.5807-2-Larry.Finger@lwfinger.net>
Message-Id: <20200527165801.881A720787@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

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
