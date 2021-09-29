Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C937241CCB5
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 21:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245557AbhI2TkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 15:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245483AbhI2TkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 15:40:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6AC06161C;
        Wed, 29 Sep 2021 12:38:43 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j5so10446827lfg.8;
        Wed, 29 Sep 2021 12:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FR6O+t/hHG3GO+XxCstQHhRjJr6nSWaSUfjf+6LlEqs=;
        b=l6MTonIcecw3Pk6ZEY4sO94i6/K+GdA0cToRE5zZaTUslJBVE3QPkEgS1De2dvi13p
         XFiBReTE4ujD4ozA+luiOH4mljOPsOwy1CufpwwJIg7P9rmMV6jfDJKomHTK5vx0ZjeM
         wIKYcpL2IMYqd5osJienjOsj3PRcP+WvLLKwHiYGIA6+zUlnR5sB0T5oT6WcFDkccgiK
         BCcklSkCOL5nYfmDc7smP2tafibBQAL7cONCxxmxZ9sXyy9OwQ0Vt2kGGygcfRNCyv5u
         TwjoFS/oBDuhWBo0mWSE2wzG/4XzIbRl9WuEbuKG+xk6WHU38AhsuUJV+TkJZLXOoisQ
         Ebpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FR6O+t/hHG3GO+XxCstQHhRjJr6nSWaSUfjf+6LlEqs=;
        b=6MT7+9kPAyGx5WLf28hmCH7KmuaqdtByXOGSQN/CBFeJDrVOJzjTLCnFx+iX+EEH7o
         R8eje8rPEOErXfHz+BKkaqoP507TnNZVMtFg/3vNDVH4iSNzUoOZT4nI3jpTqK8om3hX
         ShbYWzKFLX8NXKDBD9+ydZxP4ryJpGEfwWXqOz+O+NFddHa1WsgYgLv2zWrFNhkUXEMj
         ccbJd5cfyYBOpokexFb/DVm2Lgzg8cbpAI3OBY0tmMmMgpcsbexbnZu+7n9KwGFliQcs
         QZmUuhc+YyIppOK53WccFPuakyZEZTVW3fFcFD2NcHaFZvk4UIf/Et03KjgbhEZrJRKp
         skdw==
X-Gm-Message-State: AOAM531fSMaDaL1aZMWlFASsbeYHzAl8UQPzqIr9ifKVDNUyceXvJOsF
        J4Z7v/3F1Ny6AJp2SEXeqxWdz2gW2jSa3A==
X-Google-Smtp-Source: ABdhPJwFTrU1/4un/Cb6hi+AO39VtiV+5dxT5T9EN2MhAZAMCj5OvGYsR88wbaSeDWsaonhggnufXg==
X-Received: by 2002:a19:6b08:: with SMTP id d8mr1530967lfa.87.1632944322294;
        Wed, 29 Sep 2021 12:38:42 -0700 (PDT)
Received: from rikard (h-98-128-228-193.NA.cust.bahnhof.se. [98.128.228.193])
        by smtp.gmail.com with ESMTPSA id bp5sm92147lfb.133.2021.09.29.12.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 12:38:41 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
X-Google-Original-From: Rikard Falkeborn <rikard.falkeborn>
Date:   Wed, 29 Sep 2021 21:38:39 +0200
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Oliver Neukum <oneukum@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Junlin Yang <yangjunlin@yulong.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: cdc-wdm: Fix check for WWAN
Message-ID: <YVTAv6BWsxS0I2My@rikard>
References: <20210929132143.36822-1-rikard.falkeborn@gmail.com>
 <20210929132143.36822-2-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929132143.36822-2-rikard.falkeborn@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 03:21:42PM +0200, Rikard Falkeborn wrote:
> Commit 5c912e679506 ("usb: cdc-wdm: fix build error when CONFIG_WWAN_CORE
> is not set") fixed a build error when CONFIG_WWAN was set but
> CONFIG_WWAN_CORE was not. Since then CONFIG_WWAN_CORE was removed and
> joined with CONFIG_WWAN in commit 89212e160b81 ("net: wwan: Fix WWAN
> config symbols").
> 
> Also, since CONFIG_WWAN has class tri-state instead of bool, we cannot
> check if it is defined directly, but have to use IS_DEFINED() instead.

That last part is wrong, sorry for the noise. I'll send a V2.

Rikard
