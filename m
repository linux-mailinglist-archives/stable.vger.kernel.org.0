Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848C119970E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbgCaNLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgCaNLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:25 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C1ED20784;
        Tue, 31 Mar 2020 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660284;
        bh=FmUQVUKPYEPvynuaFcS/zDC5IwKRSHH5U73vgRduAY4=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=w5O4N5t39B+GhMF69Y1Aqvnyok/MLDK7vN0vkXew8FpG3vdAHfDjFwCGew3p8VmH9
         Wz/mf0A3ooj5WnvxUrVSflgkEMan85ukHectuBh8HcNUHPYjygLRQNFgZyM1TO8cXP
         7FUr/omkj3aYqUGf3+EFE3SSH5qTCC3Wkubm6XE4=
Date:   Tue, 31 Mar 2020 13:11:23 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [for-next][PATCH 15/21] ftrace/kprobe: Show the maxactive number on kprobe_events
In-Reply-To: <20200329184317.641598238@goodmis.org>
References: <20200329184317.641598238@goodmis.org>
Message-Id: <20200331131124.5C1ED20784@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 696ced4fb1d7 ("tracing/kprobes: expose maxactive for kretprobe in kprobe_events").

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Failed to apply! Possible dependencies:
    533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
    56de76305279 ("tracing: probeevent: Cleanup print argument functions")
    60c2e0cebfd0 ("tracing: probeevent: Add symbol type")
    6212dd29683e ("tracing/kprobes: Use dyn_event framework for kprobe events")
    a1303af5d79e ("tracing: probeevent: Add $argN for accessing function args")
    b55ce203a8f3 ("tracing/probe: Add probe event name and group name accesses APIs")
    f451bc89d835 ("tracing: probeevent: Unify fetch type tables")

v4.14.174: Failed to apply! Possible dependencies:
    0b4c6841fee0 ("bpf: use the same condition in perf event set/free bpf handler")
    43fa87f7deed ("perf/core: Fix another perf,trace,cpuhp lock inversion")
    45408c4f9250 ("tracing: kprobes: Prohibit probing on notrace function")
    4bebdc7a85aa ("bpf: add helper bpf_perf_prog_read_value")
    533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
    60c2e0cebfd0 ("tracing: probeevent: Add symbol type")
    6212dd29683e ("tracing/kprobes: Use dyn_event framework for kprobe events")
    908432ca84fc ("bpf: add helper bpf_perf_event_read_value for perf event array map")
    97562633bcba ("bpf: perf event change needed for subsequent bpf helpers")
    9802d86585db ("bpf: add a bpf_override_function helper")
    a1303af5d79e ("tracing: probeevent: Add $argN for accessing function args")
    b4da3340eae2 ("tracing/kprobe: bpf: Check error injectable event is on function entry")
    b55ce203a8f3 ("tracing/probe: Add probe event name and group name accesses APIs")
    d899926f552b ("selftest/ftrace: Move kprobe selftest function to separate compile unit")
    dd0bb688eaa2 ("bpf: add a bpf_override_function helper")
    de8f3a83b0a0 ("bpf: add meta pointer for direct access")
    e12f03d7031a ("perf/core: Implement the 'perf_kprobe' PMU")
    f3edacbd697f ("bpf: Revert bpf_overrid_function() helper changes.")
    f451bc89d835 ("tracing: probeevent: Unify fetch type tables")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
