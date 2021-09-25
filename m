Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F8F4184C0
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhIYVuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:50:07 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D756C061570;
        Sat, 25 Sep 2021 14:48:32 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so11580286otv.4;
        Sat, 25 Sep 2021 14:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/MuygwMx1OxZ//C3TbLDIOhlkRzNNcuhghQLB3V0eI=;
        b=cegK+gJCM0zu1D5Uh1oTGsJpqnvdvzr0qfLJiCdBva+ToYg1wiMw6RjJNreAg4Lyl1
         EHcc5d3bigbm2a7u2xbwD8hFurGrzNmDwiGVE+o5irWKAIcqHIHAvrDnRd2IA5gzXUNp
         6yXJQ2U1Gothk9CNAPW5S2MOLN/RJ8azYTOX85KYzr4Eg49h1dXFiPSjSTTFbQdOatNu
         o08fP/bc99eqlVFBuUHqMOWql9RS4e6QSlis3LSjH6wSk28adCmZIh7mKWoUvSVfJnaY
         eYi2B8/qph4Xt26yjx28FV/RD1YKxPrhHPk5wIgsNsJFq5a+JEM3Y0mBK1231jx42d86
         Dm6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=l/MuygwMx1OxZ//C3TbLDIOhlkRzNNcuhghQLB3V0eI=;
        b=uTyzDW9HnU1vmxFoN5B8T1DkLP6/jM4mkF6ohbcY1+vShq9JvZTM30hT8nNcRnn51a
         Bcwrp3xP93VTFJiDr10c08739nulEQEjjcVWt9QXJ1VWWONcjCBET9e/mnbEWF6wXFEn
         PveoKVofoBdjXncYXGnPFcQ7XuRBCUr1oWPK/8TsXAVegMGLvL9VopARcwwfdoJkMRwy
         lNyQ0hREaPVFF9OC3A8+0NdnsTAjBPkc1atNU3+JgQe9Lj5P8AEkqrE1GxlYuMDIiNTY
         mPBPyWnhvVSANruO0qnbTL1zuAv9aUVAxvW1Ja2ueLLhDzwfocqzGjx0izjfKwHqCGEe
         xrLA==
X-Gm-Message-State: AOAM533dnZ5q6XIRm+wYPPadwXyxjsghNePp0nMFQXwitAgnmhEt3iRH
        ZRpVij/SQwcppLBNuMQDWcbOwYQLROw=
X-Google-Smtp-Source: ABdhPJzIo4zpjuOGtQjq8tikWKonVZIREceAD85JuHjiLJDLRYAxW0Sqy6eSBME2MiBvBIS3Q51FzQ==
X-Received: by 2002:a9d:184:: with SMTP id e4mr3176917ote.209.1632606511634;
        Sat, 25 Sep 2021 14:48:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v1sm3260879ots.46.2021.09.25.14.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:48:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:48:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/26] 4.14.248-rc2 review
Message-ID: <20210925214829.GC563939@roeck-us.net>
References: <20210925120745.079749171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120745.079749171@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:13:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.248 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
