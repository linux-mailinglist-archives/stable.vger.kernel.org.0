Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8459D308C55
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhA2SXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhA2SWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:22:55 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E9DC0613ED;
        Fri, 29 Jan 2021 10:22:09 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id m13so10832845oig.8;
        Fri, 29 Jan 2021 10:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5tAYoVZyXIMDZHj0QVYPlQa4B+6hhxYu8yGBnH2EZaw=;
        b=lw0BE6qlQxBz8RfJICca+dNkRPbnmCPP1QddFQTOOI6IMOAYJTq6MqRDKbR6YuZG9T
         n5vLNk8I3h3aZ89iuje7JgvfWBfItBRLhA1hFWSA6ePR8Yz36jv6yy2yTvZ1FOWZZt55
         6qdsEZCPRZA+ROoNAIYHcF8S+rspFOoKXlLYS1TsY/yncRDiQMgSRYVPsYOLXurqsAvn
         Phr8oAmMjxlKK20u+D5BX1favF1r1DYYhPAQwcZ5udod+wGyrV7vFicS+atuXPPzBWfy
         XtdjzoJBIXiEspaUOG9GqQ1B5mSi7hB+JTFLh/Kq0UM5zUnjDd+NqDqrkp1nVx8eFmgS
         iv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5tAYoVZyXIMDZHj0QVYPlQa4B+6hhxYu8yGBnH2EZaw=;
        b=e5hZ8z15RuTtyWhLOXw5efHTS5BsjLuSDWCCgy4A2HUiz+yDGx9arR7AzY9QwaHhBl
         DHYQY6Kut1rGdlVqjfJW1mY7Mj61aW5Q3PErxhNFtl/LxU79VGlYrl17/8zvKOGCK/+V
         YMyJIN6tF5x2WVqv0gwElDTtTpQ8eP29cx7ZZkzADK7MtBsGoxrWacUJm1ecHzEMTH9Y
         oJABehq3kxH7p+6mGWlNEhoMkkE89bxLXNbQjQdRWhj2Pq9xK+rkSVr549/bnHWMASK0
         cigqlp2WYqzAf+PAvaOOw3mePPDxlqc+EaGCK3VJOlGk2v0AQ2LrBOGmuisyUIL/Sqlb
         fFSg==
X-Gm-Message-State: AOAM531KqxBNEBRL1c6kcCqq94BvEimRddeLvsd+agLluV3v1WApj7wy
        HXIqJrt7OXMbuJvq2CMY/YU=
X-Google-Smtp-Source: ABdhPJxMYIVoEHOY3wp76HDp4An4vI2InKu3k9Dc3L0XcLFc9us7x+ohIcCFPbd3IFIlioR4U1csEw==
X-Received: by 2002:aca:b9c1:: with SMTP id j184mr3436917oif.63.1611944529033;
        Fri, 29 Jan 2021 10:22:09 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y19sm2283637otq.1.2021.01.29.10.22.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:22:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:22:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
Message-ID: <20210129182207.GC146143@roeck-us.net>
References: <20210129105910.583037839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105910.583037839@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:06:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.254 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
