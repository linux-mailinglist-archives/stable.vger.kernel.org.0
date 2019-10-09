Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73025D1A11
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbfJIUvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 16:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbfJIUvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 16:51:01 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA02C218AC;
        Wed,  9 Oct 2019 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570654260;
        bh=h5UFSrQbxwQ1jaUrIAHWi1a2T2kESQj+kWn/elifWyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQuqQ6Z1qEUd6UB14Af4XMrwnjZf7DdyoQWxIwFF92Q2siHiJodulbfuvdzL3NDSQ
         I2hcwXyTNmAYvGuCeA7X+g5F4eJeT1igxgitz4B0HNL6pJNSYnVxut1HeDv+fSeTG1
         +D4WRc3anrDkvyc7JJyZXfwSVzUXX8iN6Ewe/HhI=
Date:   Wed, 9 Oct 2019 16:51:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 26/26] Make filldir[64]() verify the
 directory entry filename is valid
Message-ID: <20191009205100.GV1396@sasha-vm>
References: <20191009170558.32517-1-sashal@kernel.org>
 <20191009170558.32517-26-sashal@kernel.org>
 <CAHk-=wiVe+nxotYXExXRxhvCSTCqyRuZUto6UrvR2oHfeGrJ+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wiVe+nxotYXExXRxhvCSTCqyRuZUto6UrvR2oHfeGrJ+g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 10:56:56AM -0700, Linus Torvalds wrote:
>On Wed, Oct 9, 2019 at 10:24 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> [ Upstream commit 8a23eb804ca4f2be909e372cf5a9e7b30ae476cd ]
>
>I didn't mark this for stable because I expect things to still change
>- particularly the WARN_ON_ONCE() should be removed before final 5.4,
>I just wanted to see if anybody could trigger it with testing etc.
>
>(At least syzbot did trigger it).
>
>If you do want to take it, take it without the WARN_ON_ONCE() calls
>and note that in the commit message..

I'll take both when you send a patch to remove it.

--
Thanks,
Sasha
