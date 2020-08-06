Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35523E191
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgHFS5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFS5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 14:57:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524CC061574;
        Thu,  6 Aug 2020 11:57:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z5so27441042pgb.6;
        Thu, 06 Aug 2020 11:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DwIlrm4KeYXep1s/nhu6ARBSRIT9ZUr5qPcPvKHgUGE=;
        b=gYvlTb0bnTmljcVxmLKCpgueHPLJ8ks7DKVKGpalKhxLaSVY9Bwk47RCnn7O6VHc5M
         2QjbGXtQ4SYLWU+/B/J+HEkjtf/lLI9pJcUwrBDQ8p6WBWvqzPcDiLF7xBgFna6otOna
         0WThzcR9bnNk8VLu2sdn0Wlh79VmNfa6o44lQc0RfqY2xXPWiw4zcRlvq6q+cGXTRrAA
         kJAihe04SNvzmpY/FwMr6JbcIe3ME11zdJrvw4oVDXlSGOOlKSkbg/kwMpYrRL5Ej8mR
         Zx8NZI4uZ5XR8R0+/CLXm6+GsLoufjtzmOQk3ROnwnT9o2nYr9pzXgK5a/dPXO5WKlha
         yIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DwIlrm4KeYXep1s/nhu6ARBSRIT9ZUr5qPcPvKHgUGE=;
        b=BO7YxyIgAJA7YkeQV8VyLYmBA2PeuROKwubpFWH0yz4Go3+OZU33m0GN5bfwfg7z9H
         LkRWBesS7REWO15LZZcune0DVNnqIqdAFV4TDoBvsgAhi/+wzwFhmMjqrD9+AA+oWrUh
         k48kyfPCHpiqPDOgDMONPZIFyR8vuJOVHRXJXIGAg7NrW6JJpcW38elhjTI4efWGNZKI
         dqxWva3IQa+Wk3K2rdewUYcXd8PjvdAvq72dxAsqZkUgomm0hhsZ4iVT/MwLHU/XZnEU
         7Y5N8RQYIDcuIF5UuQzLsaUWgtwKKosse4Xi9WiCtelBOQu1Rr9Nmc22m7Fu/flmD2Fo
         Xoag==
X-Gm-Message-State: AOAM532fTxsnpa/i4OIBI7EkPpFvBRNpzKMa6LjTH/XmHPESJ9bgQ8W5
        gDb9asqqR038SCQqDZNABMytVZ2e
X-Google-Smtp-Source: ABdhPJzIIgsfu/oRanYvYbb36JWal20Qtcz48pt99KZGzQjzX/GodtBppZFZaIsUwOZi054boFGJag==
X-Received: by 2002:a62:86ca:: with SMTP id x193mr9347682pfd.152.1596740258818;
        Thu, 06 Aug 2020 11:57:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z77sm10023667pfc.199.2020.08.06.11.57.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 11:57:38 -0700 (PDT)
Date:   Thu, 6 Aug 2020 11:57:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/8] 4.14.193-rc1 review
Message-ID: <20200806185737.GA236944@roeck-us.net>
References: <20200805153507.005753845@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 05:53:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.193 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 407 pass: 407 fail: 0

Guenter
