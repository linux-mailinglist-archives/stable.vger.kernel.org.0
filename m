Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5E2281E1
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgGUOUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgGUOUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:20:08 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629D02064C;
        Tue, 21 Jul 2020 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595341208;
        bh=bMPYC0gZ0eNGnCJiMAOsEC/ZU7Ksgvb8HLWXo+1fi6g=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=kvwK9Xf0YMlsveS8meiduoYaEXEkgSHtyVwjfEcqd7dK+hZ1oNsvWlcYFiUHoCtMk
         CcpCxGcJve2O5hB/nrixA2by4tp7FOvQjfP5+Cn5THIwpPA7jsSf/H4ghiXoN2PaKO
         lrlwdj9PQ42HAtGTvP7tJm6R1zD55/VXvSy+mvF4=
Date:   Tue, 21 Jul 2020 14:20:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 01/12] drm/ingenic: Fix incorrect assumption about plane->index
In-Reply-To: <20200716163846.174790-1-paul@crapouillou.net>
References: <20200716163846.174790-1-paul@crapouillou.net>
Message-Id: <20200721142008.629D02064C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs").

The bot has tested the following trees: v5.7.9, v5.4.52.

v5.4.52: Failed to apply! Possible dependencies:
    52e4607dace1e ("gpu/drm: ingenic: Use the plane's src_[x,y] to configure DMA length")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
