Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C04339976
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 23:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhCLWLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 17:11:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235453AbhCLWK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 17:10:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D36E64F29;
        Fri, 12 Mar 2021 22:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615587059;
        bh=Dg8NPNpeo0c/PJaNRifXNhuOnGGTiIPNjQZGvYR1Vew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dZCT2wzmnDJAtkMaxZBnneaQc19JiYKbpxW8vDZJJsML4NAUYGjrj5oY/Vp8gY6w4
         6u9NzvcraAaS1vOyrtsM6+COMuwJl5QXxL/PZxRK59ZPDoVoyA6c0c9FBof2R04SMu
         7sl2kAcudQcH/BsyXxsRqYY+N6EEgdQroTYN8fi30P5BaHUZx6krfWeNsoztVPLNUn
         dEyDu+IPgTUfNlegtqvPw6DBjN032VdPdNIi949i6+dHWqgXmQl+cD+yAaPAqZDgZ9
         hNagU9Ct4F4wDuk39cBMfcXht9o04H118FB1rfkzwDs8GZaLZrQW74j0VVlcnJ7Z5V
         45s26xdyifr8A==
Date:   Fri, 12 Mar 2021 17:10:58 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH AUTOSEL 5.11 31/52] x86, build: use objtool mcount
Message-ID: <YEvm8ggvHis0tkFp@sashalap>
References: <20210302115534.61800-1-sashal@kernel.org>
 <20210302115534.61800-31-sashal@kernel.org>
 <202103021042.CBF1600@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202103021042.CBF1600@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 10:42:57AM -0800, Kees Cook wrote:
>On Tue, Mar 02, 2021 at 06:55:12AM -0500, Sasha Levin wrote:
>> From: Sami Tolvanen <samitolvanen@google.com>
>>
>> [ Upstream commit 6dafca97803309c3cb5148d449bfa711e41ddef2 ]
>>
>> Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
>> objtool to generate __mcount_loc sections for dynamic ftrace with
>> Clang and gcc <5 (later versions of gcc use -mrecord-mcount).
>>
>> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This one doesn't make sense without all the other objtool changes for
>it. Please drop this from autosel.

Dropped, thanks!

-- 
Thanks,
Sasha
