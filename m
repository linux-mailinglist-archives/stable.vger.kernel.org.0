Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257FA12D274
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfL3RUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:20:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40031 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfL3RUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 12:20:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id q8so18546503pfh.7;
        Mon, 30 Dec 2019 09:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=UlFJJJhWjCpySX1i9YWrQ8Ne1oHUOP+wJBkv41An8Nk=;
        b=Z8Al7iwGl5AH7ts4PvItQCjJYRcVryV0vkbSZo3Ydf9d4IN876i4ybRH4R36epAh3Y
         mYKSSRUnPfO9YxsnBMyKLv0MXUFtp+q2W/i4ZmfYL+yl/dhnaqrnjkYJ/Fln6koFxjtL
         wx+tLTriR+q3aUB3a8cL5OSih6W7giK/hq+k2U7Z83uZN/qL5tPtnl4rPqm7TUoJ30AT
         wDz8r5YUOXZ85L/tlUJd4ShpimreLO7o/YA9+xgCr3joqVdWzVN0jSto4+Cem4TIDOjh
         cBAGdl8rT/DlhUo15b2oY+hdNIDHp5AUgYIiCztw19LO+APRiJi4qjb2616vBsrSUbCc
         NdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=UlFJJJhWjCpySX1i9YWrQ8Ne1oHUOP+wJBkv41An8Nk=;
        b=Boy9QcHB6vjgHwxXhLz2BBdFjvbN3y82i79muNf1iebBeqo+XT/hFkfd8K0IOtuJUU
         zraF0J4z+8yD45UsEkRHQGfraKlE1QLpbnsVZxv2sJ4+r6M4Jj8ly9Zb+x1RZJumG5zb
         SuI0yuRnK/X0DGf2y/sJPYqgVWVNvNWChYSRIhG0ylifNfH0yTovQrvn3U/bUBCBJhBn
         ZLbJqiYP3vXR9NfCB93uEw3qJqPmk3b9a4qstCFzKAl+RoEvvdGoVqN0qVbOxGqFrKNm
         BObDMW7Rfc0MOIiLvWx7rk9sAQ0gWeSi2jNu2aU8HSWAjxwBbp3Vpyh22Cg2cywFV0GB
         uOGA==
X-Gm-Message-State: APjAAAXbVndZoo3gLiupq8obnC0qPZ/MXIYc7KSTrBPKNm2ghBzsy8wd
        CfKUAZtiyyizx0fQlcqsW84=
X-Google-Smtp-Source: APXvYqxnoxKo9tL0zU4S+bwpIxmZwv92nH8/6Lj1NxdvBilpWtXC/g8PsKgB8YWJKye/5j6ixjFk/g==
X-Received: by 2002:a63:2949:: with SMTP id p70mr35141492pgp.191.1577726400698;
        Mon, 30 Dec 2019 09:20:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z29sm51411767pge.21.2019.12.30.09.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Dec 2019 09:20:00 -0800 (PST)
Date:   Mon, 30 Dec 2019 09:19:59 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20191230171959.GC12958@roeck-us.net>
References: <20191229162508.458551679@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.92 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 141 fail: 15
Failed builds:
	i386:tools/perf
	<all mips>
	x86_64:tools/perf
Qemu test results:
	total: 381 pass: 316 fail: 65
Failed tests:
	<all mips>
	<all ppc64_book3s_defconfig>

perf as with v4.14.y.

arch/mips/kernel/syscall.c:40:10: fatal error: asm/sync.h: No such file or directory

arch/powerpc/include/asm/spinlock.h:56:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’
and similar errors.

The powerpc build problem is inherited from mainline and has not been fixed
there as far as I can see. I guess that makes 4.19.y bug-for-bug "compatible"
with mainline in that regard.

Guenter
