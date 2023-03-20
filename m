Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56EB6C09C5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 05:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCTEnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 00:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCTEnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 00:43:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A23546BF;
        Sun, 19 Mar 2023 21:43:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so11105475pjb.0;
        Sun, 19 Mar 2023 21:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679287396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XvWHoe4oka91PRMJ82kMIgYEdl3/ETSadVO88206sUA=;
        b=CCdq9rHl9h5ultsOwA2hAWww/6tT1QFPz+kpyfKvfgFpp5Tu3dfmuRJlUe3SbX5gLH
         jLa6Rj4SAJ4K37w8uCw7FVGv3BzNIrBEDVqMxpACRgh/5N3ZqouGe0T93ZsKBIQ0ayKz
         6aG2UVYdNCs6+Q/TDYUqSAfqPB/sg5tKibI3plMnIdRoIHLRyvxUmtjIFTNpz/c4MjDB
         iJzOfuVdBqU75lNrZ7WZiOspjQwyJCMJSUZ9tu4kCm9e9qq6RQQLj1ryMZwu8NTDBgLh
         JfCEBcWkSrG15Rdapzy88TTq3R83lbyXrXiF+Dv8XZOgkRmnz6CnWp1W3Xhj2uwzILb3
         Yodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679287396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvWHoe4oka91PRMJ82kMIgYEdl3/ETSadVO88206sUA=;
        b=OXBdTH+fV2nVRYNZKarMiiPFd4/XF0MexSia082DngpNYs/ig92e84SNDvhu1r0202
         yHlfwIb2Tbo9cfwjiHavJYYBxEkKRvH73RCPZGrYIjb6Cyc5uox011K02InivIypNVJ7
         ZWCIjY7b+xF+K25UjRModXg04vPMEMFQwXzAe/Z6iBFqwCqwPzSBifJnsQplI/E9JFTv
         OAgDif4L7/ZYwU75IjMCRSjEMC+0Q00BNZje1uF+KAA4Y4D3nTmjNIHdsdh7r/yqItL1
         2Sgjn53lHmSSrSy7Nui1aUiB0ItegudVvWrPFtVRwX6FvmuGKNtX9oOBOGisOoevdpIt
         tFRQ==
X-Gm-Message-State: AO0yUKW6T/9OVBSpGqjXebBAch1A1x88NACf2SsVEeADtOYOtH13ZCGa
        bX5ZGxIV5b68wnsHql44OeQ=
X-Google-Smtp-Source: AK7set96QRyUOxY1uSoFxs/xmLDiRsjHIy1wl/Y4P5b8GeqQx801IawR2/wB+IfidC6bI1/d/D0AZQ==
X-Received: by 2002:a17:902:f685:b0:1a1:a727:a802 with SMTP id l5-20020a170902f68500b001a1a727a802mr11720931plg.19.1679287396541;
        Sun, 19 Mar 2023 21:43:16 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:687c:5175:b0b1:a145])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090a154900b002372106a5casm4971744pja.44.2023.03.19.21.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 21:43:15 -0700 (PDT)
Date:   Sun, 19 Mar 2023 21:43:12 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     msizanoen <msizanoen@qtmlabs.xyz>
Cc:     hdegoede@redhat.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] input: alps: fix compatibility with -funsigned-char
Message-ID: <ZBfkYEe0LfITyiUh@google.com>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
 <20230320001731.175969-1-msizanoen@qtmlabs.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320001731.175969-1-msizanoen@qtmlabs.xyz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Mar 20, 2023 at 01:17:31AM +0100, msizanoen wrote:
> The AlpsPS/2 code previously relied on the assumption that `char` is a
> signed type, which was true on x86 platforms (the only place where this
> driver is used) before kernel 6.2. However, on 6.2 and later, this
> assumption is broken due to the introduction of -funsigned-char as a new
> global compiler flag.
> 
> Fix this by explicitly specifying the signedness of `char` when sign
> extending the values received from the device.
> 
> v2:
> 	Add explicit signedness to more places
> 
> Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
> Cc: stable@vger.kernel.org
> Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>

Please use s8 instead of signed char. Also, could you please tell me if
"msizanoen" is your real name? It is required in the DCO. Apologies if
it really is.

Thanks.

-- 
Dmitry
