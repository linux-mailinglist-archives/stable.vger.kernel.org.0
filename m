Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2B345220
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCVVz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCVVzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:55:35 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B925DC061574;
        Mon, 22 Mar 2021 14:55:26 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id c12-20020a4ae24c0000b02901bad05f40e4so4464910oot.4;
        Mon, 22 Mar 2021 14:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hOYyf8R8KmF/QfhTV+woj/lANeMjGRXy87SBGVVD5qc=;
        b=boaDPXyygj7srmKPA8NvYFnFCUMfEj/IcevLM0Balkwpi0mmnvyMxEXUwUBbEauSJL
         H4qaA8E3zZdx3RpMXMy51UAqOC0jywtHR7shf7/LaOoGcfFxBuyUbuTcPgF1ZZ2YpvvF
         DyeQoLosTbpA/uV2H0bke3uQRznViz07HQrFg0ZnFCQCsYSYaHK5qhOni68kuGXkm4oS
         JKSQ32XUx/h+V/k88BsBR/YmZ+D0pB9dfU+voDGDo3gsVRBZAW0FbsAzteskI9bi9KqS
         4pwYophMQkdS24suwXWzQ2aGJtHez7u08WX8U82uG90lzfu+tvfNvL9a0v/2sm7w4sVX
         nsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hOYyf8R8KmF/QfhTV+woj/lANeMjGRXy87SBGVVD5qc=;
        b=AnHJ/13HqRv4+Kc300u1RLKyAcytwJKVRdr0xmrWwRgWJt+GXzsVmySjxssV624YNb
         raR6Y7dBz6xw2CjnZmZFQTybSf7Kci92b+u+9q54MdQ49AXxykdFx+qZ08bECJA6rx18
         e6ixpKh/JdpC90exyPPEpP58Dy2sBBgH/GoD14wTcHflLv20eMD3RUEo8RE0GkVfnUwJ
         yyUczERAmGv2xfdNJYxbScZPNO+2oltzf9dToo3FJI/4eJZoH7gKa+0spMgXBKz8OIS+
         HfGIN+JxJUPWDnkh1NgS1e3fSI5d11TjFRzlup4XvXM0k9I34iVlOepXwXfk2VzyfNiV
         w9PQ==
X-Gm-Message-State: AOAM530NEDdl1gG71+e9Eb3mm6PoQgxQ8FLaqG3wnyHPn1XRz9+NG8EG
        OTTk9kbRbZfExEPDt9/X6TA=
X-Google-Smtp-Source: ABdhPJzq6Bnmn08O6rsAACH3joY0/rnXng75Az9Er3JKYgRPtfWBf3mi1DMNr8lubrMNkisVhKUc2Q==
X-Received: by 2002:a4a:b787:: with SMTP id a7mr1227477oop.18.1616450126126;
        Mon, 22 Mar 2021 14:55:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3sm3312724oov.2.2021.03.22.14.55.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:55:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:55:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/14] 4.4.263-rc1 review
Message-ID: <20210322215524.GG51597@roeck-us.net>
References: <20210322121919.202392464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 01:28:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.263 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 329 pass: 329 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
