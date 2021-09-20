Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AA0412CEB
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbhIUCsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241621AbhIUCCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:02:15 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5748C12D67D
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 11:11:51 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id i132so17260291qke.1
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 11:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUORpWYgvQsdEmTsqcLhxS3LYAuuNxmU2qeGvSjqHnw=;
        b=PDIdI/Bd3YiqDRRvwTItN8ctv612ph/5NrCbKQHyYGpliaaUHBu9xoHYUVEua3Q+iV
         smKqm1ri+0FVwMB9Xz+Bs1em5iAh5YTFqKr+mDnArGjob8zzCz/kKxgfzZD4G5gFwWRy
         sB53CtBmvrNkAF8bxCuzNsteMrAgI+ypRXIpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUORpWYgvQsdEmTsqcLhxS3LYAuuNxmU2qeGvSjqHnw=;
        b=6d6uiW2Xem+1uj3E5uD8NQLtHvKNu/Q0Lqh+fr/NBxK8aS3sDKez0zqNTiNB2dSTeu
         4md53aJHSeQJW7/JrUpFRw48Y5AeVjw1EJuitLEq0Fmw24GHh1le5iMecof5Y33TBJvC
         MUDrqooDDj5VCUXfaEGMgVX3gtEF7lDFpxNLy0w6kHkHrwsgHIHd2l9UNOVbVyuuUgAM
         wXg5fao4aNncSrm1nt5ThdjH3K3e2KF0VErbF/cDAxSxlzXOgE72cVvOXsBcaDInVGvX
         h5u2wK/Wc7b26mOQGuuRWPogPSfTKG6BB1BncQTwKrVYFs3Pzkff3rejWWKAKYZxRbGQ
         +Pkw==
X-Gm-Message-State: AOAM533XRwojKYKkG2dJ5/62osgqY33OOxdXY/1e5u7LFPA068yq992c
        mPXqjPvJddsAgO4ADpmzd8LjB05JNfv3S+rSsrBTAw==
X-Google-Smtp-Source: ABdhPJxEG9v/aaNLEG8u35+7Iyd5AXH98QBASp/agrbqOwT/fKHFzbiP6UG4x2z59icV4vp5v+b7PRLh7qXyUi/1gjs=
X-Received: by 2002:a37:c42:: with SMTP id 63mr13501119qkm.104.1632161510337;
 Mon, 20 Sep 2021 11:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163915.757887582@linuxfoundation.org> <20210920163919.680890632@linuxfoundation.org>
In-Reply-To: <20210920163919.680890632@linuxfoundation.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 20 Sep 2021 11:11:39 -0700
Message-ID: <CACKFLi=a_5Qhr1rRq2gKqmO1su-pwxt3845K1AVjVqq5iOXJ5A@mail.gmail.com>
Subject: Re: [PATCH 5.10 118/122] bnxt_en: Fix possible unintended driver
 initiated error recovery
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 10:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
>
> [ Upstream commit 1b2b91831983aeac3adcbb469aa8b0dc71453f89 ]
>

Please include this patch as well:

eca4cf12acda bnxt_en: Fix error recovery regression

Otherwise, it can cause a regression.  Thanks.
