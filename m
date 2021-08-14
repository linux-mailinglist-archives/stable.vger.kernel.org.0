Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4953EC4D2
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 21:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhHNTvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 15:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhHNTun (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 15:50:43 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576DFC0617AD;
        Sat, 14 Aug 2021 12:50:14 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o185so20962920oih.13;
        Sat, 14 Aug 2021 12:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IZpSMudFs8aVE3pfGd1Gr+76BBhEIf1kzdvwdneZmoM=;
        b=icvOJzQz0gYcSfo7ALzjND6PYIhmFUUt2iRVLkcOz9tiXMEZtdoQez2tCkJdpgM8oD
         Haa5qMC7FWyatQcmsxhzdqR+HPJtvkGWSE29A6Zn7TQamEwwjNT58iqPbWc2wom7w4H+
         0ojgRAOd9Wh9kAcZB1LMUotzRgcVMQmSdTnyjonOSdm1qVNncXlIJKSYvPNFC1gcKipO
         5iXtZwKc5WvW5XMZB82pufdpE//oeCTyTTgxJb8DiSgPl/2xh9vAlGwdbrKY8r/c2tHp
         m+kFWmhP6wj9ydPJNFfqIbNK7Vi5WZNfSyumanhouPLq8rigemxB6YiM8Fkm4jTDxB2c
         dORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IZpSMudFs8aVE3pfGd1Gr+76BBhEIf1kzdvwdneZmoM=;
        b=GuVZZe8Fj1EsbV5pAf8ife4sQlSSHnnzzx11OnH6tdYqOO/xYm5NVSmOFQPrjSDedY
         rt3GvBzlwbYj82PNzu20Yd85AD1pPb7V1e6PKp8W4+ZLtMFilZbf5AtRjqbnoxWALDdW
         0UWB3x6p0yV2BmHepK8TzdImHEDiL4ISaL63m53hiczjRUQfDP2lYg1GfVeSiLylkkcp
         +RXkcDXtFDFvtG3ujuSSRgHSb1ELNltX6pAXZsnYHfp7deLbdFFAQSj8I3W5yBlC0hZa
         WbOByqGuk+sGqekdZbWZr3cTcoVIE7+nNjzIe1xlGD5L+qrkeEGAeFzKgki32KqjYPAL
         k7og==
X-Gm-Message-State: AOAM532eNNi+b9yFBeNL8uD8THrpSOwz3aDxKqYdSLXOaOOiDeNbCx89
        Osemy3e6QPO4bmpip/OiRkQ=
X-Google-Smtp-Source: ABdhPJyR08Lk47bOc8/6600640KQuN07Chwm4w8/dNDmspGPyjWV9jGL6zPbxmlG3KbYZG9rtW2KTQ==
X-Received: by 2002:a54:4619:: with SMTP id p25mr6103133oip.5.1628970613802;
        Sat, 14 Aug 2021 12:50:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r1sm1042546ooi.21.2021.08.14.12.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 12:50:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 12:50:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/30] 4.9.280-rc1 review
Message-ID: <20210814195012.GA3951799@roeck-us.net>
References: <20210813150522.445553924@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:06:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.280 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
