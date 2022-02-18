Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECAB4BBFCB
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 19:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiBRSru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 13:47:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238706AbiBRSrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 13:47:49 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDB712AC3
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:47:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d187so2988972pfa.10
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=9s/ZIHrGES7feK2tz5dP1rmrFQ/RLT8GNy7zBmf9EgA=;
        b=f0H3TVA9AOk2uGP+1p95rEv5SaFwf75XopgpbmOxZY8zZsMWRS7/ilyAzemq42ESPm
         wlFR7t4VyV+eB83JWky1FqzO4CdSZjDePKhOC5uuKA42mL9nd98/EVdL9zpuiudJCRHG
         E/569cf/0s3ZM93xiPP35gjTOIeT6l97ECf0fifUKeerHnYhMsaBs/uZnBlqlDJvqtX8
         9zyEy2gnZm6ck0iYurd/2iReR+k7ZeFKo/nzibUUGYQkf6MeYCCb7CUMpRqjEUOum+zH
         z0+tIlA6QCpa+mIRTL/DQP/NDl3xZeu/8IIub+8KNEX5t30zXH6yiACac5mO3G2kSuAH
         2HyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=9s/ZIHrGES7feK2tz5dP1rmrFQ/RLT8GNy7zBmf9EgA=;
        b=6uaH5zBJ2Hd7pc9x/70+AMovGDPA2dTPrWa9CxVzKj+l8VheIAll4UuTiOhr/YhAxU
         v6BWoUG7hUf1vX1BeOjOOz6sZNcLj7u4HQYXoQoxbh0zudy+kGzUR2CQa7ruIf/nQjvT
         /DM4FhCBYH1txyyprI02tJNMSxXtQgf8IgpJFUeQ1YgfCKtMrPAc4RxByqtAlFbyZJKa
         qcE6ahR4rnVwBH/i5pu2AobTs1OGFjCZg6K06KqKooYDLzqMTg5wrREBRVfQZh7thT+Q
         lIPzqDna07wgMbU3wLkJNse0AFm7mQeVhc2+JCGq7n6HGwTDg3FHcSaxHiMPMUUDo2xb
         zBsg==
X-Gm-Message-State: AOAM530R9yFZkHbRrjhMks995aKhT7wUK6tFsNYtQIsvp22gLF2uk0pD
        vjZoJldH/l/uSle2dKptUXTDqTkD9eILHg==
X-Google-Smtp-Source: ABdhPJxbZeaBnK2HPkHb7qJeePZrSd31i9bN8DyNF4o8wa3tB2DdFjfjcOKFTXhdLq/D0WfDRNYbsQ==
X-Received: by 2002:a62:3085:0:b0:4e0:1218:6d03 with SMTP id w127-20020a623085000000b004e012186d03mr9053021pfw.19.1645210051404;
        Fri, 18 Feb 2022 10:47:31 -0800 (PST)
Received: from [2620:15c:29:204:701:472c:4005:6710] ([2620:15c:29:204:701:472c:4005:6710])
        by smtp.gmail.com with ESMTPSA id h5sm3534755pfc.118.2022.02.18.10.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 10:47:30 -0800 (PST)
Date:   Fri, 18 Feb 2022 10:47:30 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] slab: remove __alloc_size attribute from
 __kmalloc_track_caller
In-Reply-To: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
Message-ID: <b8e9dcd2-5b2d-af7d-e4e6-c6bd4a7e4315@google.com>
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Feb 2022, Greg Kroah-Hartman wrote:

> Commit c37495d6254c ("slab: add __alloc_size attributes for better
> bounds checking") added __alloc_size attributes to a bunch of kmalloc
> function prototypes.  Unfortunately the change to __kmalloc_track_caller
> seems to cause clang to generate broken code and the first time this is
> called when booting, the box will crash.
> 
> While the compiler problems are being reworked and attempted to be
> solved, let's just drop the attribute to solve the issue now.  Once it
> is resolved it can be added back.
> 
> Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
> Cc: stable <stable@vger.kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: David Rientjes <rientjes@google.com>
