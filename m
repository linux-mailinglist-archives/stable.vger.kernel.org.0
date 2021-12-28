Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE9480BCA
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhL1RFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhL1RFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:05:35 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEB4C061574;
        Tue, 28 Dec 2021 09:05:35 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id m6so30924781oim.2;
        Tue, 28 Dec 2021 09:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F6iFKf3Py2J1MNLQN7Q5m64y3CWIdcNo22G6/1QZMYE=;
        b=kOb3f5gcFKau1Uqm6jY0LTKBM4KsdipF0xZN18nk7URy070MB4lFcPAH88jZERJuEC
         xe0PxQigztJSxTd23ncZtt6wY+PZTvGmq4smyPc5/5pH683FrAqnd74RSDRQm3xuEkK9
         C7n0es43ZbsSLOzoeDS/Mu3qv1pUEHKr5u5ztx8dhtaEiBbvuzslTM01+IIe6d+eCMFX
         Pny4pUN+Iae7ygeE/0KSyFfSeb8aVfJqItCKnnIL6ZruFV+RvuYZzWRgQQ/WWsas0wu9
         OcD+SzVu6VsbuhcS1Ln9ihhtBH+Gjwh4OsFb/KLiJ9Rg8rGAU3iC+uXt567iPab3JZPb
         hREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=F6iFKf3Py2J1MNLQN7Q5m64y3CWIdcNo22G6/1QZMYE=;
        b=sFgoOOpgVSo5V5McE/EAthOCThPLDRH/N+USowTglK1YKbIljEmepBK8yQ5V67Nu7f
         RFtbsMgS73Ww4fqswIsdrO+s67ifclzKXV+ICzpgLuzcNgkQbVM0f1jeyGYZtNOY2tpE
         VBXNhw9Fpa5jlbqObnfCdpdukPES5Am1V6BSJJ2XBiqetfx2193Sn0WdsowD8uALDD7e
         KoMj/MUpn+gRP30XGdv/Yh243EDk1DdWSnChh8TDrD4LmQaUj4TqWLSSenbon2aewtws
         XSSBQr313vzflZUedHJs8qoBkg6Lx0Xcrfw2zpRADyJp0u4IB5ft2IUealg+epL6c95f
         55wQ==
X-Gm-Message-State: AOAM530Qc/FXLQBpOSK6IkF/hPj+Er7TAWB+EPzBGavh8/Cx9L2Ksc0N
        lFWhOsGJuvRlLaigEOUErYU=
X-Google-Smtp-Source: ABdhPJy1ku9Zig/Ll+qIEehjfNcKHR5oHs8NOC3FA32FVVieEpihlE14jrfWt2XAY1j5iHXkgmlVnA==
X-Received: by 2002:a05:6808:1828:: with SMTP id bh40mr15655984oib.105.1640711135170;
        Tue, 28 Dec 2021 09:05:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n18sm3222297ooj.30.2021.12.28.09.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:05:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:05:33 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/19] 4.9.295-rc1 review
Message-ID: <20211228170533.GB1225572@roeck-us.net>
References: <20211227151316.558965545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:27:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.295 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
