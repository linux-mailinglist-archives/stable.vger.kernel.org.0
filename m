Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EC233E016
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhCPVNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhCPVNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:13:25 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A03C06174A;
        Tue, 16 Mar 2021 14:13:25 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so7625832oto.2;
        Tue, 16 Mar 2021 14:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K0D+w3DtKcf3IG8gV1RKqgq6upop2BjX6Ht46yKIoSw=;
        b=b0XdM/v9Yd4UUKP4J1lm2Iz8hTHjIX5hiWjGL3ANh/T6V79saDK2qiLxuux+cLTG9m
         ckCp3z7MXCx67BuXshI5nYgz7V4H4TeagT+/5OX2QTdQDemap5+HtDUeotVeCPeNrefy
         mfaRk8SjeCfAcohsZZkMmejv1e9cETKFcrRh0YsbG/4g59xo0n0n7uQOQYdEZGXyOt0a
         W2iZu3/WzoAJh3wLnob9zuha/3f6fno5HjiAMhQgAHhb1e3opHfsaLVKVx+AqI8SFbXU
         MejoK0yJu/1C3kQFOlbi4Q4UJ7Lsncfz9aG58C3SrhTLHL1Y5jbb2Vdhs4Ouvz0dtTaI
         iy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=K0D+w3DtKcf3IG8gV1RKqgq6upop2BjX6Ht46yKIoSw=;
        b=AsYCuxMcRGm5DMKMddmuigQi5N18m12qLTC1lV1oYpULdJdiKUhUosIsLAEXznizj+
         STqa/HzGHb5Ga2ospTl5qyEBAnP/aP5LV2NubjXgUXrpX6KlY04X9iU0NLB1HaeliAyn
         0o70PbIaZvSCUStGifjH+0Mi3EOyuB+7VVTaMAO8QJzyyOTPsX6Cd1G652PvK6gRKknG
         SXMRV/OjxpVT+UhwM3qtbDNRbAHZU7+jntjiR0I0dO8O4haQCMQBWg+/xYuYy/mfWeM9
         HFwTNVnzAuC+6aKq3zsq2dP2yuzr+VRMlRWSAZ9voOuJRImdOV6wz8gPnDODPLTy2t4/
         GFmw==
X-Gm-Message-State: AOAM532aWHOfefQzQSFPiM3jo2eeSnCQiFKWFz1J6MyuAOlE1z4uVnzm
        t9qpAQwJYm7/K43S9m5d7poFfiwHC1M=
X-Google-Smtp-Source: ABdhPJxNybaQ7l5nH58TWqA+g+CapglJyvrgbihfIPqQXUErrr8SwXjEJM+ag4XPyO48u8HXIstE8g==
X-Received: by 2002:a9d:7081:: with SMTP id l1mr602063otj.358.1615929205057;
        Tue, 16 Mar 2021 14:13:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s21sm8159812oos.5.2021.03.16.14.13.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 14:13:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 14:13:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
Message-ID: <20210316211322.GA60156@roeck-us.net>
References: <20210315135720.002213995@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:55:51PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 419 pass: 419 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
