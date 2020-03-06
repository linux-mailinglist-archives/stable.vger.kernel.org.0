Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73317BEDB
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCFNdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgCFNdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 08:33:45 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 076D2206D5;
        Fri,  6 Mar 2020 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583501625;
        bh=7oNeaBEcLBJTlFLElD/YGwtOn6D5hzP860pjWY8f/ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KaVM1osOWw8y0P54D1DPMM/0p2uh33fDRZYm86EZibf7gD5HZ+ZR5xpo3KKmd4cUD
         zK+YT/+jgdAIEddSGGLbEjw3khomaoDB3MXpykTbXhpkLGFm2HeWOa1+2muLugtfqE
         iCOdURjWdjFlZNqF22w/WD34hJSRPmjQ5nykP8mg=
Date:   Fri, 6 Mar 2020 08:33:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     stable@vger.kernel.org, Chris Evich <cevich@redhat.com>
Subject: Re: block, bfq: port of a series of fix commits to 5.4 and 5.5
Message-ID: <20200306133343.GP21491@sasha-vm>
References: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paolo,

On Thu, Mar 05, 2020 at 07:49:29AM +0100, Paolo Valente wrote:
>Hi,
>Fedora requested the following fix commits, currently available in
>5.6-rc4, to be ported to 5.4 and 5.5 [1]:
>db37a34c563b block, bfq: get a ref to a group when adding it to a service tree

I took this one.

>4d8340d0d4d9 block, bfq: remove ifdefs from around gets/puts of bfq groups

But not this one, it looks like a cleanup that isn't needed by the
following patches.

>33a16a980468 block, bfq: extend incomplete name of field on_st

Same as above.

>ecedd3d7e199 block, bfq: get extra ref to prevent a queue from being freed during a group move

I took this one.

>32c59e3a9a5a block, bfq: do not insert oom queue into position tree

And this one.

>f718b093277d block, bfq: do not plug I/O for bfq_queues with no proc refs

This patch seems to be already in.

>This is the first time I submit something for stable branches, I hope
>I did everything right (I'm following option 2 in [2]).

You did, thank you :)

-- 
Thanks,
Sasha
