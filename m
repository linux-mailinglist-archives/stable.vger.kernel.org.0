Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C25413B75
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhIUUgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbhIUUgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:36:07 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C8CC061574;
        Tue, 21 Sep 2021 13:34:38 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso372703otu.0;
        Tue, 21 Sep 2021 13:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6scTswTaYSCOlV7iG1d12BQng0p9X5QpEguu1r8Hrr0=;
        b=NLitiv0Il9xQCRL/l0sBID+papYUYLz2JF2uFvkXu0O0/M13IHeQG72LpamMLMDijB
         U1KGtU/cbH2EACHk0AXIqZPX9HUN6JZ2/xcSzPSK7b0cp9Jqui5pbimsyk1RKT+45qYC
         giSLt6kOQroF9C6jw4KIVhWUF7JurHr9R+izrIOthFzuNkss+PwAXSldFW7fdUZrW1O6
         JAUcXsAfLjVGp96buFzQWvT+6SejUAi1BE/us3qzipe79nPjPxbRi/yAonXS0sGdIaU6
         55PFkLNDngmW+HnsmTXytgkvBMcSqgNRPtBQd3UfR5K0uHjHZNiTMgOvZ6TYCJkhJN+y
         T/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6scTswTaYSCOlV7iG1d12BQng0p9X5QpEguu1r8Hrr0=;
        b=hZNG6ZM5GT8ht96sNESd5ZR2efEOVvimrWuQEENw6rt7SYPXaZ/lMrsf1Nxw7vwAuF
         BuMLaXd0s7gjljym+sZQrLyQ5gya101xMDMcs9Up8QmBz22tuZp+2+R83ntfO/w1YAG7
         Vm5UTHEHdpC6vScigjbOLtOMaWEwzs26zagBo28WCWY1kwDVsTPvKeWzx7VHgmfkNIT1
         9jMbioHWRlYqYKPDzE2WJ+tYPp62j3BAAWUSK9YVSh2ZO1qk6IMN7romBJ7x6tzH6DU5
         2QmWkY9NoDR/jP5hl8spGUgzqx9ck5dFb4mcpWtFuz847nMhgJre61r9vDG4dcBmoRYa
         ojEQ==
X-Gm-Message-State: AOAM533zLdzZDj6ChK7UlRvMDkv7Z4l8kkhzVKJ+/iHr0z+pT7+IFCTX
        smy6akLAtapiOhitTTKZDBc=
X-Google-Smtp-Source: ABdhPJyr3+NTi7g5WfVGVGOhKoUdo+MJjJuNap3tvrqnuZpCtL68uCJXbjKsk9ofISrXpNssZuR06Q==
X-Received: by 2002:a05:6830:3190:: with SMTP id p16mr12555142ots.85.1632256478433;
        Tue, 21 Sep 2021 13:34:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bd27sm13629oib.43.2021.09.21.13.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:34:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:34:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
Message-ID: <20210921203436.GF2363301@roeck-us.net>
References: <20210920163915.757887582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:42:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
