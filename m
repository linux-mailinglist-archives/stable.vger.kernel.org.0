Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EBE4D7AE4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 07:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiCNGlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 02:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiCNGk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 02:40:59 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4653D1DA;
        Sun, 13 Mar 2022 23:39:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p17so12692996plo.9;
        Sun, 13 Mar 2022 23:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mmcv5TZfNGCnVQUPAFbxPeS2spQLkzrgzp0E7bOALiA=;
        b=KgiqevLknK6xxWE4MCm0+9sJNIAtHmuRvsf85q8qtHaHdOosoSY6cILghsqN220enF
         K6xvJfn18MAZZ60bDJIpaj8VG/Y9p8Tivs+SNATTYz5YoVcNqKwGmogBPJDy9XnMNXTi
         qTqNflnmZU0ThfMHgBXwHNa3IU/PWeS5pF7ZFAIuM3Dtlgsg3glSW0Xo38LKY2CRvsfb
         wuLqCl4ESyql7ru/FR0bvTvQ7Xx5KKIRV6jDYmXHQ6HBu/3syEC96U0LPGCxGDk5PVis
         NfJjdiu1qmLZMbuhkEQ6fkGP4elttVEhLtKaf5+/EuNt8Tu7Wl79BpDtSy3yqgxPQKkC
         /zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mmcv5TZfNGCnVQUPAFbxPeS2spQLkzrgzp0E7bOALiA=;
        b=vf8muGZ/6l6tB+YyAWq5DRI5L7h5kbegNmvRNneTOZ6nT19Oe8TO6yK84KoE5Kaiim
         Zytmj+lFzBTiE2mgDKyQFlGbuLVCXdulGrX4FoQeJLDKE3ozQjfT86z+RcPiwhNfx/Wa
         TGO5iRgVmGzebTLRDDxeh+9nBAzZiaTKKpEwyFUSCjdA3pQx6zO4bwU0xy1+2OMPA2kd
         hIDY7zrAu7mMOOuhUf4g4MaFZ9Ey9bq5ckb8+a9x0/kYeBwYgeAA4PdIsnfvspQTur86
         VWFubue+s4KAvF6ZwcnKthiZxIcQzr0Yw+yL5SNKIgD0LNFaV14xds8HFVz27QlMa8C9
         fZRw==
X-Gm-Message-State: AOAM532zf6hrrsfbZLqkQgytqdw64fTZ8Ye8SmpKDFooNnrG3ZsFH53E
        AkgMKTcv1bJZi0ioZENRBzXDmYbdLMU5fA==
X-Google-Smtp-Source: ABdhPJxgRi/ASINvSzU9IiH2LQJ8NUejsqVZ/GvLFsFqIUnyQYVzk21gAMkLYdHW3vBG2r75D3e27w==
X-Received: by 2002:a17:902:dac9:b0:152:fd44:1309 with SMTP id q9-20020a170902dac900b00152fd441309mr21965395plx.123.1647239989536;
        Sun, 13 Mar 2022 23:39:49 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-42.three.co.id. [116.206.28.42])
        by smtp.gmail.com with ESMTPSA id k5-20020aa788c5000000b004f7a02d2724sm8246281pff.50.2022.03.13.23.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 23:39:49 -0700 (PDT)
Message-ID: <9564bb9c-e8f0-77fa-4464-144efc4854e8@gmail.com>
Date:   Mon, 14 Mar 2022 13:39:45 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/4] Documentation: make option lists subsection of
 "Procedure for submitting patches to the -stable tree" in
 stable-kernel-rules.rst
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-doc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220312080043.37581-1-bagasdotme@gmail.com>
 <20220312080043.37581-2-bagasdotme@gmail.com> <YixrEFMkSZthmQpo@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <YixrEFMkSZthmQpo@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/03/22 16.42, Greg Kroah-Hartman wrote:
> On Sat, Mar 12, 2022 at 03:00:40PM +0700, Bagas Sanjaya wrote:
>> The table of contents generated for stable-kernel-rules.rst contains
>> "For all other submissions..." section, that includes options
>> subsections. These options subsections should have been subsections of
>> "Procedure for submitting patches..." section. Remove the redundant
>> section.
> 
> The subject line is really long, was that intentional?
> 

Yes, because I have to spell the full section name the option lists
I moved to.

>>
>> Also, convert note about security patches to use `.. note::` block.
> 
> When you have an "also" that's a huge hint it should be a separate
> commit.
> 

OK, will split.

-- 
An old man doll... just what I always wanted! - Clara
