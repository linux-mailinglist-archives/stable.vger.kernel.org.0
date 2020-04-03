Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021C319D7A1
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 15:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDCNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 09:32:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33286 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgDCNcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 09:32:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id f20so6990615ljm.0
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1B9NLeMDtTnr4dZAofQWYRGmeVDWcEa7QUbOLt8Zif0=;
        b=V9OaIG26ZZXBs2ja92clufhFn4bOl7BZKyyKBPjIS97kJICoeFTJ/gNh0JRjSkG8XM
         sELHUQIHzUNHOUZ1KDMD/J+JEE+vaUJpNarNzd+T8/0ftnB72UpO4ubBpiHPXj/zfB/H
         qSb3zG1ktIjiC5q7Fdq8Qpf+r7s1gTZ76sQZ/8I9hP0pHwprXb16FgqdXMOUJzZYq8+m
         ItiVGlE5Rswak81VqO7oL4nCyx0sPtR8LrcNBqEU1YCGzZUuzifVW9lZr3AL+487jotX
         MmK7sbjRL0Ey5HtpevAa+FI9mrXKmMspJxdLSoKnl7MKovjcPchWGV9RwTc6OsmH+M8P
         8STg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1B9NLeMDtTnr4dZAofQWYRGmeVDWcEa7QUbOLt8Zif0=;
        b=HnQzPeeljH0BUoWHATmPaLMlYVlWPGDjgvXCa/DT4PPRqVsMJ5nMOuSySSdaw/33uh
         umZr7BAfJdELr1UiUpvKwuRsIt/LB0RCE2oA109bkrI68amRmxZXaU9A246cgBIEVb1F
         VKRyWwBMjPjFXAzmIHuuNtWZPKPSxCsjPPNaIQ0P1ItjE4nS0VLc5QrXmtFRC2FF76G7
         w8Sp6F7+Q4B79i1TatRcpy9eXZ86Rhs6xcaDwWXDIeGs0WrBsT79+DFrmHkB0oFyMQ9v
         mFuMfKZ7GVuYhHCmQZWvq9XI5lua+TwEVPiBscDgZBAYKPesyaiz80XUcYHi3o2U511Q
         B5tw==
X-Gm-Message-State: AGi0PuaWNBE+kvzcwrP4ysQtHEOy/GQqo1jOfQh+MijfrqQoIxRIXtn6
        xcOPfJtvQWYVR8Pt5WwamnPr2XAOlME=
X-Google-Smtp-Source: APiQypJoMxosZHh+k2+LEa98vRpsbBdcqv2X4B9kWQ22u0lddJXax1ykbJNUZYV1LR2PHYfc5evJKQ==
X-Received: by 2002:a2e:95c4:: with SMTP id y4mr4912219ljh.94.1585920773859;
        Fri, 03 Apr 2020 06:32:53 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d12sm5748186lfi.86.2020.04.03.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 06:32:53 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id AB1DD100F13; Fri,  3 Apr 2020 16:32:52 +0300 (+03)
Date:   Fri, 3 Apr 2020 16:32:52 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Hocko <mhocko@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        LTP List <ltp@lists.linux.it>
Subject: Re: mm/mremap.c : WARNING: at mm/mremap.c:211
 move_page_tables+0x5b0/0x5d0
Message-ID: <20200403133252.ivdqoppxhc6w5b47@box>
References: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
 <20200402133849.mmkvekzx37kw4nsj@box>
 <CA+G9fYv0xNtnD=eBmxVqYqEoYTbMk6mdn04WmgSUasDw2L7uFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv0xNtnD=eBmxVqYqEoYTbMk6mdn04WmgSUasDw2L7uFg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 12:56:57AM +0530, Naresh Kamboju wrote:
> [  734.876355] old_addr: 0xbfe00000, new_addr: 0xbfc00000, old_end: 0xc0000000

The ranges are overlapping. We don't expect it. mremap(2) never does this.

shift_arg_pages() only moves range downwards. It should be safe.

Could you try this:

diff --git a/mm/mremap.c b/mm/mremap.c
index af363063ea23..ddd5337de395 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -205,10 +205,14 @@ static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		return false;
 
 	/*
-	 * The destination pmd shouldn't be established, free_pgtables()
-	 * should have release it.
+	 * mremap(2) clears the new place, so the new_pmd is expected to be
+	 * clear.
+	 *
+	 * But move_page_tables() is also called from shift_arg_pages() that
+	 * allows for overlapping address ranges. The shift_arg_pages() case
+	 * is also safe as we only move page tables downwards.
 	 */
-	if (WARN_ON(!pmd_none(*new_pmd)))
+	if (WARN_ON(!pmd_none(*new_pmd) && old_addr > new_addr))
 		return false;
 
 	/*
-- 
 Kirill A. Shutemov
