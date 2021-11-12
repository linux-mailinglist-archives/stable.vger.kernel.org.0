Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18EF44DFA4
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhKLBTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhKLBTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:19:44 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0EEC061766;
        Thu, 11 Nov 2021 17:16:54 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso11501104otj.11;
        Thu, 11 Nov 2021 17:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oAICyqCuACNmSUIerWl2doYjSFGoRqRYineoDlGTN3I=;
        b=Nlodd7ixQGAeQzZdS6WGOmoT9xFIHViD8qBHo7TTSS6wcRKjtVJLyDsridEfwerRff
         /zyf+aBwbyZGjKOt1Eq75HWAYTTFO0n/8c6r/9RPD1AF7JGfod/EvrUlKnNUp2kRt/YV
         D+4vgUAUbRhHYvy7tjrhDLhJHKqs5M4dQQNQRCW1iRB9VtpplDARxn3gvWUxgxtgx6pQ
         JS8nKrkAia1xM8oUbVb8DeGeQCiN0Mj4vZ9RyhKOVouuo5o/gdi81utZ/ZrcJv8Tdzx+
         97N3L7MmlnG+PEHQLC4LyN255yzkDvd67TNr9VuF/+Fmuv1ifheQ+Erjw9r4a0sETHAO
         j86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=oAICyqCuACNmSUIerWl2doYjSFGoRqRYineoDlGTN3I=;
        b=X/AE9sJfWHn9g91jZ2A3hbU+bquDpIbKtluqf9qeft/xax3iRSL13lnHrQfeooaXFG
         Mej04RejfSBXW2T+Ril7WaWylikAYK6kTym3+J7sKgUvcCEppEMmQM7t0VQZQ1qdWoL4
         glomIB1hU8aP8A99W4PHiJZhN3GM0yZNKazNGmX5AlG20XyOpX6ikAtAb+E1OzWVjJZZ
         KlulSVULHCQvbMwsUrHM/dR5VmS+CmRC16NIolzv0Ihcwh12ec9KgDaB0AYR4inAPLkU
         hcl+PR2ARyBu4kzSWAe6iOgWiYftyvkkmg4HBDqlTD6qcm1hgOhHlXOWDde3kBmbaTU9
         4ezw==
X-Gm-Message-State: AOAM531JherXAnSbzSydA2X2/JRd/4miDjske9PUGMXwCmGF7IQ1m4cA
        QAPqIt/Or7Qhj9dI8+jRTqQ=
X-Google-Smtp-Source: ABdhPJx/nMNlkekjuxbnVTfFNC2KnS2IO0PLHxTOvhPyEcF7kgHUvBu1Zs3RkQRLBQB4R7eXGW/bOg==
X-Received: by 2002:a9d:6953:: with SMTP id p19mr9393993oto.138.1636679814231;
        Thu, 11 Nov 2021 17:16:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh12sm1246850oib.25.2021.11.11.17.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 17:16:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 17:16:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/24] 5.14.18-rc1 review
Message-ID: <20211112011652.GB2588851@roeck-us.net>
References: <20211110182003.342919058@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
