Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F58F8399
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfKKXfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:35:44 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46005 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfKKXfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 18:35:44 -0500
Received: by mail-pg1-f196.google.com with SMTP id w11so10474073pga.12;
        Mon, 11 Nov 2019 15:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C+z2BrhU9BWTo1xSXTlPbmiUMi+YHzXijQ4JnRxhpgU=;
        b=d3+Dk05gT7boZ57vAb5HjNyvi1lkOpkygR/3fSJEpJLh8/Z2EYBVSo4oimJZJH911m
         m27sbGpjITj4t4e3rkg1ylRtYPFwH01g/UTAUqqCUxCiyQbsYt7JGmSAcde3uFjCkQH7
         97qTmPVdEJQd1dsYCnasbafKeWk+krjhne+eb3y83AGiYFTrUElMPWrPa8tZdpeMxPyU
         geq6E3/DdKjeKBrvsdwPhNYQ3+Ju24C85FKklHLCOCkMLHZhmZNBKBGWr4nk/eXvqF8U
         GyZXYq49gCesUores1C727Gq7Y9OuQ2z4NDpoSzcmm/EBkgSCX2B/Bj738JY2BQwb6aT
         toNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=C+z2BrhU9BWTo1xSXTlPbmiUMi+YHzXijQ4JnRxhpgU=;
        b=jiiLktNGAQmZevRcqiw3vfmW66TMw3ty1YTdV1TIhn6vJE+lu0gv6HA9aIwldXUO9i
         +Wn1Bpgbu6prgw7AnicCq9V+ukPyg0fENJIfyDYDNamkj5Ub858dwqDeM44ktRTXgXrx
         rkeJJNZznmV/yVBVUFX9pDq2BwMhIUmzxXgOBMpFJ9GE8BnlyRNd/9puNbxLajCWQdDt
         t1jh3EEQG7rp64boSgwfos9viP3MAa4AzFlBkQl/NOkLDWuv7kNc6D3540bMehzbczj1
         6iTl72Res6TZzYUyR6YSIfURWZciq1OcxtwNy6ymHOd/GXRnzu4c6BO+KELAbqQoqck+
         mhvA==
X-Gm-Message-State: APjAAAX2p567YFHw7/GNQZY/4gs5E3fhqE+pbikEwtawupcHFQfZaRI5
        7MnE/KQgewl3gZvZiQVcA+k=
X-Google-Smtp-Source: APXvYqxqCfNLZqtsqefUt4D0a+Te/71bYMXNjPHLWMdGZKlFT/bnu7gc3eE/JR03Gy7ASUK2c+Pd8A==
X-Received: by 2002:a63:d047:: with SMTP id s7mr14709678pgi.355.1573515343269;
        Mon, 11 Nov 2019 15:35:43 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e2sm14759595pgj.62.2019.11.11.15.35.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 15:35:42 -0800 (PST)
Date:   Mon, 11 Nov 2019 15:35:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/43] 4.4.201-stable review
Message-ID: <20191111233540.GA15059@roeck-us.net>
References: <20191111181246.772983347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:28:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.201 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

I am getting lots of

WARNING: modpost: Found 2 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
scripts/Makefile.modpost:97: recipe for target 'vmlinux.o' failed

for v4.4.y, v4.9.y, and v4.14.y.

Bisecting in v4.4.y points to commit 13e9ce202ddcf95bf6 ("mm, meminit:
recalculate pcpu batch and high limits after init completes"). Reverting
it fixes the problem in all three branches.

Guenter
