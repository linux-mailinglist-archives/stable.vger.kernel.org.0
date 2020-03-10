Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62EE17ED4E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 01:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgCJA1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 20:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbgCJA1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 20:27:46 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29EB24654;
        Tue, 10 Mar 2020 00:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583800066;
        bh=xl/e+svzVuJA0NC8z05vgGTgZVJ3mojGjm6jTdaWVy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJDpM2AS7kxcirBo84WODdVa1owj6muLuN+G/kmSscLcd6PTkILIrp59ld5zBMBHq
         NbjYrtS/DHKIhe8PPl/0jbXbalpn6jcffVTgK0tVHVaiq4QuDEYwLwQo8bxoGA0+uF
         a9l7EdNWKJTxlHMS/FRjcI3Lxa+Ds0km7bCHlTAE=
Date:   Mon, 9 Mar 2020 20:27:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Prike.Liang@amd.com, alexander.deucher@amd.com, evan.quan@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/powerplay: map mclk to fclk for
 COMBINATIONAL_BYPASS" failed to apply to 5.5-stable tree
Message-ID: <20200310002744.GC24841@sasha-vm>
References: <158378236575229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158378236575229@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 08:32:45PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From ab65a371dd5f5cba6bd9a58a1a6d4115a71cc5c9 Mon Sep 17 00:00:00 2001
>From: Prike Liang <Prike.Liang@amd.com>
>Date: Wed, 4 Mar 2020 10:36:21 +0800
>Subject: [PATCH] drm/amd/powerplay: map mclk to fclk for COMBINATIONAL_BYPASS
> case
>
>When hit COMBINATIONAL_BYPASS the mclk will be bypass and can export
>fclk frequency to user usage.
>
>Signed-off-by: Prike Liang <Prike.Liang@amd.com>
>Reviewed-by: Evan Quan <evan.quan@amd.com>
>Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>Cc: stable@vger.kernel.org

Is it actually needed anywhere without 0b97bd6cde1d ("drm/amd/powerplay:
implement interface to retrieve clock freq for renoir")?

-- 
Thanks,
Sasha
