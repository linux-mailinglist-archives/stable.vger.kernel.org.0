Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88375365DFA
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhDTQ4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhDTQ4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 12:56:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8368EC06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 09:56:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h20so20009425plr.4
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X5DyifeFyUsk9nMOlWlbL7GJRTuBQ89WveKtV9WXxuE=;
        b=dSlEqecPA0kolF/5pC3y6NvEwWhGcafFZUk/ZtP6zOpuYgu3I/ju5SHqgcaRsJvZgS
         H7E6pQwy/E7nVCl+wrLXC50zXlNwFWzUIAUDcB5UvgBH5z4v4jjMHRDlWMToFlgJ+4b9
         enLzqZVnMuaypRP9QDO3apacGp6w8+neh0hcIbUkFd48glmJEGy/pXbz6CmZ/LQ3A3AM
         QuRi8LDBdG9otFkwkGFlQjreAoe8e/Qpuhv8jldhILO/N5GS1xuoQYzDsU0M7a9wZIzd
         o3bLi+11O6aH3rMs2QB5qAb9n3iIXltRDrerpYointxX/A9tdWsbCq50hS40wmVD2Ich
         6rPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X5DyifeFyUsk9nMOlWlbL7GJRTuBQ89WveKtV9WXxuE=;
        b=CFT0WM9+VqwrJoXHgrSyAk66xmttTRg/Dw+WTEZDHu+RA0Nnl6WmbteLRegwY6oVtA
         D8i9I+lDpm0MRfnpLpfRJKYDXh5fHmL+EhkrZHIhd5IbT5zJDFBZSlkcOxco7tM3IeHw
         GHkgNutSsmD+umS9h3yV/9XyTM4IT00oNPLCGANKLRks6eU2J2YOo2th4wmAXB61vJ3a
         Oh501tdguHG0MZidrr9lAnA1oJ1kY0EOt5R/Qqq1d+EyYMSgUkQfupzOpN3s4OxPIEC5
         eJh4ZqITwMKvlxWxynd9KuC1lC4bQnXh0XM/CFy+YLatjLX+YItblQFZjH0nuGS/vaGR
         PVvA==
X-Gm-Message-State: AOAM533pTHDjfU39p/y/yZbu3GUa4z8N6hEHdn8J4Mb2nDa6i57MZX8a
        iNZL7vse99/xnGARqrM8vsfK5rMl8wyGpQ==
X-Google-Smtp-Source: ABdhPJydOYkPJNhyOEJSkSt45/Dm6yfT+MTD0/Pp9xIH0bIZ+YY9L2C5A4eMTYEeAnTlWCoXak9KPg==
X-Received: by 2002:a17:90b:120b:: with SMTP id gl11mr5966872pjb.143.1618937770951;
        Tue, 20 Apr 2021 09:56:10 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ml9sm2531870pjb.2.2021.04.20.09.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 09:56:10 -0700 (PDT)
Date:   Tue, 20 Apr 2021 16:56:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Patch "KVM: VMX: Convert vcpu_vmx.exit_reason to a union" has
 been added to the 5.10-stable tree
Message-ID: <YH8Hph/VEotO+Iv+@google.com>
References: <20210419002733.D5675610CB@mail.kernel.org>
 <YH38CpPjGSsSRUgt@google.com>
 <YH4HlIEvoqHWFtz+@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH4HlIEvoqHWFtz+@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021, Sasha Levin wrote:
> On Mon, Apr 19, 2021 at 09:54:18PM +0000, Sean Christopherson wrote:
> > Maybe we'll end up with a more painful conflict in the future that would be best
> > solved by grabbing this refactoring, but I don't think we're there yet.
> 
> This is the tricky part: when we start having these conflicts it's
> usually too late to refactor, no one cares, and backports just don't
> happen.
> 
> I'd actually point to the file shuffling (commits like a821bab2d1ee
> ("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")) you did a
> few years ago in arch/x86/kvm/ as an example to why we can't wait: those
> changes made a lot of sense upstream, but for stable kernels it meant
> that patches were now trying to touch the wrong files and would often
> fail or do the wrong thing.
> 
> On hindsight, we probably should have moved files around in stable trees
> as well to match what upstream had, but at this point it's too late to
> go back and fix that, and we're stuck manually editing paths for the
> lifetime of most of the LTS trees.

And I guess there's also the argument that inducing even a handful of manual
backports is more risky overall than taking this one "unnecessary" patch.

Objection withdrawn, I don't have a strong opinion either way :-)
