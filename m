Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFA390B40
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhEYVYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhEYVYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:24:47 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F119EC061574;
        Tue, 25 May 2021 14:23:15 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 80-20020a9d08560000b0290333e9d2b247so19434854oty.7;
        Tue, 25 May 2021 14:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vxXRldl+jwBtgqp6CP+E6wMj44laAt/Jamj98qIWOqs=;
        b=ee5kFuDbIMuHMxpSEuZzSwMDL+G4QEOZRPpUu3Gt2etWW+Ppt8NBCiHvoLJRAQ80La
         ZoO2M+lcbQceZ7VM6qw9BTh4CEhTOX6m3QDUxmdr7kfxwoioJSzLs6490vFUr8seKabZ
         qth5OLgYW0F262fIzIeH9DSRyfLGAzTlSDufcEEghrS93nZXlyFP7GqngzDQsEIfSdmQ
         A7Jv+3M1UguQcW6FfYtPOtAMMIhQC0cuH6mCxRbUNWxGBzhtzYlwJGCvUHjVcqt0jPAE
         Syqhv+exre6fyOm+XmCRdar/trMOVgNQr+PtoKQe356xXbnmUigA1mTEx3plz4qhQ3Cj
         NAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vxXRldl+jwBtgqp6CP+E6wMj44laAt/Jamj98qIWOqs=;
        b=fZ/DUWaVH2MXNf0l3bJlqHmG/n2kDx8agrQDVYadtk6EvmPQLO2wO4OeLeaIJW/qLY
         ILcI08QE7DlSqBcjoD8t8YqkmzayW0DD2oAVlHUi1H3pYA+hVB3mwSh7xEqgBFryekDA
         S9YYS1qS2sdU3PdBgZkoUHNDE9V6aBWuTZ/OB37lt6jIGSXlBuaF1bupJ+pYdrhhKmAz
         t7tUh+STGGMOqJOdrmDIK/JKup6JSH6XHQ5igLje5ZPENx6/+CbngaXM4YtX3YWQ/8et
         quq824RM1IWK2mvzKkmONfz01x8SFyiJ9A/rg4Uz7iu7kRrRpr+EnLHymkc83C1TVThQ
         X7EQ==
X-Gm-Message-State: AOAM5330NNrdAukSQUpexmVyXjDKnNRmxOBoj4kjxrbUbx4nhDA6VeAz
        xlxwWUbQsH55NVAbY1DL8t0=
X-Google-Smtp-Source: ABdhPJyBOlKIulL+qVzGWr7RMurzKnsQvxfy8c0VIDpldQnl9+rAvTuHrgfYNg6Hy3WwTmz1/g0dAQ==
X-Received: by 2002:a9d:7747:: with SMTP id t7mr24902283otl.96.1621977795351;
        Tue, 25 May 2021 14:23:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m1sm481990otq.12.2021.05.25.14.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:23:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:23:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/37] 4.14.234-rc1 review
Message-ID: <20210525212313.GC921026@roeck-us.net>
References: <20210524152324.199089755@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.234 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
