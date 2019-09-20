Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111B4B974D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 20:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbfITShl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 14:37:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44076 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393049AbfITShk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 14:37:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id g3so2721793pgs.11;
        Fri, 20 Sep 2019 11:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J2C+dBzI3UxwoL3UAzMkus+mtjGPJK3WinrtNCr1glg=;
        b=YTTU+b0ECyUb8fMsnmHgGhnxmCwkKoz234/7ztVVvi8x7eTnCs8o93uo2aniJ1e5A2
         zTUXf7DL3W5RbcdB5bAJ0S0EzEIsi0pJLzYb6TWt6YtbbOUceLgevGrDKtbJ8kdiBHcm
         H1x68RkKFOERgSg8lxU/bSzZe8eDebNbzOJxyT2wH5R7Q3dOujmM3oSK8cBnd0kwa2O5
         Hob47Ytojd4L4vvvQC9TvrfsmS7b5aRkckxAcOzyQbkQl3mVfAJ/HIoyyH/pQXOMbn4w
         CXCl1FciFNqQ58IL6xA9Jm9agD6yYd9Vj/36UlFphadHaQraGNOROvzboOIUs3CatIi7
         +06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=J2C+dBzI3UxwoL3UAzMkus+mtjGPJK3WinrtNCr1glg=;
        b=Uuo0JBPl5IqXRGtfYkeOqmzJzjvkNyPflGECztVnMjBR9Tfs9vg5Gqep3tckYx/9Qv
         4GPFhbKQ7wxUHS2c7ZndaUDdNcJd2Ps9no78mQkc5i2JowwTrT7QAp+T3gcAdvBYZNLj
         eQNT0ArtSdHsoF75Qo7ZIc7l8Hq7ZgvLvwMQ4CSW7z1FEESJhxzFfauIB+5PqKk2txQk
         DeW3r1/UHIThmACiOgQXU14TMBPv8YFDSkLyo3/rMFiFt7xcKd362ELxelJFaLvpUZj7
         Rvcp1nYFwNSJ/9pjlFUCQvWqreWTgCWapDx2jL6QdFv0OfO6eirB/pB4iuN5dcKFF3I8
         3DgQ==
X-Gm-Message-State: APjAAAU/fr5ct3dIZDRPARRbntt1bfNo/S5P67BRrxiVPUFsji5Mgmiw
        hzwELLT+IfLQFxF8RCV9P9Y=
X-Google-Smtp-Source: APXvYqxhOoWvJbaTL1OG8cP+se6ECOvgAjHsxTc7MymRrcgPmdDh5ptXsFcSGCd+3oRKpLYtYdfGfg==
X-Received: by 2002:a63:5807:: with SMTP id m7mr16522288pgb.371.1569004660144;
        Fri, 20 Sep 2019 11:37:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q88sm3191832pjq.9.2019.09.20.11.37.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 11:37:39 -0700 (PDT)
Date:   Fri, 20 Sep 2019 11:37:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/124] 5.2.17-stable review
Message-ID: <20190920183738.GC22818@roeck-us.net>
References: <20190919214819.198419517@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 12:01:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
> 

Ok, here we are:

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
