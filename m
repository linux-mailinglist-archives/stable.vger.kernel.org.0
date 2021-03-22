Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CFF345161
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCVVGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCVVGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 17:06:01 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE6DC061574;
        Mon, 22 Mar 2021 14:06:01 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i81so13124069oif.6;
        Mon, 22 Mar 2021 14:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rmJrd4ET7RcpMUFC3fPrcxaGL2SrwAH6u9H/ExEtIV4=;
        b=E//QCUpK7a790UYoijrO1y+NtpQhsdADpgRkn16H72pMOqgRfHCjINH1N6Rzta6kkL
         bBXwnI7swOExypiLeiK9q/byyfxcZIje8funXofBokqqsA3PNXTBGLm+E/tIselZU58/
         /YTyNJxeENXOcXa/FsCf6HJcLjSgMhKBtAPyMi+8pr/oqWWIMKHcUdfrylg+I7FaCKhd
         gk7REFzcR2EXQEhr3IwJXlmZDV6/Nt7Z+W5cHp2U3qOziNo0nOiwXnquTlG5xUhTF3hr
         ZIuhEtgDOa3lbJaeYhIecUEdljF7SR4+Ahof3WAvTITwbBiXeEqYtYI2X6SoDo/Nce7j
         U2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rmJrd4ET7RcpMUFC3fPrcxaGL2SrwAH6u9H/ExEtIV4=;
        b=CHl8GgUJua6AlAlKmViW1w23HXRUMvzxAr3FM8/GI3uKjntTtB95ca48TRC+gK7Q21
         MeWWa/hhi8viiWSZlfeAeBfDu/lOY9F//Hujkgc7FkEA/4/UH9gtnsJdRh9k+ta9QQfy
         eXEfHG/0aWjjTWaOYcfgv3ORvmR+PYMKK8bAy5O9a97qh80bBc106KelzHpdX5Zqb6qp
         08EPCD9VXQQct2H9O0LrMJaw/JfnqSWYK7nwfM3pW9A+e86tm46FwesSlw8EC7Z9vGl+
         NBFlmUtv/ei8jlgjVb1kpl/KeRESTJBL0pnRQtQYbCy78w/SMSaM32FrAEI7ipTZqRPJ
         KW5g==
X-Gm-Message-State: AOAM531daiWlaE7ikUOKvtdJfpxH0LcKnG1YStpLEEns/xdUAKCBaaOr
        lg77GJ7RFPf/PmqUs1Cz5QSUorAmeLc=
X-Google-Smtp-Source: ABdhPJyV/ptRSlVWBsfyh+oyyWd4sXGwCB+1g+e9hV7JiNfAlRbTWdfYGD0becAl98v7OOaXkuF0WQ==
X-Received: by 2002:aca:75c6:: with SMTP id q189mr704948oic.29.1616447160608;
        Mon, 22 Mar 2021 14:06:00 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t19sm3718947otm.40.2021.03.22.14.05.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Mar 2021 14:05:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Mar 2021 14:05:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
Message-ID: <20210322210558.GA52477@roeck-us.net>
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

Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
------------
Error log:
kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT' [-Werror=implicit-function-declaration]
  683 |  IRQ_WORK_INIT(late_wakeup_func);
      |  ^~~~~~~~~~~~~
kernel/rcu/tree.c:683:2: error: invalid initializer

$ git reset --hard local-stable/linux-5.10.y.queue
HEAD is now at deabac90f919 Linux 5.10.26-rc2
$ git grep IRQ_WORK_INIT
kernel/rcu/tree.c:      IRQ_WORK_INIT(late_wakeup_func);
$ git describe
v5.10.25-157-gdeabac90f919

Guenter
