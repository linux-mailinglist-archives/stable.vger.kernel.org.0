Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72E73D02B9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhGTT3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGTT2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:28:12 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54923C061766;
        Tue, 20 Jul 2021 13:08:40 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id a132so478149oib.6;
        Tue, 20 Jul 2021 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTUqnpRNjcSJCBVJZVhrXV7XWZX7nHaLzRLwJcdznsI=;
        b=IIC+Mo9W0QlgGC3avgJvTkjUD3I7QPvT70QKlSLTLOB4Y0a9ZhnqOCuKV52mm+Uwd1
         3VU34f9tS03oOoMwb5rkkvUS3a5N9gl6eVV75QwLGlFw+jRLO7f+/OdJ8ZBMESOIG4Fk
         55L3lCIU3KbEx+2XbUSyrgHFqeTZbd8nKKv/ZyUdcfmGoe3Zmb3IpP79Aq952GHLMExj
         qjVZeigWBbwHcghGU5K0vOLNfDMJW0KO1Y7Kfr79EpLWzPNtTmKGxV3ZDFcmpj4VumQ+
         FpFBu5uUHX3O+564xgxUy3F0ncWVQMDOYligPqe53XBhxfLXMVetDBihC1og1qyByCg5
         j/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rTUqnpRNjcSJCBVJZVhrXV7XWZX7nHaLzRLwJcdznsI=;
        b=lwhvp6xT/AYoPW3yd/3rXhlf5f9wpnAVuD8zRihJuTmyRUaZZCpXY08cICJwwlboZb
         EACnf0fp+F9KQMVaPAWoFqDBZ7LJgVwLbKaqixMVP3zmi8lqVp0m9XNsxR2JU75i6Wuh
         iCZV1P8oDlDr3NiWfA1CzJfvnUyoMSMA8iejAkWJ6uBg2++PHN4RtkYjG7cZgNr/VK1k
         7sFX3Ki1W1jWGBVt17ZHlE7r7VHFYHUu8bLlfLdW3fo0W+f0xy4FdepPEUUtr0D7uvFx
         rTQRVB24EkIwsd3PkhtEWx39+j64LE0ki9qj7EDyoeQasZ0xDPbxqcT/K5rLzY0FZK5+
         5kJw==
X-Gm-Message-State: AOAM531LgQ44EnkmidT+ur67xrKPLU/GjYP5VEByFEtHvYbq6flFWG0P
        OP3MDj783TQjYyrDAQ78qEY=
X-Google-Smtp-Source: ABdhPJwcYFr84/8pUZ4k8PYcFw2JYZkNH+qcqyRGBJen1/FVPvKJlw1KC+VHeqwPSB2g0hpIi53Jmg==
X-Received: by 2002:a05:6808:6d1:: with SMTP id m17mr139284oih.34.1626811719758;
        Tue, 20 Jul 2021 13:08:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15sm809109oth.7.2021.07.20.13.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:08:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:08:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/314] 4.14.240-rc2 review
Message-ID: <20210720200838.GC2360284@roeck-us.net>
References: <20210719184316.271467313@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184316.271467313@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:44:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.240 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
