Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC26921B7A5
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgGJOC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgGJOC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA68D207DF;
        Fri, 10 Jul 2020 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389776;
        bh=50V+iGgf2MS3379aPyK1msckdvEEfeg1k+ec1BjefyA=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=TVZm3YGF6QxfR89Du+7H+Rf/celh5kAZEzr2KKKY0p3HqN4g+ilFI6cSBB28Z7USU
         IjwtZgDkuKntOm57Ukp09LhVzmrZYSfH33LUv5k6gV6A3WRXkmx+jXOu47Tzfe4q9l
         HGISlrGO7G5XgaZUlbp/UvmQ4ulslbCssWoECEYE=
Date:   Fri, 10 Jul 2020 14:02:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jia He <justin.he@arm.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Michal Hocko <mhocko@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done
In-Reply-To: <20200707055917.143653-4-justin.he@arm.com>
References: <20200707055917.143653-4-justin.he@arm.com>
Message-Id: <20200710140255.DA68D207DF@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat").

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Failed to apply! Possible dependencies:
    eca499ab3749a ("mm/hotplug: make remove_memory() interface usable")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
