Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D2E311E8E
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 17:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhBFQCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 11:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBFQCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 11:02:18 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8FFC061756;
        Sat,  6 Feb 2021 08:01:38 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id j25so10980341oii.0;
        Sat, 06 Feb 2021 08:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1UkZXRhm/9xbgALFk2A7Z24DJ4uio96CVLSvBNbYVwU=;
        b=kk6pmswS5Nh25jVPkXjrhGjVTGJ6wqEoFRhpqbxPOpULQTMQQKh8NS5HKt3uTfwq6l
         koJ/blxDJpuLSchGO3PF5HHkL/g5mSk3grpvtVhCTpvnNhsppawiowIAiMdeO1BrPzEr
         lgpxUDLVcFkNN71RZ+8Frm198d3w3tOhjeWuA82StTfLyUtOjSGWOrSYbTXa150AJ6w6
         55/f35bzjgP/QbAd6M2TpJO44GYKC4pszd+ScaItIXIgLXKBL8PhNzcqP7Q+sWEFUfFk
         WzVWzamcPeHQWe7beCRQ4LHo8EUIetljafYi5galipfFDt4hiwc8IPhV9ly0yBDqRO/d
         SS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1UkZXRhm/9xbgALFk2A7Z24DJ4uio96CVLSvBNbYVwU=;
        b=Knrl8pw+jkEjfiDQe3/OKKXzc/wauy1OX6IPqCU429eaNsePbKRR4mN1CJVv4Jvy7X
         ibc8RrYfhOjQjA6AxINd7B7tqQM978g3InzPz/tHu6aI/5U1rywqz6yUAnRKvYjdrca/
         KZtgglPu07GKSGylUdVJZ81ts5d+Z14i3tZpTiL78Xx3Ls0Hxe/r5kDtXKe++qtRVg+J
         TUmtU+tKA3WMRFuCTfZD85DjaNv7Eqvtcd1oHlNM3F10AtI/z44Up1FJJvtKnYdkk/Ms
         wDvA2iDln8TfPNQYUepuf0I/lf6hRsDOmLA34GJhbrjR92ySEMT6DQpR0Rgro65tc2WX
         4VrA==
X-Gm-Message-State: AOAM531MdT0uM+5QpubEQZXi6keYbglc223qwvjr+wW2osHUF4K9YXpX
        baahMf8iwOjNDnQwVz/knHQlts7NJrg=
X-Google-Smtp-Source: ABdhPJwzYHXI1YGI4V/RV4VqPX4WKrY8kqMjlEbgHoGO1yfEpUniP3sHomEwHZtK/waX3YP6mzoxlg==
X-Received: by 2002:aca:5bc1:: with SMTP id p184mr6273783oib.155.1612627297827;
        Sat, 06 Feb 2021 08:01:37 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t19sm1561012otr.64.2021.02.06.08.01.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 08:01:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Feb 2021 08:01:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/17] 4.19.174-rc1 review
Message-ID: <20210206160135.GB175716@roeck-us.net>
References: <20210205140649.825180779@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:07:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.174 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
