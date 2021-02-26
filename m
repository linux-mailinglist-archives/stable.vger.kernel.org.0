Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3C325C19
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 04:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBZDpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 22:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBZDpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 22:45:44 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25334C061574;
        Thu, 25 Feb 2021 19:45:04 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id n14so8327699iog.3;
        Thu, 25 Feb 2021 19:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jcK+HyVnW4J2UdHEketOUxSReDTssrIxVux/9tpOAQc=;
        b=l+UvoFPfszLTV+HDyPdOihaftaaNjvWhKBYcvLysoIx8QQbeOCi9jtMq71vUa/wjBp
         fN61GutK5T7Sr1xZ4qFThtoadc5T8qzJALyynWeFPq72/tgO/WIqYtSsBCYQPhB0o4SY
         SjYEMd2FPEJrI9/r/p5e17q42czyterQmAHj/zTyZlWiDU/MgK6ZUaUlPr/+GWfoEjeI
         MKvhTs8otbzpoWuDyrSUhJi1qEyE5NAUxa21727VdA1z1YsVWuoK3POh9c5q37+9U8sd
         T5wwM+QrWfHdvsr3fSXdjugplptigQY5rUyy+CKdqn5Hy6KcWih569S4S0L2VGm0E9sR
         o9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jcK+HyVnW4J2UdHEketOUxSReDTssrIxVux/9tpOAQc=;
        b=tciunw26lOewzSKuyMVthRaP8WrjqkkCwXk27+vjvkoVETezAkGqvoykRLKqZAhn8e
         7y/cnPXRtPzN/5G7NWw1ABXvXqz0GNFjJ5zIHBgUBU0Cl0WK52JRkLuF4wATk1xNy17U
         i+6LtIw7KTjx602x9hwewrr72Pm9oMJZZ42tmpZbSzYkgnzxAQosag3aasubdjIwJQcK
         UjQ+AaC4mSzYI2mK39RJU9XeuDggEp/AdUJvpPbBYdh/2vDNxMM13T6gDxascnRbqBZd
         OVutuEILn0f/Umi5p2cxkheLsH+921vThAkKt4twPr8LM00MF26NiXgR6/d6sZ0zh0Kb
         lcEQ==
X-Gm-Message-State: AOAM530We1ij/kmu1oaE38yUz3PHYs/bD9oPLJyk428KtkaydksGcxCp
        PHDV9q7SK4rgU3v03AymsE8=
X-Google-Smtp-Source: ABdhPJzHY3i9qCAodzCmLqIVypF5aCloGPDEkUWDiCzwbfnC1nJVR6W+qsWw1oxrL7i3OFavWKgN2Q==
X-Received: by 2002:a02:b893:: with SMTP id p19mr1015045jam.68.1614311103633;
        Thu, 25 Feb 2021 19:45:03 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4121])
        by smtp.gmail.com with ESMTPSA id i67sm2120735ioa.3.2021.02.25.19.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 19:45:03 -0800 (PST)
Date:   Thu, 25 Feb 2021 21:45:01 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/12] 5.11.2-rc1 review
Message-ID: <20210226034501.GC5461@book>
References: <20210225092515.015261674@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:34AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.2 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
