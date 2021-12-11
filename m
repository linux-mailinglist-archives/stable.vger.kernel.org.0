Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8512470F3F
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbhLKANs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:13:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhLKANs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:13:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2205B821CD;
        Sat, 11 Dec 2021 00:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB6C00446;
        Sat, 11 Dec 2021 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639181410;
        bh=XTd7xMkG1GwnlufuROlO6RhP4W7ZmTqO0LM0XAobut0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=foBxdVX5lktVOorJCrWFH77aBfdkvIdpUboWb+B7j6QPmRRBz15JcuNASbcthfPmH
         zMEiMtZ/N3hsd6sI81D2qlpP2TI4uhxQZ+3r0M4k9uwzVKsMFqDvtdHO12s1ihKG3A
         kA/mrvkivl7H0Gn3LQ99Ql7/b0J/3XflnryL0H6qep+vjaZX6Tg875O9rHy7ZRw4Re
         zzrpPf/WHkAR9BU+11uRTufFenb1s7MYpiz9aPjVQIlMUDTJzdTF/N6bECaP72xXl7
         rFZXfkdMxVZvzR6EvBvhfW8oHoIgjAryJK/vhQs/8NIEzLBVtmQUeRyoiG+kmVw9ar
         lNv0JbKSL/riw==
Date:   Fri, 10 Dec 2021 16:10:08 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/3] POLLFREE fix for 4.14
Message-ID: <YbPsYMTboeZPa7Tw@sol.localdomain>
References: <20211211000223.50630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211000223.50630-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 04:02:20PM -0800, Eric Biggers wrote:
> This kernel version doesn't have aio poll, but the fix for POLLFREE with
> exclusive waiters is still applicable to it.  This series resolves
> conflicts in all three patches, mostly due to POLLHUP having been
> renamed to EPOLLHUP in more recent kernels.
> 
> Eric Biggers (3):
>   wait: add wake_up_pollfree()
>   binder: use wake_up_pollfree()
>   signalfd: use wake_up_pollfree()
> 
>  drivers/android/binder.c | 21 +++++++++------------
>  fs/signalfd.c            | 12 +-----------
>  include/linux/wait.h     | 26 ++++++++++++++++++++++++++
>  kernel/sched/wait.c      |  7 +++++++
>  4 files changed, 43 insertions(+), 23 deletions(-)
> 

Sorry, ignore this one; there's a build error in kernel/sched/wait.c.

- Eric
