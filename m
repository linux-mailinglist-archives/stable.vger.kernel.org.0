Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F181B5F4A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgDWPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 11:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDWPd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 11:33:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E4C09B040
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 08:33:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so7033125wml.2
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 08:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W4yyff1bxIyXCcjIXtUoDnnedr3hHmKrkMXh2SX0RA0=;
        b=UUleoEnGMbi8J6q2gh2oXicaEKR+rQ+fEg5QOAG93t7lUoQ9Ped5KSKEAdtqwVkQ7m
         E6ctWfIAQnnwPAxdjEEWfrW/AEHu/rtIqQg4RApTHhadLH+PNAGezgUpA+rnhDezeup0
         VL3YR/MJRiL2UBEA0PDt3b/7oy7tD8hxCeonA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W4yyff1bxIyXCcjIXtUoDnnedr3hHmKrkMXh2SX0RA0=;
        b=bOMt7J2ZbgXaub793sSYZ3RoA8+fANBgzUGvmsDc3idFG7gDdd1Du6hLhVXH14VO/y
         okEE4iUWPLqfOqJ/1syOUHcegXuCRsxY0m8vI6NiBskLM9qAhzKngDHXv/TeZYEn5AIE
         YDzIhrMIOkRmJ5Z2R4QQSRzteyOIKAkpLbjKiMCu0Xw0zJynp8a6AoZpn4Muw/rAQFK4
         v3pz6mcNvrAy65ydefqGBfssh9a7FkM8GucD+EvyP9FZYbVq4s/LA0SIJ18xwRfdibfG
         q2u6UaDQrcBdgH1XubGSebVhA/Tu/h2OUlcVlxgKa5pxPupNk091Ti7Q97aTjec2MUCo
         EDUg==
X-Gm-Message-State: AGi0PuYKqAWyQws5m+p1Tt9FCkfUYmhVW33oNWfyb+GrniyEZWoe2JTB
        eBPe6FTmywMeEqR857l6iEG5zA==
X-Google-Smtp-Source: APiQypLuRIvaOlzsnUsi5FdIR0dI+2u8ZnoEpm45/HzqUm1iJqqMuYGUVleUiY5X8duXfQH1Of6bBg==
X-Received: by 2002:a1c:bad4:: with SMTP id k203mr4712758wmf.15.1587656004853;
        Thu, 23 Apr 2020 08:33:24 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:fa59:71ff:fe7e:8d21])
        by smtp.gmail.com with ESMTPSA id l4sm4342292wrv.60.2020.04.23.08.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 08:33:24 -0700 (PDT)
Date:   Thu, 23 Apr 2020 16:33:23 +0100
From:   Chris Down <chris@chrisdown.name>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200423153323.GA1318256@chrisdown.name>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200423061629.24185-1-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yafang,

I'm afraid I'm just as confused as Michal was about the intent of this patch.

Can you please be more concise and clear about the practical ramifications and 
demonstrate some pathological behaviour? I really can't visualise what's wrong 
here from your explanation, and if I can't understand it as the person who 
wrote this code, I am not surprised others are also confused :-)

Or maybe Roman can try to explain, since he acked the previous patch? At least 
to me, the emin/elow behaviour seems fairly non-trivial to reason about right 
now.

Thanks.
