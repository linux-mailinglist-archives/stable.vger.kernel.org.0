Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DDC1F7F02
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 00:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgFLWmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 18:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLWmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 18:42:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD054C03E96F;
        Fri, 12 Jun 2020 15:42:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so4318464plv.9;
        Fri, 12 Jun 2020 15:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpnhqpiekFvzsNqLJcrAQ9nEpV1m2krINzHYPJORom8=;
        b=pXrVwaLbxiTPsJOWLw/iIdZw0MuaSj82LfKh/ZjVJTEP8COdSMR3WcjKOYOusad8ug
         UsZJPzY5FQbaGe85fjTCGGgTu2e2c+OGgSiDD3kbBRdBBdshfu6EFJ0CcYUroZyDDFnN
         3kBXLenG/6eNA59mOTAwebNg5SbJHNWM1n5l7zBeFhBkDdlLkTouDfnJPpyJtiAiiGE9
         YgEsduzm2KPmwHGv5vsoDYm5XHprijcXGqNOicfvuJGDuP6mGrUQomUFSbvfRBPmDNa9
         94/IJoP21gyKZ1ifRzgr2VNBBrJFt9v2mqJHHhycOcmhI9MDbvJw5ZIRBBQ3RomJFRip
         ys7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpnhqpiekFvzsNqLJcrAQ9nEpV1m2krINzHYPJORom8=;
        b=PRFAQfYY0A+bO7E5STu3dc1D99XErT7+LBGK3m1j8ujlYlY3SgbsDiLqhSyz/1Su7P
         vhou1j6VKWd1eC1kZdrOdI+wMF6U3Z4W2milTAf+kSrTmFLsd3AcHfU5Xw0+v2rDAQhx
         U/62ef/C/x4rMkoTZrrmBg/JyBclElzxWDvx1y8nT3lwmJEW6i7fnsj8yLrfwKaWYWcF
         4vFg+3BrD/zRM9VEq0DBbbRueHCdP4iEJXJMjnBqeqrF2f1Rq9cuIESwKXz/ysEljtFO
         fZZP+bJeM1o1m2/4YfbTRx8GYofngzo2mzL7me6tPxTvsNXiFQlnOa+XE5cZ8DC5L5rV
         lLIg==
X-Gm-Message-State: AOAM531iOEK6jO4j8YLquA0nPlzdG0ZSHlZWKTI5D+nLCe7DKKUrq1Wz
        +yuFj8PW7TNv5Kad1Kir3D8=
X-Google-Smtp-Source: ABdhPJxgTH77XrgeTyvRNDtfxyqUGfGa7sD3wM5YZmhKdJG7C7E1dguyoqySgr53uQVP9O+niarqlg==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr1038269pjo.83.1592001756381;
        Fri, 12 Jun 2020 15:42:36 -0700 (PDT)
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp. [210.141.244.193])
        by smtp.gmail.com with ESMTPSA id gm11sm6108257pjb.9.2020.06.12.15.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 15:42:35 -0700 (PDT)
Date:   Sat, 13 Jun 2020 07:42:31 +0900
From:   Masami Hiramatsu <masami.hiramatsu@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for
 value
Message-Id: <20200613074231.c09821a45924b31a875fab83@gmail.com>
In-Reply-To: <159197539793.80267.10836787284189465765.stgit@devnote2>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197539793.80267.10836787284189465765.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 13 Jun 2020 00:23:18 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Fix /proc/bootconfig to show the correctly choose the
> double or single quotes according to the value.

Oops, I missed to remove "show".

Fix /proc/bootconfig to correctly choose the
double or single quotes according to the value.

> 
> If a bootconfig value includes a double quote character,
> we must use single-quotes to quote that value.
> 
> Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  fs/proc/bootconfig.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
> index 9955d75c0585..930d1dae33eb 100644
> --- a/fs/proc/bootconfig.c
> +++ b/fs/proc/bootconfig.c
> @@ -27,6 +27,7 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
>  {
>  	struct xbc_node *leaf, *vnode;
>  	const char *val;
> +	char q;
>  	char *key, *end = dst + size;
>  	int ret = 0;
>  
> @@ -41,16 +42,20 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
>  			break;
>  		dst += ret;
>  		vnode = xbc_node_get_child(leaf);
> -		if (vnode && xbc_node_is_array(vnode)) {
> +		if (vnode) {
>  			xbc_array_for_each_value(vnode, val) {
> -				ret = snprintf(dst, rest(dst, end), "\"%s\"%s",
> -					val, vnode->next ? ", " : "\n");
> +				if (strchr(val, '"'))
> +					q = '\'';
> +				else
> +					q = '"';
> +				ret = snprintf(dst, rest(dst, end), "%c%s%c%s",
> +					q, val, q, vnode->next ? ", " : "\n");
>  				if (ret < 0)
>  					goto out;
>  				dst += ret;
>  			}
>  		} else {
> -			ret = snprintf(dst, rest(dst, end), "\"%s\"\n", val);
> +			ret = snprintf(dst, rest(dst, end), "\"\"\n");
>  			if (ret < 0)
>  				break;
>  			dst += ret;
> 


-- 
Masami Hiramatsu
