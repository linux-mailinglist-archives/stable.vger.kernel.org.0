Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83112F5070
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhAMQzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 11:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbhAMQzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 11:55:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E59E723383;
        Wed, 13 Jan 2021 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610556882;
        bh=4AXUNoo+/rH0a3wW1ydsbMHu/76qD5yUf0gV3c/8M6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Byb+jeseziXWOEOjv3tAUznXxCPCJQaX7PXBnJvu4v3p2/cCNxLhbY8q8wkhB5V3+
         DliiBPzHFvhCCd13Zczlub2DSd8vZzboDXt8LerN9kI7Pd3eQLeLv/lfxshMpaCcby
         hCjHnPvAcMDg262YFbUWBK3DVBYm0quF4dixpkC51uWsSzNicac5PjJDFbWTxL21fF
         dwnTrCqCW9J8xZoOMlR86M+/FxFrDVF2iqQ2T7X44T5dLWoSHn6r3Cdq685GpiF5ke
         OGKmRPWZNQOUjtz/MbBSB9lUTX1/PswA3SPH3d6AQh1qpm7QvbL1w9nJjGi/8cURi5
         NPn3Eblizsxow==
Date:   Wed, 13 Jan 2021 11:54:40 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10-stable 1/3] io_uring: synchronise IOPOLL on
 task_submit fail
Message-ID: <20210113165440.GS4035784@sasha-vm>
References: <cover.1610485688.git.asml.silence@gmail.com>
 <b965dc7a6bfb1adbe5b4bcd9a363a38d662a3195.1610485688.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b965dc7a6bfb1adbe5b4bcd9a363a38d662a3195.1610485688.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 09:17:24PM +0000, Pavel Begunkov wrote:
>commit 81b6d05ccad4f3d8a9dfb091fb46ad6978ee40e4 upstream
>
>io_req_task_submit() might be called for IOPOLL, do the fail path under
>uring_lock to comply with IOPOLL synchronisation based solely on it.

Just curious, why did the stable tag disappear from this backport?

Otherwise, I've queued up the series, thanks!

-- 
Thanks,
Sasha
