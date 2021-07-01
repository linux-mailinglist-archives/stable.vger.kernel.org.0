Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AED3B9607
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhGASSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhGASSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 14:18:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDFC061764
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 11:15:44 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u19so4123352plc.3
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VBK3elG7+RffbG0U9TL73XjsoLZSaxYTEj/YLeL64j4=;
        b=F4yNM9ndU/GFX5Dpx1BNEVZH7b9oSr88oWu0kz62oL9CJgaPBh/H+hgIGXunaN2WTt
         uZjvt5G1mUhUjVH9m6/v8w3WKGzo228LP2r6bRnqP4wZFsKZBWbbh1sjJYLEZgzPmMC4
         XtkhmMyF6RaCmjzBMGycnZY0qoIFT8ePmVeaz1hSrUZgYtLrEZobquEFLKEodvtVpy5K
         ykSuAWf+OI0h/q2uGyQhhgQKVtRVvvTYcIy1142iiXk/mBQHJ3MCEFePfQ/YPt0RpBKy
         yDCa0L0EZlR9eoBxm06lh7Pn7kuMYlsMiP6M2ORVr6eZi2Bs3S+jcPRbHxiE9bPs9CBx
         VTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VBK3elG7+RffbG0U9TL73XjsoLZSaxYTEj/YLeL64j4=;
        b=h1OT5NJHWvVHVoLRgTUlfaJHP2PG6nhM2+7ezwnTxNbxcOTUDwtiDhvonZKJlNWtLC
         whRLgczPW3KYofjxEXzDZx/l9ByZkMtbCfhHSaYWHjalHB5VOqbZIiT2nOkDOjYE9MO8
         OoJFL9v5KtxZX4eKRW7O2eIj4wVv7kAO+qj/GHPDeynz6Agp/oAKbvaJedknUeOAb4KR
         AvH6W2D234MBR/MTKmRXNeP5Q05ghK8mj798t2TBcrSYXY/+Oy2THh4vDZEjkNQRSnko
         tnD3NNh3ifEVOIbwQDMwMej2I8V4xLKHIaxDWRgvOFWCi6AR6XgNAMAkbGmDdFr+S/tn
         CJ/A==
X-Gm-Message-State: AOAM533OqwTSPw/KdXFRUnhEGyHXJ214PFbQf48MY3khbX4lWvRpt3Ih
        mzzW3Xg33y2+BjUIzqpL+pCb7w==
X-Google-Smtp-Source: ABdhPJx+0AKjtxUAwtA0opUfMtTSNeImrLpUEBTW3u8J/HIZARu6V3+zpwFavk5Btxnje99bkW6jWQ==
X-Received: by 2002:a17:90b:46c3:: with SMTP id jx3mr901300pjb.206.1625163343317;
        Thu, 01 Jul 2021 11:15:43 -0700 (PDT)
Received: from google.com ([2620:15c:280:201:558a:406a:d453:dbe5])
        by smtp.gmail.com with ESMTPSA id n23sm714011pff.93.2021.07.01.11.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 11:15:42 -0700 (PDT)
Date:   Thu, 1 Jul 2021 11:15:37 -0700
From:   Paul Burton <paulburton@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tracing: Resize tgid_map to pid_max, not
 PID_MAX_DEFAULT
Message-ID: <YN4GSV8/AzK1fz4o@google.com>
References: <20210701095525.400839d3@oasis.local.home>
 <20210701172407.889626-1-paulburton@google.com>
 <20210701172407.889626-2-paulburton@google.com>
 <20210701141221.1d0b1fe0@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210701141221.1d0b1fe0@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Steven,

On Thu, Jul 01, 2021 at 02:12:21PM -0400, Steven Rostedt wrote:
> On Thu,  1 Jul 2021 10:24:07 -0700
> Paul Burton <paulburton@google.com> wrote:
> 
> > +static int *trace_find_tgid_ptr(int pid)
> > +{
> > +	// Pairs with the smp_store_release in set_tracer_flag() to ensure that
> > +	// if we observe a non-NULL tgid_map then we also observe the correct
> > +	// tgid_map_max.
> 
> BTW, it's against the Linux kernel coding style to use // for comments.
> 
> I can take this patch, but I need to change this to:
> 
> 	/*
> 	 * Pairs with the smp_store_release in set_tracer_flag() to ensure that
> 	 * if we observe a non-NULL tgid_map then we also observe the correct
> 	 * tgid_map_max.
> 	 */
> 
> Same with the other comments. Please follow coding style that can be
> found in:
> 
>    Documentation/process/coding-style.rst
> 
> And see section 8 on Commenting.

Yeah, sorry about that - I should know better having been a maintainer
in a former life...

Just to confirm - are you happy to fix those up when applying or should
I send a v3?

Thanks,
    Paul
