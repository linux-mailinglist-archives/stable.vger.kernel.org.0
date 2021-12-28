Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7BC480BCC
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhL1RGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbhL1RF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:05:57 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B8EC061574;
        Tue, 28 Dec 2021 09:05:57 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id v6so30845842oib.13;
        Tue, 28 Dec 2021 09:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=984Yp+oPs0dMYomhuGNX/Wi7YNGEXYayPNbMHSKuxJo=;
        b=eyj0ZrCsTbwwygvCQZ/+mSH1rEgTTp6mCYYvMN10V/dKR22X1v/fZANNc1qSS81rjE
         AE9Zkq47Bdwqs6CDYVuNv98M3YWj0VY3jzuXNAEk6HTqwHheo3K0T5vpd296X4QOfwEw
         oc1/L9Tbqq4Ba51WUD96OfU5JxiHTWrx75lbJMAwuCYdLfb6Lzb0aHIiYoO2fCN65MH/
         1ySD8+cN3y3CM2H4ptEqiyV3A9swv7ytZzE+46krIK4HOijLKykNARlglWoFUOJHjFsB
         Z5m7YUbWOhC8a/WRKpl1Q0pz4z475rVA/10JuCeMuEgxfXzbLo/17S/zmGR3X8qd0aQ+
         T5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=984Yp+oPs0dMYomhuGNX/Wi7YNGEXYayPNbMHSKuxJo=;
        b=KtP32Pxu+WdMJ+5iaqZAucAo8MFKFBZyScaSFZT+9s9zJf0F7V7SL3u3dMNhb79zMx
         aUJ6jDU0ekbmtlWDzvgSPjmNEtFyRPGuNeE8PxChn/SGrNcKFwwN+JNl+BRxrbwQrsXZ
         dU1GpHomlf6G0JaCDGk7rLMBaWsWjCDHHMM/WxYvalXuEpD9w/NER2T5p48hTes6mtxv
         KRLYk3FjXJA5821kboFHtEJ4nXujQKLanibu0Qxcjg2Kg9rtuYguSAskTuB3EEeMlbP3
         JU0e6M60R4ls7utCTEhU1sV8zxAQT5CSYOQX4K1OmFhLJTFgt+7YXqeDaHByaiWiKTup
         6kcg==
X-Gm-Message-State: AOAM530HL0xGS5M3Cb4IXBQCXdQXw8aNLt2SHpU6zWqLiupDlypmn4Wd
        nd1Kxxs92kbPsmL4JyNDvm4=
X-Google-Smtp-Source: ABdhPJzZdDQsJrYu0GtwDgUT9zW15EtdPqn4jZvTbQHiiTb12rbkkpwOuscdCKtSMw2J5hUGw9TyAQ==
X-Received: by 2002:aca:dbd5:: with SMTP id s204mr17390851oig.41.1640711156428;
        Tue, 28 Dec 2021 09:05:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c10sm3481680ots.73.2021.12.28.09.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:05:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:05:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/29] 4.14.260-rc1 review
Message-ID: <20211228170554.GC1225572@roeck-us.net>
References: <20211227151318.475251079@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:27:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.260 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
