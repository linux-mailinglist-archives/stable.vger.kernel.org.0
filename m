Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C3365AF5
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhDTOMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 10:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhDTOMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 10:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8C2613B0;
        Tue, 20 Apr 2021 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618927934;
        bh=tvK7pubOd318CrftylobLXNNkH3qJ6zthF04bsbCdXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2hIBRCtSxC8kK/D3SqKcUWfCG5xyuYcBIszcBkvXlqeEBRje0/ZijUh8ZQcqFqWY
         MSK5LIhNvhwy6nERLKDXr/M7eISswtYmY6a15czX2YkMesAoIxVQm7jgwoa5e1zdCr
         U3xKYOmEccrC90q2vG2Om6xAaFl0Y5I6WwsSHGe+ZjGyfWBz9cuuYXm8QxhKvRdR1u
         mR9U8GcwuK3KH3QS4FcAiV5GSaPGYRW0CshG9LFqEbqyYJvVrdKeFCCcQIAWXHMWZ6
         2DsGdO4SblsreLjfKvNXPmcktvJa0NqnjPRhVfEVUGhaIAE2nWXoaCM41vajZrkcJW
         qK4USDiRb5bkg==
Date:   Tue, 20 Apr 2021 10:12:13 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        johannes.berg@intel.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [patch 11/12] gcov: clang: fix clang-11+ build
Message-ID: <YH7hPT9Xk7Ru28EQ@sashalap>
References: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
 <20210416224623.nZhisHrwM%akpm@linux-foundation.org>
 <YH33+R8pwviVysY5@archlinux-ax161>
 <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:12:26PM -0700, Linus Torvalds wrote:
>On Mon, Apr 19, 2021 at 2:37 PM Nathan Chancellor <nathan@kernel.org> wrote:
>>
>> This should not have been merged into mainline by itself. It was a fix
>> for "gcov: use kvmalloc()", which is still in -mm/-next. Merging it
>> alone has now broken the build:
>>
>> https://github.com/ClangBuiltLinux/continuous-integration2/runs/2384465683?check_suite_focus=true
>>
>> Could it please be reverted in mainline [..]
>
>Now reverted in my tree.
>
>Sasha and stable cc'd too, since it was apparently auto-selected there..

I'll drop it from my queue, thanks!

-- 
Thanks,
Sasha
