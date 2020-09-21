Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F627245A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgIUMzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbgIUMzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:55:04 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD225221EC;
        Mon, 21 Sep 2020 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692902;
        bh=5O0cAAXtuqI4SBzaqKAjJmi8X79NcwFPjsFqFs/2jy0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=cyDkGeju7lETEwZiG9s1kejkccsKOsyqokIzM6OfxnW5y90eBnc+v3FjNxH7JnHn9
         MfNIda228f0j+lF47dUOwEfU1odtdpZ9Z3iJKh3oKiw0qEcVpkjzoTarFUdZGJK4IN
         37mGcIV+6QMueKqBqaorKvjUH3K4rM+x0zqz88QA=
Date:   Mon, 21 Sep 2020 12:55:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
To:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Cc:     christian.koenig@amd.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] Revert "drm/radeon: handle PCIe root ports with addressing limitations"
In-Reply-To: <20200916132017.1221927-1-alexander.deucher@amd.com>
References: <20200916132017.1221927-1-alexander.deucher@amd.com>
Message-Id: <20200921125502.BD225221EC@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 33b3ad3788ab ("drm/radeon: handle PCIe root ports with addressing limitations").

The bot has tested the following trees: v5.8.10, v5.4.66.

v5.8.10: Build OK!
v5.4.66: Failed to apply! Possible dependencies:
    8b53e1cb2728 ("drm/radeon: switch to gem vma offset manager")
    9d6f4484e81c ("drm/ttm: turn ttm_bo_device.vma_manager into a pointer")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
