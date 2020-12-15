Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91B62DB52B
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgLOUcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 15:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgLOUcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 15:32:09 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5ACC0617A6;
        Tue, 15 Dec 2020 12:31:28 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id j20so16244550otq.5;
        Tue, 15 Dec 2020 12:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AdIldY4ko80i6G6QSqD9mZLWzrwxUYE3Ay5v3W8U5sU=;
        b=rupg6F5pOpiXvpOr9wfVJ+IE2lW16VZRhu0a3YBI/6wULrOmYBDeYgntrwmYvf21Xj
         JLy5Qj5uzYTT2GJ70x0zkPZNvEaBGszlGplAY1M6Hc1/QLRerOFUHQJvLoxxXzgoGTXV
         UU5wuvvRltiuyBg766mJwOTxlHFpvu5jh42K1nSOSax3g2esFWemuw9vU1m9+Xuwy8Oq
         M8C03zcyHzCUNUWW67mwVCPkSX0AWShT5AlU/Qa80mCEanZvn+e922BlW664XUAUK+bq
         b03vBpXy0DiVqVRC2eJ3vhSdw0tky9NbspQr22tuay000zxQzA4gu3XXPim18WcBt1v+
         DWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=AdIldY4ko80i6G6QSqD9mZLWzrwxUYE3Ay5v3W8U5sU=;
        b=mm4M3caUg93OfMb7n7C/M50mjCq2bhz+qpCsKT6JP+KuArEWpJM7WrKLrwKxEFAmGz
         x8XZOVPML5UuHLoPsQJK51QEj69cdTg32FarPnMfYjWIjp3lRymp02w6Fj8N4fUzOcuE
         8sY7d7IglBMn91DiShPijZ3eXUN7/Wm6sWGGL3Vu2YXPVQyyg8VVBnY5Mmf8tpAZDUs5
         y3ZoTFK2xoxM8UZCWD+eVFytDkCFY9B82DZc6CDKZAXqbgwYxSmvDSd3fH4Hc5DMoylq
         KtADE67ddIEsaWeMVILU97iA0ByxUxusocLkUIQgLZGabIJUpAIKMX8Oo8+mfVBcjwO/
         VDVg==
X-Gm-Message-State: AOAM533u4o6sleUMPEH8fmcQuJQgCnGuhenJKqZhkprECIRrFz+z9pf2
        XqKzNe60rZU/yLbCg09fkJw=
X-Google-Smtp-Source: ABdhPJxvvBBxDrAVbgRys2H3/gQGXGpp/E59vgUirJBMOshKSShGBDyVyBLz5UP4WN3/62C5qzl7NA==
X-Received: by 2002:a05:6830:1f52:: with SMTP id u18mr25008228oth.200.1608064288165;
        Tue, 15 Dec 2020 12:31:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f14sm5315240oib.40.2020.12.15.12.31.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 12:31:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Dec 2020 12:31:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/36] 5.4.84-rc1 review
Message-ID: <20201215203125.GA188376@roeck-us.net>
References: <20201214172543.302523401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 06:27:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.84 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
