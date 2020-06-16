Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73A01FA53F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 02:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFPAqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 20:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFPAqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 20:46:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB67206B7;
        Tue, 16 Jun 2020 00:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592268379;
        bh=GEKCZUJRfxRyc5jfWjzU1VrXXRzORUgdpynn3yuon3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GsgqVEPIQfgCO1UReEzT2A86ZpKCOBA01XJl0nB2T+sq9Un4LafehUsM83/E4akA2
         BSQBb7eNL4DiddXPUfpHZVT1rUp3pvI+RyKa2opRKGJ5cPyKyV6iR7+drrN2H2aG5q
         PPc4wQGe/4OjZZQHmTQ6TjAF0Bei2lE1fevtYlIY=
Date:   Mon, 15 Jun 2020 20:46:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hersenxs.wu@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: disable dcn20 abm
 feature for bring up" failed to apply to 5.7-stable tree
Message-ID: <20200616004617.GK1931@sasha-vm>
References: <15922346929938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15922346929938@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:24:52PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

Greg, I think that your scripts went bananas here :)

No stable tag, no fixes tag, and it's already in 5.7, 5.6, and 5.4.

-- 
Thanks,
Sasha
