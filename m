Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3BE364AA9
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 21:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241228AbhDSTho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 15:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbhDSThl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 15:37:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20063C06174A;
        Mon, 19 Apr 2021 12:37:11 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h11so6252361pfn.0;
        Mon, 19 Apr 2021 12:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=51hqgV4ek8AE8oEPkqNrcW2Zw4e1aRqQijeGQq3vHpI=;
        b=oxA/Cs+c4O4nzOKo6LCl8H9aOXMfO8uu8ncCuJf2NknoKrtoWX/2u68dt7HNkADAnQ
         pmyuFbBbsqw4JYwQ/hbkwCK46mfRqIaf/aLHWn02kzuxWDlzlKFu7lBNZjumX46q+Qar
         wMO+IF3G44gcz8CRrdd/0KF4ix5G3S8EYCMNKD8UMUzRM679bqDbNCZde6kM/P5A8jru
         B0Min6gxdPyhOYIOn1hkXgoNQgvQ9nlgDXWQVbt+Wmsslbb6usEnoXXFAltI64U1tOF3
         L6vwLhNiPOhTQs6AxVAgDTEJZsoAJWG2t8OkBp2m48l/DakmK6vmpER2rLsXDK8weVUM
         3clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=51hqgV4ek8AE8oEPkqNrcW2Zw4e1aRqQijeGQq3vHpI=;
        b=D0gDiYSInkDXfRwRXR+DcKPlvLV+evZo9XlopFFi4KU6ulGI6KxCGqNkKQ7THVGChK
         sZwXb72EM3OsC1XMTVJ0ATGrZVDXCxetVltg8Ld9Rpa84n93gT+YSWoYkj/WnqisRy2P
         8rppLBlPagqJd+hnvc4IdXwj44YSGIXwcAjWs5zYBU2fzWzC0WYNz9AxBara3Fjh6RuE
         LAI1ZfLeNLA9lW1oEZfOrURmPhHAVnuVl1N5Iz51+xc7OkTP55vfulDI6V9bskXiwQ6L
         WJrgllbpNKvQfhjfRw18+XawGTly1YSyghoN0A4eCugY5qyjI2J1ll43TNS5rWqP89YN
         Lh3w==
X-Gm-Message-State: AOAM532Sp9Woav9//8FE1MLSYHZiNMOpxtXeh32bnBrWm1jWStThNkws
        2HaXi2DONyV1gAHAWhNBvS/MHJnr12QbYf2/ookxsA==
X-Google-Smtp-Source: ABdhPJwAgJupOuadIMFqwi1K1jRjDgblRnEa0Eck8mFrKhwSlh1lufp4X661u8aOscGznfNcYCr9Cg==
X-Received: by 2002:a63:f5e:: with SMTP id 30mr13408291pgp.138.1618861030285;
        Mon, 19 Apr 2021 12:37:10 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id l35sm13659341pgm.10.2021.04.19.12.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 12:37:09 -0700 (PDT)
Message-ID: <607ddbe5.1c69fb81.88e5d.2cd1@mx.google.com>
Date:   Mon, 19 Apr 2021 12:37:09 -0700 (PDT)
X-Google-Original-Date: Mon, 19 Apr 2021 19:37:08 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
Subject: RE: [PATCH 5.11 000/122] 5.11.16-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 15:04:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.16 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.16-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

