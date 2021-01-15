Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EF12F878C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbhAOVUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAOVUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:20:17 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0A1C0613C1;
        Fri, 15 Jan 2021 13:19:37 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id r9so9896715otk.11;
        Fri, 15 Jan 2021 13:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y37ypfgDbhV/ir2mCVD893LqvpKeASpEP6BGqwHK0i0=;
        b=MKb/EUvLlqaW3aq5LxgKySbus7pidYn8ykfFilqQbKUL5G9WtdM3JQDySrz3CZSCeA
         VDCTQsMmB6/RA11EkpfotVKcjgx1LJiPunOlBurBdpcUhx01wD7H8KRju6NvfS2ZZO5R
         LEWQsTiIxo9j68L543JE6QBUNZWBmcAy3uUqnW1YiGko6ew0DMpVEMqQMlZcBljui+gn
         kIBYFzHZ8wh/1blSVNIBgae1FdAs1qrJpNmPSL0a1iZ2Y8gfhMWFh6bFFZIr2Q7Jep9h
         +DH4I/gO4oZvEPQbOfnF962APYRyubAXdwbyp+UnZrPJjxLMvAFgl+R3i2cBaNfNQHtu
         7GXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y37ypfgDbhV/ir2mCVD893LqvpKeASpEP6BGqwHK0i0=;
        b=kIWrYlUJdvVSjWCqUmVfNwiLUKekpWc+F7RCU990ZMJqWubIEQY9XtR4OwLWQpC0Um
         xyKq/M1rj4rRRFs9/V2Om5WjJXGIGMV0b2J+iuxC9PqVxY3WSGC2yuCgu8WWDugsq6cQ
         0scxnPsAcJY4LMMQmh9VImF6aYF/aAjQtE+60tzWJx21eeyWH3h3HVjYJ5N16GqrUYol
         VtOXvcUBgrBjKNxx+HhEzPrkvNsGrRKV3ecUP2RuA3ct17UTbg6u30rakmikIR13pc4h
         FXTgPhW7KWPmthR1ISByQeuwCRiRhKdumx1dpXPWrILRY2lHac5IBiM93Q80gKZwEi/o
         TAdw==
X-Gm-Message-State: AOAM5334t3l8S7MlKEoVWBTYUQIqDKXg9XQZS7qM7hgclvnPzyc+hOnv
        FOpBrk4nGpKOTJInR9Vafx9x6Gm9r5E=
X-Google-Smtp-Source: ABdhPJyx4IGqwOgE5CYxhaKd0wivIBYJRf0PsyQpxF803mM9E9XPjPuckSdq9uK+pc8Tr8PBfBmoHA==
X-Received: by 2002:a9d:2021:: with SMTP id n30mr9928700ota.350.1610745577106;
        Fri, 15 Jan 2021 13:19:37 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o135sm2024237ooo.38.2021.01.15.13.19.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:19:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:19:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <20210115211933.GF128727@roeck-us.net>
References: <20210115122006.047132306@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:26:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.8 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
