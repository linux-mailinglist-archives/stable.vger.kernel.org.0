Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6660D5A0C
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 05:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfJNDyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 23:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbfJNDyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Oct 2019 23:54:23 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30DCD2083B;
        Mon, 14 Oct 2019 03:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571025263;
        bh=uYcB8PgCIwdgGrIVcf3SezJHgLPztJ5ajN0YupMt4do=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=dcukEqjf/olPS5HcZk/UhAV5uMatMHZJRrNT9N0yovDcH+FF+2mBuDwWnUZ31bE4m
         VNQu0mbNlCigonnHPLl6H2v/9P1UE1nfUkgO9I/Ur0ywvi5TV+dfsIhRsbSzt0H/KV
         Ekl0MHvIwTbEtk/ERqqMZqVbZCtCR3aTvYBQNX7I=
Date:   Mon, 14 Oct 2019 03:54:22 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
To:     amd-gfx@lists.freedesktop.org, kmahlkuc@linux.vnet.ibm.com
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Revert "drm/radeon: Fix EEH during kexec"
In-Reply-To: <20191009181503.20381-1-alexander.deucher@amd.com>
References: <20191009181503.20381-1-alexander.deucher@amd.com>
Message-Id: <20191014035423.30DCD2083B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.3.5, v5.2.20, v4.19.78, v4.14.148, v4.9.196, v4.4.196.

v5.3.5: Build OK!
v5.2.20: Build OK!
v4.19.78: Build OK!
v4.14.148: Build OK!
v4.9.196: Build OK!
v4.4.196: Failed to apply! Possible dependencies:
    6f7fe9a93e6c0 ("drm/radeon: Fix EEH during kexec")
    a481daa88fd4d ("drm/radeon: always apply pci shutdown callbacks")
    a801abe4773da ("drm/radeon: wire up a pci shutdown callback")
    b9b487e494712 ("Revert "drm/radeon: always apply pci shutdown callbacks"")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
