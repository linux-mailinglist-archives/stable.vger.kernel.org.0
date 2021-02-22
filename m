Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3843D322165
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhBVV3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhBVV3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:29:14 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45583C061574;
        Mon, 22 Feb 2021 13:28:34 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id k13so2983916otn.13;
        Mon, 22 Feb 2021 13:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UJtSLMLGUwJjp33XDNk+VRwUvqhrPumQ+4syopWumw4=;
        b=YlDDB9Aji3igXRysuepnIbr0eiYZOVgD05JcJSR3vvc/UalhHHBoMeoriCfppYPh7a
         v9H7zOZLy2RNn8254VYBukBrIxwBXdeDbdTv/3LxyYMkW3ghJCuOTty+ZMbICqS+oPar
         HCTlIrVdXhHpS6sPAd3Jah6GNHM3kDflnH9WoerNUP9ybuQAq/aX/aOrNpUY8zSfUjgV
         KWSYEZyPNJiAVv2il7RrLU+YOy2j7To94qmoRMnH9TB3UTA8GrIl4q7dKMSkuBDpfaUC
         PKYBUVdForog75feQHOyRvtaxBRX1LcShtoqOJSPtbFQGgyrLkZ0/6ZnQcvu8H+1BMgG
         vhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UJtSLMLGUwJjp33XDNk+VRwUvqhrPumQ+4syopWumw4=;
        b=BuXZB+zbT0r/VDNz2SFqKpxlEB1p5XWzvWsdSYN/B5gBuEhEXHYSNSuXiSIoq0jX2p
         dvvlDjvJSqDdIcJy7Jvb2ewf2zQX1y+H5f9OIOYKB8KJL4vc9ou7iImac9toRLA4M2rc
         dTbe8r8pvbQtpMlsK5TqXIiOgJOLIT1kbYEqeiXbgO2IrYc/UAAiq8qIiJJgENiPy0Ou
         32pzPwrzrd/JfcqixKEdIBffhYfUa2g2fb/Wznk22aNJrImoSl/8SeJPKBv84qM9V8n2
         Hdym40nkURVjDC3jUaWI5sQAUW+C4Wgat5mbPZmvZ0BV9ODfWJZgDkKbEmMsNjS9DNOp
         ALqA==
X-Gm-Message-State: AOAM530A8zTORiAMFcLS+hrbq1aA0ulu2GxU3pu5fO3btDb/eEcsekjg
        4s29f8dquo9/7O3xhvJLi28=
X-Google-Smtp-Source: ABdhPJxKOhDKVem//95b0h+lbr2oTMXLpi//gbmAx6Z38D5AkDpqjnYBb4od/65o/1S/EhgGXRVopw==
X-Received: by 2002:a05:6830:1646:: with SMTP id h6mr18699162otr.267.1614029313721;
        Mon, 22 Feb 2021 13:28:33 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm3930501oij.48.2021.02.22.13.28.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:28:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:28:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
Message-ID: <20210222212832.GE98612@roeck-us.net>
References: <20210222121013.583922436@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:13:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.100 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
