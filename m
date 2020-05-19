Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940DE1D95A6
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgESLtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbgESLtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:18 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D5E20758;
        Tue, 19 May 2020 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888958;
        bh=gt+DL+h2Jj48KB77zFys0B0Z8pdsBWERL6n/XavhLUU=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=zWtqkPDItTlUx+MqRZN1NurUjdIXCOdHMBZDtThcoQVNyxZZmo4NPiiIigEuEIccw
         urT77pytAZl8csK6oOQlB6r9RDfDRilY5jaO0kKoKJTg8d4G03IkG1ib4sgWeARs/g
         9TtpI1EL3LUh0ihcj6N56mddCnIVMZTARAdcSExQ=
Date:   Tue, 19 May 2020 11:49:17 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     od@zcrc.me, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 06/12] gpu/drm: Ingenic: Fix incorrect assumption about plane->index
In-Reply-To: <20200516215057.392609-6-paul@crapouillou.net>
References: <20200516215057.392609-6-paul@crapouillou.net>
Message-Id: <20200519114918.25D5E20758@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs").

The bot has tested the following trees: v5.6.13, v5.4.41.

v5.6.13: Build OK!
v5.4.41: Failed to apply! Possible dependencies:
    52e4607dace1 ("gpu/drm: ingenic: Use the plane's src_[x,y] to configure DMA length")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
