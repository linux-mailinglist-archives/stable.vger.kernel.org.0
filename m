Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BE72AD41B
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKJKuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKJKuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 05:50:12 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF16DC0613CF;
        Tue, 10 Nov 2020 02:50:11 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id d142so2521625wmd.4;
        Tue, 10 Nov 2020 02:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RI3echpmsILHMbwDzAgMqcqkjUKk2AOhPsGaeepkNKI=;
        b=FrhFbwdHS6/kq3jq8MO8bIfVNpx/tqWrlhlOsA3bKsZghA74MehbDZoUkpZHwRJM9j
         4g0/JpvOD6J4nGOkh8cLPQG8LK5xHzSP2efrQ+y8UBN7JoBdflYvnLUmqWWmaVOa4XZh
         HJZP5sqeRG/lRZAvH5YMsdwOxr8dsfPsTrSV+0kJVaPP2Ecm08KQRP1Q6QfUI8+E6gRh
         uxcowjkBfnD69wwWMgU+E9/miAGpncdYoQGEt2jhyNckw77imOXJ9qirusZt4ptHaADF
         6SU7wyJzV9+k5IccBZ+nfFT984BpzWZ7p//S+aGMh7NuoIgFqWHshg9WYhW7ahC++LXd
         yBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RI3echpmsILHMbwDzAgMqcqkjUKk2AOhPsGaeepkNKI=;
        b=WR4VKww8wnie04JARLuatz1nFnVFknJSi214f/RN+2asQR20Z1K2eiqHieFIUQVHuF
         aW4mNHS5Em9AdEeI6YjukHGoMplma4EGkzmTwKo03afUedbNwixfOJdHDcHdu7ChPqVg
         Ba5LSG7yMRBYka9aGbJOpDpKWGNWVsPNd5g32uudBKGPDOmIgTwVNCvX7YtZg6HtGgVg
         M1UaxKL5XmiGmKxK/lzvWi0mCy6PItBgQ/Hszojs3QHncrHuEKtsITR9t3UjrQy6UF3p
         snX2SYFRcAmp3an1Wy8uXaqQ9UKmiOHCmWjttra43w36iRMNcopK4KNIF775+NSH2v2c
         TJEQ==
X-Gm-Message-State: AOAM5339emz/XGIfC/3R/2VMAzUs5GenrgHgtNsgSVdUxBYOELUikNjn
        AkqWtoVi3wG8juDLaXZoEHQ=
X-Google-Smtp-Source: ABdhPJx4aH/axjJpFpDOjbOiN8JuiZiLYbtFxERcm0uuN9Xjc0uKWDIuFz8ESgqBpekhNRBqg9O1LQ==
X-Received: by 2002:a1c:9652:: with SMTP id y79mr4175402wmd.71.1605005410743;
        Tue, 10 Nov 2020 02:50:10 -0800 (PST)
Received: from ziggy.stardust ([213.195.112.112])
        by smtp.gmail.com with ESMTPSA id m20sm18743080wrg.81.2020.11.10.02.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 02:50:10 -0800 (PST)
Subject: Re: [PATCH] clk: mediatek: fix mtk_clk_register_mux() as static
 function
To:     Weiyi Lu <weiyi.lu@mediatek.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Stephen Boyd <sboyd@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Owen Chen <owen.chen@mediatek.com>
References: <1604914627-9203-1-git-send-email-weiyi.lu@mediatek.com>
 <20201109102035.GA1238638@kroah.com> <1604972321.16474.9.camel@mtksdaap41>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <00a5aabb-b478-66e0-0663-3cf5557e861b@gmail.com>
Date:   Tue, 10 Nov 2020 11:50:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1604972321.16474.9.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/11/2020 02:38, Weiyi Lu wrote:
> On Mon, 2020-11-09 at 11:20 +0100, Greg KH wrote:
>> On Mon, Nov 09, 2020 at 05:37:07PM +0800, Weiyi Lu wrote:
>>> mtk_clk_register_mux() should be a static function
>>>
>>> Fixes: a3ae549917f16 ("clk: mediatek: Add new clkmux register API")
>>> Cc: <stable@vger.kernel.org>
>>
>> Why is this for stable trees?
> 
> Hi Greg,
> 
> My Mistake. Indeed, this is not a bug fix for stable tree.
> And there are simple questions.
> Will I be allowed to keep the fixes tag in this patch to indicate the
> mistakes we made in previous commit if it's not a bug fix for stable
> tree?
> And all I need to do now is to remove stable tree from cc list. Is it
> correct?

That's my understanding, yes. Keep fixes tag but delete cc to stable.

Regards,
Matthias
