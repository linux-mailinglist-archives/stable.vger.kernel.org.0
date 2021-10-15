Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52D842FE1E
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbhJOWa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbhJOWa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:30:27 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB555C061570;
        Fri, 15 Oct 2021 15:28:19 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u69so15101129oie.3;
        Fri, 15 Oct 2021 15:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iiKUuCI4L4rH4uq4zgJy24UHT2x4TLsFSUMLWLTJpEs=;
        b=Gzw/WsqUnlestSEuq6JKEPnnagJ7tuznG96GSf16HQ/jBng06CmjMXVXkSDJrAKd9j
         gJhtxHRIaAa/Y7QwxOPGByHmZG/qJn9fDir/Va6cFv4o2aYt9/A6rek0a4/90/CQYzpQ
         bpZ0pAePkO6dUWTvHP7zZ+wQ7HDMWdeExW6Ed9V3M7O54mvz/unNiujwLm1NQMnxdjD9
         nAWljOuyfxzs5YdXUC2Fud27irEEhS0HkhS+fulG8FNoen+cbtxghD5dX1JX+JKnnNJl
         yDwAuuNgRusfcA4ceoX4DYWSaQQJysNmmrlEStxpre1nc89tbxaXHNLA6Ol9MGKHTZKP
         0eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iiKUuCI4L4rH4uq4zgJy24UHT2x4TLsFSUMLWLTJpEs=;
        b=XdsMUSjB6XhC2li1bZnu+2RpD0SOsLsDIM8HADA5tN9a/nhyEP8hf5Ak5Do1ytlSwx
         IAmC/OawsJGz5xuSxKTDxaIadH1pSV/m0eQKre5HEHHShCFFh+GWtufQ4KivWnpsEuTo
         +q5WUvGhpdBrc2t7WCsOG6wImmHXdYUfqGftHfl8alTDF/uxF8yZeIe64lin3q4+yFSK
         O3cvy6iKZat2c7l1z11ti/ziaNsQlLX7fQ3cUr9L5U/1eqXAvheYVkPu1H6LTeJGw3X9
         /g497k3GcvqNIEOVOvbE5FPw8GOml+nqEYEmn5zZ/0/nGB4Hx/FD0snSqOJrGJoMz2u8
         4xmQ==
X-Gm-Message-State: AOAM532gspoDXGP3c0SglVQ0VOXt+t6VUREnVmQIplOiYy8eIynJGsDt
        FhXedUe9dQz5LFdseu+Y/gM=
X-Google-Smtp-Source: ABdhPJyexbbooowZkSj5gCO3lyLqZvYfGK9S0UuDuB/9lGyhOLIAuJ5Ah0MmF8qQBH9uvUIuSkU5ww==
X-Received: by 2002:aca:da82:: with SMTP id r124mr19093763oig.28.1634336899265;
        Fri, 15 Oct 2021 15:28:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d15sm1180447oic.32.2021.10.15.15.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:28:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:28:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/33] 4.14.251-rc1 review
Message-ID: <20211015222817.GH1480361@roeck-us.net>
References: <20211014145208.775270267@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:53:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
