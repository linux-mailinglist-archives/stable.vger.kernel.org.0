Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8D74B2D47
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 20:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiBKTHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 14:07:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiBKTHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 14:07:06 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A27CC8
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:07:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d27so16819740wrc.6
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 11:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ryg4ZUFHI962rCyK+CHNKTCJjj1tmk+yN1iOjFNfHFs=;
        b=bWKScGFk5CIihxhS87QHfSFsC7gSV+lWOALNIg420BOjSw+xjj7NeFC0cZsknZ/Ksc
         iqEhevr9H/mMYUg8kWMUM9TdkBd6cliHdAx75AKNmhRN58aJuHlUEAUCDG7RDTZ19jic
         3xMWc2OCtRN4aVpSJCAQlH4S56Y3w5IJhK9nywGg6fLytTu0QQY73CkLPeQv5gKdFxsA
         umS/MSHnV1siZrFyg2zaa0dM729lwA7NNMeJYfWCUP1QctrjHTZtGkVkYIW80nqIQWOA
         eYQR/9AJLQAXF7Wq+YHRzue7SVo0yQEZ1mVraO4glfPFAlBL6rKj6zPU+AEbhlmpd+vT
         N3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ryg4ZUFHI962rCyK+CHNKTCJjj1tmk+yN1iOjFNfHFs=;
        b=vXNJFWrfiQFJ2mdGnwVEHa467AyYgiqz8nRbZmVgNCE+suzGA/af6rBcoWhjYDA5zY
         yYNLqNwW74AkoBmhK+ExXEPQOTmQGD11nhbGDKhCp5M79HFEPVszzoTIdditI5+mz59R
         MuNARRsx+/aTrgCz6o/TXy6XTUWQB6Xz0spUQUDyy6eqWc5OflZGUL0s6Hd89Q87Y7Le
         FV4+3oLO1W9T8be66BRCPi0Nc9r+cFh+YhQRhxHzsnqYO53QHhnrg5bXCWjOoiCVZZC2
         fzdg297n3xeVTEQ1pi1LY6GnLeLqQ4M5BlaXRHDFONeZtYfRy9+u4OfEmyeAzBz5fSkW
         YyWw==
X-Gm-Message-State: AOAM5315X1NEG9xYNG9MkZo/uKEJPYcpG1Nujk2bZ0sO5ShsuElUDz2z
        5mzJF9um9eeMyQMisDdNYss=
X-Google-Smtp-Source: ABdhPJxAjgyb3jLmPz0WggeSSOSWBoK+FZ6YYbUkpnsZts5+V0XDRS45LL64EsoN5uNrabH8dSA61w==
X-Received: by 2002:a5d:4a92:: with SMTP id o18mr2447756wrq.112.1644606422966;
        Fri, 11 Feb 2022 11:07:02 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id l28sm21378314wrz.90.2022.02.11.11.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 11:07:01 -0800 (PST)
Date:   Fri, 11 Feb 2022 19:06:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chenzechuan1@huawei.com, Jianlin.Lv@arm.com, acme@redhat.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        mark.rutland@arm.com, mhiramat@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, namhyung@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, peterz@infradead.org,
        ravi.bangoria@linux.ibm.com, yangjihong1@huawei.com,
        yao.jin@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf probe: Fix ppc64 'perf probe add
 events failed' case" failed to apply to 5.4-stable tree
Message-ID: <Ygaz0wOtMGQnSQVD@debian>
References: <1643031189224222@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YsHsV+du20vH7lyR"
Content-Disposition: inline
In-Reply-To: <1643031189224222@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YsHsV+du20vH7lyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 24, 2022 at 02:33:09PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.19-stable tree.

--
Regards
Sudip

--YsHsV+du20vH7lyR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-perf-probe-Fix-ppc64-perf-probe-add-events-failed-ca.patch"

From ff3e8777c4a2aef9e680088fcc292ee8ace17f57 Mon Sep 17 00:00:00 2001
From: Zechuan Chen <chenzechuan1@huawei.com>
Date: Tue, 28 Dec 2021 19:13:38 +0800
Subject: [PATCH] perf probe: Fix ppc64 'perf probe add events failed' case

commit 4624f199327a704dd1069aca1c3cadb8f2a28c6f upstream.

Because of commit bf794bf52a80c627 ("powerpc/kprobes: Fix kallsyms
lookup across powerpc ABIv1 and ABIv2"), in ppc64 ABIv1, our perf
command eliminates the need to use the prefix "." at the symbol name.

But when the command "perf probe -a schedule" is executed on ppc64
ABIv1, it obtains two symbol address information through /proc/kallsyms,
for example:

  cat /proc/kallsyms | grep -w schedule
  c000000000657020 T .schedule
  c000000000d4fdb8 D schedule

The symbol "D schedule" is not a function symbol, and perf will print:
"p:probe/schedule _text+13958584"Failed to write event: Invalid argument

Therefore, when searching symbols from map and adding probe point for
them, a symbol type check is added. If the type of symbol is not a
function, skip it.

Fixes: bf794bf52a80c627 ("powerpc/kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2")
Signed-off-by: Zechuan Chen <chenzechuan1@huawei.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jianlin Lv <Jianlin.Lv@arm.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20211228111338.218602-1-chenzechuan1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 tools/perf/util/probe-event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 6357ac508ad1..67b7d2af1755 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2954,6 +2954,9 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	for (j = 0; j < num_matched_functions; j++) {
 		sym = syms[j];
 
+		if (sym->type != STT_FUNC)
+			continue;
+
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {
-- 
2.30.2


--YsHsV+du20vH7lyR--
