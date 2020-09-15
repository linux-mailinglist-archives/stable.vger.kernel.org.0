Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE3E26AC56
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 20:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgIOSmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 14:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbgIORfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 13:35:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53383206E6;
        Tue, 15 Sep 2020 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600191340;
        bh=ocm/+kwHLCe5rLfG41L7B6G08gLAwLJB4lHGGUavr5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soU+GhDKnsdGI90q+/ZkhEaYdFuaCkLGz1miLhNYyGwN7POODe8AuGidQMOukKMXq
         zIJAiP6l+sg8iu3mTAHuGKoR/2LEdr7NNaKzlqnLoUKOHN2WtXWqoEwvOFIHSKItoe
         NtkGg9jL8bWUgz/bbpZLWLHBnStfGZwaS6JOe8co=
Date:   Tue, 15 Sep 2020 13:35:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH 5.8 108/177] gcov: Disable gcov build with GCC 10
Message-ID: <20200915173539.GE2431@sasha-vm>
References: <20200915140653.610388773@linuxfoundation.org>
 <20200915140658.820608455@linuxfoundation.org>
 <CAHk-=wiBNqZm2E89SiTmtSPQr+pbdswwdPY6oH_wF1rvAeJnAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wiBNqZm2E89SiTmtSPQr+pbdswwdPY6oH_wF1rvAeJnAQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 10:24:25AM -0700, Linus Torvalds wrote:
>On Tue, Sep 15, 2020 at 7:28 AM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> GCOV built with GCC 10 doesn't initialize n_function variable.  This
>> produces different kernel panics as was seen by Colin in Ubuntu and me
>> in FC 32.
>>
>> As a workaround, let's disable GCOV build for broken GCC 10 version.
>
>Oh, Peter Oberparleiter actually figured out what was wrong, and we
>have commit 40249c696207 ("gcov: add support for GCC 10.1") upstream
>that enables it again with the fix for the changed semantics in
>gcc-10.

AUTOSEL spotted it
(https://lore.kernel.org/stable/20200914130358.1804194-27-sashal@kernel.org/),
and I didn't want to rush it in given it doesn't have a fixes/stable
tag.

I'll queue it up for this cycle as you've pointed it out.

-- 
Thanks,
Sasha
