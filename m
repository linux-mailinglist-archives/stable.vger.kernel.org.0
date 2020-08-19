Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD06524AA17
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgHSX4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgHSX4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:35 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9D621744;
        Wed, 19 Aug 2020 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881394;
        bh=clNqGInZpcU+sLDTIvIChzWr8ATSGgZvfk4+nx2hB2U=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=cRPLAgRBIZGi9peqzU372KKon83fIunlNQQHRbXFGjy5YIyMydT3kzDJCgXkRKSYQ
         jVRDUpCIhk/RRyyhY19NHYyvjqLg1JEjwfdeeOTnONtCBShF5WTpi/iKtQ8btc5fIu
         08sS7p9x2nCBSoZsLGId8uw1E7FmuJTvfaSMKd4s=
Date:   Wed, 19 Aug 2020 23:56:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Oleksandr Andrushchenko <andr2000@gmail.com>
To:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
To:     xen-devel@lists.xenproject.org, dri-devel@lists.freedesktop.org
Cc:     sstabellini@kernel.org, dan.carpenter@oracle.com
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] drm/xen-front: Fix misused IS_ERR_OR_NULL checks
In-Reply-To: <20200813062113.11030-3-andr2000@gmail.com>
References: <20200813062113.11030-3-andr2000@gmail.com>
Message-Id: <20200819235634.BB9D621744@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c575b7eeb89f ("drm/xen-front: Add support for Xen PV display frontend").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Failed to apply! Possible dependencies:
    4c1cb04e0e7a ("drm/xen: fix passing zero to 'PTR_ERR' warning")
    93adc0c2cb72 ("drm/xen: Simplify fb_create")

v4.19.139: Failed to apply! Possible dependencies:
    4c1cb04e0e7a ("drm/xen: fix passing zero to 'PTR_ERR' warning")
    93adc0c2cb72 ("drm/xen: Simplify fb_create")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
