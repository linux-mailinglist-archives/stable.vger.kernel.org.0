Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93F53D7CF8
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhG0SA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG0SA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:00:28 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED08C061757;
        Tue, 27 Jul 2021 11:00:28 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id h27so10147189qtu.9;
        Tue, 27 Jul 2021 11:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lsbI2QCITx+zrUDr38OmrUeyV8r/XmUyw3zKm2xZLy8=;
        b=Pg1kfs9SF5qXYXdTCi7BE+W75KUmVdFSGQwCwIxjPxleqj+CQDLOIyJfODJvIcKJ/l
         DiHkxfxnlbdMX5aBW+MjEwL9OIUdzNSrzJnBGZbrGA2i+DRc2OJBdQXtNw8cBfkGHesS
         ENwRMxRqABjvU4q3+VpvqCroRKfi670FfDwkKID5tHbyXzGQsBgHCrOYTdfX5Z/sYiAz
         VJnkYLMihJrgvigqc0SxQgTNBxryhAIN4ew1SWkGIeA+bjfSmq95jAMS+RVn4sgOKAJ/
         5xDpn6rRi902eiOaE3aSK4QHW7C30lp70fxByMtdskAHN6P/CMAvbJKbFgAeuqXGmGRy
         +TMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lsbI2QCITx+zrUDr38OmrUeyV8r/XmUyw3zKm2xZLy8=;
        b=i/TmfXLLLdIMGFowMCX1EW+IM12yeOJmZZXM4a415rXkrbJivnt2ZaCys8gL11t9bR
         /tJFbM6qmca35rj1fJczhNHJ4myIfmYuZjIE5+xtyfPqOvncCpG/mJOELBVDyu53u8ZH
         WX+vvGCao9WJ1VjdfUOXNBjUvl3aRB8eWU5MtlsnXiORlsO8YvWUzKlHFJak6W75TzxU
         SlyBdvsAskxKXInUnReMNhsfN4qVgxEZ01faQNsCVzAXG+tE6mTLTYznXjhw4sT1YbOA
         oE/NBmwMkeyReEqDdDBD6EruLdGFylQEFS5YyUECh/KhXhp/FgDXhtNN8yb9aqqOxCkX
         g91g==
X-Gm-Message-State: AOAM530Ckj08BlNHqULe4BmsVMSOG9lLyb/0FLYnoARfUft9O5RSvp3j
        2OQ/gB4FiDwjKOLUTxQy/r0=
X-Google-Smtp-Source: ABdhPJxAmaH08mAV9lHiNYSXv/3jPRXDZlAPl+8REVcWtb5WIiQ9tIiXDXc0trvdMCY5w93b+LySWg==
X-Received: by 2002:ac8:41cd:: with SMTP id o13mr20435959qtm.289.1627408827528;
        Tue, 27 Jul 2021 11:00:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f62sm1964343qke.135.2021.07.27.11.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:00:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:00:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/59] 4.9.277-rc2 review
Message-ID: <20210727180025.GB1721083@roeck-us.net>
References: <20210727061343.233942938@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727061343.233942938@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 08:14:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
