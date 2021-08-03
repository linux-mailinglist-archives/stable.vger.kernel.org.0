Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEF63DF53D
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbhHCTQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbhHCTQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:16:19 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57741C061757;
        Tue,  3 Aug 2021 12:16:08 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so21677373ota.11;
        Tue, 03 Aug 2021 12:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6bkt97YO8ZINmyXUfVF0WYBo7qVKdebbiTJbFZSNtEU=;
        b=nVV77hYF1OdMBQ1z5QlECw38sIVIBpA8BEoz0Ix/CBR97yhnvb16TQC31GUArqq1Tj
         9PY0RZcVCoZWLckCzUMF+3jEssy6qhzvHAFumgwTpeFWzcWCc62kU5nYHP82M+Ai7FPD
         HH4vfKoF8fYIIFBBrDiX0ZrvLeUj2OHMk1+fsRXrB2QCj58A363faDkdM71mn0vSjadq
         uVCGN9/519SauNTsImbqOc7S+Iw6FYXIQvET0Raj/CEDCBHN0tmvKVLy3hm0nMq2ooPN
         ffO4DXwNwl7pwLXx7cu6SxvdWSj9qyVAsUe9oDbxiXUk5ffT7+bxljTr15aFharHWALj
         wZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6bkt97YO8ZINmyXUfVF0WYBo7qVKdebbiTJbFZSNtEU=;
        b=qkncpSD0D8kP88Rw+SEU4NyCiJQ4uiV8URc7T+HJHVUuqCGFwzVuY+BodG+rgvGp2U
         AvJ6av+BkOgUeLdzXS5z1M9guwuxT/mnzQZFtwM+JSmgTApLJLoZWbSas8KOATC3VSLj
         pO93L6hJqbxjna8GnuEI5j26q9Gt3d9Ucw4NCY6pzKTMoB180PLxfUB/HbIDnWMug/sB
         FeUf38B75S20Iw01GYgawEJ3zae4oD4Frh6AoTMYax8I/d3rEesucm2bYtf4QWahHKQa
         h7rcZjySuM6HuGWAS1LuABY76Aih+nAeHGrBG/CNtDOuHsCMdmlDgX50cvtFgtlwPfb0
         OcvQ==
X-Gm-Message-State: AOAM532pplA/EGlpi2ok+a4yZwd+jdtpLxgnbSlbrRlM/fP43dA6ysC5
        ao8VaNyQbM7avrZMmIe38bc=
X-Google-Smtp-Source: ABdhPJxsPH3r0K1mA/zlVaavcZ3heow68SH3pTgtHeqCJ1xxGAGZRKFMiyefMXYaoU21P88m1y5Q6Q==
X-Received: by 2002:a9d:410b:: with SMTP id o11mr16540578ote.211.1628018167742;
        Tue, 03 Aug 2021 12:16:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h1sm2686578otj.48.2021.08.03.12.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:16:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:16:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/40] 5.4.138-rc1 review
Message-ID: <20210803191606.GE3053441@roeck-us.net>
References: <20210802134335.408294521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.138 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
