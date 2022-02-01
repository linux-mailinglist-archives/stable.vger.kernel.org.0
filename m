Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259484A55EC
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 05:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiBAE3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 23:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiBAE3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 23:29:49 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA9CC061714;
        Mon, 31 Jan 2022 20:29:48 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 4so6576952oil.11;
        Mon, 31 Jan 2022 20:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uZzsabxfrpTClI9zTpvQQ28E2VWNJwP+ovfNK5T+140=;
        b=LQnSIol4Kd3HG6XKcXxM5Ju0u0bXDIH5tPOo+togIat+LvRvl/0GIKmRsGRccTHQA9
         /P7mFHgvQfkq/sYp1VMPsp1xaYYC0mpRIsIxD7JFOND+Y181N+0+KNRt9C1wui4kLEeC
         JBYkLBGc8VX419p/7HzqkVflMHrKRi8GvVnwdCGKBH+woqsu9miHWH0BBnlatOvybMYD
         ZqgYYp3svKuqXrCsb9B6GRORszTHjC7FAYBZILxROqO73c+lqUyohODVlYtg+cAmmxon
         bY8pI7y14B0SyyLGhjW/NdJEUTYTwaNw8dAIHJY1jyLsCm8QW5pkYey34LunGaUugM+v
         L5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uZzsabxfrpTClI9zTpvQQ28E2VWNJwP+ovfNK5T+140=;
        b=3LgB/2818B4F/zkmzADvj+cPlN2YY5Bd9xDN3WovcnzXQTa8KpEHUW3U8C0LaVpOq0
         GXNeDUPeg7+GW1Ww+44VYp09G4qicSPoh8enJgS53DEFJQqxW8IZ8fwBjh9uB6UWuLs7
         M/oYoSP+T+jxWWgWmavwc9cQBFiOI8ZdXTXo3//HaPzMvLxyKiC9T+dkNMa8NbsF4Wpl
         DeX3VwAo6e00Qlr0ds0q2Rp2yPkzgxC3v36Gk5W+xvfBd3ww0q9B3ooBOkoR0nVWwG7k
         sPxe0fyFcJd4DsD6oS2HL8jM8TOjDdTa61lT8byYTeUKVbLsrbjg89u8ndUyCGizbvq4
         Z+bQ==
X-Gm-Message-State: AOAM5313Kjy7V9T6s8jmLPGqpnSoIzH8WomMxaDL3JgXKdFUp9liAFZw
        OlLOv9b+AxFwWwESReTwMts=
X-Google-Smtp-Source: ABdhPJyeM86SqPJnq0kr/6xlE5nUtZWmo/F4Tpw10Wen7B594C6OQnV32/d2otmMTRah3SbUAdBvNA==
X-Received: by 2002:a05:6808:ec5:: with SMTP id q5mr129374oiv.318.1643689788359;
        Mon, 31 Jan 2022 20:29:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm15939323oog.43.2022.01.31.20.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:29:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 31 Jan 2022 20:29:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
Message-ID: <20220201042946.GD2556037@roeck-us.net>
References: <20220131105233.561926043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:54:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	powerpc:ppc32_allmodconfig
Qemu test results:
	total: 488 pass: 488 fail: 0

As with v5.15.y, the build error is not new and fixed with commit
33a0da68fb07 ("mtd: rawnand: mpc5121: Remove unused variable in
ads5121_select_chip()").

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
