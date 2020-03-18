Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4943918A471
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCRUyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgCRUyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD6A20724;
        Wed, 18 Mar 2020 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564860;
        bh=ZoQfsYV5oyjOhVLePtj4IPbfQtSZmYVg5ew6Q2rFuJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1RS0Ab8FNPupn+qwHpzmnrHQF91AnAgdTKtXDRCtqnTE/5C3q1xxmCoLHMxjKu9wI
         V1eEMZRzu1v233cygFesq5V8XZj+LLbgRwLoPYCLA6hZekA8fq+Q7x1Fr8+85uZ8j5
         nATOzWeRcyTeIeuLmWxSnpooRT46AMtRrTP8yQsA=
Date:   Wed, 18 Mar 2020 16:54:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sven Eckelmann <sven@narfation.org>, hdanton@sina.com,
        sw@simonwunderlich.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] batman-adv: Don't schedule OGM for
 disabled interface" failed to apply to 4.4-stable tree
Message-ID: <20200318205419.GI4189@sasha-vm>
References: <158436631216439@kroah.com>
 <20200318141750.GD4189@sasha-vm>
 <2953272.8TNtrSRRcZ@bentobox>
 <20200318142652.GA2807628@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200318142652.GA2807628@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 03:26:52PM +0100, Greg KH wrote:
>On Wed, Mar 18, 2020 at 03:20:11PM +0100, Sven Eckelmann wrote:
>> On Wednesday, 18 March 2020 15:17:50 CET Sasha Levin wrote:
>> > >From 8e8ce08198de193e3d21d42e96945216e3d9ac7f Mon Sep 17 00:00:00 2001
>> > >From: Sven Eckelmann <sven@narfation.org>
>> > >Date: Sun, 16 Feb 2020 13:02:06 +0100
>> > >Subject: [PATCH] batman-adv: Don't schedule OGM for disabled interface
>> > >
>> > >A transmission scheduling for an interface which is currently dropped by
>> > >batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
>> > >is simply cancelling the workqueue item in an synchronous way but this is
>> > >not possible with B.A.T.M.A.N. IV because the OGM submissions are
>> > >intertwined.
>> > >
>> > >Instead it has to stop submitting the OGM when it detect that the buffer
>> > >pointer is set to NULL.
>> [...]
>> > Adjusted context and queued up for 4.4.
>>
>> There are most likely patches missing again when you only added this single
>> patch. See the 48 patches I've sent yesterday for batman-adv in 4.4.
>
>Yeah, I'll queue these all up later on today, thank you for the series.

And I've dropped mine, thanks! :)

-- 
Thanks,
Sasha
