Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC0298F92
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 15:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781782AbgJZOkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 10:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781661AbgJZOi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 10:38:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E51BD22263;
        Mon, 26 Oct 2020 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603723106;
        bh=cTgwGhVJW9l7gAJRWGZrNGjuQjLk+5fJlfa3XX8ksdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qp1O0hwd2GwbEv4XWvz/2K71KK+Fr25JaHVgMFPxZcJGOyikT6MUuqYhcbuYfRKnH
         /SbfY31THcIMl/MreFvzHJCTitB+FUXXtxgZMuTvVahagCHQ+CEu6/s6MYsZONVqwG
         WgwodV40e/qNbkGhnKvA47MYBV7xUHUvdIRtVJLg=
Date:   Mon, 26 Oct 2020 10:38:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "s390/qeth: strictly order bridge address events" has been
 added to the 5.8-stable tree
Message-ID: <20201026143825.GK4060117@sasha-vm>
References: <20201026053517.556992085B@mail.kernel.org>
 <4617e1c2-d791-3a18-9cfb-953589ab6c29@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4617e1c2-d791-3a18-9cfb-953589ab6c29@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 10:16:08AM +0200, Julian Wiedmann wrote:
>On 26.10.20 07:35, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     s390/qeth: strictly order bridge address events
>>
>> to the 5.8-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      s390-qeth-strictly-order-bridge-address-events.patch
>> and it can be found in the queue-5.8 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>
>This requires
>commit a04f0ecacdb0 ("s390/qeth: don't let HW override the configured port role").

I'll grab that commit too, thanks!

-- 
Thanks,
Sasha
