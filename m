Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963413E3B3A
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhHHQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 12:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHQAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 12:00:47 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F1DC061760;
        Sun,  8 Aug 2021 09:00:27 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id r17-20020a0568302371b0290504f3f418fbso853741oth.12;
        Sun, 08 Aug 2021 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=02+rn2M527Zs9x6jfvmScP4CidQxLvjEEikveohQpC0=;
        b=CU6x3WYj0HJAMvYPD9Xjl0hd9H/If5lt/BmyF1gn3YngXP/M2Ok0LGf4EaHm4SkBQa
         86vitYdRpTYpCQmM3VFnVz7VwK/si3UiEiAIv3Oys5GeUmGarPN6gOg0Ip5EmFjR8BTK
         69fHcJtJ91xRr3iToW9ITEzAKhkLrD99ZxKM39xfAAwRqCEHRqwJhuyMHHYEhclGVUxS
         tBc4Y1wfyMxD1/NTFPE6CQhtOuKSZn62lTQAjywr8UXLOSbybhrvFmL7RubT2G0YYI8m
         FO84A9GDKoYxfOJloiNNsEH2Z/mRH7IFRiEM5avAcqRLYGJoZfFQOt75lmkPSm7uBH9l
         9dBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=02+rn2M527Zs9x6jfvmScP4CidQxLvjEEikveohQpC0=;
        b=hY6BAHkgLYaed8C4eLOh9l0JZ9lxdkCqopvSpGdysMDhR75Xs2yTPigTcPTPTOmwJX
         DQZPqUXysfa/3O1v+NL0T2iPnsQuAonS7snp9pLC7FSUwBjQce4O6h2RZ0Si1V7ei+fl
         exLX4ZqX5v3eeaQNJBuMgaa8E6uGkrIqrqhA6K0OxdXRueAkoV9Y+9Rcqh1azvihj/Wa
         j9nIr0AlGQds3CRD3+61WPBittcX2ylPdSvzWk9a5iTl3O8SM/Oqd8w5c/9KsHc8mqOW
         4NW1u0hSoDdQhNXL5FmjMTXVuqlnc+a1lCai+OSSZUkmkd1qerZUo3aMkMNfAY4z85Zl
         0eBw==
X-Gm-Message-State: AOAM533v2eny1fB+Feshdn2xakEZ5q/G32dS6lQgNiu1jI4AyHcK+mrv
        In6wqDN6AQ9PDHY/QZqWsE8=
X-Google-Smtp-Source: ABdhPJwvoNTZQ1qEe1aFBZ/Mgjog4RZR7nHscFt8eNhC2kDJC+ge93jN4WbMvs104OQ/KyX3UyKGyg==
X-Received: by 2002:a05:6830:114f:: with SMTP id x15mr7665412otq.100.1628438426586;
        Sun, 08 Aug 2021 09:00:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q13sm2316083oov.6.2021.08.08.09.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:00:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 8 Aug 2021 09:00:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/11] 4.4.280-rc1 review
Message-ID: <20210808160024.GA832953@roeck-us.net>
References: <20210808072217.322468704@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808072217.322468704@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 08, 2021 at 09:22:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.280 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 10 Aug 2021 07:22:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 340 pass: 340 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
