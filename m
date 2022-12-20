Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CD76523B3
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 16:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiLTPdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 10:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbiLTPdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 10:33:31 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6845F16589;
        Tue, 20 Dec 2022 07:33:30 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-144b21f5e5fso15733653fac.12;
        Tue, 20 Dec 2022 07:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MbMRylFp3yaUyriwlLlTe12XOv8mI1KU6wVM24tLw+I=;
        b=Qu2UNTVjYJGtQga16RefWVEcZIOVyI3q9u0INd0U0CkHYIn9Px+/LoCkj6jdVL9+mx
         zzN+xhoHJLouNYCYTnYQI+iXfOwjVGTVnwogB+E0RCaG7rLkTGZKTMpCE1ASv7EHUv2n
         Q7KAJat3u0lIvfTPEsum0DyQIS7iuOctY7NnOe8M4Vr/j7OmqYyOflWrO5lj1OWtoa2N
         w2GZK21gxmYDN45McIMw1hikKljiLeBWXxrWv0HhzSkSBE2pCX7v4mNSzReZjhFdb7JJ
         H36c849gsS/soLLQVFy4/KI0XwlhCL+DA0NwNj4OJ6zYQvUlQe2prksg+34b/TRBYYqv
         beWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbMRylFp3yaUyriwlLlTe12XOv8mI1KU6wVM24tLw+I=;
        b=cU0gTke9054z1+TId7jIuV5c3ZFbxEWTdqR4PFkc/CWCyO+p58EQL8HQ97Y4nbtDSJ
         6b8jtfQ4EyswsWWENcdgOiWdlO5zmiCQIKODYaeFJv3ledyPvtJ0uPi5llelC0AgSjDb
         p5Cu2bsX30v+8Ndn8oNDcN88Idtabqv2fOGfSHanEfUEY7zfvz9kNFkX5tTpb5vwZJeH
         ygcEKZrSe0n+rj0LXbEjPdVxZ/6mzIzDwdtj835L6nxut3jHPvxTi+MfmF+eM2ow6KUi
         hrgnphpvlNkmIz7iM0wia2Jw/diF4pWm0kNFIXkPFGvlJotgA2fU4/oIFuqHw5dyVE33
         OgUg==
X-Gm-Message-State: AFqh2kpm+kQhzjJlCAnKJGmuC5UKLc/fam1CvRWkfPKXmF5Rljibih3t
        1flgnXpzI19jYANM0AFI/V4=
X-Google-Smtp-Source: AMrXdXsmiMrHdrne/ezuf9SG5+KPGrz4wcocDVFvc/PGscEuPJKxAvoL+/RoFx+5MNphAb2GacEtfQ==
X-Received: by 2002:a05:6870:3441:b0:14c:37e7:2078 with SMTP id i1-20020a056870344100b0014c37e72078mr2458354oah.25.1671550409786;
        Tue, 20 Dec 2022 07:33:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s22-20020a056870249600b0013ae5246449sm6145955oaq.22.2022.12.20.07.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 07:33:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221220153328.GB907923@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
 <20221220144835.GC3748047@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144835.GC3748047@roeck-us.net>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 06:48:37AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.85 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 489 pass: 489 fail: 0
> 

Wrong results, sorry. I'll resend once I have the real ones.

Guenter
