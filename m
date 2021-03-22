Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3F345214
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCVVwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCVVwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:52:33 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4405FC061574;
        Mon, 22 Mar 2021 14:52:33 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so17215650otb.7;
        Mon, 22 Mar 2021 14:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aYM93wjBNY7yOqzl/sergQpihPzgcgHPw5qRcBOG1lQ=;
        b=nRQ/iiyQbFr2w2S3ARLQiAwsPaSS48bURsCIC4tdumvBBHb5Y8pSS+XVjObTYjLI9k
         mro6FjktnMVNiZRPU1oH6hIqMlpJbld1mIm3csQpb/5eX6X+iHSShIkc7YyW9pVbOJE5
         XRWS7vlbfJCnwudKa8iMKfXfkHeOn1MlQsf7Pu8lafFGylCfyCDjRY77IWnjYLUaBFNp
         6S7iBas471nvw3h338CjxCVTekjtM+/hTE1cnnTaku29HQCJAh7HQS3vI6qF8HW5lj/x
         kKCQfQbSvRDUB5Vo0O3sdOYQj89iJuMDCCgzdcRJdsKdXZfi4m7vMlF9DlWWw0yZYkvH
         +uEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aYM93wjBNY7yOqzl/sergQpihPzgcgHPw5qRcBOG1lQ=;
        b=fsUwfE8jgcd/Yss/I5zT+GQOZEHJNBX1BOBw2T5XprLA0jNk6R/VqnxcrAoMF76rbv
         haPB1iGJvQBI/1A/bw0WY1v93QGSjoUsKb7iHh612OeqjsGGKprFy69TuWp00QBM4Bhy
         gUpuFGifeZDUtFwpRzJ4ptootyhD3eHlC7Git61QNdi9W+eJA6GxmRuESiTPha5BKkPb
         D0SmHBusMhtVqmsNa/o4kxOUCootbTHKA/M3zAOnP+gs76J/9JBqJja6/pOLdWJWvp2z
         Ul0DGhEg0YbzCsPUhdAKdcrhLlnZ3R8EDAI2F4oGml5qoVo7nIiJH8itssWkp0UjZ6An
         zRhQ==
X-Gm-Message-State: AOAM5337n+rFjQQCaFU/XDf9Rw8biHOh7FsOMZmHcJcu46sCBsM35rJp
        LWRj4xkJj3NpXqIDs6KelWU=
X-Google-Smtp-Source: ABdhPJxP3C2JztuUOrXJjs4sNBQH7+rOsgkPCNCi2UpiP7pbCZIu/bxkA27jzAroUOwdXl+Qrbq54g==
X-Received: by 2002:a05:6830:908:: with SMTP id v8mr1594662ott.217.1616449952750;
        Mon, 22 Mar 2021 14:52:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm3758356otu.80.2021.03.22.14.52.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:52:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:52:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
Message-ID: <20210322215231.GB51597@roeck-us.net>
References: <20210322151845.637893645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322151845.637893645@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 04:19:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 432 pass: 428 fail: 4
Failed tests:
	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd
	arm:realview-pbx-a9:realview_defconfig:realview_pb:arm-realview-pbx-a9:initrd
	arm:realview-eb:realview_defconfig:realview_eb:mem512:arm-realview-eb:initrd
	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:arm-realview-eb-11mp-ctrevb:initrd

Build failure:

kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'

The patch introducing IRQ_WORK_INIT is not in v5.10.y.

Guenter
