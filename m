Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D6201EB7
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgFSXpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgFSXpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:45:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FF1C06174E;
        Fri, 19 Jun 2020 16:45:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j12so2925435pfn.10;
        Fri, 19 Jun 2020 16:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=pDwVXOjrGAxAd8pVFxMAGrSaitVs8gznN/vYXdUdOB0=;
        b=S0IPFDiCez/5lJGBf2j4qC4SFm9FTT1BKsHjBfWPZ8hOA81VRHPfKoj+uneViINIaH
         JD2edE3mEI8ZwN4OCRJfJW4Y2/1L7Z51gx2Ra1nfpefRX6vCLhJL6/QYu6l3QiNR1VEL
         PYuKFcE6OgOTfQBnWG4UtR9Ct79mB0JNBcUbjp0AxPkRSd5ZemA5SkjIy03gmMUDejb2
         7LDKeG8IY1QH9/jw3RYry6bjFvLr67+dtL6ld2qs1ynhI7D3R1yG8/rIl1De8OiLtjF+
         tPFPDnyfdLUSuaxIhSPVga+hj7e5DvzNxcYYOuOM6ULX7F3TFirlM822c8gswh0ajFBT
         voDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=pDwVXOjrGAxAd8pVFxMAGrSaitVs8gznN/vYXdUdOB0=;
        b=AV3rx4frG3NerhTLBtZr1G+3VWxZQMczcw8Dn0ubtaY3RcBnTH+xGOqg1MOwEbrb1T
         c0HzJdCDuJPC9e5k+0SeA9C8Uw9Kzu+a03jhghDmUlJ7GP50Wxrayb02HsAL7m12iLA5
         08hh8LboYzKAvDJbNmNplc4y7vLIMZ5Wfo5nZ+9JQzw/NB/vlJY62e7L2tdoPwlJhQkD
         8GJYRDB5jCTtLSvjUgulLR1fyXm+p05opfdbfKTrOgmjvCSVxMFTHrx16eT8FTX9oCv+
         wcnGzZ5R4/ob3PRgtwQnOjP7WNmujsw7Mbe/Mn56MFOWvOSX19iWpCLGj/kOIBylh37Q
         QbVg==
X-Gm-Message-State: AOAM533hGsWQqhRktldrJMLQtd0hWdvL5pkgMbzy5i68L7Kt1II0Qyi4
        btAPz+JbjShBaa77n8VBWXU=
X-Google-Smtp-Source: ABdhPJyKRz/py2wB0piMVjCth0JwD6fkYgvicgYO28fElLNMRLaxohRrSDfHmr62/t3xYtQugU5Nww==
X-Received: by 2002:aa7:8d4e:: with SMTP id s14mr10998699pfe.143.1592610328291;
        Fri, 19 Jun 2020 16:45:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u4sm5896650pjn.42.2020.06.19.16.45.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:45:27 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:45:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/101] 4.4.228-rc1 review
Message-ID: <20200619234526.GA153942@roeck-us.net>
References: <20200619141614.001544111@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:31:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.228 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 168 fail: 1
Failed builds:
	powerpc:defconfig
Qemu test results:
	total: 332 pass: 332 fail: 0

drivers/macintosh/windfarm_pm112.c: In function ‘create_cpu_loop’:
drivers/macintosh/windfarm_pm112.c:148:2: error: implicit declaration of function ‘kfree’

Guenter
