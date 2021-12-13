Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99EF47354E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbhLMTyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhLMTyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:54:41 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B3BC061574;
        Mon, 13 Dec 2021 11:54:41 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id t19so24651203oij.1;
        Mon, 13 Dec 2021 11:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/Npc7J67RGYo8d8AT9CSK7CaRiC1ooSYYChmLfo6qw=;
        b=aLGRd/I3OrPPbjUURu07Gw3Z7+grO5PZxgkWKu5Et9b6noLQ9TikiqbDybCbF+O1U8
         bvhE3rljlAg64XwUwEa0JYG3uxLVnijNeHXpJd9hO6lZamODgkVZt8xWuLDkMxsZW9/u
         insQOgd+51oUXKzw9Ne5AYyhyDqM4vID8/c68vpvTSEpFYCehPQIaQmbwEcXuJ+CyCDN
         4C0Yd5dpDoOWuOveQSvrGk9QbNMJA70LYR+/68Ht8Y+Qw9+mFd0u63c42NfPJXEfUzH0
         9kWUJ6mR29fJKEZEgKCZSHWG1ivxKyjX49hiJ/L52aWtSzpHG4FBVnw7GlfD7LEBumV/
         BYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=l/Npc7J67RGYo8d8AT9CSK7CaRiC1ooSYYChmLfo6qw=;
        b=HYpx1MOU5MAdD0mEZFBwsD81kzX0YYGkGosdyc8TwUGb+W5T0QJiTjHJ75avL47zMX
         sE4+NdOZeL5ZpAuZmatfemWFuNFeOEnJyAy1vWMUJCRCbYhqS6HHPt8huVZLG0uzhIn/
         rj8Rsk6g/1IR4+sDDuw0vZaQ8JHs7fFfK7xQDyZg5/WgzjX04qaKbNOWdeoowYC8UL4u
         d+3w9BdWQsJOQojwH2QHss3c8P5PIbKtSTQ35ivG9iAzTwkd/NkD0El3sMGlkEI9vTC8
         wxqQ0XDiq7PhnbNeeY0VuTNGz/5H9syAYgAc3QGjIQzvonf8ozeDewdArtHf13mnKiTN
         22gQ==
X-Gm-Message-State: AOAM530AgrdHwBILb5mqPeNNJcCOBn2rGq6oPbpdp6YF+3oglK8PuPpb
        EgnTCLNwiI+FcghJPuIYSnQ=
X-Google-Smtp-Source: ABdhPJy3B5f7MtQnnDsrrLnkWOqx6sxdTDIWiQLBIyal3McYuStE9lJfQi2zjpZgZ7ojta6B7TG49w==
X-Received: by 2002:a05:6808:3b7:: with SMTP id n23mr663019oie.160.1639425281033;
        Mon, 13 Dec 2021 11:54:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm2354091oou.23.2021.12.13.11.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:54:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:54:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/42] 4.9.293-rc1 review
Message-ID: <20211213195439.GB2950232@roeck-us.net>
References: <20211213092926.578829548@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:42AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.293 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
