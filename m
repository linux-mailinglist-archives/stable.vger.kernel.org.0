Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE0F3112F9
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhBETSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 14:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbhBETQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 14:16:44 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330FEC0617AB;
        Fri,  5 Feb 2021 12:57:01 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id w8so8960160oie.2;
        Fri, 05 Feb 2021 12:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PsloxtXggqL3mSYVwru9m/EK38xEV5v2ID0nQMA9cD4=;
        b=neQSihu1ny/PdaAgeRhiVajbKgtuv7j8pRJ/sZRbxOKEfEvJUsH7sHEC8ciDqaB2Ky
         4GR21BygKRxCfRs0XhnYdNpWuUmq9rE30UnrNazqsQ7VdtlFqUJ5cDfz/mpJf1cCa8eS
         HlDpXZlTB9xJVwOetherqYYNLpOjGYq6KUTh27pwTpygNLhE890W2HTFQsGJJfwGoXxa
         JPzue09sRZQKoQRDAYzkM06KDmXO6sOVcSXNutlDTd4+wfPfdp5SJP4VLIT9hJ/068tU
         HaR2spA782g1mWz5uus0+a58eBdP73brTy2HElijCqZAXC7DJzWot8sEsUSa/2rU2w9z
         mCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PsloxtXggqL3mSYVwru9m/EK38xEV5v2ID0nQMA9cD4=;
        b=jKnHPVAWvJnucJV6U+WkWh6zmz1nkBFsHh18Bq2+tPr0aAYZUeO2J/aqC3KmQS9BVS
         aeuA7vsbsHstofk3qa0xxzujGQz3MXjq7qAOwHZ8EFGr2ekc4UtFq6rARP8SsS6OZ7ZU
         JsJOTz/xcAwFPC33V9ir/9FQaGiuZsCgPDWTi1Khl93nty2K6N5s+0IvWvrDJZ/YZL9d
         M+wiAoXPrQBDgcUQWhSz0J6D+3vS030P4KINUDbO7k1g1tOmOi5j8ibaDMnjzmeOFr8J
         d+8VqqQ94K5LI9R/QDPkk/54n+IEUEUw50Nn3H4/pqk9mm76H9QBXbEl0fcnfpVH/UiT
         Zs2Q==
X-Gm-Message-State: AOAM533K8VCCJb+H+pTa2mlV3NyuI4bB1xxBvJ3qXig6Ehe5/86FZTmN
        Ok0Be85izS3wn5ZDr8i7KiXw8shaj7c=
X-Google-Smtp-Source: ABdhPJzFL2kWMpWmi9VZt1+8k3C7gZWk7F08lNcwXI/Sx7rsG0rgmp+dfZTBHFqbOcGCB09s4oi5Gw==
X-Received: by 2002:aca:dc06:: with SMTP id t6mr4360435oig.125.1612558620537;
        Fri, 05 Feb 2021 12:57:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c26sm2053058otu.48.2021.02.05.12.56.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 12:56:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Feb 2021 12:56:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <20210205205658.GA136925@roeck-us.net>
References: <1612534196241236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612534196241236@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:26:36PM +0100, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.4.256 kernel.
> 
> This, and the 4.9.256 release are a little bit "different" than normal.
> 
> This contains only 1 patch, just the version bump from .255 to .256 which ends
> up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
> than normal due to the "overflow".
> 
> With this release, KERNEL_VERSION(4, 4, 256) is the same as KERNEL_VERSION(4, 5, 0).
> 
> Nothing in the kernel build itself breaks with this change, but given that this
> is a userspace visible change, and some crazy tools (like glibc and gcc) have
> logic that checks the kernel version for different reasons, I wanted to do this
> release as an "empty" release to ensure that everything still works properly.
> 
> So, this is a YOU MUST UPGRADE requirement of a release.  If you rely on the
> 4.4.y kernel, please throw this release into your test builds and rebuild the
> world and let us know if anything breaks, or if all is well.
> 
> Go forth and do full system rebuilds!  Yocto and Gentoo are great for this, as
> will systems that use buildroot.
> 
> I'll try to hold off on doing a "real" 4.4.y release for a week to give
> everyone a chance to test this out and get back to me.  The pending patches in
> the 4.4.y queue are pretty serious, so I am loath to wait longer than that,
> consider yourself warned...
> 
Thanks a lot for the heads-up. For chromeos-4.4, the version number wrap
is indeed fatal: Unfortunately we have lots of vendor code in the tree
which uses KERNEL_VERSION(), and all the version comparisons against
KERNEL_VERSION(4,5,0) do result in compile errors.

The best workaround/hack/kludge to address the problem seems to be the idea
to use 4.4.255 as version number for LINUX_VERSION_CODE and KERNEL_VERSION()
if SUBLEVEL is larger than 255. Did anyone find a better solution for the
problem ?

Thanks,
Guenter
