Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301043015EF
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbhAWOes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAWOes (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:34:48 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57FBC0613D6;
        Sat, 23 Jan 2021 06:34:07 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id w8so9565746oie.2;
        Sat, 23 Jan 2021 06:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r0ekf1v7CuqihpJXJBKvBn17OqnAYehEM5oob28FlSo=;
        b=lLv9v/SzanJV4jYXvip6IgtWGPCGOvjY7HJdmXc6yhfnMEplY3kEmeLCielwc9o7US
         FRbOtCiYwo80yNNBv8Own2xu5NtQWwSXsMJ+WUYK1i/bnVvjqR5E0aGxuMMOxrqVNXDZ
         NTj8u7GeX5sgDd8yq5roTKkSvMT4pGjq/1dVGTAeph73HvPWC7Lp55cf2CSPDKE6WUiv
         ftvYm0nvL8gFxypGFrevaQ6/OUQ260OqIF015bma/2Uwrs/Ph2MBBxVHXyPSVmmvTgYG
         6/tRBoPDwIRt7EO+ZG62G6pRBcjD27TI5ugo2zH9kpH/pW8/f8PSDPH6WvfhU2qy6x2E
         mBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=r0ekf1v7CuqihpJXJBKvBn17OqnAYehEM5oob28FlSo=;
        b=ADyW/CzyPpqhB52IHWOPz5miIOM99gVR0ycIJrlJrjV9V8T0mK6Vl4rtVmCUSswrm0
         uBm+iiJhU9sgmn3Gw/3nZwOy8HXF+4Uy8n6HwrNIVsv1P8DY7oFjfroZ2+4agJvA/2Zm
         w9fPOsvgApYLMcSspWqu4gk0UdiRdCiRHGBywESCHykKfVGbUsOWzq9whK4wNzQtTZ8w
         DPMGJCrWkOf8rFHzBSafTYwx1nya8TccMfgtMKZY6OReHbEc7s5aE9LJHKiT9YLkDXcz
         e2lIknIUd1+xgeiX4ackQ0Wlgh1KqMVUG4txSWg7WgYBNyzYi0ZsCsMIoNHmrQFxu/3T
         y9hg==
X-Gm-Message-State: AOAM530YhL9oPqy7/kU79mTWKu3RRapEb9k7znrmIYCXTG3VodoakC/u
        J19xsme1N+KuObeB6YpZuBU=
X-Google-Smtp-Source: ABdhPJz/7H5MAD8N8ucQTdB9K/HqmLBxENjyHbQ6/qk36T7DrBlxMEDx7yeQ6HVn8o4rI+CAv0WEkQ==
X-Received: by 2002:aca:f157:: with SMTP id p84mr6323863oih.98.1611412447252;
        Sat, 23 Jan 2021 06:34:07 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11sm2325181otg.58.2021.01.23.06.34.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:34:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:34:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/33] 4.9.253-rc2 review
Message-ID: <20210123143405.GB87927@roeck-us.net>
References: <20210122160829.171484729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122160829.171484729@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 05:09:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.253 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
