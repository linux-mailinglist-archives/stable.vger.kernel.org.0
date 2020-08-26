Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924E2253084
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgHZNyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730446AbgHZNx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:56 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF7222B49;
        Wed, 26 Aug 2020 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450036;
        bh=OV4bwx36FNw2xv7P1ILL50dIdP+4ztOih/WWEpibydI=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=q0HHMwNiZbjG4uSe0dHHCHRVKXNaTb58Ui3GUpfSmKI9HgV1Su6I1E1Thd/hEF7Sk
         LUm7JF5nKbyOQjewa4GO9hU483wcH5IbyC9FAcvP/n9COK1DU0AvrDZL35kqAzkabP
         QRodIDdZPYywSAs3Zx0ZqXKoQ106KMBHYB+UuPj0=
Date:   Wed, 26 Aug 2020 13:53:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
In-Reply-To: <20200806230129.324035-1-lyude@redhat.com>
References: <20200806230129.324035-1-lyude@redhat.com>
Message-Id: <20200826135356.0FF7222B49@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support").

The bot has tested the following trees: v5.8.2.

v5.8.2: Failed to apply! Possible dependencies:
    3c43c362b3a5 ("drm/nouveau/kms/nv50-: convert core caps_init() to new push macros")
    5e691222eac6 ("drm/nouveau/kms/nv50-: convert core init() to new push macros")
    d8b24526ef68 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core caps_init()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
