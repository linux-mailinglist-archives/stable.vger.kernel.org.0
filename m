Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535B14839CE
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiADB20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiADB2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:28:25 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064BEC061761;
        Mon,  3 Jan 2022 17:28:25 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id x10so52397403oix.6;
        Mon, 03 Jan 2022 17:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2s3Xia69ToEZXWF2oaYuHywBfL/h+QQpntwwVrGooXw=;
        b=SlhxKCHBG4h4mO8bb5UzaK9gie+KMraOa0yJBVxvHZJr5jtnECukCCErrH5HYApOZm
         i3WibC+jRY37UqXWv7ZRBfnPvE2jNAvnGYpXT4HJ0hLjTP0TKVjvgckaO2VgjpzVob9T
         5h6zAFHx71nWf/rYP6sCIf9+l4Ewj2qM3udSoWLeQE2pbODysqvit5ZCLE3J+1MUHIdA
         boqDscEcKzqp1dfAozIg8AFNH3T1vm1ibkB0kNLuLVsJjMfnlK6xMNIbY7ZcDogsKU4n
         WShVbkTn+FW04E/KYqBIvu+y3oHsAcEhFTW1Z/IHAT3M66pkqxWFNedEqbWsU09hwhtW
         GVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2s3Xia69ToEZXWF2oaYuHywBfL/h+QQpntwwVrGooXw=;
        b=LN9KPmD7QB6K/dq2Fc3wSqxoVKP8kmn25USwux4jyNlwT6q6N7TNAclRJndTP5re70
         AA+7t2tfcrcEa31KbE/UpaTqCjN1yNRXGUBGHJ4hWKlrFF87WxWatvfSGWUgdeGPbeNE
         RCp1qyKat0SXAgDr75znbFWPoNUtImBl/YhRnSBhoKuF4nWgH5vcn5a/kagKB/D/kw/l
         Js+Efm/QnhfjrWjwaE/4S1SOFUFoVI/zWIAf4U/knkkcDPjiHgwSIialTtyhGP7iISxc
         XSALn/zvghJkxSvNj+X1G5QCiVsqgngnnFPS5Lhcfk/ARcqNaNQhukzsOl/Z8yDPgUPd
         x++A==
X-Gm-Message-State: AOAM531/+1liK4FeMu78U6biXIXO0if454gThsuWeTjSSmtrDTFcq4/J
        s3mennzQB/Y8NpgdQgNv4PE=
X-Google-Smtp-Source: ABdhPJwbEjc1jsTzV+nAS9iTZCyYJ2scbSI3kMRI/vyI8oW7j7ojSO2GDSgsSAb2MngV1lUGs+enEA==
X-Received: by 2002:a05:6808:18a9:: with SMTP id bi41mr39267282oib.48.1641259704462;
        Mon, 03 Jan 2022 17:28:24 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u40sm9523135oiw.56.2022.01.03.17.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:28:24 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:28:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/73] 5.15.13-rc1 review
Message-ID: <20220104012822.GF1572562@roeck-us.net>
References: <20220103142056.911344037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:23:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
