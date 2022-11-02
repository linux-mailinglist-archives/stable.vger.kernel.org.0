Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F68616F01
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKBUpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKBUpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:45:17 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9366471;
        Wed,  2 Nov 2022 13:45:16 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id v81so11772098oie.5;
        Wed, 02 Nov 2022 13:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSiWPJniiLxzsO2IMiTjGqMh4d3SMmf0JzhNe976ryo=;
        b=I8c780hRp3L9X3806uZwlBW1cU6xUdYgk4w+ZiYe0rwOddJKq6yBcaPz0oF1YxfJaE
         SYU3u/735UxSaDIowp8o5fYJyKXvApm5AHc9NrgqWQqb33/pjMVNO1LcD8vVdLDyowdT
         L+fyvqPMZGvFRE/AlVstiokInwsRwVr0zyHfMKzBCshVSIZo22+pXjluNqkwmM6rpP1+
         Qx5iGZWCddOZ+tyS/0KVcVrl52Q0AP14t0j/nyeUE2Bvh7NdNzGtxfdo3tAm+At97B8V
         Eog4/ocyrxkyv+kZD9h4QTMj62vry3BsMjg3mqiU3/DMft46BD4nmKZN3v7JdZ6FUbMp
         UDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSiWPJniiLxzsO2IMiTjGqMh4d3SMmf0JzhNe976ryo=;
        b=xPPnFzGxsWRq4ryUc3KsOnkSZbnbcU5XLtFJL89EDXJ5uOk0HRqCG2hgiPM2hBZ3sW
         AJjNf3jkUaP29LB49XSzzQjdD/rAJcp7aD8pam0aEgVJUqVwESKjagH/5QeZeAVu+/pJ
         1NgODBFbsNjJw8M9fFaIeM15W97WmsUcO8W5yOOCuLFcVfUInM++QqzkuXb6l8HKW548
         pYyFSskPBfd58BLMi3oqOBJN10BsHVng5QgwZhhKl6vy49Qff5tPZaVXvKPN+lpeU/2C
         nETTePnuNfD2QGxv31SRtyj6wjt/iS6b9TJ7I3CktBBX3sOZ9kDApnv7dyN0frC6tEYs
         y0Ww==
X-Gm-Message-State: ACrzQf1sHCriluBEXATW5aFgg3u4AeC6b9JElp5BBDPFQHNiQL0tSRvy
        koZMYFBOJPgyll14PfstS0E=
X-Google-Smtp-Source: AMsMyM78I1JgVRU8WE1CtV6sWVA2ugCovJYFth9g0/88Bk/jU2d56hsGL67Xvh5zoTMmAsPg0OI8zw==
X-Received: by 2002:aca:4303:0:b0:354:cbc8:d269 with SMTP id q3-20020aca4303000000b00354cbc8d269mr14242321oia.115.1667421915999;
        Wed, 02 Nov 2022 13:45:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13-20020a544f8d000000b0035437f4deefsm4946401oiy.26.2022.11.02.13.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:45:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:45:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/60] 4.14.298-rc1 review
Message-ID: <20221102204514.GC2089083@roeck-us.net>
References: <20221102022051.081761052@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:34:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.298 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
