Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D952036BAC0
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhDZUgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 16:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbhDZUgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 16:36:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3078AC061756;
        Mon, 26 Apr 2021 13:35:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x5so6937079wrv.13;
        Mon, 26 Apr 2021 13:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/qpNf3s9s9yCF8SdS6sxdw81lzQb3WBRWXKQ4RBbloo=;
        b=bouwjuXaDMt4okV9PCZWfpqZlinFD8VD1Q6xY2X9BUr7ryB8JgNgL34hB6ZwGAE6Tu
         B3KTPeV4QhISB+Ge4PPodV3VmUwH7F5wgPhGI0VKoQn4UdY6w8QsmyMgQwyswGDMjHzT
         1lGCkwE+Z/S68ktWxBxbKWrtMriTRG6FqJqs2HzBVtnDkXiTIy/a1NR7I0v7FfvLfvpT
         hR6YyJvVbnWOP5V/Ig4FHu0P0iRXuZ0me6WCdQg+6l8OKW00+J9YuknsHWUV/wIxpWZz
         TaQnqucRfWhANj2cf4QirKC6GLmzCey0UWCqT61Dj9gXtHpLNrfKR5veCYexQdDDTpnE
         t6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/qpNf3s9s9yCF8SdS6sxdw81lzQb3WBRWXKQ4RBbloo=;
        b=neZSKagIZRSxfqT379Y6bpRpNxHHBXByrTxxL/4sNacIxDmVFjCzWlubMij/PxP6gX
         rSmzdr4YU/+/4DbGDCURl8r9erxG2EUXbJGZ1+FHkfV3rT8j6ATQmAY6AaH0m5+lTptG
         7xtnYGe8RKIyNZLVA6b07WpDFPudtOAX+LhwBNyoguLgd0lfrHqmeZqjaTq9+FdTQwZX
         5rW8448hhIMc4gXombkX8dixrcEUfcL6StkYXZC2ANSGngt6hnVB2EWDqrxPD0lE14N7
         UjbZkrQNjzkvIfhB0VYzNIUlL2YEZiHRnZHgDqq2ORC7Gw4XcDo6aILi6ac+f36PsHIZ
         femA==
X-Gm-Message-State: AOAM5332rd3psroYm08oiM2EJYe9EAA6xFQOK+d5xH7BOp4FuN2E2eSB
        chAsSO/la3Ah82nDj5jtH3Gp7PFScuD9eQ==
X-Google-Smtp-Source: ABdhPJxPhVBRO0cd+MfYQtCiDck7tsYJ/wlfphHLWLt6SfcsdPpHw7TcA0ldLSR0EtIKrtiLMc2AsA==
X-Received: by 2002:adf:fbcc:: with SMTP id d12mr24991257wrs.151.1619469349956;
        Mon, 26 Apr 2021 13:35:49 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id g5sm1420351wrq.30.2021.04.26.13.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 13:35:49 -0700 (PDT)
Date:   Mon, 26 Apr 2021 21:35:47 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.189-rc1 review
Message-ID: <YIckI6fTgBux2VBB@debian>
References: <20210426072820.568997499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 26, 2021 at 09:28:57AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.189 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210416): 63 configs -> no new failure
arm (gcc version 10.3.1 20210416): 116 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
