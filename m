Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE02A84F7
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731587AbgKERd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 12:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKERd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 12:33:58 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0838C0613CF;
        Thu,  5 Nov 2020 09:33:57 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r186so1850860pgr.0;
        Thu, 05 Nov 2020 09:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AUFgPvv6rFgfWp8DArPv00GwKNR+UKOLg+uDf2rhEHc=;
        b=JCS92kQTECAAa7cDKcOEZyVg1HDPCOM18Lc/ZmZ4okFITjl+71gi3Sk9AUr4QpltYK
         YWy0skAWf+ehpUvWrlA6S5Zt7HkflK13LhEQNmYW2aU+laan+fREW9BmXeM6ZYl9EN4A
         k/0FJMDalzkC4I4uz1ceBQNeOCrfU1txTtb73gPx3a5QbMMyuyuGpfNQZmbct7OAn7To
         EzGe9ewcpYo1d+R7TumcejL9X9HTi5ZQsupWUsGAtcFbp73SvKJ9qRNZ3bMA3RG+bmXY
         ++c9h5K/SIrVN/ePzoSLb9xsZ2i7df5oTbTkEly/+OTL56Hro7IDQEetkVCSn9Iq8f+/
         k8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AUFgPvv6rFgfWp8DArPv00GwKNR+UKOLg+uDf2rhEHc=;
        b=QExEY0zjSIHlr3vB7pcx/8Sh+eTl9kQ4wmRltcsvpm+LdMtk34Pb9nPUDeQRriTbz/
         XWhcJ3NIEpRqy4IN7/wRlfzikU5ieQeW3dg1azJW68/zTfthXNvuo6gXvPpkm/OCRTou
         /Piy6TndfgnUzKnsk3wMHG/51HKJuM2PVMOe5Ay5p2RDB5o7hXNyNvQ17dN1Q97zluvw
         +Ibg2l6BENoMQZeY0ZD8WTV4gounvhZicwAl5lo3MRTpm1NFrRD4TQa4bzD/Ulrt5ans
         cZeDxA2voE1+20MA7pqZOKHFAMrosqiUaCf9Y9m1BkSuoIXvlETyLNhT9B3yi1DMybrT
         rseQ==
X-Gm-Message-State: AOAM533SS3larEpASvI3F0YChizAI4HUVFRP4nz5belBxrJyJDp20lkz
        02gzewQzhbG4YccJl7OVzGCB9XCCG2Y=
X-Google-Smtp-Source: ABdhPJwDUNyet8V+rYqybZMW4aewS6nXoTRbi5Gko1Sgw0E1zV4Kok8rYlEFd2TRnec9qik6ZS3sVQ==
X-Received: by 2002:a62:5382:0:b029:155:6333:ce4f with SMTP id h124-20020a6253820000b02901556333ce4fmr3444030pfb.28.1604597637374;
        Thu, 05 Nov 2020 09:33:57 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id h26sm3229500pfq.139.2020.11.05.09.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 09:33:56 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 5 Nov 2020 09:33:54 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201105173354.GB387236@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201105171602.GP17076@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105171602.GP17076@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 05:16:02PM +0000, Matthew Wilcox wrote:
> On Thu, Nov 05, 2020 at 09:02:49AM -0800, Minchan Kim wrote:
> > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > 
> > While I was doing zram testing, I found sometimes decompression failed
> > since the compression buffer was corrupted. With investigation,
> > I found below commit calls cond_resched unconditionally so it could
> > make a problem in atomic context if the task is reschedule.
> 
> I don't think you're supposed to call unmap_kernel_range() from
> atomic context.  At least vfree() punts to __vfree_deferred() if
> in_interrupt() is true.  I forget the original reason for why that is.

It would be desirable, However, the logic was there for several years
and made regression from the commit in stable kernel for now.

Can't we have graceful shutdown if we want to deprecate the API usecase
in atomic context?
