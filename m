Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B86390291
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhEYNed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 09:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhEYNec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 09:34:32 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44890C061756
        for <stable@vger.kernel.org>; Tue, 25 May 2021 06:33:03 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso28625883ote.1
        for <stable@vger.kernel.org>; Tue, 25 May 2021 06:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1NijBJLWzOf7MfUGRtu0KcHG7q+oxwZAX6VLEngnlU4=;
        b=c/K/RvqtohAAS/3qyptsUOoHKx9KFZiTING8JAWdWQ6Wme0hcEJ3b/f+rs8nydyx4T
         8loZZcslWFMqOZryzncfu/0Olf4HNuxnNwXf750nGpiROMj/wbAHtvG2PT4XKYFddzYd
         F3sVjY+TnBDXBCLWVZWvRkeebbXxGFdLeYvMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1NijBJLWzOf7MfUGRtu0KcHG7q+oxwZAX6VLEngnlU4=;
        b=Pk2XoV0MaZyyn+BQm65xQra//BoS3xPDD+H1ZDkg/JUcDcOzI1isaMdcAhNt5Izsae
         P8wwMIyzU/HXQ398Y5kc1nyjlbOD0W82eCXuO4ofwEKPV2QcKVEksmpsGwwLYa8HRZe6
         HugucmyVuuVhGk6Uvvvfsu9u0TQJm+EjZa7CyiDZZ522LwojI0cqIXZM65ciTeq35HQ1
         vU+PMSi6S9gFEa530G371xdG88SEhVesaS9q6rKororRtvXMiMFY3To8bDf5k8KaVwaG
         G3qrabgsAehGr6HXGU9Z7+sWY7wwJCKjw11Bwpd2GiUARSzGQhy4JHehRg/ugt6CgRmg
         mQyQ==
X-Gm-Message-State: AOAM53204okxqpU4SnOfpSmyGCyeOPMKmHyotIFpHuF2a9krIDibLtmz
        h5Zv3JBLVu26yDP4e++hAgbyDQ==
X-Google-Smtp-Source: ABdhPJw+NlPaH7XXWP9WQob3oBzAAY3ih0zd7OU74jzTF/9Hr290Kl0HTIntUuWTW1AbXBAOJQiubw==
X-Received: by 2002:a05:6830:1ac7:: with SMTP id r7mr22959654otc.167.1621949582569;
        Tue, 25 May 2021 06:33:02 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id 35sm3820474oth.49.2021.05.25.06.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 06:33:02 -0700 (PDT)
Date:   Tue, 25 May 2021 08:33:00 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
Message-ID: <YKz8jESbC7lHSfQ8@fedora64.linuxtx.org>
References: <20210524152334.857620285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted. Also had
several users test due to the i915 lockups fixed here, with positive
results.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

