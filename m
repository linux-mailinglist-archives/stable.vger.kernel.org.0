Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E173047354C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbhLMTyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242533AbhLMTyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:54:17 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9BC061574;
        Mon, 13 Dec 2021 11:54:17 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso18647794otj.1;
        Mon, 13 Dec 2021 11:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bAU5673VCbs50eoF7jJ5jNPYdl9rCy0WVWW/ejjhY8c=;
        b=hdI4SOEGjhhPqVHx0iwVtaMo46KZ1AR6uH9aPknNcHxtact9zPzifwBpJp5l39+Rrv
         Lw60OvJchxDthYnEuSFD4jBcu0PEYC2EEHfkTjutdNaQmNQadsYOIvHeCUj410U33XEt
         exIq56q3TI+hDIyv2bBBdTmrd9V3Hit5dkRfFBeNGFl3uMxfoOTrjhy119HsXF8F8VVt
         SWd1dE+LWpBfQJVxJDVSq1IiBHW26q5YDPzFzivlOBomDFEVQbTF8bqLHC2T8lCD+St9
         sO4/GaughT2ge6aK21CeDlS94BW7GL8vmJqb3WKxmZVnA24QJhLv319BL8Ofo6rbheqr
         yDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bAU5673VCbs50eoF7jJ5jNPYdl9rCy0WVWW/ejjhY8c=;
        b=oUJZHy/5AQhh00ZJJnF5WS8sMOPFipzvj9nk8vHbGewfnjV63YhilxiDD7kJg2ndJU
         WfqTm9xlePxazo4fhi7fJDJ4qm8xSkrniHdVV2XTEErMEdT6oq+KoclPa9lRoDrj31vC
         1SKvNvuaRnjYBYACApOURnSe14ze4oNGFFRsJGKwnpgQ5SgxWja+Kb3W3U7PKAipHjSP
         /Wrr8/HwwJYX2cfTVIZYyiy+fB7gBMPKcnEgguiMof+NHGWfQdj4Ewpp6XqliFj/1TOz
         IwdKvjh0v4qnGYJDrRaBYV7G2XTl/8OxxeJoSB1XdxRlVXNubL/A/5meraz7FtrnIqju
         Pphw==
X-Gm-Message-State: AOAM532pRn0XnLPne8deCm3hLsAHFipwF2OyUTRhX8MfXSB7kFXTCRVf
        XD2io7gwtH9oqTYX3nSwldM=
X-Google-Smtp-Source: ABdhPJx4nbzbSOoyeJJt7J0XiUyOCtQY6UM1ZDn8VyM6kU+sGwgAeAtIJXR4DbE22O88JVbM46vX+A==
X-Received: by 2002:a9d:578a:: with SMTP id q10mr527732oth.149.1639425256409;
        Mon, 13 Dec 2021 11:54:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bb7sm2445631oob.14.2021.12.13.11.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:54:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:54:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/37] 4.4.295-rc1 review
Message-ID: <20211213195414.GA2950232@roeck-us.net>
References: <20211213092925.380184671@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.295 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
