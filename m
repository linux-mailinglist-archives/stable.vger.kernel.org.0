Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E7F12F8C5
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 14:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgACN3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 08:29:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36965 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgACN3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 08:29:19 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so23565017pfn.4
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 05:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9PDoDHTv+akQfxBnieWWtMmxOAv8OLNpwPLZ2uZv8S8=;
        b=hgeeX6Dp4+3iH//Ux/hUj/VZVth6IxQ6WgawPMCE2hJGon1hfy+luMyIROkqDbMJVA
         bVCB6Jhsj/EpEuTaIMDVN3DyQiz7vDttLW8xxkIgDHACeWUtO8zRML3DBsJnB4Wn2HZQ
         3HJlRyFjYNCNIAKJAxwvOlTKuJ0L8u8jzfomOwiMGVFOdxueTS8E5JYSIXO0dnbfbWHC
         enhI4D4Cm0pv3NlLv1u5hiNQ7KKjXyuRnTdvW+UiFs9svIcqE02H90aYvVnv1/jA5VL0
         Vr4OSAfaeezX+rW/rAMqdA/C1pLgJRaOOvHnJnF6TyaTP67yheT4ce9pdl4AiuL3Q1f5
         SXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9PDoDHTv+akQfxBnieWWtMmxOAv8OLNpwPLZ2uZv8S8=;
        b=A+fjBY7j678n2db6Av51MIJ9n9ggIRtiMpszLCzAQgFrwCLP2XRJ7OoavdFlpeproj
         07oIwbYvmT86C9ckogzqa+mPdZ8m7TpploMcekx9JCNAS8sAmldfVeO3Iy6D92R9PJuJ
         2+h7nhcl2YaAF7enXOu+v0Dm7XfWjdJ/LFwlraQIxh+kRvZmrvsIBEhhLR+/LJ3RzL/d
         9NmrEG/IlaOJgeQNBx1/jpwKMIWuMa1wmRNDaEP5+z3XBEL0nDY9R3M+Bz+MZjTp1w+4
         3C1zW8i8SPK268BYL+PtHCVjZCEB4ngyABeqwKfv8OcXfBLhQQa+H/FKd1T5YmwPHT3y
         vNrg==
X-Gm-Message-State: APjAAAXk5j0v9wL3PQvcG3qmp4mrMaWXhE7NL03oBKgWeL0rLoTUjEc8
        33TWTo5tPjJGCSHmLrXPP6bzmQ==
X-Google-Smtp-Source: APXvYqzloO6lU1/X64uJ/4dfnoD/ocWE+7Rv18qaZfW6WHZn15AboeSrG1wkxTVNoHW7zJnY0XhW8A==
X-Received: by 2002:a65:55cd:: with SMTP id k13mr92550692pgs.197.1578058158331;
        Fri, 03 Jan 2020 05:29:18 -0800 (PST)
Received: from debian ([122.178.22.49])
        by smtp.gmail.com with ESMTPSA id w131sm69647124pfc.16.2020.01.03.05.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 05:29:17 -0800 (PST)
Date:   Fri, 3 Jan 2020 18:59:10 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
Message-ID: <20200103132910.GA6212@debian>
References: <20200102215829.911231638@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 11:04:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 

hello ,

compiled and booted 5.4.8-rc1+ on my laptop. No Regressions according to "sudo dmesg -l err".

--
software engineer
rajagiri school of engineering and technology
