Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08D4A2AD9
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351944AbiA2BGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351970AbiA2BGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:06:04 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E794C061714;
        Fri, 28 Jan 2022 17:06:04 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id e81so15618318oia.6;
        Fri, 28 Jan 2022 17:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HS7b+IhNb6O3XNmfL+vuTDNX3POyaLtcEaiqHxEgZ6s=;
        b=Rj69fY3QxPPkLe3Td6wWHFb5+Df/IT8RB0/ADuhGgwZItpO23jpBCTIwF5X01UyBQB
         zZpiTlrfHtm6nUhh4QiVjSBpyZri+4M9rHTvzJaeR5DrkJAd5tXJyYqrD2DpR5UrZjSt
         vfaJDLMoydSQusuuhgUv2BjJfnGRia6+z6nVr6//EVGvzeHcJhmSrK/4hRfpy/TaFusD
         b7mCtNz3PADYU8Z+1vA1mDj1t9L2Xo2aZrlvN9C263xNGn29kf+EUjXQdGDmFHGnuLwU
         iXzKW7h3p315kcrBN68mrI+dTmSzg90Wb9TCkhxcrIuIbanoJjf3wH41HQJ+fs4vnDFj
         DZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HS7b+IhNb6O3XNmfL+vuTDNX3POyaLtcEaiqHxEgZ6s=;
        b=JcLIh5773Ca7dkjnXOSR13eSSxooDaETciMHPbSoqxAEQT4GOesfUDOv7S/bHNID9I
         99s6LacLBS+YxpCFmf0fOcfxO1bSbrXVn63jx4lKo6dLAam9M0qS11nMS6alDX4FZ5oD
         tmy0Om5nPpI5TWsbQsRn1kiKp5n5S6IHZyptFFnPAidM2rczz3rW/x4TZFjf7ogtOq3W
         Ki5g4fc7nAKraxpOdEBf/Tegnr5GUcVXWTQaUKZYnmiKodYqaO6lC6VQ3ceN3JhuOweE
         PW5rehtUj3ixnUuNF2Cn5cG1mzzBP4dx1BJkf+q6zQ3MeFyHpz+3MhqVGU97lJfGjFxu
         56AA==
X-Gm-Message-State: AOAM532OCoEtCvdqhuJIQ+QXzCf/alF8h/m5nu2kh5lQKxGXh/yrZooc
        eshNrJU2cU0inmuewNgBwwk=
X-Google-Smtp-Source: ABdhPJwmCLvRWt7XMJFRix22XZbwX4ULCkVhOu2C4hUeiBkDuBpYgjO4jRzcXF+I+tdsB6pKjybZBw==
X-Received: by 2002:a54:4110:: with SMTP id l16mr7042481oic.114.1643418364003;
        Fri, 28 Jan 2022 17:06:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e20sm13883020oiw.38.2022.01.28.17.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:06:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:06:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
Message-ID: <20220129010602.GD732042@roeck-us.net>
References: <20220127180258.362000607@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:09:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
