Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E110632571E
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhBYTyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbhBYTw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:52:56 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35000C061788;
        Thu, 25 Feb 2021 11:52:16 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id f33so6859073otf.11;
        Thu, 25 Feb 2021 11:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rk5HW1orvt7qTGw9mY4nhMM94K4YBQOzj5Gj2JYqfE8=;
        b=Mp0FoEU1E+/9sTaTqPx6kEnU93Pg36vyoQSgdahxGGAu/cNoKn30i4arneIozTYIKK
         LbNMmKRv4mIQrSr2qSC4HeG8TvknefiATxKsjgX+T99jZIUpoi3vAPBI3TIT+yfs1nEh
         74zF2yVO7UL/5b/SbB11iFVAZUvDnNwIuvKyI0vKdMHBkA2nwhZ7N8xicTq9BglszN3m
         +S5czp4xjfSnla04wl3qvkzAbeQzpO5GRrSJ6d9RnngsHsDxIwNZbyQxBiHP71jBFaNT
         LsR0NVwJIXUewXUU/9aBJVaUa+0wMPoK1Wzbzq5dV4569XSyJmNl1Hp8DZXgVqtWhMR3
         +IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Rk5HW1orvt7qTGw9mY4nhMM94K4YBQOzj5Gj2JYqfE8=;
        b=GAqJgHw6ukGgLl1hb3P2e+SQzBPxPHMJMObdzH8dVtmmo532QiyM4brwXL0st+aj35
         bG2DIGmNwBRYFlBRXWGI6uHfSTKbdTOGf+FPOLWrHguhlEv7mk+hrGDm4ZxqTgz6/sro
         6x+oXqOQFSzBl5lIJ8XmPv4+ENJCi0nq5o7huDSq0M8KdllexgpP9NVbRZC94KWkQvdr
         yNb0MQRcBvZegChYD2PU0wzu53Z2QTjvJcjYIXD3FFKIZHUgpsXrYey2mef+JjSrR3Av
         jWjcYi4JsWJ0676CzFRKT1pEwt8WDGAq+WjM2Gq/TLIbr3PzlnTicEjfgRZ0U1UwaoWc
         Y3XQ==
X-Gm-Message-State: AOAM530ElPBfSrpD/1RuZTdciqK2PaWaMZd+F/a5lp3BNS6f3Aim8vWZ
        dKbRof7lkVejjHyg4QpFUtk=
X-Google-Smtp-Source: ABdhPJwi2vzP0bqfFvsuz5k7XXQMscU9Ib4LLi6d9b8EMBglfOi4sYRJXwRnoLS9+CoHloIpcryDIw==
X-Received: by 2002:a9d:6358:: with SMTP id y24mr3532009otk.229.1614282735612;
        Thu, 25 Feb 2021 11:52:15 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l11sm453748otd.16.2021.02.25.11.52.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Feb 2021 11:52:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Feb 2021 11:52:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
Message-ID: <20210225195213.GB107964@roeck-us.net>
References: <20210225092516.531932232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
