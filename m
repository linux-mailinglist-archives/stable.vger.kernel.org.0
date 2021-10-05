Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7684B421C7D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhJECQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhJECQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:16:41 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B370C061745;
        Mon,  4 Oct 2021 19:14:52 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id x124so24148647oix.9;
        Mon, 04 Oct 2021 19:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zmxenga20s32axOrAa5Nbx20ILQuKzWe/iFMFwZkAqg=;
        b=azZiM+/IvK402ofVDkELwimaN673vzU22AxGP1w4Td/NkMU/JjH7yY85XYvSffUdM8
         uoat7qnurxzmxmZ7t231sVdkjL6a6RTFY+tcpCa1l0gXt80E/0VZ9JzZVwS0B4KafqFj
         ls0eZ038XqMlOH135jlYlRJrgS7yEfoz/bNAhgQPBfRqbFxY6CQglheEyHds/vTsidvT
         VX6it4pCwTqtZTFGIuEu7Gicq7yAQX9ZSWrDHZDSeZ7QiLkWErfYhx57kvkOhZXhmtdw
         cuR0arxzowmDwMPHBmYZeytbmBLF9kzKwZV48OhRZRHeCDF5ClwykzC+tM9XY8UJuFX0
         Oq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zmxenga20s32axOrAa5Nbx20ILQuKzWe/iFMFwZkAqg=;
        b=20KC0flrkSPp0BgOdPTT+3rLOAspKs9OJV52YjvuFwlKWKZ242nOgU1icKfg12svre
         5U3exw4WdB0OPd+DM0yzP90f2f530UMNg8nw8EwMmekIQZiRm8KxWR3ARp3NPAbbm87u
         uF8gdPQMBUvPZxW1Qz2Dw5UNhxCTfPd/hYD5CP9Z/JCuo7ppcyl6Jo3MGQ/3p6w37Z3O
         8lqCYBIEZcmGQw0BooIAljcS0JpgFcasQiSbjcpWtSsOPJZco06ymOmk9VGDUk+H3m/v
         bsDMxi7rBjm5jJvOZYlO6PiEk27A3fM1znAiaLTN/4hO0xp4ZB5gaOA0C0ZJ+8WbbWSm
         gCpw==
X-Gm-Message-State: AOAM532TCjwI+FVJM6WENp2NFuRw1slbQrSKatpX9MFYvL5r5zkc7StZ
        nciolRvZZ8r0WIskTq4VunuLGz/5XLY=
X-Google-Smtp-Source: ABdhPJwjZycA6woCtibXZGrU0f/LACKpUfDSgn4+SzYXZF3X+eJILPBstOU0kR5oDSWwbEqIyyOclQ==
X-Received: by 2002:a05:6808:346:: with SMTP id j6mr410930oie.131.1633400091639;
        Mon, 04 Oct 2021 19:14:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i127sm3089025oia.43.2021.10.04.19.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:14:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:14:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/75] 4.14.249-rc1 review
Message-ID: <20211005021449.GC1388923@roeck-us.net>
References: <20211004125031.530773667@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:51:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.249 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 5 fail: 416
Failed tests:
	<many>

Presumably the same crash as reported by everyone else.

Guenter
