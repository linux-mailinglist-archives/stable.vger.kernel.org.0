Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F86E24AA25
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgHSX4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgHSX4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:42 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB6921744;
        Wed, 19 Aug 2020 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881402;
        bh=Oq9ak067tZOreYkcNNEdaTtTd+RbCyZMbyNOYCsIPjg=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=2dliK9QnoVob8PFtBT8ZpQwkSQstn0Q3VZoqzaBGoezQ6sUSzew8BG5/q5Jnaw0fP
         n475WddT5jJvV0OJ0gDMSKYTtZm2zm972vTUPLRtMIf6FwnK9n6174i902JZVFW6OR
         eXIgjKVnIAl/8PPn4jjODxIdY0UUYWI/Ilq1Hh4c=
Date:   Wed, 19 Aug 2020 23:56:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
In-Reply-To: <20200806230129.324035-1-lyude@redhat.com>
References: <20200806230129.324035-1-lyude@redhat.com>
Message-Id: <20200819235642.0BB6921744@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support").

The bot has tested the following trees: v5.8.1.

v5.8.1: Failed to apply! Possible dependencies:
    3c43c362b3a5 ("drm/nouveau/kms/nv50-: convert core caps_init() to new push macros")
    5e691222eac6 ("drm/nouveau/kms/nv50-: convert core init() to new push macros")
    d8b24526ef68 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core caps_init()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
