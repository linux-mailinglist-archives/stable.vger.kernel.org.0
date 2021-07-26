Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C393D678A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 21:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhGZSz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 14:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhGZSz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 14:55:28 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B455FC061757;
        Mon, 26 Jul 2021 12:35:55 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 184so10042461qkh.1;
        Mon, 26 Jul 2021 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8DZHbNGR6RnmHM3zJD9SfShwkcBsyfVNOVHE+UpdZEU=;
        b=PgV3Lx/MGsmmLsVwsce86RTfvztiSxsY+tK88xevkvjZk/W3EHjTnJ7squ4OpEGHNI
         2zniXGLL6CZC/8aWW156QEZOrZlAdXMqBeNqkHo7iPK8UKgWb+DcAIHeZfBa7RsrxRxr
         7AAs04AJ0IZ0zoqfn7agaXQIOycPHSzzjpGr5LDih1m6xFl6NTGissx3zCCfrsbl6l99
         mvIJntcDEIT+6jcZ2gYmfzHMH6sFhfQ54TgyPz5SBZoQvYgbH3wt7PVqmo8EdtHJUUNH
         2d3xqQZ826AvlL0BiedmLAyFr871P4FxEiHoZiuOltFSwcm8WCb5nXU5KaX6YmDFa9Mr
         lXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=8DZHbNGR6RnmHM3zJD9SfShwkcBsyfVNOVHE+UpdZEU=;
        b=ZrAq5xtYIyICxUJUqeTMhffFqgEVODQSBepMs5k9ghKf+B4+w5X6CYXQVyqmqPIPnh
         TJvtMQ3RB3BdQpc43rEiCoB33p7ge90LsfQOuyCRgqrRMSYZq/LvaMCXEBGzfdaiPPRb
         rcb7FK617yMj1upSGxOLsJhgBRMzMtGZD5ePtF0M2o+E+0Mdsrc+j2UB1ztkOkvANcwE
         9Gz0JrkrM3YlAB50G9tyFeyE8a1g0gpvOENy+/KOJoPc6jELTZazVzseuprTBzP+fxla
         1LcybVHLIYA6kX9plb0wG65ZMac6UF1uwYQkTR2Lj9oCUpZ6ZuEmCunE1pliNQhQOF2a
         uwZw==
X-Gm-Message-State: AOAM531evd/J7AvrbW802vOjn9ul8s8d4H6F7VyIzgi+7ZGUwU9qjMfb
        oUrUJbEivqyfwEemxod08tY=
X-Google-Smtp-Source: ABdhPJySr3zjCgknT4yap8l9u7CyLO74itxdZV2uGuS+FRYLzBueAoCyJKiWaYY9hnZGWRuzKfHd3g==
X-Received: by 2002:ae9:e010:: with SMTP id m16mr19262351qkk.345.1627328154975;
        Mon, 26 Jul 2021 12:35:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t8sm415327qtq.28.2021.07.26.12.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:35:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Jul 2021 12:35:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.199-rc1 review
Message-ID: <20210726193553.GB2686017@roeck-us.net>
References: <20210726153832.339431936@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 05:37:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.199 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 

perf fails to build:

builtin-script.c: In function ‘perf_script__exit’:
builtin-script.c:2212:2: error: implicit declaration of function ‘perf_thread_map__put’; did you mean ‘thread_map__put’?

builtin-script.c:2212:2: error: nested extern declaration of ‘perf_thread_map__put’ [-Werror=nested-externs]
builtin-script.c:2213:2: error: implicit declaration of function ‘perf_cpu_map__put’; did you mean ‘perf_mmap__put’?

tests/topology.c: In function ‘session_write_header’:
tests/topology.c:55:2: error: implicit declaration of function ‘evlist__delete’; did you mean ‘perf_evlist__delete’?
tests/topology.c:55:2: error: nested extern declaration of ‘evlist__delete’

Guenter
