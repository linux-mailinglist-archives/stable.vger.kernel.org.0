Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598544AFED4
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiBIVAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 16:00:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiBIVAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 16:00:01 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A01C043181
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 13:00:03 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w11so6136695wra.4
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mdWU87qJ15uoRi0XKUmRR60YpikgIJSqzx1OaJpO/0Q=;
        b=ikHBECuyCT9xwNZWyq3J0rWOGuQLctq3eUjjfRNgjGZUgP5+pHtnHrnlZFkZ1cvlHg
         /VsePF0xg4+T8XQ5ZgL7ozYDFAgAd72YK9eJd63nULnxu642Q6K/jz0v31ca4nQpFKqb
         Eo8cDLZAKw375q7qyhNG++Qu4X+zsroESecHLOs/ezsk9ARl9Ielb+U8jvZNDvOEXQYG
         dg8cBVtvsIs+KEWG9/IBaMo7EDQEffkGhOB+/MryljA6o2GcOLczjupdrcuxfqIJ1vfI
         EZP1+2DaJ2wLoPxIysxaLGFVnCRyQyJYDj2K2MSTuA7wWAxOf0q4A7rHNlowP1ARdJZn
         bAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mdWU87qJ15uoRi0XKUmRR60YpikgIJSqzx1OaJpO/0Q=;
        b=TJ++aIe2cfLqGiO6OyeP9AA+vHnOHwqG8C5JVYVyNYHZq8IeqpH+6n+ik6T7V5P++Q
         qrXVcHKhfcTD3BMF18o1252qvL5MHpeenWbxg+HHk54cxS8qrjaYqkOsdQoN61ECYiGp
         qncCZiFkwvWJNiC74vdtKjUVz5qPBuWeGIyYl/L524nnwUFk7jKfcomG9VpKylksHgjz
         yFXUbkjSoeyfA+A7G9ZRbaTHwEqr4RgJSi1V+tJ7k/VB/ky8BShN6sMFZ3pEFMIiDZvF
         ZWzinoFH/QT/0DVV7jZGTzdNhl5Y/Q0Plc5nAzjInjhPKoQzYuOVnyhEgu1zrWgZEo5D
         thWw==
X-Gm-Message-State: AOAM532YxKreeU+WxiNGLaloFrz+WXrLc3f9joZ1srqTte7FnqHb+Gcu
        TR1r3k/hHvHEVSPjPkNIGMj9u/njOJTRPg==
X-Google-Smtp-Source: ABdhPJx12Nh3HzI9tlKjRJ+lhPLedHWdDG6elBeT0VlePIz6LiBaSiLeldBu87YwGRvWAgCHIIcRaQ==
X-Received: by 2002:adf:f710:: with SMTP id r16mr3462057wrp.327.1644440401662;
        Wed, 09 Feb 2022 13:00:01 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id i15sm1978194wmq.23.2022.02.09.13.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:00:00 -0800 (PST)
Date:   Wed, 9 Feb 2022 20:59:59 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     zanussi@kernel.org, rostedt@goodmis.org, ykaradzhov@vmware.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Propagate is_signed to
 expression" failed to apply to 5.15-stable tree
Message-ID: <YgQrT+dZfEvlgEmt@debian>
References: <16434604001373@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MAMyE9upMT7QF7ib"
Content-Disposition: inline
In-Reply-To: <16434604001373@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MAMyE9upMT7QF7ib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Jan 29, 2022 at 01:46:40PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--MAMyE9upMT7QF7ib
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-tracing-Propagate-is_signed-to-expression.patch"

From 3992cdc5734342773551436a7270a424240edba5 Mon Sep 17 00:00:00 2001
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
index 83efce3a87ca..918f969dffcf 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2220,6 +2220,8 @@ static struct hist_field *parse_unary(struct hist_trigger_data *hist_data,
 		(HIST_FIELD_FL_TIMESTAMP | HIST_FIELD_FL_TIMESTAMP_USECS);
 	expr->fn = hist_field_unary_minus;
 	expr->operands[0] = operand1;
+	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 	expr->operator = FIELD_OP_UNARY_MINUS;
 	expr->name = expr_str(expr, 0);
 	expr->type = kstrdup_const(operand1->type, GFP_KERNEL);
@@ -2359,6 +2361,7 @@ static struct hist_field *parse_expr(struct hist_trigger_data *hist_data,
 
 	/* The operand sizes should be the same, so just pick one */
 	expr->size = operand1->size;
+	expr->is_signed = operand1->is_signed;
 
 	expr->operator = field_op;
 	expr->name = expr_str(expr, 0);
-- 
2.30.2


--MAMyE9upMT7QF7ib--
