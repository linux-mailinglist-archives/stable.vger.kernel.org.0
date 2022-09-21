Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B375BF589
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 06:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiIUEo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 00:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIUEo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 00:44:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CD97E827;
        Tue, 20 Sep 2022 21:44:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b23so4730717pfp.9;
        Tue, 20 Sep 2022 21:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=QvCStQH9wWobodRWutr5mV7TPPRrro8caiAVbbSMeAw=;
        b=M9IoHazJ/8Rc9MI/UxoGN6jKsOSMKrX35y2GS7AqghechlMDFEjsoh1s/lf+GHffGG
         UaBc4NhH61owmUpUxeestiA8RxhGObHEfx2yiSd+YoUTeV/TJKq90ORHobvV67mo3Y3x
         2mUwTHxUiObzLSMGR0lUfDfjapQYbQjI4GUaSmUt1A16poWNCsuW9O1meos3q6Mlp17o
         sZQ86rPyOt2FSoIVVO9bjxCGs/BD/alvJ5a7X3PuQOE4vP5YsnK8A5l5+jlgWu7Vpp9J
         UpkHkXGLUCBbjSEe83weEn089+idev3Ij8hfatBBkMM0nY9QK9vjFW84yppYqr0CFlrD
         CaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QvCStQH9wWobodRWutr5mV7TPPRrro8caiAVbbSMeAw=;
        b=wPfep5jGyrywNvtg02dvgIrhRnOs9DA5a2fxe5HfXfFA/oHxMIRtbE4qPctzj5Ewn7
         wvm0xOpV6lx+A5J+AanlN1FvN5yDLeggxVQMB+TvEYanyXn4rYLp9zzUdHxi4o44ZuQh
         q8h9IW/REovB+hQTzNWdbHpIAb/cQ+/IZ7QZhjNkLkmfyF5lFo1vXf8OHznk7qZrNwmT
         lfdL//NOm8zDHeaRfkQDQzC32Ac/MTB9Orc4RDionMVOnVLiXZg7WyIHBYfAliQ1S8bS
         fObgCsTUAqJY1hRTwvAG6vIZEeeTWPvuQHaoJVJ3pt2YHsDfhL0o2GNS78hzdMg1GMX9
         JZwQ==
X-Gm-Message-State: ACrzQf1Jc89CkE6Q8QGWCKaSpftQI4WuFQzgU8WX3HXkFQq/c3ivYTvT
        xC/Mpv2HX2IOhSlI0Yxm+To=
X-Google-Smtp-Source: AMsMyM7XhRL4gXDZPwHm37mPuhOCN3dCuo6MXMRo9ipXtoy/jcC/OZmhnXvBwwsLUo5tYDBrbSy20g==
X-Received: by 2002:a63:86c6:0:b0:43a:bd68:5075 with SMTP id x189-20020a6386c6000000b0043abd685075mr8103197pgd.512.1663735465393;
        Tue, 20 Sep 2022 21:44:25 -0700 (PDT)
Received: from localhost ([2406:7400:63:83c4:dfab:3b6f:2c7f:db86])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902c60200b0016dc2366722sm825262plr.77.2022.09.20.21.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 21:44:24 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:14:19 +0530
From:   "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To:     hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
Message-ID: <20220921044419.epojssm3g4j3qkup@riteshh-domain>
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/09/19 04:18PM, hazem ahmed mohamed wrote:
> Hey Team,
> 
> 
> 
> I am sending this e-mail to report a performance regression that’s
> caused by commit 244adf6426(ext4: make dioread_nolock the default) , I
> am listing the performance regression symptoms below & our analysis
> for the reported regression.
> 

Although you did mention you already tested on the latest kernel too and there
too you saw a similar performance regression.
But no harm in also double checking if you have this patch [1]. 
This does fixes a similar problem AFAIU.


[1]: https://lore.kernel.org/linux-ext4/20200520133119.1383-1-jack@suse.cz/

-ritesh
