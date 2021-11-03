Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90428443DC0
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 08:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhKCHku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 03:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhKCHkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 03:40:49 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BBEC061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 00:38:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id y84-20020a1c7d57000000b00330cb84834fso3838901wmc.2
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 00:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=66uu6pMFwaoqtLUfKJfHxB8EI3iZ+Lon+COm99nenUY=;
        b=HqJqilX/JQilM9KQgkgb6Bnwml/foCLiItRrTReaWcfjqBrlTDnshb6i6dlzTYL7lh
         /t+dJVYNUu9ncUNo0g36PLv/a8EpQUBuaDSBLBBe8n7YrnE1r3icMXcHHXQFF+9M/0Nh
         dtnOxBbsePavMlxkkRHudD4ouuPvLohjQvchhR0JV/fshrhsAB+I9TofAJdPuZhJZxLp
         SJYzg895+76IsWC18Plfk2hqqk+RJ9iymFf7dS7JWxkG60vva4hKrM2UjZ20YlYfGt5o
         KPFIYHIS+A1TpZXcuMRbBkPgYwz+J2n2gQjXileDnlwRKH6HB3BYAeuH+fnFAdHDKy3S
         nQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=66uu6pMFwaoqtLUfKJfHxB8EI3iZ+Lon+COm99nenUY=;
        b=WBgYmYzFCSOdRODJ4GMDqlCv1jAib/8hALqf8aI09omLk2ETyxjJJCtHudQO09sm5u
         tgHsLNPeJCIcwew60HVN3hODY0ZCfNxctOHL/0UOw/LDA0eje3K37XGN+/2Ya6zRD01U
         qaiu5c6Yx5p47IiylQ9aSupFDdOpWUDWtgdICsC5NwX+qRRyQhS68ZNUEi/K1peAp+VS
         OoFnfTLxABHEVbss/yABAb7snLfkWUeN+VHf2f/3cx0SwX/iEqExKtVIs5MlmzHw/sqF
         zlyKu0l7K0ryryk8PVZoru/QUwiamMdEIA/C+eCtVa729kXZnccDTs3ea3tcVlZijw86
         FNOA==
X-Gm-Message-State: AOAM532NKiDq1j9Eq1pSYkO1SphwtZynReSlp/HRUjGBOensmk8SDE8C
        eE2H04DflsrA2MW2RKSjdQ0buo/rFzIzCQ==
X-Google-Smtp-Source: ABdhPJwpt5FRcgqWxnYtyGA/+iVpKBGh0lFBovYyOVnD0FcaaHzWWVyRsxSvVsU9OVYbHtuLoIFQaw==
X-Received: by 2002:a1c:a711:: with SMTP id q17mr13231252wme.158.1635925092007;
        Wed, 03 Nov 2021 00:38:12 -0700 (PDT)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id l4sm1126960wrv.94.2021.11.03.00.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 00:38:11 -0700 (PDT)
Date:   Wed, 3 Nov 2021 07:38:10 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org,
        syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
Subject: Re: [PATCH v5.10.y 1/1] Revert "io_uring: reinforce cancel on flush
 during exit"
Message-ID: <YYI8YjbE5xTSLLn4@google.com>
References: <20211102154930.2282421-1-lee.jones@linaro.org>
 <YYFfIk2CQaFI0Zdg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYFfIk2CQaFI0Zdg@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Nov 2021, Greg KH wrote:

> On Tue, Nov 02, 2021 at 03:49:30PM +0000, Lee Jones wrote:
> > This reverts commit 88dbd085a51ec78c83dde79ad63bca8aa4272a9d.
> > 
> > Causes the following Syzkaller reported issue:
> > 
> > LINK: https://syzkaller.appspot.com/bug?extid=b0003676644cf0d6acc4
> 
> "Link:"?

Sure.

> > Reported-by: syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Why does the patch here cause this error?  Is it due to the backport
> being different than what went into Linus's tree, or something else?

The patch is the same.

I need to do some more testing, but I assume it *was* also broken in
Mainline until the whole section was rewritten.  Unfortunately, the
patch which does that does not apply to v5.10.y.  Again, I can look
into this, but I'm not quite sure how far the rabbit hole goes.

> The original commit did fix a real issue, what should we do now to
> resolve that issue in 5.10.y instead?

Ideally I'd like the original author and/or the domain experts to have
a look and chime in here.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
