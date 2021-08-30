Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1783FB5DE
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhH3MSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236921AbhH3MSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 608E5610FB;
        Mon, 30 Aug 2021 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630325832;
        bh=tFvVHHaMT6FlpbVDOckw2bd08wQ0Fl+0KjyQgVzmY3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMjVfd3wgG6wqDUbaNgLfLsPz3zM32dKy64W5urL0GCkXgmiM0LrLMU3MoNQiXDXc
         JsO8349ziptSjBteMiE1WofnvbNNaB+MNzUqZRJEXQBNSTgGvwylMIZAkU3EkMoe1D
         QW+Q/+ewl+bE+avsGzKgWBLCqzE3QDJeepxVgJyBInc3E1g199RegSPXTSBNH0hz0s
         kxtHDRz1z9AeEyQItbgzRrYKQU7AxAAcd6v6iaJiNVKt33F6aiVh1egbz6hTtm3zPC
         7HWD9TRl0u+z5daA/qidwz4Khr4uelQd43pTN78T9f7KTU8Vv9VNmVokqaGGVeQ/ZF
         fPHMunvXk8yWg==
Date:   Mon, 30 Aug 2021 08:17:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
Message-ID: <YSzMR4FnrnT5gjbe@sashalap>
References: <20210824005356.630888-1-sashal@kernel.org>
 <20210824005356.630888-20-sashal@kernel.org>
 <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:08:28PM -0400, Lyude Paul wrote:
>This is more hardware enablement, I'm not sure this should be going into
>stable either. Ben?

We take this sort of hardware enablement patches (where the platform
code is already there, and we just add quirks/ids/etc.

-- 
Thanks,
Sasha
