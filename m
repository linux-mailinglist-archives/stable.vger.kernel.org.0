Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD17354656
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhDER5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDER5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:57:12 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C799DC061756;
        Mon,  5 Apr 2021 10:57:04 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so12131964otr.4;
        Mon, 05 Apr 2021 10:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xf7Rke87LQtzOILKnwVnFusYRpDGPD7VNdKPVRn0pzk=;
        b=h5g7FLp56ZWJFMcwHtuTjwKm5uoXpf0JSVylHgU3mJESyCfICaRIjTVkJpXVta2U5B
         gEuru+69oRrILDyws5q+ZT8xQkusF3nzRnlhc9b81zhjPj+tJPgiEh0gZPK3o1bSFIos
         VeLTKSvQ84RZW2xpm4XDWO9GwKelEwCSS8mcWSLI8kwx0Rqz7O63wsR4SJMw2qWZXyqU
         VncmIo3bUy+M2xkVTN8vNLHoJhBpDw/oYINkPEw3o8YZOQ65n55yQj3SmCWQd7ta4kqI
         EQvM3mnl5FgEQrjixjM5YnUe9zqx1xy14hT3j38QXvHhiJlWTcZ7eG83xqMvMql3BY/v
         XApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xf7Rke87LQtzOILKnwVnFusYRpDGPD7VNdKPVRn0pzk=;
        b=SzQXjpoIZoMkmUMoCSbcF8676D3oR2XzW1CiLXqTB8Uu3+FZJajGR2Jv/OOpdfttGi
         4E2KqYrvmJjr2oR1K1mL3b5qrg0fPrVXUcuNPwCpsti/BAiNmJWnNBMJw6y0HUq09RCD
         gByeO53btW9BmnT6QO/BwRkJVIHEfipsZytYrEQUqhfnV03TwYCl5J4L/GwD5B+IGwvT
         sfKuaeGEYip8UK6mgaD2cnzimgSvlSp2cJX7N7Q6yvqDGQ8PMjVHhR7cOyZxHjPf8huI
         Vz6NY+zwCaKRT5Od3cPhEfJKgE/3B06NR9rCbln7VmlJRCZc/bKlKtJYaNDJkI5LWFqG
         UReg==
X-Gm-Message-State: AOAM5300XLDm+2hO/Fa5UHqENabahpuJ8aoKCcZGYYlB8cuaaKiaxJ9U
        OgvhXRjAgUXXsn+d76UpfZY=
X-Google-Smtp-Source: ABdhPJwbXtX+o22Z3b220ogwx2Gi9sv/adNywNB5n5lsyho5kER7F5o2GJzhhQd9zZMGNHGJrzY+2w==
X-Received: by 2002:a05:6830:1e51:: with SMTP id e17mr23283361otj.292.1617645424296;
        Mon, 05 Apr 2021 10:57:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u11sm3261371oif.10.2021.04.05.10.57.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:57:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:57:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/52] 4.14.229-rc1 review
Message-ID: <20210405175702.GC93485@roeck-us.net>
References: <20210405085021.996963957@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.229 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
