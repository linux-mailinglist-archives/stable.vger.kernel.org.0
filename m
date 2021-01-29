Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B462308C51
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhA2SWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhA2SWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:22:03 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC3C061573;
        Fri, 29 Jan 2021 10:21:23 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id n42so9471613ota.12;
        Fri, 29 Jan 2021 10:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5X4YtgBMEVEyv03v8P1B3WP13UY1i1jA62TKIIbtiEk=;
        b=RfynpvdU/CwN3netvDIyiAxrLWWCDEjf7MaIi2MFCXUKBJDXtqFFvjwmaHbLoE9gSO
         R7kiv71LcUvUlOii5yfPfCURa9qjrXhiTot2TSB5UmTxc/YLTpCOyjA1hS9fT2AXMnTy
         8l7OoEpXpebUc1pa31vFPV7+QqodDst96SKwJALuMp/GGYW821CG84OGRqlSEvZRDxrQ
         8Gt3Dhja6pJTRj2y1lRapuQt9eF1uRN444STu4ka06CC41EHZIdaCRg1x1KnKiGYAWiF
         Bk1rkkL1GvuEjyv9SA58wuP9dTw0Dc3eJaOkZsi4ND85JRfkaHy7437+Ooj9+YsI2Gta
         +dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5X4YtgBMEVEyv03v8P1B3WP13UY1i1jA62TKIIbtiEk=;
        b=GHVT2OcBIVhHoOYlg/fJF6tOUSZzvZoPyJyXN8J+gu4nNXH9O6WGF7br1M4OioZuxF
         kiaYcBpfa5Ca7WwbYMY3tlirn0JyjUvGB7EWVzREowr8OdCes56C+AuIIsLSyOgKpfBP
         JPCIS/XBAISvwv5oo31oZGhhJ8CBxoWLZt03D5BeLVDoBHT2OO8D59QcKeZbXuLn5jmt
         0ly7FW4E8pMJr9k0FyVEqpDWou0q9xoxRC24b1sIsIqb88A0Jt/1QxIHwjBYF7dgr/TZ
         9aoVl6BjWe8xqi2Pt6MStHY2L6ZoqfsmjAhoclK9oup2xApjBreY9eFqYibjsatfyMmO
         IXaQ==
X-Gm-Message-State: AOAM531Tu2Rn1Gy8FnDqqbXfnyR8S6NYqrCXU7TWfRtBg0ZtDxc4mI0U
        VF41eRUDnOhrDZcYx0Jz94ItW0xO7VQ=
X-Google-Smtp-Source: ABdhPJzU/+FFKfWFyYL+Tl1vfcxKMv0azJPIPCg45bh87uejs+s4XCkVFC1CrkBuKB+8O1hlAtutiA==
X-Received: by 2002:a9d:61d0:: with SMTP id h16mr3574991otk.1.1611944483055;
        Fri, 29 Jan 2021 10:21:23 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a8sm1981296otk.52.2021.01.29.10.21.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:21:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:21:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/24] 4.4.254-rc1 review
Message-ID: <20210129182120.GA146143@roeck-us.net>
References: <20210129105909.630107942@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105909.630107942@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:06:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.254 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
