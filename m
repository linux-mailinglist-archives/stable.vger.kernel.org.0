Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BFB6D5DB
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfGRUgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:36:38 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34202 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRUgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:36:38 -0400
Received: by mail-ot1-f66.google.com with SMTP id n5so30513499otk.1;
        Thu, 18 Jul 2019 13:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OY9UR9zkTdLDOjE/tTwcXypGYfY2Y7i9s+/aTr0TUyU=;
        b=OO57QEKH+VuW/gw4VaXDrWVYTt9xqAKiPtCaTBXdRJcPaJAItekcL3v+21IRE7zBeT
         gI2hZi2c9yLrPwur48hfzlVsXXbkVGYiZlqXV8abSHX7uT+FfkM52leqES/Zu4Q/9cSs
         Ebv1mFqaKN2H78kfpNWLmWU+SAg++muUOvKmuJf5n9/bBTyHvvNIEnX45yatqcAkgjZt
         ZRMmzV6zVv4V1TlHXx4pEqQe1wwfYj+nVE0zm9SjyHy4wi3vp8NnJlIcwm3jUFHLCvZ3
         k9rXldwWbtSsYLqO/Sy+Ix1W647U+Fc8em6KNz4axIBvL96Q3KgIdgn6n5E2py9k3eDv
         Kzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OY9UR9zkTdLDOjE/tTwcXypGYfY2Y7i9s+/aTr0TUyU=;
        b=RcwpcN3YxuqiAn+zprkxt3RcvIjpKi6cgt0Dl0dOvsFGXxH0Q1ncBItLYvcO2bQCht
         4swOL1olW6fZ7L0ECJ2a1CLeSeRrS7qY8tU9UNv9+guA2dp1L+E6zzEeNwh6nCblpesi
         b7ytg9S7Yr36eTNityq/adXcmvAHLVtyjXv0Bdr5xCO4tEZDfjUx+ONab6s+0+7L8w3l
         XYbSJ3rR9TkMPwoQMnONGvn4YlhDPDIZZ6Ls9dfBUP84NOfqNzDBDd9Geye+kuRiAClu
         BSalTZoH019G7XIMR7BqGa41ycWVD4IMhLrt8/Bl2Nc+hDE/1P91a5eZqp66bK9IPx3i
         owCA==
X-Gm-Message-State: APjAAAUkq5aP6CxHbzK0uG7zMdrNANoLxiMfPrA4SB+h8jE83uk/ABjy
        /r0f9Cnpk1coF0Gl4pvRLiLelB4IVOg=
X-Google-Smtp-Source: APXvYqwsOyICYj+jizrXxiNM7ZP395rkZVEKBWwwSNIYXHh5krxURjXLJqDgEHpZ1vqdmgShwCR/Nw==
X-Received: by 2002:a9d:5c0d:: with SMTP id o13mr17379827otk.310.1563482197096;
        Thu, 18 Jul 2019 13:36:37 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::38])
        by smtp.gmail.com with ESMTPSA id m7sm10035563otm.5.2019.07.18.13.36.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 13:36:36 -0700 (PDT)
Date:   Thu, 18 Jul 2019 15:36:36 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/54] 5.1.19-stable review
Message-ID: <20190718203635.hzue3utbi2tydrnv@rYz3n>
References: <20190718030053.287374640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:00:55PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.19 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Hello,

Compiled and booted.  No regressions on x86_64.

THX,

Jiunn
