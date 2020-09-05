Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A12125E75F
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgIEMCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 08:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgIEMCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 08:02:13 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E3320757;
        Sat,  5 Sep 2020 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599307333;
        bh=Byd7lldqYKdhk0D4aP5ylXoKM5Ow4mbv4nJ33uiteZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chuIF9SbtPql5/5QxDbmfAOD9dcumoSjcy3NdT7h3/FN4zZgBYLKNavX70bOY5sTX
         JAXdCRHdO6/kbTfiNsPrXa437pRHICuLPPqZZGf2tW41HeZmAhrdKM6VxYa8r9qSdK
         5dIGoJ5nI3ZeMzHsp1hK6Prv4hhoFFnTBUPZLSag=
Date:   Sat, 5 Sep 2020 08:02:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 5.8 07/42] speakup: Fix wait_for_xmitr for ttyio
 case
Message-ID: <20200905120211.GH8670@sasha-vm>
References: <20200831152934.1023912-1-sashal@kernel.org>
 <20200831152934.1023912-7-sashal@kernel.org>
 <20200831153345.GA2525965@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200831153345.GA2525965@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 05:33:45PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Aug 31, 2020 at 11:28:59AM -0400, Sasha Levin wrote:
>> From: Samuel Thibault <samuel.thibault@ens-lyon.org>
>>
>> [ Upstream commit 2b86d9b8ec6efb86fc5ea44f2d49b1df17f699a1 ]
>>
>> This was missed while introducing the tty-based serial access.
>>
>> The only remaining use of wait_for_xmitr with tty-based access is in
>> spk_synth_is_alive_restart to check whether the synth can be restarted.
>> With tty-based this is up to the tty layer to cope with the buffering
>> etc. so we can just say yes.
>>
>> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>> Link: https://lore.kernel.org/r/20200804160637.x3iycau5izywbgzl@function
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/staging/speakup/serialio.c  | 8 +++++---
>>  drivers/staging/speakup/spk_priv.h  | 1 -
>>  drivers/staging/speakup/spk_ttyio.c | 7 +++++++
>>  drivers/staging/speakup/spk_types.h | 1 +
>>  drivers/staging/speakup/synth.c     | 2 +-
>>  5 files changed, 14 insertions(+), 5 deletions(-)
>
>Not needed for 5.8 or older, sorry, this was a 5.9-rc1+ issue only.

Dropped, thanks!

-- 
Thanks,
Sasha
