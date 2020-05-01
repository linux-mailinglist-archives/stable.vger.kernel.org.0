Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378531C0CBE
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 05:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgEADmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 23:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgEADmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 23:42:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA06C035494;
        Thu, 30 Apr 2020 20:42:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so1899673pjb.3;
        Thu, 30 Apr 2020 20:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WMCuecapfK8TP1C+t0k+ZRJhqGkBC7unabxZLdxz/e4=;
        b=S0FtNEUWEXiQ/DXkFSfvkIEekbv7RKUWWiEINqXp/Flp087/w7VyXNKf21AWo9zgKi
         AobA4cZV3UcY2JcI/k2wTQhhk/DeyZg7+dlUoVJMGwS3UY3ggkro1X7tdrbIlk1NWAtf
         uhy/YJtoPk0IyrS8OZ1TBxkXxRKc72G9excD59KFHpb0nFzzwWENbK/WrYyyujV4eXxy
         TT9pHFPOf0AxnkthfhlAtCCJmxpsb008P9v1odnE7gNy8PZe2LdfNBRwA0tQVGEmPhYE
         8aFIquB8W5OZMWkqxuOxXmxvgdz3QtnxjkOaK7sKw9MuTMm6zauRDxj6pwPv+BqK2Eez
         WneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WMCuecapfK8TP1C+t0k+ZRJhqGkBC7unabxZLdxz/e4=;
        b=GVRbCpvT7YSpO8bxbP+qynCzN+14D8kvCmOAcp0E4NkfdjFjcIuMhVaPp7ZbDv8mAY
         DY2mjPqRJluganpJP8zbvJJN1OdIoGUu60QlGViKoE0BHu1z4RhmBKSnaMeoBkIc6H79
         AIy5rNIEDBxiutPNQBYevUoFxX9oHPZVKRizsyCAuaepcO8vEuJV9U+RKR0is8e/zXZD
         H4L2iua6EfS0H+Qmrs38LQLahNJvjOPyh2xbLJz++sopnrzAGuKClhsamqyTrGo70zLv
         w1648pqxO6IaHxCPjtk/Pjo41vIocTAmUUXpzJ5U1J+YGhjD45IXpaXY0jcbKMCXFgi/
         MXRQ==
X-Gm-Message-State: AGi0PuZNXqVyH7L5FUSjAYw4c45xzNeSGvm8kLyZc//6aO6JInQvsbrS
        rV51Z867N11IkkvQZ7R7B+QGVYax
X-Google-Smtp-Source: APiQypIJJ2693R68Mz3NJYOvrz3X/7p71kRzy1+DIwH0mXqNOcjsmYUrWX0h3FccHb8AkN+Xi0ekeg==
X-Received: by 2002:a17:90a:a402:: with SMTP id y2mr2463659pjp.24.1588304551655;
        Thu, 30 Apr 2020 20:42:31 -0700 (PDT)
Received: from udknight.localhost ([59.57.158.27])
        by smtp.gmail.com with ESMTPSA id v7sm1016149pfm.146.2020.04.30.20.42.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 20:42:31 -0700 (PDT)
Received: from udknight.localhost (localhost [127.0.0.1])
        by udknight.localhost (8.14.9/8.14.4) with ESMTP id 0413gS2d004975;
        Fri, 1 May 2020 11:42:28 +0800
Received: (from root@localhost)
        by udknight.localhost (8.14.9/8.14.9/Submit) id 0413gSZA004974;
        Fri, 1 May 2020 11:42:28 +0800
Date:   Fri, 1 May 2020 11:42:28 +0800
From:   Wang YanQing <udknight@gmail.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, lukenels@cs.washington.edu,
        ast@kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: Re: [PATCH] bpf, x86_32: Fix clobbering of dst for BPF_JSET
Message-ID: <20200501034228.GA4956@udknight>
References: <20200501031950.GA4782@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501031950.GA4782@udknight>
User-Agent: Mutt/1.7.1 (2016-10-04)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 11:19:50AM +0800, Wang YanQing wrote:
> commit 50fe7ebb6475711c15b3397467e6424e20026d94 upstream.
> 
> The current JIT clobbers the destination register for BPF_JSET BPF_X
> and BPF_K by using "and" and "or" instructions. This is fine when the
> destination register is a temporary loaded from a register stored on
> the stack but not otherwise.
> 
> This patch fixes the problem (for both BPF_K and BPF_X) by always loading
> the destination register into temporaries since BPF_JSET should not
> modify the destination register.
> 
> This bug may not be currently triggerable as BPF_REG_AX is the only
> register not stored on the stack and the verifier uses it in a limited
> way.
> 
> Fixes: 03f5781be2c7b ("bpf, x86_32: add eBPF JIT compiler for ia32")
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Wang YanQing <udknight@gmail.com>
> Link: https://lore.kernel.org/bpf/20200422173630.8351-2-luke.r.nels@gmail.com
> Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: stable@vger.kernel.org #v4.19
