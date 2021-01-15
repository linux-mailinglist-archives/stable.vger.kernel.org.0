Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0292F877F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbhAOVTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAOVTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:19:01 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2FDC061757;
        Fri, 15 Jan 2021 13:18:21 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id f6so700419ots.9;
        Fri, 15 Jan 2021 13:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mp1Ip6sXryZbtFGCkTWngW8dgbL2XHp7x74N7LpAsXk=;
        b=Apa9hICF6moKXApKWDXrW9wBkLTySfqJZ834DhwooCZ9asG/ZFUkSXAi+RxmTJ05QK
         ywjthxzLGw04TTUGeVmjplxbcaWKl8dTxihbZeazEoDvLiCHEv1gjlozG1jPXnZ4q4rA
         a/fjBUjKdLwrzT7bk6IHuOY2nEjylu8kLH0kIQ17Cv8LXrIf6Q7p18Eh4i19Czj5/R2U
         u1nxUfz3Aecy4GXxBlMeT4i9PAVNGfWbmhR4hI4lJpD/GgLRS7zIr08u03eNqsDpCfQ2
         FNuGXVsmpGDrprudwkIziW/h3X7hmTDU5mVC1WVzMfa92b2tULPKuNhFWvm3yXKEZa+w
         5mTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mp1Ip6sXryZbtFGCkTWngW8dgbL2XHp7x74N7LpAsXk=;
        b=Fe8LdAv3Q9S6v+KYaNsJ1unhFqxjrQQmoOTtTfU6FdjXwsxAdQ+5wbB3gShuL7sjPO
         umG/3zhy/aOs5SeysKTjPlaPcL+lxTX7DJLZqfTpaz56fJbYnkKidavGxFfZAJoKpICl
         j3WL89KJEtqbG0LRMWbiQZF7c1+7BiyDV0QJreN4Yhi4L2XH/8oAXZ0TlYMFb1cA7bSF
         DexFC0bLUmtcRR8WsY8a1fIkAima0ehX1ZkNhHEY3f5YOtQ3sr0LD+FjV6R+OF155RgE
         1vyurqcf3NRWBRtz5tZ3dTM698aVpzQASaU1I01NiWKP+LXJv0188HzD4Vfb/Otix4PB
         X7gw==
X-Gm-Message-State: AOAM531q+VhP1b5/thbR3sojEV2pam8h1jmEMGjgpoGOmUsP+bR75It6
        gW48GIYQ3RrXp4zrUxfvk24=
X-Google-Smtp-Source: ABdhPJwEoGjtq6pFdhO0omsdYF1KFeTZZwmPOB5iHoe7xqiho+fD8uWsHYAnjEvuHFxd2Zg2DeLY1w==
X-Received: by 2002:a05:6830:114e:: with SMTP id x14mr9712123otq.253.1610745500926;
        Fri, 15 Jan 2021 13:18:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 94sm2093661otw.41.2021.01.15.13.18.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:18:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:18:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/25] 4.9.252-rc1 review
Message-ID: <20210115211817.GC128727@roeck-us.net>
References: <20210115121956.679956165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:27:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.252 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
