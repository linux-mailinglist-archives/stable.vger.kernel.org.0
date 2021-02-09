Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48874315663
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBIS4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbhBISv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:51:58 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B7BC06121D;
        Tue,  9 Feb 2021 10:14:46 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id i3so9536906oif.1;
        Tue, 09 Feb 2021 10:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dVoznBe4entQNlXbE77Db7hOxWdbkjksZE7UKB3oiWo=;
        b=bEZrUNPOYyKRapnQjLZJOWEXh/L4N6ocx//5PAxb8NpJsgMZOnFXH/d6LlYRb4mnXp
         6ySJ96nzUnsOgn2Ykhc1z1moSfJ7Br4uf/RJWt4i099m32IHIx2Yxr+buUHvdPsK4VDd
         zH9nKfHs9SeRSyyE6zm84StuneTvVM5l7Z0sLMYoei7VBN9Z3FhW2v/g2C4CEvH+GzpE
         tDUejLbdc8lPbFpR4kISPD2opQXvmm1pYVCGpwx4y2VM4VvKGUYGf2T94wTfRAQJ7vXF
         B1tSwutidiIrAtR1QXZA0XcEBpUNkPdKEbW41/i17DMzBompluwVIVk+yC/FuPoaVTCn
         r7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=dVoznBe4entQNlXbE77Db7hOxWdbkjksZE7UKB3oiWo=;
        b=GKw2RDhovGBskrYVt4T75yXP1bz8N9+fj8Zd9VZU7rlAUzAccmA50mXW55HYTxhBpQ
         M/1/V8PJyY0H5WWmLR8ANV4gYoL/zgBRC2L0rsoepMqn/kv18t596W/QIin82e+qGt3B
         vp4W44WJUyi2wTSmrdKk4Nm2GYOZ81RsI/6Ak+uxM/+8o+4ngyE7sEe9BEclAVqn2wGP
         w0eRdQFZ3DOJHS8tYpClTyN63EG5fW3cJ6oIgEGUynucQCpL60y6DFIEBoxPlZ/1gZV0
         hR9+55Z52Xsf5f+eRMhxWimLSBRI7LJUS88AKCrjDbMhhZMcTEJROlSFjUCwvm3gqNqv
         vlxA==
X-Gm-Message-State: AOAM532w7l0sof7HNeQ8F4fwaYfmgz3Hh7KkQ4Zo9IqrK7UzmxksRX/3
        AJ2K91cnLkiG0dIZ4WCkto8=
X-Google-Smtp-Source: ABdhPJzw62ku8HHugfAWFyhkQ+c9T0BQIjq4Zk4lzOGZDJbBUX6QXSWmAOJgYf2rJqudb+IM9/x7Mw==
X-Received: by 2002:aca:6256:: with SMTP id w83mr3450437oib.170.1612894486281;
        Tue, 09 Feb 2021 10:14:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t3sm1493765otb.36.2021.02.09.10.14.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:14:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:14:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <20210209181444.GB142754@roeck-us.net>
References: <20210208145818.395353822@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.15 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
