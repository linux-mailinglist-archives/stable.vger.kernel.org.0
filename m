Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A84738AE43
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhETMdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhETMdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:33:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EC7C061763;
        Thu, 20 May 2021 04:38:56 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g18so10478845pfr.2;
        Thu, 20 May 2021 04:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7zLtfprzXuegTIA4p07/iyZIuvz3cMv0M9dQl84C9y4=;
        b=Q/7bJQoXJdbVtB6wpcoUOPLEleZWqRnni5fQlGkn81IDxOlfGAKAFZnGjWkFpACt9X
         y+JewgcGItqrxmj/ZfIcu255GcOGzw7xNXh58ZGiJwR9qbODOmULeh70Zqz6aAkfXPEu
         B9tfeS9mq8OuP014RsoD63tFe0pAo28Pl9ryy3Glps3FCxauLKwCGUxHe2PIvpHDIG4c
         I6BXW3jIOdfaeuS6pIVpZW+UIuG8zkHEo8eZjJN3T2boGGixhBajYpohr5P1W55ss857
         oPtXQvKgo7BFcutfnB/2OxuFJtbFll4DJ3mVJU3fbIkuwid5cZhveGd+LVGLyOhy4CeT
         O7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7zLtfprzXuegTIA4p07/iyZIuvz3cMv0M9dQl84C9y4=;
        b=mLlsh8IV8zglohQ3wS3Cc3+JZ89GrpjRffZtA55ZW90uSfidp/CrLK0FMjT+yLFm6i
         8WcIBfwVOMBA9fLuJAn6RERytSv/MEhKFNO5Q9ilIiM6w0frbied2QzXzeRg4l42TfAg
         jEU4ypLt4YBxj1OL/ur6JV8/s42lQVeMH6fs90xyVqkkbUB2M4TBfML6uBOHXUceKw/Z
         +y2fJ9WeKtqjmTe6NTQodFcjtDLHkVFSOK6C81Y7niSyNsbS9zES5tMUnKJhiout9bOr
         iMxEgV1XIRau28AdOx26lEbtHbCmjrGYdUYndRHAEqNactH8ZlaP0nRYsTs1zrwEQKit
         ohJA==
X-Gm-Message-State: AOAM530E0PxPqxkQ6HEBIIfyOFNbOmwB8lYrBXyYEXcAaZllIMJgVjOb
        7cLX5x0pzQgRrg15Pq5Sox01GzHJfEWdN+L2Ps0=
X-Google-Smtp-Source: ABdhPJy50v/wpYD51e2/DXPewOwR5RHgjFndiTZY3CLSJbwDNl1Fd/rcwF4gpYw3pw3B1ih4pUpiZA==
X-Received: by 2002:aa7:8601:0:b029:2da:f3a7:9b41 with SMTP id p1-20020aa786010000b02902daf3a79b41mr4403410pfn.74.1621510735316;
        Thu, 20 May 2021 04:38:55 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id a8sm1584024pfk.11.2021.05.20.04.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 04:38:54 -0700 (PDT)
Message-ID: <60a64a4e.1c69fb81.9c251.4d30@mx.google.com>
Date:   Thu, 20 May 2021 04:38:54 -0700 (PDT)
X-Google-Original-Date: Thu, 20 May 2021 11:38:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
Subject: RE: [PATCH 5.12 00/45] 5.12.6-rc1 review
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

On Thu, 20 May 2021 11:21:48 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.6-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

