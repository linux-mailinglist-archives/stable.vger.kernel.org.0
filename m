Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66856B22E
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 01:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfGPXDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 19:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfGPXDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 19:03:08 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E581D21743;
        Tue, 16 Jul 2019 23:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563318188;
        bh=MyaDXyUXqqVwCX2pz9xvaZgr+tnf2doAPue0wFWeh6Y=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=lVGDNpcQamZj1qwQHGy9RLDa3KyLs1AHI+h3n2Ea0FTcP/CQBUr/QhaFshWgWzzTA
         8BYZ7mJuvizjJdp0c2E9unR2INkQeV5hB+vKOHcVWI8EG15jDDl6O+W7CcpjjvN84+
         LyYk6FOlkpje41YXxLAd4LaqvFDxInBKSjZG8W4E=
Date:   Tue, 16 Jul 2019 23:03:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine
In-Reply-To: <20190716072134.10009-1-hui.wang@canonical.com>
References: <20190716072134.10009-1-hui.wang@canonical.com>
Message-Id: <20190716230307.E581D21743@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59, v4.14.133, v4.9.185, v4.4.185.

v5.2.1: Build OK!
v5.1.18: Build OK!
v4.19.59: Build OK!
v4.14.133: Build OK!
v4.9.185: Build OK!
v4.4.185: Failed to apply! Possible dependencies:
    78f4f7c2341f ("ALSA: hda/realtek - ALC891 headset mode for Dell")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
