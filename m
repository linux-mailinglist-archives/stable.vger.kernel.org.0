Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C931D313880
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhBHPvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhBHPvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:51:06 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F28C061788
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:50:26 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o10so135442wmc.1
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Qcbtr1LdWWW5bciKMkCu87TpuKaqvnxst2wajR8RZW8=;
        b=KUsHg8NGb+T2B4xF99XcgIfb/RaSHEja0/y1aGBLaOv+2CLKU8AaZ5Votph+yZQDX2
         nXOjhoQnV3QBiwbiIMIf7I4N0JXvpllgI9t8ajzVn1ahe9rV5x+xNC3HJ1qSdlgoV1VJ
         Y0u23WrXUkwNhWDXltRMAmtPluATW4tdm7qA6yYQv9XuqB6AzO5rMYrdBFfcpdmVJjht
         2wdbfPzMAWxaNLu1TN4v8mnCsPmiKp07L4v7nMoaxYLCIR0UXhfZF8S4VgkM5gPmpIJp
         2c+b6wrr8dRKj8yLUgtrbkpzPSzy9Bbk1uCb3YnS+o82czmzt3/urU/gkaWkB5FCrng9
         TYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Qcbtr1LdWWW5bciKMkCu87TpuKaqvnxst2wajR8RZW8=;
        b=bbBSb+Teg+3kBqPlpg3u9tlbo/iuQ24/3RzKlYCoX+2DAEAm/leegKAgdPxBQZbc9r
         EvBh4TouyZApS6fG45FEfvDhgBAV5BvgZetZVHDHn7yNfBpSCC9QJiUFmkx06RijaWWs
         UkzyUV9LLuvUlGTxe7oILezR9IQvJtiYQyDMjbw2cEP7QPkCmkhPtQd8E+b85D5kmTU8
         e1Xnu+BFxRJewyj7dwUA+CU+tg4Dvaa0DSvQMKhfiGI7Vciak9u8GwGsC8Rq1NZfLx43
         lo7s2bZj3du/FmO2blIBl4I0qHTGsD4b7741k4mjDmXF6MEFQKPkzpI1RqVvaocU6wqR
         kLGA==
X-Gm-Message-State: AOAM530Vknm5ZbQCbbb6zYPq+4DAddqNxmh7SSWKnBxRq/GnLZBo7D8J
        v9TOk7MdVeYcwYKprS0rSUXctg==
X-Google-Smtp-Source: ABdhPJxNwMJK4nbL44Z8eihFpHQDQVbnhmaXtunWragEFnRiizr+xHZTjmQ9l5tDztZZdkwG7fvR1w==
X-Received: by 2002:a7b:ce93:: with SMTP id q19mr15356415wmj.65.1612799423642;
        Mon, 08 Feb 2021 07:50:23 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id m18sm29493995wrx.17.2021.02.08.07.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:50:22 -0800 (PST)
Subject: Re: Linux 4.9.256
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
References: <1612535085125226@kroah.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
Date:   Mon, 8 Feb 2021 17:50:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1612535085125226@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/02/2021 16.26, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.9.256 kernel.
>
> This, and the 4.4.256 release are a little bit "different" than normal.
>
> This contains only 1 patch, just the version bump from .255 to .256 which ends
> up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
> than normal due to the "overflow".
>
> With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).


I think this is a bad idea. Many kernel features can only be discovered 
by checking the kernel version. If a feature was introduced in 4.10, 
then an application can be tricked into thinking a 4.9 kernel has it.


IMO, better to stop LINUX_VERSION_CODE at 255 and introduce a 
LINUX_VERSION_CODE_IMPROVED that has more bits for patchlevel.


> Nothing in the kernel build itself breaks with this change, but given that this
> is a userspace visible change, and some crazy tools (like glibc and gcc) have
> logic that checks the kernel version for different reasons, I wanted to do this
> release as an "empty" release to ensure that everything still works properly.


Even if glibc and gcc work, other programs may not.


I have two such cases. They don't depend on 4.9, but they're examples of 
features that are not discoverable by other means.



> So, this is a YOU MUST UPGRADE requirement of a release.  If you rely on the
> 4.9.y kernel, please throw this release into your test builds and rebuild the
> world and let us know if anything breaks, or if all is well.
>
> Go forth and do full system rebuilds!  Yocto and Gentoo are great for this, as
> will systems that use buildroot.
>
> I'll try to hold off on doing a "real" 4.9.y release for a 9eek to give
> everyone a chance to test this out and get back to me.  The pending patches in
> the 4.9.y queue are pretty serious, so I am loath to wait longer than that,
> consider yourself warned...
>
> The updated 4.9.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
> thanks,
>
> greg k-h
>
> ------------
>
>   Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Greg Kroah-Hartman (1):
>        Linux 4.9.256
>
>
