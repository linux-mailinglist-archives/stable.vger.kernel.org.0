Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFEE3D41F5
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 23:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhGWU1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhGWU1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 16:27:09 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C8C061575;
        Fri, 23 Jul 2021 14:07:41 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id a19so3241494oiw.6;
        Fri, 23 Jul 2021 14:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0p2DIY+MNQy4T/2J4ZLCY4VykTCysEMXoPkouFw5xWY=;
        b=Zl/PhSOkZAWPk2w3S3LwNjTxld7f0Ct5CY7KkxzjTn9l7p1LjQ8yiuy0hw4MytVWW7
         YjGbwULsNPqvs+0JLIlkxZSlRV7wISYslcC4zp5chs/6gnWQ4zs91QTOCccGFHWEqB9w
         BPBxj31Qvu20hDad1Y0U23WeTbnk6ZUDM5WqO8sBySWAw35TFJFv87hQ9O8yBC1MI92z
         rHGyGYhbQ6aHqpSBAfHWwszbLMtCvuYi5RFM0hPhqibARDLBAdpbkNw13LXt+XUwtQCO
         lpWSd2ngZTRAYFGzBQQuIzQtP7WV0KWSmXyrRhselk9pdeGSNMEBA+J0KIpEx1fz4WPv
         ah3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0p2DIY+MNQy4T/2J4ZLCY4VykTCysEMXoPkouFw5xWY=;
        b=TdLkUyzxhh/H+uG1KHZ31poyDXgznlUEo+UZBgqmyWWmKiQN8GnMiY5AfgQZ7/+bdj
         chUZyFxbQRgefw7rOoyNn2Nk1jrxnN+P3H5M1tvzvz4eb8cAqIomrS03+axepjq5s+1z
         7OVp0o8qW0lyRXV7JGf4QemN2gabONTjGdgqSESyv0SLvMSw1sGBOG4Wh1vwzibF97zc
         KnmSgbmxDq7b88jvpeuLdoJHcfdX1wJsbXCKjNvkBj/rmkTgVNIEVfJ4GGDljdtpsBkA
         Fgzzu8FJffHskTG+iUB7c7DjbT5MlQCJzlTs2TtAwXAzcusCJ3A36xuTcxgsdCM8G7V0
         usJQ==
X-Gm-Message-State: AOAM533lO+rfiOTCjobH+R1Y+o+3O2TLPizDzcKVfCANOyCmzKGgavM0
        qCgcBvW4Y2F4jwGBSt3lLihx1z2oNvU=
X-Google-Smtp-Source: ABdhPJzhT559kUZw/fJuqzfOHzpz6wYrmbyiajdkYVS5c39fzEUhLB93L0aqsQa0BLK6hRCUUrTIkw==
X-Received: by 2002:a05:6808:bc2:: with SMTP id o2mr9663727oik.163.1627074461269;
        Fri, 23 Jul 2021 14:07:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v5sm4563850ota.33.2021.07.23.14.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:07:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 23 Jul 2021 14:07:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.135-rc1 review
Message-ID: <20210723210739.GA3652778@roeck-us.net>
References: <20210722155617.865866034@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 06:30:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.135 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 434 pass: 434 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
