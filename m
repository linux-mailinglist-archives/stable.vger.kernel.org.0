Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E33449C636
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 10:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiAZJWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 04:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiAZJWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 04:22:38 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF30DC061747
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 01:22:37 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u6so30092599lfm.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 01:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xkcY7QEiaJ3QELLMv7empbscOPwwif+Hn5rC1CgT83o=;
        b=aV07h61YphegXKSL7xAYax2+orY2J2/niHnCklIslT2oe/K2HIBSZxBhVoKM6Jc6FB
         wchXgI3XlY32V/h3wgeyiKBaOT7Ly2ljN/HOVdxTcozhZKdtympP9Qgb+Ka0ANF5WOEc
         4fyMitf76ZRloQYIg7+tuSoiAtnbkHc6Dj53PmVzwT0xcoCw2PHN+oujuLwG1YpgJPVE
         E0C6+Fsy358PnFkY1h7riXbxe5j1YUo398ycOKLinqTmgfkmz/Qzm8cn+sA1eqesj4sK
         VN4WOdAN+XtCZugW++2lgB/l1XYtQmy/UBfDSWQPPts1SqT5Y95VfldPXXl35DYqnryj
         m6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=xkcY7QEiaJ3QELLMv7empbscOPwwif+Hn5rC1CgT83o=;
        b=uog9oUCmfwZGUPFQDkbmQMjHdjl1yXjACCUanHHIMLghEpIqz1Y12/TZgi//4439pM
         K5M6SNlEPbafCgNxXfmDJJdOVQqz/nXJ8G1RGbZpGGFB7li5qb6awvWFhzjPAt9I6QVe
         qfe/Gn7ScUNUb6jGCw3E0qLp3oNX+dAyi5fdpYV3gtx5gj6rairBSRcTzGfk875Hoiet
         WnQCT3B41e0GRSvWRycbAXyYWRjswMTZhOM45azlKM3z0+7qOvIuCoocd/Jks/zz5q89
         s6s3eOnw9S5iDjajOO7FF0JcLJTqa5ckHMyxI3z+WJCTvcv2S9lQ6FXgypGUoGtJ80LD
         ZWbQ==
X-Gm-Message-State: AOAM53109+halD+aEL8TRF3Awaw5VRUHY9GVGM2LEGup5kt6Qg+e+D0/
        l/oEiGT/DuQw+uRXsHCbBNXmuA==
X-Google-Smtp-Source: ABdhPJzerxnNhAMQYchpetaXvqyc5iQ3ti3nWTUnJGWoFCSLGR8WXA/GAnhvbiuvJKU4fHaXwHYsCA==
X-Received: by 2002:a05:6512:39ca:: with SMTP id k10mr10567702lfu.378.1643188955759;
        Wed, 26 Jan 2022 01:22:35 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id n10sm637970ljj.106.2022.01.26.01.22.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 01:22:35 -0800 (PST)
Date:   Wed, 26 Jan 2022 09:22:31 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Christoph Hellwig <hch@infradead.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tty: Partially revert the removal of the Cyclades
 public API
In-Reply-To: <Ye5vx/8CYH2zWK28@infradead.org>
Message-ID: <alpine.DEB.2.20.2201260542450.11348@tpp.orcam.me.uk>
References: <alpine.DEB.2.20.2201230148120.11348@tpp.orcam.me.uk> <Ye5vx/8CYH2zWK28@infradead.org>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jan 2022, Christoph Hellwig wrote:

> > Fix a user API regression introduced with commit f76edd8f7ce0 ("tty: 
> > cyclades, remove this orphan"), which removed a part of the API and 
> > caused compilation errors for user programs using said part, such as 
> > GCC 9 in its libsanitizer component[1]:
> 
> This looks sensible, but a #warning might be useful to get people to
> stop including this random header.

 We have no precedent, but your suggestion seems reasonable to me, thanks.

  Maciej
