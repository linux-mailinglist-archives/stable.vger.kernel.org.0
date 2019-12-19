Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C2F1265A4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 16:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLSPWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 10:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfLSPWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 10:22:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68442053B;
        Thu, 19 Dec 2019 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576768950;
        bh=F+rYk+LJR2nTrz/ibA+mwpo10qBbrMh+7m/qM/VBiF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jHoxyRjxzH6beQ/+z+Gx12s3j0gYhu4CtQLJaaBWCcAe4v3ca++HXkLlD81yZQenq
         Xo9aV7PBiYp3IUnuHncigOM/oKcuslHAUQc6JdlqJ+EsWLdBIzR/XyhLxaRdcw8Ai9
         H7X+gc7tkTQyRV01QgMuqgl6EZokOatuz1ytC5mE=
Date:   Thu, 19 Dec 2019 10:22:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 019/350] iio: tcs3414: fix
 iio_triggered_buffer_{pre,post}enable positions
Message-ID: <20191219152228.GK17708@sasha-vm>
References: <20191210210402.8367-1-sashal@kernel.org>
 <20191210210402.8367-19-sashal@kernel.org>
 <20191215155203.607cc56d@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191215155203.607cc56d@archlinux>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 03:52:03PM +0000, Jonathan Cameron wrote:
>On Tue, 10 Dec 2019 15:58:31 -0500
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Alexandru Ardelean <alexandru.ardelean@analog.com>
>>
>> [ Upstream commit 0fe2f2b789190661df24bb8bf62294145729a1fe ]
>>
>> The iio_triggered_buffer_{predisable,postenable} functions attach/detach
>> the poll functions.
>>
>> For the predisable hook, the disable code should occur before detaching
>> the poll func, and for the postenable hook, the poll func should be
>> attached before the enable code.
>>
>> The driver was slightly reworked. The preenable hook was moved to the
>> postenable, to add some symmetry to the postenable/predisable part.
>>
>> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>I doubt this did any harm, but wouldn't consider it stable material normally.
>
>This is part of a general rework going on to allow some core refactoring.
>
>I should have added a note to this one like some related patches that it
>is a logical fix, but we don't have an actual known bug afaik.

I'll drop it from everywhere, thanks!

-- 
Thanks,
Sasha
