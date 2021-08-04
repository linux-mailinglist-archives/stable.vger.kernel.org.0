Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFB3E062A
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 18:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhHDQx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 12:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhHDQx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 12:53:29 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E50DC0613D5
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 09:53:15 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id k3so2283189ilu.2
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 09:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SpSYu1z69a0jpVO2LbxgfPc2QvfwNfjCudd2tD1/bko=;
        b=MBAS7cLIwbd+XAo8i/Cf6+X7R/aOwmCAV7dJkcrJoDoeVsb/4XqYJWQVpEm87GeW9g
         iEgH2nu0VKSwkGqPzqORCXGdNTdtUbhtyswH+7pEyAUZLTvC3HdCIOsINA2EO/648QZM
         Ju1zjQH1P0s1X/icpVLBTU0fV8XwPY/kIIuzZ8htQ+A5F7IxQmI70CjEnaHoEZ7hQL/A
         EGdte260NO4sG3SLUFxq+DonULCxH4Fspc2kfzGlxb5Nqp/6QTxfqFRkWx9CAw1NG4IH
         kcq1gDSDumaPFrqBh+nVpMpz/erB65URZdUDRM53TxuR0yRzDaHy9vK5H3DZxD2hZPee
         wM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SpSYu1z69a0jpVO2LbxgfPc2QvfwNfjCudd2tD1/bko=;
        b=NLL9vIRhIN/cxb3bArNkEZxCBD5L1sMkyGIIITlIn6yRRrx2icClTuD0kqW6p5Iu89
         R6sM+RZOas7F3E1WWDnOqqMPnCvfr921Bb2OCESXZ+sb9LN5U5o0Tarr/hL64jbxU24o
         YEL8jW0DG8KdqEUFxOEwDjB8bEKElzpxUdBOtrkxSYVvR/n3XPxqvE4lQT6+z5I9+zjr
         mVoB5YZZLai3B06IAG7D1D1FElugA8f8/KjOA2EVHYezUpmkg8tn93s/zispUqT4xBPo
         qM1pchSs38wt2jBuxXGy5pFJX8Vy9PgaaeAIre7c3bu23kJTy4uxO/1tUgti9VORnTZb
         BibQ==
X-Gm-Message-State: AOAM533gN++urKHUlsz1fDX8aTCT3vnhA0OjJs3dm+kZG1Xfdw1vReUA
        8iWYKWwWBOtGvhCKMkkGrHQ=
X-Google-Smtp-Source: ABdhPJzwD+9q4eeGogY3y5Xa0sxtCdWRzIauji4+rgOWH69B1Cl6HcWwWqwhiY4uLnlVlQWSLBeuwg==
X-Received: by 2002:a92:c54d:: with SMTP id a13mr391720ilj.74.1628095995056;
        Wed, 04 Aug 2021 09:53:15 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i2sm1330505ils.84.2021.08.04.09.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 09:53:14 -0700 (PDT)
Date:   Wed, 04 Aug 2021 09:53:08 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     gregkh@linuxfoundation.org, john.fastabend@gmail.com,
        andrii@kernel.org, jakub@cloudflare.com, kafai@fb.com
Cc:     stable@vger.kernel.org
Message-ID: <610ac5f436445_10ef4208a@john-XPS-13-9370.notmuch>
In-Reply-To: <162790507510829@kroah.com>
References: <162790507510829@kroah.com>
Subject: RE: FAILED: patch "[PATCH] bpf, sockmap: On cleanup we additionally
 need to remove" failed to apply to 5.4-stable tree
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gregkh@ wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi Greg,

We should get it backported its a fairly rare event, but then we get
bug reports when it happens.

I'll prepare patches, let them run in our test env for a bit and then
send them out.

Thanks!
John

> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 476d98018f32e68e7c5d4e8456940cf2b6d66f10 Mon Sep 17 00:00:00 2001
> From: John Fastabend <john.fastabend@gmail.com>
> Date: Tue, 27 Jul 2021 09:04:59 -0700
> Subject: [PATCH] bpf, sockmap: On cleanup we additionally need to remove
>  cached skb
> 
> Its possible if a socket is closed and the receive thread is under memory
> pressure it may have cached a skb. We need to ensure these skbs are
> free'd along with the normal ingress_skb queue.
> 

[...]
