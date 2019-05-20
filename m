Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C69238FD
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbfETN6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 09:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730162AbfETN6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 09:58:11 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDF25216B7;
        Mon, 20 May 2019 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558360691;
        bh=1XoNRY35+5XtWIU4NY/RtwTEWQpObRguoYyOqsTa+s8=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=NKct5ysb99xTVVxCKjqZzaSq/dX1G6ZE+TnCjVZGmpXcx+6159Zt4fZbZkteHrrk1
         I7YTBpwQLCczH7GD5GJ/s6+GesNMmQMWlX3ZZXrX/nMWU4etIuj+pW0jrTgei+y2QM
         iB6GQkbvZRQfBpS3bNMegNMUPB6A9C9liXllFDc8=
Date:   Mon, 20 May 2019 13:58:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 01/22] perf intel-pt: Fix itrace defaults for perf script
In-Reply-To: <20190520113728.14389-2-adrian.hunter@intel.com>
References: <20190520113728.14389-2-adrian.hunter@intel.com>
Message-Id: <20190520135810.BDF25216B7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 90e457f7be08 perf tools: Add Intel PT support.

The bot has tested the following trees: v5.1.3, v5.0.17, v4.19.44, v4.14.120, v4.9.177, v4.4.180.

v5.1.3: Build OK!
v5.0.17: Build OK!
v4.19.44: Failed to apply! Possible dependencies:
    4eb068157121 ("perf script: Make itrace script default to all calls")

v4.14.120: Failed to apply! Possible dependencies:
    20d9c478b01a ("pert tools: Add queue management functionality")
    440a23b34c06 ("perf tools: Add initial entry point for decoder CoreSight traces")
    4eb068157121 ("perf script: Make itrace script default to all calls")
    68ffe3902898 ("perf tools: Add decoder mechanic to support dumping trace data")
    9f878b29da96 ("perf tools: Add full support for CoreSight trace decoding")
    b12235b113cf ("perf tools: Add mechanic to synthesise CoreSight trace packets")
    ffd3d18c20b8 ("perf tools: Add ARM Statistical Profiling Extensions (SPE) support")

v4.9.177: Failed to apply! Possible dependencies:
    20d9c478b01a ("pert tools: Add queue management functionality")
    3bdafdffa9ba ("perf auxtrace: Add itrace option to output ptwrite events")
    440a23b34c06 ("perf tools: Add initial entry point for decoder CoreSight traces")
    4eb068157121 ("perf script: Make itrace script default to all calls")
    68ffe3902898 ("perf tools: Add decoder mechanic to support dumping trace data")
    70d110d77599 ("perf auxtrace: Add itrace option to output power events")
    9f878b29da96 ("perf tools: Add full support for CoreSight trace decoding")
    b12235b113cf ("perf tools: Add mechanic to synthesise CoreSight trace packets")
    ffd3d18c20b8 ("perf tools: Add ARM Statistical Profiling Extensions (SPE) support")

v4.4.180: Failed to apply! Possible dependencies:
    3bdafdffa9ba ("perf auxtrace: Add itrace option to output ptwrite events")
    3becf4525d9c ("perf tools: Add sink configuration for cs_etm PMU")
    403cacb8a25e ("perf unwind: Don't mix LIBUNWIND_LIBS into LIBUNWIND_LDFLAGS")
    440a23b34c06 ("perf tools: Add initial entry point for decoder CoreSight traces")
    4eb068157121 ("perf script: Make itrace script default to all calls")
    5a155bb77a67 ("perf build: Remove all condition feature check {C,LD}FLAGS")
    68ffe3902898 ("perf tools: Add decoder mechanic to support dumping trace data")
    70d110d77599 ("perf auxtrace: Add itrace option to output power events")
    7e21b0d579a4 ("perf tools: Make coresight PMU listable")
    9d8e14d306ef ("perf unwind: Separate local/remote libunwind config")
    9f878b29da96 ("perf tools: Add full support for CoreSight trace decoding")
    a818c563ae16 ("perf tools: Add coresight etm PMU record capabilities")
    b12235b113cf ("perf tools: Add mechanic to synthesise CoreSight trace packets")
    d1706b39f0af ("perf tools: Add support for skipping itrace instructions")
    ffd3d18c20b8 ("perf tools: Add ARM Statistical Profiling Extensions (SPE) support")


How should we proceed with this patch?

--
Thanks,
Sasha
