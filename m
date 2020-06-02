Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB961EC44D
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 23:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBVZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 17:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBVZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 17:25:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9456BC08C5C0;
        Tue,  2 Jun 2020 14:25:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 185so140913pgb.10;
        Tue, 02 Jun 2020 14:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Chq/IxyUXGeQg4iFhSJO433W2x2ArreETHP+Ej74rbw=;
        b=b9pGx50L/5aOGaGI8fRHsl9Y2rskhq+v4N7asuzer9z5hH4KhdUB55DCnXg26W+R9n
         7nQKroEx3qPSWaL3CBjW/gcw20sStrnFIdnC/9FfKSod47MuCS6a1pLQ4laVPv9Xms0f
         79uShTemZ/EZtmuLU02gyKG1rTOOCu5WsjKGY8bx2bo74+NNTySC7DmZAqFc5Bu8m7LW
         N3vgZgOTJEl+63DhSldG8Q4IdvVKOAg1KBreCtUsOaLL15upUur0b12/7ls2JYSe0IWA
         vdIpJEdKSkJTmfKlBm8qh41+4kOiVYdDsWw0OU6kxuYZJmMwcoLoZbymF2V7zrGiWssP
         iRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Chq/IxyUXGeQg4iFhSJO433W2x2ArreETHP+Ej74rbw=;
        b=fvGPGeYdgBOmEMj8OAKXgzEtVpS2VVXAag0SLceofAn7xctANEvTdUp5dpP1MMBgtj
         iBjueBmLfKab5KBR8qse0fSzjzsqdpCBZsIiqeu7iZoWafpxQFtc9hlFXcg3lEYuBRWj
         OO1IIz3m1lTwwWqE5sCaatAUIdpAVicignXZa63KvHpBETlNCuTUgjQocZdsFok1BOq/
         fb827I+Lb1KAd9zdvd9ejz/UUu2xImNCDWNNmWDd16LT/Ssk0gjrnAQCBXZGK9zM957T
         0YEttfsV3JhqlLqqi34FjlLWj9kM/9vSXqfSWjmljH2x+y/hkJeod+BmYMCxK8EY9FEL
         Cx3w==
X-Gm-Message-State: AOAM531C05KgGHwKIhwKsOQoOHa+B9onPmJq68QN3mRoMep7pIFlbSZ5
        1V51Lltso4pp/4KbD+O/FXM=
X-Google-Smtp-Source: ABdhPJz+3JXvyi/JLESD/dHqoG+LPIxBVh/dw/wc8Wbm/qeFHEe9afuk8NFizDHZYbraFxA/VvUkBg==
X-Received: by 2002:a63:1f0e:: with SMTP id f14mr23025185pgf.405.1591133106158;
        Tue, 02 Jun 2020 14:25:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 77sm66346pfu.139.2020.06.02.14.25.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jun 2020 14:25:05 -0700 (PDT)
Date:   Tue, 2 Jun 2020 14:25:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/55] 4.9.226-rc3 review
Message-ID: <20200602212504.GA167487@roeck-us.net>
References: <20200602181325.420361863@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602181325.420361863@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 08:13:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.226 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jun 2020 18:12:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 385 pass: 385 fail: 0

Guenter
