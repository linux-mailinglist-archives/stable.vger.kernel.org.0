Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B1D261993
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbgIHSVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731314AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D75492476A;
        Tue,  8 Sep 2020 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579712;
        bh=bkuiSO+ueu7I97XgCOVk+Lv0XZoU3jMC62jGM9VZPi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byUyvpg2ZI1komoATIT5Rufn37ZmrKUqktDIJ9ZUakqMo6vz5/fG2/upFouVAjVLl
         X0L+eMmlwUz37ma8+YT/5virG5t+BtUNbhHuA0NTAckLrq5kgGPqODHfQkNX2l4ZZQ
         bHmgcQ1LRn5YJGSmcC+tFYxghV8A4KXt1noCQSNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Song Liu <songliubraving@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Li Bin <huawei.libin@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.8 177/186] perf record: Correct the help info of option "--no-bpf-event"
Date:   Tue,  8 Sep 2020 17:25:19 +0200
Message-Id: <20200908152250.249228483@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

commit a060c1f12b525ba828f871eff3127dabf8daa1e6 upstream.

The help info of option "--no-bpf-event" is wrongly described as "record
bpf events", correct it.

Committer testing:

  $ perf record -h bpf

   Usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]

          --clang-opt <clang options>
                            options passed to clang when compiling BPF scriptlets
          --clang-path <clang path>
                            clang binary to use for compiling BPF scriptlets
          --no-bpf-event    do not record bpf events

  $

Fixes: 71184c6ab7e6 ("perf record: Replace option --bpf-event with --no-bpf-event")
Signed-off-by: Wei Li <liwei391@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200819031947.12115-1-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-record.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2417,7 +2417,7 @@ static struct option __record_options[]
 	OPT_BOOLEAN(0, "tail-synthesize", &record.opts.tail_synthesize,
 		    "synthesize non-sample events at the end of output"),
 	OPT_BOOLEAN(0, "overwrite", &record.opts.overwrite, "use overwrite mode"),
-	OPT_BOOLEAN(0, "no-bpf-event", &record.opts.no_bpf_event, "record bpf events"),
+	OPT_BOOLEAN(0, "no-bpf-event", &record.opts.no_bpf_event, "do not record bpf events"),
 	OPT_BOOLEAN(0, "strict-freq", &record.opts.strict_freq,
 		    "Fail if the specified frequency can't be used"),
 	OPT_CALLBACK('F', "freq", &record.opts, "freq or 'max'",


