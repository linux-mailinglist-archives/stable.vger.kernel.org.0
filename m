Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159F025AF8E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIBPlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgIBNp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 09:45:27 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C12A20767;
        Wed,  2 Sep 2020 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599053926;
        bh=FO/90G4itIgxxN1W1kStpgfVtuKzsMA5nfqzHUr26bU=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tow7Heak6FFdKBk5425JOeJcD2OMnTVI5wftAR9OP3GIlE+SPX6HGQ21FZYXg1yx8
         cq+TO6IoK5FWZ5ishjf/bwBKUkxWMM4buYdLa3Kdezud96cU6N5pmL7MWMNwzA+DCL
         jdmcO8gI73WGMtv4fZW1qV/cRuOcOdU3h4hiUJec=
Date:   Wed, 02 Sep 2020 13:38:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
In-Reply-To: <20200901234240.197917-1-lyude@redhat.com>
References: <20200901234240.197917-1-lyude@redhat.com>
Message-Id: <20200902133846.9C12A20767@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support").

The bot has tested the following trees: v5.8.5.

v5.8.5: Failed to apply! Possible dependencies:
    0a96099691c8 ("drm/nouveau/kms/nv50-: implement proper push buffer control logic")
    0bc8ffe09771 ("drm/nouveau/kms/nv50-: Move hard-coded object handles into header")
    12885ecbfe62 ("drm/nouveau/kms/nvd9-: Add CRC support")
    203f6eaf4182 ("drm/nouveau/kms/nv50-: convert core update() to new push macros")
    2853ccf09255 ("drm/nouveau/kms/nv50-: wrap existing command submission in nvif_push interface")
    344c2e5a4796 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core or_ctrl()")
    3c43c362b3a5 ("drm/nouveau/kms/nv50-: convert core caps_init() to new push macros")
    5e691222eac6 ("drm/nouveau/kms/nv50-: convert core init() to new push macros")
    9ec5e8204053 ("drm/nouveau/kms/nv50-: convert core or_ctrl() to new push macros")
    b11d8ca151d0 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core init()")
    b505935e56b2 ("drm/nouveau/kms/nv50-: convert core wndw_owner() to new push macros")
    d8b24526ef68 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core caps_init()")
    e79c9a0ba5e7 ("drm/nouveau/nvif: give every mem object a human-readable identifier")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
