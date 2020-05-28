Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A371E5DF7
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 13:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbgE1LLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388078AbgE1LLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:11:18 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16C962088E;
        Thu, 28 May 2020 11:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590664278;
        bh=ki29YA5N+T9mFWtkVk4TJL3cfcAoBnTCNqbg8DxOHCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anzf/W4Kc1OljXga9k7iPjG3CMvMKjyHwJwTtUCqNbA9kIEHZtpEjobFGkouGqC1P
         Hyy1d+WUH9PV8tLo/jvl59GJ8RAQbRd3+6hfeCp1vU7oQFB0WVLYnc+xAeOhXt/PC6
         nv2Pg541XeitM8JCFKkqKxohETCrfQ9XjTX93Jlc=
Date:   Thu, 28 May 2020 07:11:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.6 086/126] virtio-balloon: Revert "virtio-balloon:
 Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"
Message-ID: <20200528111117.GK33628@sasha-vm>
References: <20200526183937.471379031@linuxfoundation.org>
 <20200526183945.237904570@linuxfoundation.org>
 <8f649042-bc3a-2809-0332-44a5d3202807@suse.cz>
 <c8253932-5e6b-51e1-fe0c-19514779c9be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c8253932-5e6b-51e1-fe0c-19514779c9be@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 10:21:41AM +0200, David Hildenbrand wrote:
>On 28.05.20 07:51, Jiri Slaby wrote:
>> On 26. 05. 20, 20:53, Greg Kroah-Hartman wrote:
>>> From: Michael S. Tsirkin <mst@redhat.com>
>>>
>>> [ Upstream commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 ]
>>>
>>> This reverts commit 5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031.
>>>
>>> It has been queued properly in the akpm tree, this version is just
>>> creating conflicts.
>>
>> Should this be applied to stable trees at all?
>>
>> To me, it occurs to be a revert to avoid conflicts, not to fix something?
>
>Agreed.

Right, I'll drop it - thank you.

-- 
Thanks,
Sasha
