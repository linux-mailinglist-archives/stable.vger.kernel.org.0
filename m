Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF04E290D19
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410658AbgJPVJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 17:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410572AbgJPVJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 17:09:45 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75664C061755;
        Fri, 16 Oct 2020 14:09:45 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id f2so973079ooj.2;
        Fri, 16 Oct 2020 14:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RC57eIG2T2wl6Dk1LjMezDDJ5l4KVUlGtYA8RMHXXLk=;
        b=lSbbA6jIyQbfQH2/Sv8GOTdd36Ro3JSrxhkPjBntYz5YVfoBxf59AgIxc90fLkD2aL
         oVXKcaev4yvWBxMCEtZHCQqB1S7AtjmcSsdsY7czF0FydJAcdyTf8DgnhuM7pxwq96wZ
         anNIzVZnERw0CE3+EDd1FZGHa6lPURrHJASARLzKqNlYK0f/gu3/hzJ7YGPc/IBb7aKa
         ssZ+c01Fy+ymxoxZewkbZnspksV+ZkLY0lRRISkzp/l1Ck34X0Z72Z6Jscu4ayLM3nPO
         8lQTwkShIouL0dcwXEFXZLp+l6St5jh48xzwCKLXNOD6sDJQ8Ba21mRfxNbneq5Zu4Vm
         YhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=RC57eIG2T2wl6Dk1LjMezDDJ5l4KVUlGtYA8RMHXXLk=;
        b=fZ1X5Bj3Mlkun8y7P79HBIA+MVbcY2o3EHqQJ20a0HxKAHqNiaNwcsDhYZyXs5bXS5
         cZXDvbRCVGTm9KTWk873qAASEfWHsR/Bdjl9RGEop1CHrPVkPE5e2JV99HgWiyvbo4jk
         KFZS7yu5ucniPiq9tHAedQ0ND90Rk5eUAcFwkbqtLlG7zUftIOsQF26XaaBVqYXFUEba
         tfiWDQq5ub7KFaPzZmVevuvmV7a9J1ldKj/YCeAqY4TeAdnUptAMJaWTYzJRbDcgvav5
         ybOc1dYv1/R3GHCP0S8ulzb5pXsmstJ/0HlIZvVvgmf4n32Z+j7qXuXJJ0EDNlqr+iVl
         b/MA==
X-Gm-Message-State: AOAM532f4AuMje3zLbfeI2FAY8QtdmWL44BsC61MpEUyH6CwyV6mrmko
        6Jv3V/XIoPNFhVaB6+4aamOdH3mZY/w=
X-Google-Smtp-Source: ABdhPJzEZ+79uAbS0XlGub+jBEnpUoqeY+aPTGG1x4QN9XhBs1AxvX3x18Jb2nybzTLVpVoAqEXjRg==
X-Received: by 2002:a4a:3b91:: with SMTP id s139mr4189612oos.34.1602882584668;
        Fri, 16 Oct 2020 14:09:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u186sm1345631oia.51.2020.10.16.14.09.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 14:09:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 14:09:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
Message-ID: <20201016210942.GA108535@roeck-us.net>
References: <20201016090437.170032996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:08:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	mips:allmodconfig
Qemu test results:
	total: 430 pass: 430 fail: 0

The mips build problem is inherited from mainline and still seen there.

ERROR: modpost: "fw_arg3" [drivers/mtd/parsers/bcm63xxpart.ko] undefined!

A fix is (finally) queued in -next.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
