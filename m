Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB66336818
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhCJXu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbhCJXuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:50:55 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FABDC061574;
        Wed, 10 Mar 2021 15:50:55 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id b8so18231489oti.7;
        Wed, 10 Mar 2021 15:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MWvqhNV4JfDa4XVfwoSOowOHKfIFuSZIQxmsbkzwWOQ=;
        b=stmvkg9C4wahxNXx8YbhOlBvKiiv6GdFAvW+2G09xalREWjBzwp1fo5CWfSbvVsR1m
         519vPbNXlqKyz52aqbc1iiQ0suADXO27TtjKsMwdCgU6IKXY6pebAL+OcND8uI3tGdRB
         AUnx9oNf0YODNmvn3VASa6I19lWWtZhxfGprHALuCHRhBu+JdJWxB0ppLBvT9sc34uAf
         cX6yyJE/IueYmJWNHfXbCDhzom8oI51QYC40UN1LLhjXszHhG4koBeCrGAxk+aZXaV/G
         GsxsDZ/KzyWX4nYainVpp5gRzp5CeLZpt7LmVIOqFtv0PuB8UBukI0kqmHSvzEHlzTCU
         KpaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MWvqhNV4JfDa4XVfwoSOowOHKfIFuSZIQxmsbkzwWOQ=;
        b=cfrZjuf44rJmRymiPk3y8wPiWOvXz5s0hy3jqoKqw8h7ShLGiUpEVyrHUXsExq5gIf
         N2Dy1Cb4oIgX48bIJKCzZzfIlQl6ZCgLpQwloHmetAkoQkBLgF+A1A3uGElm1EUE+8xa
         6abvs6DIxQK9Hq5GWp7FwRHiAskpQDyNcT4q+yB7xpyZU6xiLwGSQ3X79WifBGfqleLW
         3+YUYZ6vE8R8/FarwG2ADAzuEQAONRtoJz+oX8xdBHS4KpXaqsybCv/7m5QGEsyixscE
         6mifdl/p0VJsCqLsdzvKlreApFKOro6/mn6qtPqBUh5s/zsTtJQ5/vi/XMKjDFKgqEQE
         2V5Q==
X-Gm-Message-State: AOAM533/r9+Fw2W3b2cEYxwU2XqITMdXStlqO1ufB7LDmRMXAie6zdF5
        afPQzV/BKy6oqjZts716+MU=
X-Google-Smtp-Source: ABdhPJyO/mwyyxPDS3WfwX80asI5QJcbPBQk8mHqFDBeK90Vv2rTSj3UMo5HlBZfRfB5YA0zKPvdYA==
X-Received: by 2002:a9d:2d8a:: with SMTP id g10mr4647338otb.212.1615420254947;
        Wed, 10 Mar 2021 15:50:54 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a185sm212065oif.49.2021.03.10.15.50.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:50:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:50:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/11] 4.9.261-rc1 review
Message-ID: <20210310235053.GB195769@roeck-us.net>
References: <20210310132320.393957501@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:59PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.9.261 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
