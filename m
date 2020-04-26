Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B91B910D
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZPDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZPDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 11:03:41 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF472074F;
        Sun, 26 Apr 2020 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587913421;
        bh=dzN9sUVYHG0xYRX0gNXUrDvVxu+SEf8im7Oy0LK9d3c=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=INQ+yqEbBlihurvSbJu3KXw/sVCLX0Eu5nkKmFIYaRsybme5RFXpKfZ9Rz0ETo76a
         weIELWiM7me8jsLN3S3KIGRB7uwQR8vc8CVpfhO++1fiRllxFLBR08T6Agc2bU3B3k
         5QTGsyqRGii6bG5uOunzIgtI3WY1GXnQPicjTiDE=
Date:   Sun, 26 Apr 2020 15:03:40 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] perf-probe: Fix to check blacklist address correctly
In-Reply-To: <158763966411.30755.5882376357738273695.stgit@devnote2>
References: <158763966411.30755.5882376357738273695.stgit@devnote2>
Message-Id: <20200426150341.2AF472074F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 9aaf5a5f479b ("perf probe: Check kprobes blacklist when adding new events").

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Build OK!
v4.19.118: Build OK!
v4.14.177: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.220: Failed to apply! Possible dependencies:
    3da3ea7a8e20 ("perf probe: Factor out the ftrace README scanning")
    7ab31d94bff9 ("perf kretprobes: Offset from reloc_sym if kernel supports it")
    e491bc2f0dd9 ("perf probe: Generalize probe event file open routine")

v4.4.220: Failed to apply! Possible dependencies:
    053a3989e12f ("perf report/top: Add --raw-trace option")
    1c20b1d15473 ("perf probe: Show trace event definition")
    2d8f0f18a5c3 ("perf tools: Add stat round user level event")
    361459f163fa ("perf tools: Skip dynamic fields not defined for current event")
    374fb9e362f6 ("perf tools: Add stat config user level event")
    3938bad44ed2 ("perf tools: Remove needless 'extern' from function prototypes")
    428aff82e92a ("perf probe: Ignore vmlinux buildid if offline kernel is given")
    54430101d2af ("perf hists: Introduce hist_entry__filter()")
    5f3339d2e83c ("perf thread_map: Add thread_map user level event")
    60517d28fbd9 ("perf tools: Try to show pretty printed output for dynamic sort keys")
    6640b6c227fc ("perf cpu_map: Add cpu_map user level event")
    723928340c9d ("perf hist: Save raw_data/size for tracepoint events")
    a34bb6a08d60 ("perf tools: Add 'trace' sort key")
    b8f8eb84f483 ("perf tools: Remove misplaced __maybe_unused")
    c7c2a5e40f17 ("perf tools: Add dynamic sort key for tracepoint events")
    d7b617f51be4 ("perf tools: Pass perf_hpp_list all the way through setup_sort_list")
    d80518c90bb2 ("perf tools: Add stat user level event")
    fd36f3dd7933 ("perf hist: Pass struct sample to __hists__add_entry()")
    ffe777254cce ("perf tools: Add event_update user level event")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
