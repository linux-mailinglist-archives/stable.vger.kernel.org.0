Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BE7480BD3
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhL1RHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbhL1RHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:07:31 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA9FC061574;
        Tue, 28 Dec 2021 09:07:31 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso25136218otk.5;
        Tue, 28 Dec 2021 09:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QBgyaZn3deOyJJo5DvNIWrAkCZNqYnnQBmqRN+1ITEA=;
        b=ECv5OgiBnk4ZOIErLMR3OxRbm84QPBRXBCh+Gx9zlOJvBat8qPBvf46iNPD+KoG4JX
         TMEqDiwChLyHqPIPN9mbQzowrTLKoVcanayQuJMxn3NJXVNW9rsZFMiafkjR0f2GfwzL
         B0vrkGY7rgwXmyFugUhRlVGy7Ym5z/ndtBBa4sPfnGXHibeMI/byDb2gxmgikhWpZCqE
         7sqC3u1ZzXxhFsPAYcYwwcWnt5VxI//EwH57GYFs/CDJcbY3PZnarkoU3t+FPvAKxyzv
         GuJ32Azxqgd6yLCLhj9+zUOcGzmM2TdeqQ54i2YjRlv23P0HEXrSjNpKMRuNwBh8U0OF
         FReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QBgyaZn3deOyJJo5DvNIWrAkCZNqYnnQBmqRN+1ITEA=;
        b=opqTeDC3vSeyxoxfysO32Sg869Czmr227BxD5L4xsfHQyUcaxteKtoEYVLfBqWcrL7
         JNd3xHDh3ci3xgVyJnuDlOUJVsFEknFkg3dDKZ88MYe5nauVlAKNEUFV/xhmNv6C1Uw1
         YQwSdkubPcTn6mQ75CqsoJcl4ATLcO/u+F50c2FIzF/E1KQZbP4NAQ+/OCilDwA7egkP
         dytF09sVGy+aUE9VoUbtTP0U3h53A8f5txhcFFNUIkwl1BgnJalLjFBW3NHvnHQU1f53
         NuFKIrcbSvxj1AibvoRZT3DP/a/NxRZ9vS9JbcWnVtr5DbcoEJHH3wc8iRUPUo7AW4KV
         oRgQ==
X-Gm-Message-State: AOAM531/CC3D8SZws164d0bvpbGqgfFbkTRVM/lw0UweoRSozVKy05ig
        5NzdO4Ol7FvKDHFtzYaLH60=
X-Google-Smtp-Source: ABdhPJxGk067LrRg0hGgSN7v9mASrmIal01Pfc+qDR8e/P9ps3AP4Q2YHi16LHs1a0hGasJazE/WmA==
X-Received: by 2002:a9d:744f:: with SMTP id p15mr16031395otk.314.1640711250851;
        Tue, 28 Dec 2021 09:07:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u40sm4048568oiw.56.2021.12.28.09.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:07:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:07:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/76] 5.10.89-rc1 review
Message-ID: <20211228170729.GF1225572@roeck-us.net>
References: <20211227151324.694661623@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:30:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.89 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
