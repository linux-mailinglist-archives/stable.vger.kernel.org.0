Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8870B2A6C2E
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 18:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgKDRt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 12:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDRt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 12:49:59 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5013EC0613D3;
        Wed,  4 Nov 2020 09:49:59 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 79so12641089otc.7;
        Wed, 04 Nov 2020 09:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yq13A97vT3o0xF+Z6uN3vYG07g1F2uBCUEaGSyAELOk=;
        b=V566ur06O4UVTuCEzos+8qmjrSFI8PHo0VzSjpk9tLt7MUEOV72tPBe7/N4RkS8FRX
         E0ZrberJJySLP/2dXL/phhz7yzMBsgxcCWYGd9NLCK+TFCPBw9KjoDwJ6vgSPMr9miDJ
         DoT9UZFHf5Zp/ygR6e+76tuNG3NmUSCN7uGaGMjWBthdbXtKrtJm6g1um6U5/OOSzp/t
         At/zQpUqNTQxl8QUu1hWXh81IJMTcvCABXPkOHs/4K5P3l6RkeIwdgOP6jhlkXY+iTaz
         Ru2oK3J2i5dAi3I2UFT2R5+A8bsI0kzW2E73r8EyrL67waAvXbsTiy5uzNhq0XHEElYl
         v9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=yq13A97vT3o0xF+Z6uN3vYG07g1F2uBCUEaGSyAELOk=;
        b=DV0EknlBDBryO/yqYO0FgdPC4qiaQSiYN+5iWHokvSUMcZoaJwVNyUhh73I8Wu2HHI
         obrVixPDkOcC8csE126hqNBcFK5kbXBHHfOeuMutStzDkOAYO/8pZrvh38f67MU57ZTr
         vNiT1mfTsfqafsMh4O5ZHj+Tm/PXJNKSC4QIYleE1kTDpbJ6Yj7C4doFptaCsWkV+dUq
         akJFJ3y9hxM4+5dUeJ39ru4gSN9AlbTgZVwkC5m7UKFjwUpMIiZiutI+nrUfJl4f8HGB
         W7I9lSl4cvairaDlNwhizRiEyL7KgWPPN22JRIAGngt6Ed4MgQzcq2vWKpnDNHDrC7cQ
         hhDA==
X-Gm-Message-State: AOAM5331Y6gSH0MojrUiiTzfQBQ+oY4+8OXDpuaIvdTBiYThI28qm13K
        C/ivpcH6ouEr1JjGyfBeMCw=
X-Google-Smtp-Source: ABdhPJzfoKoxurU07zgVNcaHCxUpFp/h4qIs6qeHfw8uFsXm5zE82ema5AR7VGNwdfNHoSzCKTxiiA==
X-Received: by 2002:a05:6830:160f:: with SMTP id g15mr6059186otr.22.1604512198747;
        Wed, 04 Nov 2020 09:49:58 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e47sm643138ote.50.2020.11.04.09.49.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 09:49:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 09:49:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/191] 4.19.155-rc1 review
Message-ID: <20201104174957.GB225910@roeck-us.net>
References: <20201103203232.656475008@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:34:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.155 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
