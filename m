Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B616F70
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 05:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfEHDYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 23:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEHDYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 23:24:08 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824F421479;
        Wed,  8 May 2019 03:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557285847;
        bh=JZFfwAbdZWpV7RJVu0DpOCmlBagkkfQg2hFWs9B8ij8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vLK3C1u29YCMDmdrymg7oxLr8qKddMID3oYe56PIwMuGTYQHp5jPXZ3QcDFSvV/7B
         oMhomvoqU817G4MAmJy6GO9eJa2YVMgXrv22XB8EvHsT6sgU4aWjeMApiZLK77cOA1
         eEmL0ZlpYAo3wbVeNFw/nvh7x7LIV/ZDQ4qGSfKk=
Date:   Wed, 8 May 2019 12:24:03 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] tracing: probeevent: Fix to make the type of
 $comm string
Message-Id: <20190508122403.73cce014a6f7d66e0835e2be@kernel.org>
In-Reply-To: <20190507174758.1D5FA205C9@mail.kernel.org>
References: <155723736241.9149.14582064184468574539.stgit@devnote2>
        <20190507174758.1D5FA205C9@mail.kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 May 2019 17:47:57 +0000
Sasha Levin <sashal@kernel.org> wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 35abb67de744 tracing: expose current->comm to [ku]probe events.
> 
> The bot has tested the following trees: v5.0.13, v4.19.40, v4.14.116, v4.9.173.
> 
> v5.0.13: Build OK!
> v4.19.40: Failed to apply! Possible dependencies:
>     40b53b771806 ("tracing: probeevent: Add array type support")
>     533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
>     56de76305279 ("tracing: probeevent: Cleanup print argument functions")
>     60c2e0cebfd0 ("tracing: probeevent: Add symbol type")
>     eeb07b061500 ("tracing: probeevent: Cleanup argument field definition")
>     f451bc89d835 ("tracing: probeevent: Unify fetch type tables")
> 
> v4.14.116: Failed to apply! Possible dependencies:
>     40b53b771806 ("tracing: probeevent: Add array type support")
>     45408c4f9250 ("tracing: kprobes: Prohibit probing on notrace function")
>     4bebdc7a85aa ("bpf: add helper bpf_perf_prog_read_value")
>     533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
>     60c2e0cebfd0 ("tracing: probeevent: Add symbol type")
>     908432ca84fc ("bpf: add helper bpf_perf_event_read_value for perf event array map")
>     97562633bcba ("bpf: perf event change needed for subsequent bpf helpers")
>     9802d86585db ("bpf: add a bpf_override_function helper")
>     b4da3340eae2 ("tracing/kprobe: bpf: Check error injectable event is on function entry")
>     cd86d1fd2102 ("bpf: Adding helper function bpf_getsockops")
>     dd0bb688eaa2 ("bpf: add a bpf_override_function helper")
>     de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>     f3edacbd697f ("bpf: Revert bpf_overrid_function() helper changes.")
>     f451bc89d835 ("tracing: probeevent: Unify fetch type tables")
> 
> v4.9.173: Failed to apply! Possible dependencies:
>     17bedab27231 ("bpf: xdp: Allow head adjustment in XDP prog")
>     1d9995771fcb ("s390: update defconfigs")
>     23a4e389bdc7 ("nfp: create separate define for max number of vectors")
>     40b53b771806 ("tracing: probeevent: Add array type support")
>     45408c4f9250 ("tracing: kprobes: Prohibit probing on notrace function")
>     533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
>     60c2e0cebfd0 ("tracing: probeevent: Add symbol type")
>     67f8b1dcb9ee ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
>     68453c7a8973 ("nfp: centralize runtime reconfiguration logic")
>     6b0b7551428e ("perf/core: Rename CONFIG_[UK]PROBE_EVENT to CONFIG_[UK]PROBE_EVENTS")
>     7ff5c83a1deb ("nfp: simplify nfp_net_poll()")
>     9802d86585db ("bpf: add a bpf_override_function helper")
>     a4b562bb8ebd ("nfp: use unsigned int for vector/ring counts")
>     b4da3340eae2 ("tracing/kprobe: bpf: Check error injectable event is on function entry")
>     cbeaf7aa733a ("nfp: bring back support for different ring counts")
>     ccc109b8ed24 ("net/mlx4_en: Add TX_XDP for CQ types")
>     dd0bb688eaa2 ("bpf: add a bpf_override_function helper")
>     e390b55d5aef ("bpf: make bpf_xdp_adjust_head support mandatory")
>     ecd63a0217d5 ("nfp: add XDP support in the driver")
>     f18f97ac43d7 ("tracing/kprobes: Add a helper method to return number of probe hits")
>     f3edacbd697f ("bpf: Revert bpf_overrid_function() helper changes.")
>     f451bc89d835 ("tracing: probeevent: Unify fetch type tables")
> 
> 
> How should we proceed with this patch?
> 

Thanks for the report! I missed the Fixes tag. I realized that the comm type
check was done in other place in older kernel. This bug was introduced by
commit 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code").

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
