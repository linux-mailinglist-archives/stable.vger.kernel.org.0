Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958812AC905
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgKIXFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729886AbgKIXFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:05:09 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BE4C0613CF;
        Mon,  9 Nov 2020 15:05:09 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id l36so10696344ota.4;
        Mon, 09 Nov 2020 15:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jxkYyJFF87uYwkUbkY9q22SbuR/biNa84Q1AZPSf+G0=;
        b=g4S1zlq/uhdKD5rNBhboz2kt8qjkBEdVOzHv5zqkz4rKPK94IlAyOdYDHy7z0JsYDS
         Uf23FJpkSFB+aYcbkfHpIArAf97bgUoyciWcr6rIzlPfjUwgE9zYdT1fQ4B3h74AbP4m
         yGxs74uS8Q9u7srxWVx0tilLtH6PAGp0bhEfyMy6J2obTongqT87ndVTN9ILn4XLodHA
         iTVH7gNwTpdbWabopwCG2vMwOdIxJLgNhwLBbSj0TF0ayLKg2P5tlySBxs26ssFUehBZ
         NBefMEHNgKcTfPSlCreeDB6nCvvCQGJRrEC3M0KER8c5oos5Hb56OGxwf/2CwhL3BWl3
         M8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jxkYyJFF87uYwkUbkY9q22SbuR/biNa84Q1AZPSf+G0=;
        b=pJ8vGntpge2R0S8Wbvs9NgsaDfpP2h/X5DyaEAeoz//5IVMOVmeac/49oShVMVhRnO
         e6RECXTpSM1YksiNWgkM+kkJeDeKzgDbLc73F8xKjnGhKRMMQA8uYtWdqTeAZiUUIe5b
         EYpcBhB/FTSMGiXMQI/5MQX4vcDL5SyArGke6K34eLI/2C3hSwlXbx3nCeb9QBkar3XG
         L5tTvh8kLylMXsER44IOSQeigLrfcuC9yulnqgIQ2z6C/FtUcpHeak+XL9CP4y7+tpPF
         Lf9OnfMzqnF9NzCEAw/pP3OBNy753qxD8jkjstiXO7LH1MB8DPr4gNm8TRJ0MfP7PkRi
         wA2Q==
X-Gm-Message-State: AOAM530jpkDBRBgD2w2S2PRoJ7h5jPrbEGiD+xVs7jrgkelFp8mdCWq2
        ROZJiPAoe6ObqF7eOF10IYw=
X-Google-Smtp-Source: ABdhPJy1lXlMFDzNkifDuXWCLa8kapLKwFe3zKqAsgw4jkAJ+umCTSbOSM+aZYvS2hNA/lfXv2uWsA==
X-Received: by 2002:a9d:550a:: with SMTP id l10mr10886186oth.357.1604963108754;
        Mon, 09 Nov 2020 15:05:08 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v144sm2705638oia.21.2020.11.09.15.05.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:05:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:05:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/117] 4.9.242-rc1 review
Message-ID: <20201109230507.GC92773@roeck-us.net>
References: <20201109125025.630721781@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:53:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.242 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
