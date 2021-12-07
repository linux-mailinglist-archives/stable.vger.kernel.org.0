Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5753F46C4CD
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhLGUps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhLGUps (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:45:48 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E952AC061574;
        Tue,  7 Dec 2021 12:42:17 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id m6so910637oim.2;
        Tue, 07 Dec 2021 12:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oqg8eGIMwCkIu/NLmzOPhh2DpJvnhlnKib8mf5Wpdkk=;
        b=kyOufgRYFQ5vd9CBoi0dGJX/WeugouGeCojjAaHRlnjkSbcf+kCidYXOdXfiAIi6rU
         CE8g6IQf7HLytp2wrmg4AsBedUAEMqZuMKSY7wjfmDLCLUkwe3gPWq4f98zdV1Fo21dv
         YXfE37VUcxuozuc7uJjw3hMzZucfi/iyMLE4XPoClhCinm1EUrdIEkKixpJiG8mBLwq5
         v9wNECmnCpGk6gongJP8Q+wYgeG3ud2sUa97jsgnQcLfdEKmjvIV5xB309fMZHR8pIKi
         ecFWG8Km3nZs2ePuQqDVq6LTYqD4E2MKosqWHMw4gOKwufY06BkW8kDh/MvQzSfT8pTR
         yofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Oqg8eGIMwCkIu/NLmzOPhh2DpJvnhlnKib8mf5Wpdkk=;
        b=u9QOt2sZODEudWLGEtv5EPLY5a38zzkNa7DRgbeKED8xVsX5nHYyqCXUEBenHf8AVq
         zIr6d0dU23di6GRo6SHwXVGvq++iRa8C2L5nSX26NfJ1Z5FG9OnQ8FgPMTXZfUj4toE5
         Z7TZ1BDmFmBGbPOaCEs+DZTFOsGIZMA4+Nd4+MGTUd915B0GQtbhhvKtdAEvXMd/N+lV
         /epfBNBV6sM525/o8v2OUfmc7D/Kc/ANu397/9SFWCO7UTjWXMv2Fezp1ZcitGHMuxcc
         XktdUIcoxYEsoy3mw2apiIOA9U2GsIsvimn5LpEV/hnQkXzdZj0ydj0U1KX8kedYOEVj
         kNkw==
X-Gm-Message-State: AOAM532POw8mLavmx1uger1KuryXsDR/vMIJBqgukx9vuZI1PEPWuMFc
        Gdwu8QJihFeT5ZEYE0DTzyy5BR5YNLE=
X-Google-Smtp-Source: ABdhPJwvZHhvaKrXguhP/Bda7Iih8DhhsRygfzy4UIxUTa/Im/N8tFtPYm4PyJWcLroWw1YNu2RSOQ==
X-Received: by 2002:a05:6808:a8f:: with SMTP id q15mr7220476oij.65.1638909737389;
        Tue, 07 Dec 2021 12:42:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t3sm121708otk.44.2021.12.07.12.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:42:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:42:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
Message-ID: <20211207204215.GG2091648@roeck-us.net>
References: <20211206145610.172203682@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
