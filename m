Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB703F8814
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhHZMyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237352AbhHZMyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7970160F39;
        Thu, 26 Aug 2021 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629982401;
        bh=yrwb4uEntkRQqJ994a3jggnAuLx+8oGgYb2dSY88G9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pAXdtE3h8p6rivPFcuXNJocr3hJlQq1RnTKy6zGRjS7ADvN4KuCO22oC/uYASuW/C
         22T/8U+iNfx43/9g8BCgQ8UBUt4haOSuvjrI+SApX/WL5U/v8PTS814+e4/AR6X2TW
         054/a7icB+96GCj3o9Yg29Yxhn2hP/04HJRib6F8fxIw3Ru6XHwNnYuAt1Z4D7btwT
         OBNn6UU9qmAPcupPyC/QVCoi4DbEYknE79F7H2cAzWY+n3dP79LafO5sg7o5BSuAa6
         Nz4lEvkFBp4mZLrWvNRWbe0CxWNS0iKk+pdf4zUvkFVvVgtQ1KoSOIV6rRJiO0Klt2
         zjyxExqhmzPFg==
Date:   Thu, 26 Aug 2021 08:53:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 00/98] 5.10.61-rc1 review
Message-ID: <YSeOwH2YzeTDbg/p@sashalap>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210825073527.GC4193@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210825073527.GC4193@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 25, 2021 at 09:35:27AM +0200, Pavel Machek wrote:
>Hi!
>
>> This is the start of the stable review cycle for the 5.10.61 release.
>> There are 98 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
>CIP testing did not find any problems here:
>
>https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
>
>Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing, Pavel!

-- 
Thanks,
Sasha
