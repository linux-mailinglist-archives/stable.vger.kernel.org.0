Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168851A3F9
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 22:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfEJUYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 16:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbfEJUYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 16:24:46 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40CE82182B;
        Fri, 10 May 2019 20:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557519885;
        bh=7EexOEKHQ71BXjM1iOgmau0hcwDFHR5Lr2t2c0tUWls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0xEUbN+latHuXc6ESCppuP/nqTEWJRTtVR9Lm0ER6dS2OQvJ/SXVMZFykgcTOnyev
         JN/ndhQZstGW8YyCVE6ZLfH+y9YqECWHY7Vkja2gSm8wuOMpiE69LEQT3m21xEOXBB
         AralSBjWiAnjYsohpf7+65mYnVpfNMhVbXhHk2/I=
Date:   Fri, 10 May 2019 16:24:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chenbo Feng <fengc@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, maze@google.com, lorenzo@google.com,
        Jonathan Perry <jonperry@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [stable 4.9.y 1/2] bpf: fix struct htab_elem layout
Message-ID: <20190510202444.GC14410@sasha-vm>
References: <20190510023354.182171-1-fengc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190510023354.182171-1-fengc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 07:33:53PM -0700, Chenbo Feng wrote:
>From: Alexei Starovoitov <ast@fb.com>
>
>commit 9f691549f76d488a0c74397b3e51e943865ea01f upstream.
>
>when htab_elem is removed from the bucket list the htab_elem.hash_node.next
>field should not be overridden too early otherwise we have a tiny race window
>between lookup and delete.
>The bug was discovered by manual code analysis and reproducible
>only with explicit udelay() in lookup_elem_raw().
>
>Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
>Reported-by: Jonathan Perry <jonperry@fb.com>
>Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Chenbo Feng <fengc@google.com>

Queued both for 4.9, thank you.

--
Thanks,
Sasha
