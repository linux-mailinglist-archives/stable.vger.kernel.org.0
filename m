Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3238922F8BB
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgG0TMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgG0TMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 15:12:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24C520719;
        Mon, 27 Jul 2020 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595877160;
        bh=iDjuqni09Ye+Y5tnBznZ5YEHc2O13s9uN4udYT6xhSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbgCyEDCCb9e28CEWIs4zRb4ylp5tXAupnlxiuhkXb7GspPsQvYAzWADUqm5idmbp
         W2kek20eQJMvggBOY7o0OMkIakJOOY8j9ATva8TRjGuJOByzP1YDl86skpoJBjb1ba
         kbJgg10ZmpQCq/HNvMUXyz69h/3my82xjPz0H82U=
Date:   Mon, 27 Jul 2020 15:12:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5.7 024/179] dm mpath: pass IO start time to path selector
Message-ID: <20200727191238.GH406581@sasha-vm>
References: <20200727134932.659499757@linuxfoundation.org>
 <20200727134933.846667790@linuxfoundation.org>
 <87sgdcuda6.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87sgdcuda6.fsf@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 12:35:13PM -0400, Gabriel Krisman Bertazi wrote:
>Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> From: Gabriel Krisman Bertazi <krisman@collabora.com>
>>
>> [ Upstream commit 087615bf3acdafd0ba7c7c9ed5286e7b7c80fe1b ]
>>
>> The HST path selector needs this information to perform path
>> prediction. For request-based mpath, struct request's io_start_time_ns
>> is used, while for bio-based, use the start_time stored in dm_io.
>
>Hi Greg,
>
>This patch is not -stable material.  It is only needed for a new feature
>merged in 5.8.

I've dropped it, thank you!

-- 
Thanks,
Sasha
