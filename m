Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E292B20FA66
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbgF3RUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 13:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbgF3RUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 13:20:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71641C061755;
        Tue, 30 Jun 2020 10:20:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so4350228pjb.1;
        Tue, 30 Jun 2020 10:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q7vNRAdwknYiexV55sGxvItNjXux5N3RieyX7S5Yft0=;
        b=E9Mr54oIaWNTdfrwloNwST7X7lG1Hx2fuV98wNIsLuOqhXYCPhslNa+SzA7oIDENmu
         q4rb436TZk1yhzaY4ERvHJCfLiH4vNa7saSlGC35/psAWtTrLhylprMGR6c3ASUVUGJQ
         ff27Z5XmUZjYlVg42V05SzqxrezO07tHejXW7/K2lTj0zynDFTAzVqmUE+56TTlKG9fe
         yerGGRi+cnjUgwCasX6iPA48FSxrLOWLOIVuDNLsvN0RO9lkWGuNH4lIQ5XeOBAefU3o
         WKFQWAi5JOqQb0oPD+REmtLkcC5p2b0dEeqlb9xusI4Qp+jTJH2AGB76XYKi0LFo+BhO
         OlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=q7vNRAdwknYiexV55sGxvItNjXux5N3RieyX7S5Yft0=;
        b=sc1Xwz2qGrioomOHaGrm5IF+nZgTt2tb7cDZWWKHdeNXsj2dbbhP0hn+YmoEv2klUa
         Lk31S8hqWzY2s5FhL0SnmWdUEwEt7G+2kxdhLaVat4Q8GbPqsPQmshqbbiv2YIEBrg93
         37obSzagHdAjmFZ9laRYPsSYfAa4B34dUUodcTItVTbC5Sw/Zi3QAyLy9YikuougcQQb
         XWhtAoL9Qa9KmHrCZtfl+aTkoicqWWRhK9kqcEEJ0evj73LOGr1SXI0N5tW5SrywBt7Z
         Cy6i0oVFcJGoTzMwZ4r2AihujKosO0jfq71qpnoAWue6yhaNqzty8DMjcwE2Dc4dOsjI
         JxoA==
X-Gm-Message-State: AOAM5319rhbT24N175YKHwzuQ4o6WHnAWBO6xbmQBkamRFlZHgQaPWsT
        rHP4qanYmOGrqw82btDAHu4=
X-Google-Smtp-Source: ABdhPJwTY5TdjpWWCUEHKMn5KMRwZIVXi66kdtgBcNWEt7+FZt9zKEj3aCPxeCS9N9ZL26Sc1XpcRw==
X-Received: by 2002:a17:90a:a788:: with SMTP id f8mr12612923pjq.39.1593537633093;
        Tue, 30 Jun 2020 10:20:33 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l191sm3399510pfd.149.2020.06.30.10.20.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 10:20:32 -0700 (PDT)
Date:   Tue, 30 Jun 2020 10:20:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.9 000/191] 4.9.229-rc1 review
Message-ID: <20200630172031.GB629@roeck-us.net>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:36:56AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.229 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:40:00 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
