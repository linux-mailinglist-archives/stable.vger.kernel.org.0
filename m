Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35AC35D2E5
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 00:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbhDLWIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 18:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbhDLWIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 18:08:54 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65A8C061574;
        Mon, 12 Apr 2021 15:08:35 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id k25so15030826oic.4;
        Mon, 12 Apr 2021 15:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LO2TGBHXas1iDiXMBTZ94KDDGXgAdJmH/NPuH5OoAA4=;
        b=UofG9adk8NUssqbTs6zHTQlkMpGgOMy7P5GKI2FVNxxBzSkDdQwoo1vLzsr9/2VWov
         QWzif5lEhI/twtqEaNFPZQbmmSz04+4atk7r7wfOcvD6Rk2AbvKAitugAik8Ra30T3Dw
         tCI538i4D/tPCUvuiC9zuU6I4FM/4MevwFWca+MY5chi5iDB0V8qG0iVk+kumy5VOGsz
         FaNVtIo+BmgQuNherX1TXmSot42vknzAeI0oI2kSuN6YHwGhb5j6sVOuas167Ra6XyOr
         1JHeH7MqF8bjltuefRDH81hFZa6+UJmeq99P2OdacVVq9i86Sp4TFMnUjgkxMV9MxMmM
         movQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LO2TGBHXas1iDiXMBTZ94KDDGXgAdJmH/NPuH5OoAA4=;
        b=nixWFvEjpNNcY3iyPlcSO7qo3DthOOZUvfg/cVCS6tkGWBrxDPd32JX6KnigyaEm2P
         XiMZ8Js73UtTsV/gvO0pfTIi1w1CNfscPlv95SNzPJWIDqMDRsxs4DcoJ4+g63hPX4UD
         7Yxvqy4iKOZUIq0ncisrPTg/H5+I+jByeC5LLXlY8TXv9edPDaUwXDcA47Zk4Z6zEXxb
         kwXotPFx9jETsWdXQ8roqkJXwdnans8VcpO6qhQq8A7mci7MWCal2tCn7mw19+p82zsh
         owRPzLzCwN9erzrmye6XcpSwDqh7du7qaOlBqd59htZu4oSxdAXhiIabvTSr5by6x+n2
         am8w==
X-Gm-Message-State: AOAM530GV2RZarq65hn6U4YnEmFF/XOUAUpn3SlLjnJYJhXEoWtQvQtj
        l1eGtp2tyQeRJLmql6TXOVU=
X-Google-Smtp-Source: ABdhPJxb4XtdODHyRZuWKpxkzoAUvWaMdWV8aKQfJtarrtPJ8d0Zx4/VT60STGT0h+5Jma1pFSDkKQ==
X-Received: by 2002:aca:de06:: with SMTP id v6mr976470oig.91.1618265315396;
        Mon, 12 Apr 2021 15:08:35 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 68sm2932591otc.54.2021.04.12.15.08.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Apr 2021 15:08:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Apr 2021 15:08:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/111] 5.4.112-rc1 review
Message-ID: <20210412220833.GB182151@roeck-us.net>
References: <20210412084004.200986670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:39:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.112 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 432 pass: 432 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
