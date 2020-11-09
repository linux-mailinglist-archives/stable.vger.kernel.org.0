Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968D52AC901
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKIXEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgKIXEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:04:04 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9B2C0613CF;
        Mon,  9 Nov 2020 15:04:04 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id 30so4927046otx.9;
        Mon, 09 Nov 2020 15:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vis8sVozOQr450S6Xh/Wfokk9jRWIQrNKP1sXncp4lA=;
        b=qXbC+1JVCzTKjA5HM0pAP3n5ukh7A+egR0OGJYcv6rRiOxfd1FbYInRxYkZWAGH2d/
         sqLSX3jNeYT9ejjraV+itxOKV8nRnYPs5rRi+4seU3qvqLxpAM6ITxuw6moBZFyjdJhZ
         kx/b39+Gj6/QGwP+jWFr2T9HW37jKnwKSM48oiRUcPFpMzNjohT2re/xTp/oTBw28alB
         Aq+Tf+68cRGI4Wy53410IWcWnoWQKhu20ONGJy3U/3euDyl1IAFxeod2PJPe7Nd30SMD
         2vPJSwSsketg0GTXTM1U9M+hySJlHJ/RR3aKlXt4HsKlWJScJUZCOoQYx5y1nQ6tRQEE
         py6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vis8sVozOQr450S6Xh/Wfokk9jRWIQrNKP1sXncp4lA=;
        b=DzjEmhC8grHW/+gdvHObJ4mZmng+ObN4KRHFmHJq0CsQVF6BloJmddCylDWlTNppIA
         wzIgroS6niJsB1cCGlnQq3uyByevsKNd6L5g74AqZzoVxLzSfyVLh1P1NFOdBhbfmth/
         V0Pb2gP1satCoG8FWTrPvbsMIfQYIKNPINoK0XttVvYMKlX5wvoiFfnGnrH9tUIV8jT3
         Yz0cpTWpYj1kW9sw86yF9GeM/35hAAB6NObRmKCpQkW3W1H0bQueedWyDsFpBe1mFkIt
         nkyNA/DjGnkWwIDYt7Tel4vP7A+Op0juRIxc2g5eOj3Nyq0F7UuaooCnQkjeqTcn/yU2
         a7dQ==
X-Gm-Message-State: AOAM533cQOql0N/SzcvNb/9JnfR7RwwYAiv+LLAABPKx3PTla/uGQoeX
        8ZJNc5PqPL0JVXiXx1aev3E=
X-Google-Smtp-Source: ABdhPJxKEou+yzhqnw++yoAaLs/7Kx/YMBg709lhDMa/HIvEblyeeldvrvTUMK8k1JP1nCCs3MVeaA==
X-Received: by 2002:a9d:6a91:: with SMTP id l17mr12543148otq.187.1604963043436;
        Mon, 09 Nov 2020 15:04:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m65sm2449441otm.40.2020.11.09.15.04.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:04:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:04:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/86] 4.4.242-rc1 review
Message-ID: <20201109230401.GA92773@roeck-us.net>
References: <20201109125020.852643676@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:54:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.242 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
