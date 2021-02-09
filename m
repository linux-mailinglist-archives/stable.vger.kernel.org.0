Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569DA3155D3
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhBISYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbhBISWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:22:00 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21A7C061356;
        Tue,  9 Feb 2021 10:10:45 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l19so7902825oih.6;
        Tue, 09 Feb 2021 10:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fDl+34Ws0reoegWYcMSOTld+/zyr9JSnL2c4x6D1jmM=;
        b=rrAEl/s+ibJpeJ39yhbxxw3u8/HsX3DZUmTocwO+f3cPD02AoNXJ5mxv1F96gIw6u6
         KwKFu2NoEShbDA4Tg3I6jrh71RRhsKXKLoXgDfCnn4fcGuFPGfUEvM3m7vW1/S1VhpMx
         KxalunLpOzSz5pdIZ/+XGerG/OgKgJexibCBPXZpxJ2S9ucVYB9onxrZ2aTnQhaTeZQY
         TXGWEAUVMW8zVie0ZbIfT+nlBa+H0JsFKJTjLv+GgnnJglbrYuA27nOlPY6pAmJ1wP1i
         6WJv+4nk7Eadjoo7OY4+iJnK8axienqCupnxXJDoNyxNJHjDU098/tnoAAFjQcK9eEEe
         5Sbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fDl+34Ws0reoegWYcMSOTld+/zyr9JSnL2c4x6D1jmM=;
        b=hqpqJ0G0t/vlDt3435e06zzP6P0fS7DyQE8eLAK4TfP12xbQidp7my0p77RnAh264m
         SdS6uDKsR7/yBRbPiYIiEcbMIiFZnqUQ8m7/7q2in/4LFmy0eRxA2dxUOxxWeYoJEmxi
         Noz1+ujtGh5T6vHSRs2SDxoU9uPQb79pk4NuXIvkDSqBy0HejMBv5eafmBwjLqQ5ZS3W
         VG/gA5SPUJIu9fcbTrq6KUUhgZ1zllSyPbs6VOmwwSSDpxSOfPv1j833oY4g4mvpjEO2
         uUQZTKKztGvtiRChhQuXeyYmClwlPBpTX8svhgCQDpPKLNqUmxUBhPBP3z9uCBUAgsDy
         1P1Q==
X-Gm-Message-State: AOAM5324KnZ+yn43geSQCYYvl2hZVkdYHF9ZXIQPR65oAM2KvnBoQnb1
        UbMx9wCu+rxBGhHZ8y5gLl8tSntON6A=
X-Google-Smtp-Source: ABdhPJwrladHCZioyFWnaln0oPzWpqZHS2VLcaOS8Aa/zn2A42vUPym7Aq4nkowakHBR/8Q59CwXtg==
X-Received: by 2002:a54:410f:: with SMTP id l15mr3218375oic.149.1612894245423;
        Tue, 09 Feb 2021 10:10:45 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e14sm1371581otk.22.2021.02.09.10.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:10:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:10:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/30] 4.14.221-rc1 review
Message-ID: <20210209181043.GC142661@roeck-us.net>
References: <20210208145805.239714726@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.221 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
