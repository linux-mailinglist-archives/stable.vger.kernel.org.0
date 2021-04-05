Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5196835465C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbhDER6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDER6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:58:51 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54917C061756;
        Mon,  5 Apr 2021 10:58:45 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so12164206oto.2;
        Mon, 05 Apr 2021 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MBkDXcBohjUN0HxJH7lIIeknMwEwqLBds4EUAHOPBjg=;
        b=AChzqrQcDNcLcvPrK28Zw5AZksFYeuAXguLOdgt1N7Ukt4eW/5Ke3brAombYVufThW
         ScS3BUAoIglFS4NIvEq6vnkHTQhWH+i+3w+JTSXliGZIuqQgPhzmMOeXTP9AnrkytsSS
         nHGvy4yCAdzXaXcPl5NJM2j6ioZokHwpJMJvyYtAqqKjUsnkyHg2QSk32ybZck3JAGWh
         0yn5DeUaspWj2RHpKQ+EnkQ4keEMW4MrqVoPP+4Ipsem8VpTCP/NE1IyWGV0eZ4b23Wg
         uvjGnHuw/4XiyzTBkrbP1J7sbA2xe/FS2q8iHYWkD+h/Hoz67Z+stA/bCuzwS58uDH9i
         Es+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MBkDXcBohjUN0HxJH7lIIeknMwEwqLBds4EUAHOPBjg=;
        b=UCfp0o41g/0B9pACPXiI4GI7zdJh/xQrL0IZUBbJ1DgVJTTtDeDtq9O7YHo4jQ6w84
         ev6ws+8c7fvVDm/id+7sSQMfsF9+AjFCwoRKQ/0VU/NoODVJ+8DhnvzuDRJ7C2xW+fSB
         2U5ck/vLUjFcGIWaJ0lEOPYocoAPUQyvJO+jqDmN2UwOrz1tuETXCpvITI77oY9gtK1/
         uADS7+WW2EhcaAUN2bLUbsCWMMBIXQBl5028m7KxOOiRA7cgZn669WB/x7sVBVPxQPnj
         tudUhs+1saTIhSM9WDsL0vRPv23/SXKocEb66/QMmjLf3lunCsftI5LtKW4o6rTZaRsg
         OR4w==
X-Gm-Message-State: AOAM531LGVKMyITgKXu/sv4P+mJvlhN9TTWuUyAJLcYBNNfmykqBbK8c
        RO6IxOHfDU66CP3sWoOnhqY=
X-Google-Smtp-Source: ABdhPJz4nxUe39YIbVMotF0p7yuPUxI1oKVGUE837rEe1GRQ+lmy6vCYpSM61XhGPBOsN+DTPUXyqg==
X-Received: by 2002:a9d:458e:: with SMTP id x14mr24268381ote.231.1617645524721;
        Mon, 05 Apr 2021 10:58:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h59sm4094848otb.29.2021.04.05.10.58.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:58:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:58:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
Message-ID: <20210405175843.GE93485@roeck-us.net>
References: <20210405085024.703004126@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:24AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.110 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
