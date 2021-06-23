Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8E3B1178
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 03:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFWB6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 21:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWB6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 21:58:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DAAC061756
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:56:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v12so290454plo.10
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QUgqHd3BhenUMFEp8uIHcWEBQTypPvwjrw3nOmO+ZYY=;
        b=JLn2NWbSgG2Hw0aOhvMbDLrM5/jRQpLTEzBGsif13QRps7I1MR+P60oY+8eP831ERw
         VsehXLImLWBxRUcEKy1ZnaumttU4lNxeBb6zlsfhj0VGPKlVRQ/aQGqk974NzHzcCnL8
         oOSrkzaGVKxAVDlg5GBcjr0jnthjVU7aYVdWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QUgqHd3BhenUMFEp8uIHcWEBQTypPvwjrw3nOmO+ZYY=;
        b=aMOX+mci5rnJPHJDtDm1RywyrtJ6j5eijNDlFmGRtKla/91i3iWYqXSsSMFwakVh8M
         xCE4rqy/2VLgc60zE4zUCJja+pudH/6pCsB0JsxSyaRYZzqs5XGDkiPQLu9RxFf6fjDb
         F2hV78STbhVNJPXxlJ3plzfn1wsQ5oIdsyr6ZS5WnBgwhxbqbZvYu4YUUGVNoQm0Om2g
         XKwaKdKgjnPR84Upv3U32Q++5t9tmc9jFWnm/4F1jWsRKV754SoXNqtq4pyA0trABBIz
         cxyGn3EibHrNYyPVOhKCO+EEn1XmmtDILlGHO3JusRN43D6tOgTX3O3jh02oJ4pVYcPg
         /HZg==
X-Gm-Message-State: AOAM53262sgR0XGUW3gh+2FxpieXjYnRfPH7tpz4yLsmOA1ndhGZFf0Z
        AeRIs50yYgVpq5mB6k729Nrg1g==
X-Google-Smtp-Source: ABdhPJy/m1eLeZLttRYlCJ0FZ6WVsv2nrTskS/2gbAxk5Jj1pP+6EDA/Yk13RUaUk7nBLXYcxzr2rw==
X-Received: by 2002:a17:902:8541:b029:11d:15db:46a3 with SMTP id d1-20020a1709028541b029011d15db46a3mr25563033plo.41.1624413379602;
        Tue, 22 Jun 2021 18:56:19 -0700 (PDT)
Received: from c8bead504505 ([124.170.38.181])
        by smtp.gmail.com with ESMTPSA id z3sm500738pfa.67.2021.06.22.18.56.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jun 2021 18:56:19 -0700 (PDT)
Date:   Wed, 23 Jun 2021 01:56:12 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
Message-ID: <20210623015608.GA677700@c8bead504505>
References: <20210621154911.244649123@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:13:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.

Tested ok on:
- Tanix TX6 arm64 (Allwinner H6)

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
