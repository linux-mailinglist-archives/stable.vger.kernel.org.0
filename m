Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57A108EFC
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfKYNf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:35:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfKYNf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:35:57 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A4B2075C;
        Mon, 25 Nov 2019 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574688956;
        bh=n14TQvf9g4qyW/ZVi5jAFld976Bydgquqn/Qbd89L7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfLN5zI07d7u8Ipwc/HaRElooWsQOOSYsbrxknRVEkFvhVeYDMgl0eGMYe8rtrMyv
         5CvlhJqp2BU6q/mK7ZRzi5oqdi+rZ0gmdc4bC5ZXOVbopec8ijeBvnYEz5nTnYXSqv
         dWDjpDOc3pEHWvAqdP5HyKFtkruzxYEs05RSUhjA=
Date:   Mon, 25 Nov 2019 08:35:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 2/2] can: dev: can_dellink(): remove return at end of
 void function
Message-ID: <20191125133555.GC12367@sasha-vm>
References: <20191122105417.11503-1-lee.jones@linaro.org>
 <20191122105417.11503-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122105417.11503-2-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:54:17AM +0000, Lee Jones wrote:
>From: Marc Kleine-Budde <mkl@pengutronix.de>
>
>[ Upstream commit d36673f5918c8fd3533f7c0d4bac041baf39c7bb ]
>
>This patch remove the return at the end of the void function
>can_dellink().

Why is this patch needed for -stable?

-- 
Thanks,
Sasha
