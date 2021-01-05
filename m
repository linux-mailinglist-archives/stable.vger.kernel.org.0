Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E952EB250
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbhAESRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbhAESRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:17:21 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DAAC061574;
        Tue,  5 Jan 2021 10:16:40 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id w124so516789oia.6;
        Tue, 05 Jan 2021 10:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8xiuB6I+77P+HIGaXFS4kJ1ZXVbEUlGBop0ZoImixhA=;
        b=RPSoVQaa5vIawUwGEHhtEawbtcivszsE3HsphqL3FbA323GGCR+7+Awmls4JzHCcvP
         gdkjyepdVmV663s8MvOBkif6mDjMKVjNmPW5SRNJ9Ht3p0r7S7f48f7gnuOlYrX1O/Ug
         3fJy/tewBHmq34tkx4PlMyaVAKpOUqKaoI2VLOiiqvkHGVMe8eTKvww4aYK2zAgFCH55
         b5kev+vHJUSrasj8m1TnhOgKH88L4YYqyrbPruRntC0UGPFkfn6iidgikcmkqw+KKP0d
         RPuSISDgfXByrOlmsoeD4KJHK4Ngwy6Fs0c65I3ytsMcFnRajnx41TtFeOKbGUl5nZFe
         Dytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8xiuB6I+77P+HIGaXFS4kJ1ZXVbEUlGBop0ZoImixhA=;
        b=HLWdbKG9yQk2MD+xH1+6V939Uh7a0q1l94d5XdDw1+l7wMTchFh8DzDoG/zqrMv/4J
         bEnVVnzGyg9i+nV40gzXXWzig2jQUNydC73tcZpL1ajEYIoq1lMn5vVVMC99GPWGZaRC
         QNQYXH+cWF8rFilOI+yjjJxaDM/wCkvqnGROYD2R6s4O7T80DkKQC9r8X2dGl3Wn9ZTB
         zY7hrkEBcOox7MJuqg78Bx88eEUuglUOy67PGY+SCNlaUl9bzZ9RJmHKYVerw9NwBpcL
         ffi7G13xpR6PnwuOlcB7kYsIBK1biukedcFrw9Va/1r5w60Uam96sgyca/nfDUzDW60v
         9YzA==
X-Gm-Message-State: AOAM532hA0MtmkJBUpnAX0/DHUJ9LGL2zroxx+6ZV6PQBZOvhW8y1ybG
        pq8f19HQNX0r+bsPossRwGo=
X-Google-Smtp-Source: ABdhPJz3EVanA5c4+c3+Jbrh+5+77Ky23w65jcHtlW6+FrRc3919uIh+5EaGnoaVf/qxrILQvN1C1Q==
X-Received: by 2002:a05:6808:8c2:: with SMTP id k2mr621293oij.132.1609870600011;
        Tue, 05 Jan 2021 10:16:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t2sm66069otj.47.2021.01.05.10.16.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 10:16:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 5 Jan 2021 10:16:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <20210105181637.GA220537@roeck-us.net>
References: <20210105090818.518271884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 10:28:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.165 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> Anything received after that time might be too late.
> 

For v4.19.164-30-g40a2b34effd3:

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
