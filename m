Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8087E14F2E9
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 20:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgAaTpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 14:45:06 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34771 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaTpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 14:45:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id j4so4012329pgi.1
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 11:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WpGTs6wk68o47CN1/DRt9VHyowucU6UaB1AMmww7rZI=;
        b=jXDzOK3WCXpHkL9Q8yGzO1v05N+a1wZmEMIs6Zs1OkXpjU84OrlAcFMSnYp6wrZ8Cb
         +zXQuD/2Ok9MwT/Q1XYe9Dv8p2KzZg+WKqAKjrvjTpiAKYOPqXhdffHP7mcifqQY5UrX
         +K8N5cHatjM76/sfcIEijjaCMjlh6oOsBX2TazP0V2quD5fYEjtCimihD2TiYkoHvIwn
         LSA/FSUQyQfD/o9wvabHx3D2BP4c0mjcjZuc8O3aWBrefyeRIcBFpu6HizjWkdjaTy/m
         TP0Wg3MSfF9XSSIm0ciWIw7l1v/yo9zxRaLUw2qU6Sderdkx35gx3qpNMNzxRgTlftgZ
         dYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WpGTs6wk68o47CN1/DRt9VHyowucU6UaB1AMmww7rZI=;
        b=YgYGFBtxnePc+vR9GxTcCk1zNplncN/8jv/fretQ5REG0xOTHfR0I0KNnoVeX/kKz5
         RfbyJ1uIwAsRBPYj7RSAgXWfvx1Or/CqpPtQssswl3YAWKN0Cudnne/vHtA/0yfS3mCZ
         dtBbbq15Jp0eyqwS2iAmRUd5TjmiOCJh+soJUjjJ4uVd5JC9i3XoldAeAaDJPVvZWKwy
         fwt8IR1FSua1IJoiSVzd5yMzCSwuSM176X1pm3KYoZxArg24Vyj5PV6QtG/jcdqk+4EY
         SEtiF0l5vPwBoIDOLJFQYKlya+rLkKjfj1/Gi8NP5kIKks2jv1P1dw4UZo4Fy0F8sS5w
         TjQw==
X-Gm-Message-State: APjAAAV5H13KubdEitOImV1RSiPMhAOf8+B1KGS9bYO4fsYXbAQ6XaGl
        7cTWfT2vDviwIBfOFuQzqcpKShh444M=
X-Google-Smtp-Source: APXvYqwZQP6nu2iuJWmR5ARlc+7fEa8aUWut81icyjcwj3Nzbu+8zSs8Vo4SfGnmQkvOx3sf49K4xA==
X-Received: by 2002:a63:b141:: with SMTP id g1mr12596332pgp.168.1580499905186;
        Fri, 31 Jan 2020 11:45:05 -0800 (PST)
Received: from debian ([171.49.162.166])
        by smtp.gmail.com with ESMTPSA id d24sm12299704pfq.75.2020.01.31.11.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 11:45:04 -0800 (PST)
Date:   Sat, 1 Feb 2020 01:14:57 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/110] 5.4.17-stable review
Message-ID: <20200131194457.GA3818@debian>
References: <20200130183613.810054545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 07:37:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.17 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

compiled and booted 5.4.17-rc1+ . No new errors according to "sudo dmesg -l err"

--
software engineer
rajagiri school of engineering and technology
