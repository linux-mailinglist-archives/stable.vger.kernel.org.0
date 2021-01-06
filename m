Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A102EC609
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 23:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbhAFWIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 17:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbhAFWIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 17:08:30 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F74C06179C
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 14:07:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n3so3084949pjm.1
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 14:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7exsSt5huO4DQVvEq7ttYl8C8U4/ph0YHja3ukzLUgQ=;
        b=ehc+yWdNNWPAfWc/rBlILax1T7u2pUmbWhPgqXjN/axOborgrC6sIPi3tiAD0gALZn
         6/UM8Ovzaxpanr1CrWS9hlxGLFkO0kYshKTuWL5a2pJu6/MS5SAexihDxyvWHBflj/Ee
         myiUt6B0QUqSVG/8zfHo3aJFPj/vwqNc3qKkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7exsSt5huO4DQVvEq7ttYl8C8U4/ph0YHja3ukzLUgQ=;
        b=hveU1im/1A1eCMa51EWvBYnwmfIAjs0hQGm34Q/hhQghqW/wo/kINQYcuM6lIULcyo
         uuB+pg25Dlt0hf/E03/XtUd2sY/D2p/lusMeB560q/++ffsw/Z/Uy3vNJczQqBoM2t3G
         aPulKOOjn8Yksw91+qM9/aM0XYVkWaJlU2t4/YHxHhkAgRfDI7fqdZnXWntABeTSYpLP
         LCer7PApZNE2ndeNgTqUarInjEtkAO1PC/pxRVzsTfrjU7ESXZVv92Ls3IqE+Xeaic+L
         ++c1lnksmdVwj6LtoElsdP2Gut/y+spjo31azOke86LNmwOwW3/P2OD0+EmWz1DMYXYK
         ZWtg==
X-Gm-Message-State: AOAM532EjPNyi/kww7FKh/dcDCfjFlL6BUjX6GKYtD7ZXJbmXHqJ62MY
        f9XBiG0cv+tLnA/5DIrKOVWwGw==
X-Google-Smtp-Source: ABdhPJzNfWzBTMCVpT0yILuJWFRJEWWfLibePrvIbop06+FAplpdAilopaPhSjByOtMN0CsG2nWd9A==
X-Received: by 2002:a17:90a:7485:: with SMTP id p5mr6002683pjk.132.1609970847261;
        Wed, 06 Jan 2021 14:07:27 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p16sm3102487pju.47.2021.01.06.14.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 14:07:26 -0800 (PST)
Date:   Wed, 6 Jan 2021 14:07:25 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alex Smith <alex.smith@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 mips-next 1/4] MIPS: vmlinux.lds.S: add missing
 PAGE_ALIGNED_DATA() section
Message-ID: <202101061407.5E63FAB771@keescook>
References: <20210106200713.31840-1-alobakin@pm.me>
 <20210106200801.31993-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106200801.31993-1-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 08:08:14PM +0000, Alexander Lobakin wrote:
> MIPS uses its own declaration of rwdata, and thus it should be kept
> in sync with the asm-generic one. Currently PAGE_ALIGNED_DATA() is
> missing from the linker script, which emits the following ld
> warnings:
> 
> mips-alpine-linux-musl-ld: warning: orphan section
> `.data..page_aligned' from `arch/mips/kernel/vdso.o' being placed
> in section `.data..page_aligned'
> mips-alpine-linux-musl-ld: warning: orphan section
> `.data..page_aligned' from `arch/mips/vdso/vdso-image.o' being placed
> in section `.data..page_aligned'
> 
> Add the necessary declaration, so the mentioned structures will be
> placed in vmlinux as intended:
> 
> ffffffff80630580 D __end_once
> ffffffff80630580 D __start___dyndbg
> ffffffff80630580 D __start_once
> ffffffff80630580 D __stop___dyndbg
> ffffffff80634000 d mips_vdso_data
> ffffffff80638000 d vdso_data
> ffffffff80638580 D _gp
> ffffffff8063c000 T __init_begin
> ffffffff8063c000 D _edata
> ffffffff8063c000 T _sinittext
> 
> ->
> 
> ffffffff805a4000 D __end_init_task
> ffffffff805a4000 D __nosave_begin
> ffffffff805a4000 D __nosave_end
> ffffffff805a4000 d mips_vdso_data
> ffffffff805a8000 d vdso_data
> ffffffff805ac000 D mmlist_lock
> ffffffff805ac080 D tasklist_lock
> 
> Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
> Cc: stable@vger.kernel.org # 4.4+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
