Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649422F2241
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAKVyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731421AbhAKVyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 16:54:11 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E5BC061794;
        Mon, 11 Jan 2021 13:53:31 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id l207so203423oib.4;
        Mon, 11 Jan 2021 13:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4xqlBLylXXcc7GWOAV0fUa2LI7S/Z5itvHZJ9rGz7oI=;
        b=mHEa5cwJ7g3oTm7sN3bjrupc2gtU4HLs6XAeDu+Uqb5DZ+BnlXU+atWoP5EmwVEvbA
         RWuyWSvRvHwskSN3zh+xgxUbhZ/eHMBmOLItyop1WMnRqmww5NntMbTwdSE5ig+rZHPS
         4es7POCIa1n21uZSdCjQp9Ew4BowtT/6zywFYoBV/cOWbR8xce3REHrj/Y95UOnJxAFo
         2fs/twLDmEAMC+lODFboHaoE8RhWO+zXizSjr2qMZB7cxdcoJK7HJ/zNRUbMaQrvXdod
         EZXGAnWuGPFMHn7+YA/6tbagMnvr49H4hE0E8p3wZ66AdhCu1dD1LT8CMp9SDq88zGF0
         HMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4xqlBLylXXcc7GWOAV0fUa2LI7S/Z5itvHZJ9rGz7oI=;
        b=FUmTrWDsZhwURGfRyF/i4PcbmPN6f4rBGgjIWgEzYUrtSgIm5nim3AKCO7L5vYLeRE
         AlMWKjJbjvSEPX9F3KJqG1N6gGDKf5oEFnxnwakQ3XOLovaZYnRrIbQWx1Dy34bgy2/Y
         9n0xmYCmxB3Y0vqe4s8ksOyouw/qdwt0lJg38b7B1NUIzEbqXHgv1XRv9xbD8fmROXI2
         KmdqOlGYbftMXzuPctJJhNJ78addaj9UnoshY6FagNUZxGPZo9u8cxj53483kMNFBlXn
         e7DWnILJpujHr76OzNAJr8HuZLjSPn4TcH5zU9BxsREmcndq3e+6POy/o7qFKlz9bcdk
         PVgQ==
X-Gm-Message-State: AOAM533+mZuYRAC5Ice2tyY+Ccx+qX6CXZpEHaojpp4BBSwY7NZsV0y3
        /Lm5Ok2dlUOqtGytNPFDtBB/2HRVR4g=
X-Google-Smtp-Source: ABdhPJwe8PP2Ag9dk67YvgwelC12EqeTtqBgoKHu6Ux6BzFEVGkRCEgerzrJzuRmqvlRqIrjZqAElw==
X-Received: by 2002:aca:3306:: with SMTP id z6mr487398oiz.141.1610402010575;
        Mon, 11 Jan 2021 13:53:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d16sm214877otk.74.2021.01.11.13.53.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 13:53:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 13:53:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/77] 4.19.167-rc1 review
Message-ID: <20210111215328.GD56906@roeck-us.net>
References: <20210111130036.414620026@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:01:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.167 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
