Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DB42A2132
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 20:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKAT7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 14:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgKAT7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 14:59:52 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C666CC0617A6;
        Sun,  1 Nov 2020 11:59:51 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id s1so5229894qvm.13;
        Sun, 01 Nov 2020 11:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oam4cLJvZQF6jvN0Liy/kzC6cJ2K7PgyBy8C5SiLk/E=;
        b=E6wgK8VxUUuFZ7dVRHR4RF1HRYspAGFOZOcdlykhVDAz9/5pUCdxe/j7TcPRLFyQEa
         v1JM8EZsr/RKkcKDtUbdjuw+p1TnCgZovNFVPQnrYvmvOR7t+gNGZwucNzsmvWMaSuQD
         hl7rlXmhWOeBtD4dZtswedQNBMPL4C0k2e89CRemxvxOM1TSs9fljvKrK6CnUIHdWaT6
         dlkdnHTgI0+ir92SIksmxT0Rr7wr1D9ZLpSKE6C1hEewv0P92oisKL0LXzM35t+oayFP
         kiia+52h32WT4nP+uoFIKWih+VVFmdqWpb7NdjcFWyJJkwdJ37NKv7gnkrG92owwre7M
         lobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=oam4cLJvZQF6jvN0Liy/kzC6cJ2K7PgyBy8C5SiLk/E=;
        b=OQzhpsa0aeeM185xCfex6mk6fkcq0czu8pUZGfnxqW0s4cc5ECBO0goG4Irr/25alg
         deS1yeMRmTmTBaAEM8vv+vMpbSDHhQAhla9CdAxrDPapYvps1mtTLXnaf/O3EniTaoO2
         z4PrZdm6q4eMmT+2v0U0yOCfiaDHHtkxwiJY15iSXXQ5s9agjjGdtVjIj0PArMp1I9FM
         JUT2pMQbRpNnOoJS66AoFRrUkC8QHfzx6/ycFf8iMTgsegwwFtqL/xrwtFpUvKLps/vc
         Hzly6FGLR2krRWWGe13Gr+7Zf9mh8zXMJJy8jAQJ5vMxCp5PLnJyeqdeCBT0TLDwDKOd
         eQiw==
X-Gm-Message-State: AOAM532pAsYncpi1eXrqOMzrY82koKUH14xYpqvCLpoEfyCEQF5vRnuQ
        eE4/tUHw/qSCc91MNhIUNxQ1/+S8xIPGXQ==
X-Google-Smtp-Source: ABdhPJynXMW7U0C6gc9MBH0yeTiLDgbp1PLHXqvyx6J1fsP0wHfJKrM0b4IX2ohUWcQXLraqcUIOtA==
X-Received: by 2002:ad4:58d3:: with SMTP id dh19mr19366551qvb.14.1604260790823;
        Sun, 01 Nov 2020 11:59:50 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id g3sm6480473qki.84.2020.11.01.11.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 11:59:50 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 1 Nov 2020 14:59:48 -0500
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        kernel test robot <lkp@intel.com>,
        linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201101195948.GA1760144@rani.riverdale.lan>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
 <20201101195110.GA1751707@rani.riverdale.lan>
 <20201101195215.GE27442@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101195215.GE27442@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 07:52:15PM +0000, Matthew Wilcox wrote:
> On Sun, Nov 01, 2020 at 02:51:10PM -0500, Arvind Sankar wrote:
> > Ok. So I still send it as a separate patch and he does the folding, or
> > should I send a revised patch that replaces the original one?
> 
> I think Randy's patch should be merged instead of this patch.

Ok, if that one works then it's better I agree.
