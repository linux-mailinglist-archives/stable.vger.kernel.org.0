Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F93C3699
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGJTyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhGJTye (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:54:34 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18FEC0613DD;
        Sat, 10 Jul 2021 12:51:48 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id m3so17417330oig.10;
        Sat, 10 Jul 2021 12:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ukZFI+zLqOPsrdm5W0dgPMAmy58bCc9y3xzvcCVctTg=;
        b=CPQ8eGyrt3hFd7zekL/dAQHIYGGCtQgmm9wPekbzUMhchi/MVSUX0mqOb2V73Uf8xh
         hsQ/6ZmihomgfR9kVpJc2woAFkrn3GDJQdFvkpP9+3kHdQrsa4B8yiedcdHA272XOuhm
         FOmrNRyE4B70g2T1edToislnsUpWya+HGaX0amSCz2uIPQ86BlISzfrrSQ/I72/LKpy+
         pno0mOiyLko3A1WICtChkQ0RZ4yzg9LdM6PQuejb+bnjmOVnCqHzt10pFb9QIuRxGENj
         ZBDEYBV8CPlj9B2/MwlMgxuV/wNrJGFy6wvQDQLUN4wTZt8qfYuU7Z5o/MhKBwRlB8HF
         DgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ukZFI+zLqOPsrdm5W0dgPMAmy58bCc9y3xzvcCVctTg=;
        b=iQo82to2PUZWj1QrDtPmPbPNW16cK2RwzlTIuPojDUqPX+ZQrAJcyIDSLVrujwNAiQ
         w4dkZbcfV51AN+ErsxDil1P5z4iv5trnI3M8T3RvVbxIEXSa29L96GM/O1PXtvbFVihF
         WlF/Rs78nhapzJ3aqv71apYuWPmhHUdGR+yPpLKkMzX0yLkZIyF42i2ybVeeb1XHiCVl
         1edHNGae8jMAgQ9843IC168Ehzhoco6hhPWLnqn1Md8wmWhQFZqFVoA/TKAKyJTWtZsy
         5HwIv9uXQf5Vr+gAT8DANDH2YJOmM86WlqR1K+tWsw4OEYSEgfY//SFMpBZto7wEHLvJ
         Xweg==
X-Gm-Message-State: AOAM533q88MH3jK9DlOz5koQwGdPjeHHYzyPHmD0OcWaKykghpCsqHbb
        +xcZs9f7fHw1xG1MNC5wdvo=
X-Google-Smtp-Source: ABdhPJyiu7nAKj1baDf2yTcKJNKR7czklnrmNcom0jiWYbR7xtq9nUneorVpG9uTIKfX5gKvcd8MvA==
X-Received: by 2002:aca:3902:: with SMTP id g2mr32323707oia.162.1625946708101;
        Sat, 10 Jul 2021 12:51:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b11sm1334649oti.30.2021.07.10.12.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:51:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:51:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
Message-ID: <20210710195146.GD2105551@roeck-us.net>
References: <20210709131644.969303901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:20:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
