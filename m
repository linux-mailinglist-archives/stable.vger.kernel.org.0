Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25514388201
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbhERVUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhERVUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:20:22 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DC9C061573;
        Tue, 18 May 2021 14:19:03 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id q6so5743160qvb.2;
        Tue, 18 May 2021 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NE7MehZ3cnf48W0y5DyNbLG5th3aneIv/zQnI0Su8/8=;
        b=HG3dfUvL30ZKhTEyiY/xo47XeUq+622wqmOd2tmUjG79cl3jGfyCgrIY0VoNKDUDH8
         CA8wp/L6hmcTO6cae5A0Eg5+zPN+RH8qSjSbar0lXuCNoS9M+UgeGeY14cI0fX3U3yPm
         mRwrHCQOeDwc1CTl9LMJD7thJn0U3of1i9qoaRfoZ4Vu2zw7QB1W0AVq704VHZEVVeox
         +VC09JzOEJxNMEF9kN90VFiR4Z7QZhWw7GYxjDoqcWxj3PEMID/WkBWCs/vlGXZDFUX9
         aU7CQ/Ef0goO8d3xpKBxjETghVHmGIKuOOSe+/8m75D+aQNg3UpnSGxNstV0BpJLARnm
         JxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NE7MehZ3cnf48W0y5DyNbLG5th3aneIv/zQnI0Su8/8=;
        b=mztwVfV1grE5s3yV2pe/IlNUNel4XU/Ab7GDJPT5cCNHOD10oKehPy8FO1Y481a77/
         UK4IoWy3vlDypRYl1RaAjTjol9/ObVSeORZjNOwhAgiZau0PdJYDdMpKxflJ2nw9bgR0
         iFbsCX+WVsXkjeeMl+p2Fs3+JEC8IX31LFrWirPxfTI4HiFTadgoTm+XPw91sWFrK12r
         hs+4MzSF72LXJlm+4WvwvcZPfdnrzJVK1df7+CGI0Sr5c9/0Sytqff3GuTAfHrIBxPH/
         fNxDJY8qresjtQg0VyQ+TVjW9DMOypgh6cQxi0Y2gbTaiUImZg6u9ooXqXkfVPhlYd9d
         BjdQ==
X-Gm-Message-State: AOAM533R0cX8CpOO0SCpqrvKg9NyPStZ6bX+aR4Qb7KqyWAOu5V/kbjA
        C2zNqqE8UndNxDXJ/2OnZvo=
X-Google-Smtp-Source: ABdhPJwXp9Tijg0g1GrpN7FBxp0NHUymEa/dvuklf5/x0Sq5AkKNgOrFcWrLZWxbmL3Hhn2Kyk6vcw==
X-Received: by 2002:a0c:e1d1:: with SMTP id v17mr8563818qvl.52.1621372742816;
        Tue, 18 May 2021 14:19:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m21sm2391882qtu.11.2021.05.18.14.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 14:19:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 May 2021 14:19:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/141] 5.4.120-rc1 review
Message-ID: <20210518211901.GA3533378@roeck-us.net>
References: <20210517140242.729269392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 04:00:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.120 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
