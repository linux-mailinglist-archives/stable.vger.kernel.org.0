Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9584B3DF533
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbhHCTPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbhHCTPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:15:01 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D479BC061757;
        Tue,  3 Aug 2021 12:14:48 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x15so29341963oic.9;
        Tue, 03 Aug 2021 12:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lHTPpYahPDRRm0GavXEpeJH+/SssBhBgq7SsQFymoOg=;
        b=M2CF11MyRmrZ0DidXrEpmz3bDzYgvk1TwZPVsAmrPKEYVBGFKE+5F2hM4nGbh2mx+z
         7cyM0Jm9hjmWRkozU+BFSbODmEp/iPULGpqbJkiOkz+vBpJUvrb2lyT9zEMx+yAkxIfi
         dAXVf3fVPMJhDmVjzAsbX1W++1xARejJjQLGqJVrqyNOvVOS77CFnzTTzVOImgvGpR6O
         lv8QaTslWWe+xjNkonBbb2sSR6T1FvN+tVG2i9/B0evHro8w69L/wN1MKbGNH4G6BmXs
         QrGUUoAltEglfClq85XM66jK4z3mGkGWjSKpFsJorzJUmVTdZ0recPpGO9Rg9Ulv4c15
         hM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=lHTPpYahPDRRm0GavXEpeJH+/SssBhBgq7SsQFymoOg=;
        b=G+adajxmQSsWEj6US37AxFZsNUix1Y5De91xJdpawgXv5JEat8yc4DLSDokdG0WS1r
         VRe9G3gGlvbMOdtx43SOodMZ/d7ci3SKt9NfnaGnCnofukn2yH66uG4U3km79SLywleG
         Zmdgc6YUfvkOY909SPpu1fISGhUKX5fnwf5wPOw8E0bHqYAtZxCVuhfsX1rVQt3DHqZJ
         9xQLxZFGKHZ4S/NhJhdpx/xiRRu80zb3bpwIUpQDEBmHoRo27c/edsMlTofAEyrGWpih
         kIfV6W3OWqQBopdefUP+y3YBTy+V95ngt7UCUnvp7UWnmhl3Ebvq/jJ46x8Kj/scnkxk
         ux8w==
X-Gm-Message-State: AOAM533kPga6J9jzC1laKOuDc22W3S4+BEIYA4B8ffnwD5+z8/jYILT0
        F7dhIWFOY4e3xta/RkjxD0Q=
X-Google-Smtp-Source: ABdhPJw9mBXJdP5qHtkrFmLHI1l9Ybc0B6Bj0iR4gPK0KnvPEZqmIGgm+7sIY3q8JE3aF5k7be8EjQ==
X-Received: by 2002:a05:6808:ab1:: with SMTP id r17mr15698699oij.136.1628018088324;
        Tue, 03 Aug 2021 12:14:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 68sm398064otj.57.2021.08.03.12.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:14:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:14:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.278-rc1 review
Message-ID: <20210803191446.GB3053441@roeck-us.net>
References: <20210802134332.931915241@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.278 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 392 pass: 392 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
