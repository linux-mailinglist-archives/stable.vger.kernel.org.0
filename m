Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75E4336AF2
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCKEFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCKEEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:04:53 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14DAC061574;
        Wed, 10 Mar 2021 20:04:52 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id c10so17733688ilo.8;
        Wed, 10 Mar 2021 20:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YHQDPJLlBCHVTwjigC7ZPwhYb9aYfT9a1b5eWJFDzVg=;
        b=FmP3qbXwq2UV+dG9BAkN6yO7CdohLpAuFabmpMm1Drvo5ynjBRjLw+d/JLfCMpQyAC
         AYULwojgrIHSbToO/xeZGEA6n9xB0Xsg8uwS6Am4L7vFrWSkdmW4o0En+vZNzrSzKTDj
         RZBthpXJ7Xxu1NwaZNkpS2R8N+Eeb0s8eCcPbxHIeREzYVyqXmZz79VokdtoD+PReXse
         Lq+f/hacr6hv2QG3QyNEnQa1GqWa1OZgHtBLoZYxQwKILwwXfIp7/Fk4c4yVoPfc2Nig
         rd/lqooutd0LnZ299XIPBV2+BCtsEH8VlReNAHrk5CwuF6rTVIQ1Y6pzdWksInhM34vZ
         Y3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YHQDPJLlBCHVTwjigC7ZPwhYb9aYfT9a1b5eWJFDzVg=;
        b=rydlDrQB2iOmvYxZvOKPWYJUTV/CpQbj54C1x88LUJaxoPFMx/cUzUT/nnA5ZCB/Fb
         N5rKWCfKvNCoEw6Xm9OD9Pcwmm8iR2JSzTQAyIyJ5YdLqDmhL+Svjbv10gB911TElczM
         D0rtm2jrIyy7ua0Ty/8MVYNq9nuDzPc10q+yPONnnmB7ZTzeunzEN+Iu/pb9rf7bjJCq
         9DXnBQ7+NBtPk5ydLeDGAng2ZR+w0oVsT/ii6+3RHrDK62eLZITZde9suiNCqw+w2JZL
         dC561XOpphsoa1D6w35o+SOuPfHTjMgwbLXR5PFHB6Q0tH5BNyY6xJP53cRsrVDjqpys
         oePg==
X-Gm-Message-State: AOAM530NviEf0VskDfFuaGV0o3T39OdF03XljNlocWHWUmDdrg7rbCAx
        +SkIqyBn1V/SX41ddDnAqJM=
X-Google-Smtp-Source: ABdhPJxtWu+YDO6s5jbTZQHamDMIo1K6GRyjRSwY9THaCIl0mxldDS35BIfpS3d1AUIPEyea6rPJfw==
X-Received: by 2002:a92:dc50:: with SMTP id x16mr5348515ilq.281.1615435492496;
        Wed, 10 Mar 2021 20:04:52 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id y18sm766648ili.16.2021.03.10.20.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:04:52 -0800 (PST)
Date:   Wed, 10 Mar 2021 22:04:50 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/39] 4.19.180-rc1 review
Message-ID: <20210311040450.GA7061@book>
References: <20210310132319.708237392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:08PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.180 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
