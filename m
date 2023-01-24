Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB75D678E78
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 03:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjAXCnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 21:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjAXCne (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 21:43:34 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004911BF9;
        Mon, 23 Jan 2023 18:43:17 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id p133so12149792oig.8;
        Mon, 23 Jan 2023 18:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prNWvFmWXRi6ZhVqb1pnv+VdehJYPKDnuFpbCwdm3Fg=;
        b=exmCtIQT0XNLjQO4ubQOKmKTku9yjVAB1bj5cRrQbBxxx2kCeVQrSasR7x/A25R67t
         o51/R8DY5BehfubUcYkKlAg4DpeBorn9mraemmm/ulVNIMNEwap0TUSqcvrGC7ZNCCCE
         XIPABupThdl32FFUjuY8DOW+u5B7IS5jotO0hIhmDLjAn9U0dWkbuTJq/wU3VxUVnr4L
         EMlVVg34PAQ3snEMwVyIxVHRP9XhEzxX6OZK38xDtVPlyvMDZ+o2qj/Ao3VcroGAis/K
         Aa7jshki0ufLP+EmegLTgQl1kupoH/nzaX7sZxaPD1OWYrIDlqDSf39xs7JQNrReiKl/
         QAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prNWvFmWXRi6ZhVqb1pnv+VdehJYPKDnuFpbCwdm3Fg=;
        b=jrHEGAvoJxoWfwmyt74j4dpUOojZ44Ge7izMv62cV2CW4pcgI9OADQdWIBaTSks8J5
         WLp2JsMofn+X4w++cGCv/gOLgdZITeRU9GkTd7mSuNreBbK7It9FYr7Qf3cYtx7/5NEj
         GFA3c0GAarSy7GuLQdqFqqhsZnbG+QM4lb0X6Cjtbh2iUIVydlHn7EjZFwAQ7GJ33aF0
         ukFqpXR5C+r/h19VVoDM88UWkI6RRLhEiqLDFdkhWalZerHe6m/firtt7eUmkoW8WiYP
         q6G+3ddHku86KuNkqThKxEbNy4rhaTRgV9LrBcrvWY36ihBBOWmOL8e7i0S6CgnCZaCh
         EAAA==
X-Gm-Message-State: AFqh2kr5szXwdN9+umTvExbmL8l0YT+V2d4XIg+nPdFATxPZ3wi+q54/
        YhCgp8s+jxrcsTPwwzii6cI=
X-Google-Smtp-Source: AMrXdXsBc0R+9NiGGckODiUzlLhgOLrCz7/ykSllbw3Y+hHF4JzY2zqYshE2bEQ5xDyBM1Z+ytiAXw==
X-Received: by 2002:a54:450e:0:b0:36d:460:40fe with SMTP id l14-20020a54450e000000b0036d046040femr11081026oil.48.1674528197188;
        Mon, 23 Jan 2023 18:43:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bd36-20020a056808222400b00364ebf27363sm548528oib.0.2023.01.23.18.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:43:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 23 Jan 2023 18:43:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/25] 4.14.304-rc1 review
Message-ID: <20230124024314.GA1495310@roeck-us.net>
References: <20230122150217.788215473@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 04:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.304 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
