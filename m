Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB3397F00
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhFBCZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFBCZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:25:45 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E459C061756;
        Tue,  1 Jun 2021 19:24:02 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 67-20020a4a01460000b0290245b81f6261so238502oor.6;
        Tue, 01 Jun 2021 19:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8OhOy9nydL+dqePPtxFLK7a8wPUpOxdvsDHlUAfV8GY=;
        b=kO/kPOn4bTLcuURPLw9sijNJwj0EQ1/7k8h6oJyQyxB8rTGzkSlZp0ue2QiVNfeYVm
         5v5siWeNFhQ+a5skoM+7c9XyZsol8YhiMCp5QyV9iJqUnw3UfhltMtW9eTAloh2nRu+I
         VaAPWk4XCkc+R52A30qtMVMx/TvBH62JvSR/8SsSBDmE5REp80No1UjzadyDRMSJCp6M
         xVrUjFlYIO4T0ItmYv30DDlwddqI+g7wDJt/LcYQ8I/R7Aogi50dSAlXlKZeS5I+z3db
         JOojWz6OblHRlw3En5P8A0IDh/xaoTMnBngiXeA6ILnbNI7HNb93Ik2BG7ojyeO7e86/
         7k/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8OhOy9nydL+dqePPtxFLK7a8wPUpOxdvsDHlUAfV8GY=;
        b=a4YnY91gPoJAGkcxXDV2w2sDGlzuVRIhNu4NJyVzGQkc9aooIQbAF6jXA9MP3qZghw
         yhRfurltRf4rpY3mPvOqfbeekRnZGkSX6LyLCqD+tVFem2jUpOajdesbYhYHFseURvkX
         +zbXW8W1OudOmUK+Dbua9O8+sGcSkHFrhu2Kmd0z+SVmmiX8ZHKmN2pe6sNyjlTojij/
         O8Gdi55TD/N4fkBvizKkBCl72lFl8l3R0MugVFaxz0gEqTV+5eNv1mQMSku5qHoXOiN1
         jngJ66WqKWtmYm8yZEr5+taZU1FcwhiweMewyTcW07jFS8xzufCmG4WbELS4SsHsiemX
         WeOg==
X-Gm-Message-State: AOAM5304SMBAAA0br9C4kBKKDXVH3ros0o63JBfmQ6mozH+V5qsnWTPB
        w4wpuLag2CnQWBpxazkK60o=
X-Google-Smtp-Source: ABdhPJz+eeYhd7w2XvvetZb7mre93Y9cmjulR3DD6glWrjV7AwxOAX0G8IAUIEibG82P4FmFQDoMSQ==
X-Received: by 2002:a4a:5253:: with SMTP id d80mr14077274oob.52.1622600641848;
        Tue, 01 Jun 2021 19:24:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm4311061otf.47.2021.06.01.19.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:24:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:24:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/177] 5.4.124-rc1 review
Message-ID: <20210602022400.GE3253484@roeck-us.net>
References: <20210531130647.887605866@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:12:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.124 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
