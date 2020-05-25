Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01821E1562
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390678AbgEYUzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390712AbgEYUzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 16:55:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF63C2065F;
        Mon, 25 May 2020 20:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440133;
        bh=iTyFvvlCZ/j3BxxOl6AeqmUXRM8D/KraYq1iJby5i3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgCKQG8JxHWwW07J3gvLrTvcyI9Uhc0qamrC2eX4OI7daw9uN7cwGiCGEI90CXitJ
         V/EZeffm5yrVaNUHZDDMEUilH5dovnGaFrthiHL+40YCBp0SHKe+5HDUn+l6zlyNbn
         xUwv9nMaQ6eWr0As2R7fvJ/P5darPydzh16IEZNk=
Date:   Mon, 25 May 2020 16:55:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andriin@fb.com, ast@kernel.org, jannh@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Prevent mmap()'ing read-only maps as
 writable" failed to apply to 5.6-stable tree
Message-ID: <20200525205531.GD33628@sasha-vm>
References: <15904175802874@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15904175802874@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 04:39:40PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From dfeb376dd4cb2c5004aeb625e2475f58a5ff2ea7 Mon Sep 17 00:00:00 2001
>From: Andrii Nakryiko <andriin@fb.com>
>Date: Mon, 18 May 2020 22:38:24 -0700
>Subject: [PATCH] bpf: Prevent mmap()'ing read-only maps as writable
>
>As discussed in [0], it's dangerous to allow mapping BPF map, that's meant to
>be frozen and is read-only on BPF program side, because that allows user-space
>to actually store a writable view to the page even after it is frozen. This is
>exacerbated by BPF verifier making a strong assumption that contents of such
>frozen map will remain unchanged. To prevent this, disallow mapping
>BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.
>
>  [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=9OQPJxQpgug080MMjdSB72i9R+5c6g@mail.gmail.com/
>
>Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
>Suggested-by: Jann Horn <jannh@google.com>
>Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>Reviewed-by: Jann Horn <jannh@google.com>
>Link: https://lore.kernel.org/bpf/20200519053824.1089415-1-andriin@fb.com

I've adjusted context in the selftest update and queued it up.

-- 
Thanks,
Sasha
