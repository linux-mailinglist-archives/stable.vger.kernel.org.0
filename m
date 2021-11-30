Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C261A463D05
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 18:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbhK3RpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 12:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbhK3RpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 12:45:15 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827D2C061574;
        Tue, 30 Nov 2021 09:41:56 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso31305635otr.2;
        Tue, 30 Nov 2021 09:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EQ57z4LfNySYVzS+HkhvTCwq66ruMr4M2Pg6O9rj1sA=;
        b=oLvDnqsLftllITlLbHajFnXGEmmn2zw35fvzdgC1OIhh0C2vMr6ccrEh3FmuNEYbBN
         M233/xqrZofDD3W4tIxZjh1CYJk/DW6ODKwb8YlBWTtpI+11spdGTAVQJbaMZYJ5hgW6
         n3p+C55675AbJcgy9HXvygdqMyv77f8sqoBWRZloL23ZtpLN4/Xt7q9rX9j4Cj0Bg5S1
         0VrAwHDDH9tigFBfRI62V5pcpcMQ1ahRcd7WG7cr5dLOC44UhdCFb48QKymWO7ZlLz7K
         wCFgHQmIG5zi9wSGqMFPe9nzcNCgaduylvWt9C7y3dIx/jwyeTDxQ+hIIdRhYfyaFcR6
         nidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EQ57z4LfNySYVzS+HkhvTCwq66ruMr4M2Pg6O9rj1sA=;
        b=H+P1T5cSvIyka0zAUFOPIfvWV9+KOBFR8yqRtYegS0PbQPgB6wIbkUdx78Xv1j0ZlE
         n5NSHFbM/ipDU8TjpSayTbE84EeAofE/URkL/Zikby/f+ZXiQPCxofRwA4IFghjrlrbe
         w4Be4OT7bAzBJY9ta2n67Og/za7QkMyOCfVss1e+U+ekY2JekxXZF9Ik8gpETxObRUK1
         k+PZ6wAuH17b0jsWZaNyBwceWhFhOOJaU5eNRVovxHrHJTBABujy/OT8lxAmuCQ3skD1
         ulkb6/5Tzbv3/9oqpXRVdoYcUfLll63rgSTtYnSgb7j/LIXw4ENtdrqNuGrZtEwznfVE
         Qumw==
X-Gm-Message-State: AOAM532p9s2RWipAAJ20zjS4s/zdfNm+lYdIkQAfwzs9LCjy2uqQ7npG
        CW0m1VaMxzKCKt8CM+0/G4LzN0nYV4k=
X-Google-Smtp-Source: ABdhPJx5ZlKlIOUNAU7br+I10r0kpBCltlzWmQa9DFT9Ft+6YZ8QPBplpXREtUswRyGY2bb4v2cAKw==
X-Received: by 2002:a05:6830:1688:: with SMTP id k8mr651280otr.238.1638294115936;
        Tue, 30 Nov 2021 09:41:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm2973130oog.43.2021.11.30.09.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:41:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 30 Nov 2021 09:41:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/92] 5.4.163-rc1 review
Message-ID: <20211130174154.GC3226251@roeck-us.net>
References: <20211129181707.392764191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:17:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.163 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
