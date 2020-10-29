Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D1929EDBA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 14:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgJ2N6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 09:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJ2N5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 09:57:54 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBDEC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:57:53 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id g7so3056501ilr.12
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 06:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l77W3XGVv6Fdm9/Smjr/6C/TcdaaBfmJqErnw0+vZCQ=;
        b=ftsTylih8sWlJN734jeGFKiAeMI5g+mfWWIgVuYHxOTkIB+MALU2ze4YWbsrg73PNN
         VHqCg1u0ZFqnD2zCyRpPsp68xO2jX/SmAT11cP99OFAxplQOPjXGU4mWECx0TS2OQCgQ
         CCqrQPuj96GFG1lgYrQlQogUnkGIMPwTLODD20HxOM/zCYX62BgWB8N81hX4wHOR3dTO
         8Hmr2kZbaG1eusZaxC6I5p9vtYd5JedGe0hTWuzkSFEqVYTpGoeolBf6JCzpd6Kv9EBT
         Gphn9YIS8Lso7GGBdU+7f6OVHXuYHSrvoMeop7AXCR6WavPmhfhGYcfShfzzmBid0eKH
         gH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l77W3XGVv6Fdm9/Smjr/6C/TcdaaBfmJqErnw0+vZCQ=;
        b=ek2Z/kixydffB6k3P4E4wzWJKE3elQJILGuZaRvcOELtIdbwHD1OK4cgaGCmutzdTJ
         CisG8aDTP1N7lbREcAKs/p3+TMEjrlzj3Io5MOdK0o5W/t95JeWOm0fS7U36w9fN3Wvg
         /WfeDogHciuhG0F4t71Jnmh88yzIq28TWZ7T0HeAJhWxEF9y3uxq9/kALx1g0edN2qoT
         pTNsdZZw+ULO8AiQT91jB/BogJP7dEmU25J6NUqcNcLOeySLQhkmTcZ5IRH71FHTTbZX
         hQBZceVLUbKDtEWXi2DksYfid+NHS0ap4PHBkB7SRx8ucGazpa+enY+1UUc9BG/jtGXV
         Yh1g==
X-Gm-Message-State: AOAM533+bH88F6EmCdLOLCkBkfmGPxgx+lfdh5xVxQW6HSEuNOyHEJ+I
        wRX3wAiVhvuY1vZvi7HZS+yrfOUJ+1h3uw==
X-Google-Smtp-Source: ABdhPJyo3XA2DjgRVdz1X6d46plFWYn0m8y+rV+MvGDqWv93YC2NGHDCLtPiy5FSgQJf8NDFsiXXEA==
X-Received: by 2002:a05:6e02:ce:: with SMTP id r14mr3454556ilq.240.1603979872189;
        Thu, 29 Oct 2020 06:57:52 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g1sm2343953ilk.84.2020.10.29.06.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 06:57:51 -0700 (PDT)
Subject: Re: 5.9 stable inclusion request
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
References: <115609b0-9167-dfda-85eb-de8d87f33e75@kernel.dk>
 <20201029121955.GA1620833@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e31986dd-3a69-3997-10e6-6ab554405a47@kernel.dk>
Date:   Thu, 29 Oct 2020 07:57:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029121955.GA1620833@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/29/20 6:19 AM, Greg KH wrote:
> On Wed, Oct 28, 2020 at 10:31:23AM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Please include this series of patches for 5.9-stable, thanks.
> 
> All now queued up, thanks!

Thanks Greg - for this and the 5.8 series.

-- 
Jens Axboe

