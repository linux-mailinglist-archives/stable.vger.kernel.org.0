Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC2F67F6B3
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 10:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjA1J2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 04:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjA1J2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 04:28:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6BC1ABC4;
        Sat, 28 Jan 2023 01:28:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D7CB801BB;
        Sat, 28 Jan 2023 09:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5432C433D2;
        Sat, 28 Jan 2023 09:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674898114;
        bh=xbE7bM539qnzMQFvBTwSJgnxtUnb4Nx5ruJUOTi/T0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dyE5nvVi0802ke4GVZyIdhwZpKnlmCVvZPDWgWuD6Lge3vd+sJtTQ8118vuRayY5K
         yR3I5wi6/sFxeoKAiWnDoipPCVoEDsBYxzFXAttuuoh4xWXyZXeIep1dqWHFtZeprk
         jozvnUA5ghsuo25hl7W50RZxyBXCPdMWp4o8ofIs=
Date:   Sat, 28 Jan 2023 10:28:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: Patch "bpf: Always use raw spinlock for hash bucket lock" has
 been added to the 5.15-stable tree
Message-ID: <Y9Tqt5Fn/ZxcILh1@kroah.com>
References: <20230124113323.598714-1-sashal@kernel.org>
 <fa6c2876-a3f8-f37e-f3c3-97f0cd4e39d5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa6c2876-a3f8-f37e-f3c3-97f0cd4e39d5@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 28, 2023 at 10:21:43AM +0800, Hou Tao wrote:
> Hi,
> 
> On 1/24/2023 7:33 PM, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> >
> >     bpf: Always use raw spinlock for hash bucket lock
> >
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      bpf-always-use-raw-spinlock-for-hash-bucket-lock.patch
> > and it can be found in the queue-5.15 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> Please drop it for v5.15. The fix depends on bpf memory allocator [0] which was
> merged in v6.1.
> 
> [0]: 7c8199e24fa0 bpf: Introduce any context BPF specific memory allocator.

Now dropped, thanks.

greg k-h
