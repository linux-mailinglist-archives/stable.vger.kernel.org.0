Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B222FBBA
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 00:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgG0WAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 18:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgG0WAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 18:00:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EDDC061794;
        Mon, 27 Jul 2020 15:00:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d1so8880284plr.8;
        Mon, 27 Jul 2020 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/DN0sQ1yN0BI4O35TSnVTHQF5sub0pjaa2Ram+1a69o=;
        b=oVqcntnmDnJXPQdIm8s8tQdN00Q9O5NgfCpGmGmj7Py9RJYxoUNUnZZJxxSMOKdEmN
         K6+Je6rnVJ7HvDkV3tYZQSDtZGSIboJEEnqyKdDll9dE1yJeAXmKA40wmpvjyhOUR7ih
         3Mn5JNEISVcgn7LjbgcraU0In933821ISPRAYTp718kUlHm/zoPrLFYx0eZfjrO8ysvw
         Ubz9BozbBuQtftqz5PSH4m/An5++/TBWav/hgsf4ebemm1W/WRjpV7rxMJTEwJGsYkKp
         g5smMMxaqLH4BaYkzWxUpOTA0ACdyC3GPumYUEK4jkPlfdsUT1JXwOIyJsRkQqdTXALe
         PdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/DN0sQ1yN0BI4O35TSnVTHQF5sub0pjaa2Ram+1a69o=;
        b=b2CvH7TZ6w6QxB8pbIo16VcWwMSfC3/qVQsm5r4TmebLXaWZNZuqeCfE+GDiuaobdq
         +LuCEeQJf4iMfkANH926/LIwOX8SQ0evwRL7BbqEEDLGl6+cRSuVcSKtzjZmqbT4yqtA
         qHeR1Pzua+0D2Nusxl6Jmeb/p+JLoKpHWO3HKARhveU70pmSvGxkVCRCRwJA/GatW31m
         saNfW7VIz3N3Q4g3iqhtui0iAebahdKlDAzxw9k6CKZr9bIKayt7uR0MOW6PI2OdCIsB
         iik01r8m9xk/+yIVWWmvOKkyp+Zwi52Lbd3FZg0SsrPral4WSzQRkfLKTFmYw6kVVnTZ
         TmyA==
X-Gm-Message-State: AOAM533F4rdSLTKEBJr/mTeL5YCuU0/XvB7L5/Ag7cPMbBuVOjg6mgeo
        7fpOsMxCicCFmfawT/yAvTY=
X-Google-Smtp-Source: ABdhPJxcciBzlgHrGeKRrT2xAM0xcBIUg2eLsmGAKR9MvSYovIrsnJ5lwfGYE1lo+9+GJQpsavgeww==
X-Received: by 2002:a17:90a:9f84:: with SMTP id o4mr1210753pjp.200.1595887232843;
        Mon, 27 Jul 2020 15:00:32 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id u66sm15856614pfb.191.2020.07.27.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 15:00:32 -0700 (PDT)
Date:   Mon, 27 Jul 2020 15:00:29 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 48/86] Input: add `SW_MACHINE_COVER`
Message-ID: <20200727220029.GU1665100@dtor-ws>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134916.823991118@linuxfoundation.org>
 <20200727212623.GA3724@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727212623.GA3724@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 11:26:23PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit c463bb2a8f8d7d97aa414bf7714fc77e9d3b10df ]
> > 
> > This event code represents the state of a removable cover of a device.
> > Value 0 means that the cover is open or removed, value 1 means that the
> > cover is closed.
> 
> This is only needed for N900 cover changes. I don't see them in
> stable, so I believe this should be dropped.

I guess there is no harm in adding the new switch definition to stable
releases. It is now part of ABI and is set in stone.

Thanks.

-- 
Dmitry
