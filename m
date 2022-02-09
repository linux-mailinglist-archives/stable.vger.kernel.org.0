Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D944AFEDB
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 22:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiBIVB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 16:01:58 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiBIVB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 16:01:58 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC50C03BFE8
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 13:02:00 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k3-20020a1ca103000000b0037bdea84f9cso2553862wme.1
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 13:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vIDZZgKiowrOIvh2VmzMX7Q8T/Ps00jsD26KxMfXAZM=;
        b=UNg7gBs0ennVyq16LSWyYm7nopFlKyyH/6xYI8YAmVLBY/Ro0gzNXdcZnhNi1Lhtjq
         Xj/fpFEDNk7a/gq6cMbmOWzRmC3oUxGEvX8JmjGYMJndAjgUcj0poxRCO3oWuDKjxyEH
         pSTlfgc9iT1ApmAYhEkJdU4vmY5HZOFvh8rwaDuKj+p/oR1DKYd18nJJm85N+HzF8pTT
         T0vytO4cQypbS3jhVCp0X8As+9smzLTD1ZRYQgEkEgzzRLSfFeIGWIAM6IIIl22WZ2K+
         l5UiL16caJRVZ+3hlvlPn0CSomuJVmhbOMQ3flUJYXKpDWBkJoeeB7BnHq/rTDCZOXeN
         Ex0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vIDZZgKiowrOIvh2VmzMX7Q8T/Ps00jsD26KxMfXAZM=;
        b=lVdwjV8X1eCiwc+KN69t/6uNmwRDU6HrA40p1prKIlEOHgVrFtniMBCZayfPe97gW0
         k7yT+AmY2ZAdkwrPnwYseLjQAbKLFeGurgLhqFc2AmhlJLz9bAciSqLAP+BxVHyvFJ10
         UgB7dYz8Lg2sStK2VoJSwq9FU+w+cFe4dLpCcVhJpytxli5rQdyz2gnX7ofusQkcDREX
         UlZie3g5Zyoi8hJtTuUgG0Rx+JE4CX8p1wztguzgFq8lvDsi+iuQmYeI0BoSScM79GXu
         i5auQZCAljrPI/mRLBH5Q0TEG6UMxWIOocaLRTvV9v1WuWMCqZo6VxEibLabSYwsWjAM
         AhjA==
X-Gm-Message-State: AOAM532mSwfW0lIAo8hXduDhDUtVuzkbRfsPjx6GYf4nfBh2H7xeoYxm
        s07bk+UAC63Z5Lec7aUoLBZsFl9j5cko4w==
X-Google-Smtp-Source: ABdhPJwDjfBy9lGfCCkKeCsVi7FW7nZjn2jcFn4Evx1vi7sQt2MNoqijobgUQJaByrJefnge6A5tmQ==
X-Received: by 2002:a05:600c:4ed0:: with SMTP id g16mr3769852wmq.19.1644440518957;
        Wed, 09 Feb 2022 13:01:58 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id u15sm16642449wrs.18.2022.02.09.13.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:01:58 -0800 (PST)
Date:   Wed, 9 Feb 2022 21:01:56 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     zanussi@kernel.org, rostedt@goodmis.org, ykaradzhov@vmware.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Propagate is_signed to
 expression" failed to apply to 5.10-stable tree
Message-ID: <YgQrxOy8MRLHDXis@debian>
References: <16434603997718@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="50Tsk5X8MI3K+nUr"
Content-Disposition: inline
In-Reply-To: <16434603997718@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--50Tsk5X8MI3K+nUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Jan 29, 2022 at 01:46:39PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 5.4-stable and 4.19-stable trees.

--
Regards
Sudip

--50Tsk5X8MI3K+nUr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-tracing-Propagate-is_signed-to-expression.patch"

From fc4baa0de214ec68a02e9155b739c2088b098095 Mon Sep 17 00:00:00 2001
From: Tom Zanussi <zanussi@kernel.org>
Date: Thu, 27 Jan 2022 15:44:17 -0600
Subject: [PATCH] tracing: Propagate is_signed to expression

commit 097f1eefedeab528cecbd35586dfe293853ffb17 upstream

During expression parsing, a new expression field is created which
should inherit the properties of the operands, such as size and
is_signed.

is_signed propagation was missing, causing spurious errors with signed
operands.  Add it in parse_expr() and parse_unary() to fix the problem.

Link: https://lkml.kernel.org/r/f4dac08742fd7a0920bf80a73c6c44042f5eaa40.1643319703.git.zanussi@kernel.org

Cc: stable@vger.kernel.org
Fixes: 100719dcef447 ("tracing: Add simple expression support to hist triggers")
Reported-by: Yordan Karadzhov <ykaradzhov@vmware.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215513
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 1557a20b6500..41a9bd52e1fd 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2154,6 +2154,8 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup(operand1->type, GFP_KERNEL);
@@ -2293,6 +2295,7 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 
 	/* The operand sizes should be the same, so just pick one */
 	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
-- 
2.30.2


--50Tsk5X8MI3K+nUr--
