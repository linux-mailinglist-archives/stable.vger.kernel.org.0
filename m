Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1877D6523B6
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 16:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLTPds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 10:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiLTPdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 10:33:47 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48A518699;
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-142b72a728fso15770139fac.9;
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yo9h1s1BW8zwaie0UAm0eYHIJR1g4N+GT2rF9fz7vic=;
        b=OH8omz7lzZJc7F8hJUoZthfy0hS/ASASJYCBkwoLLLOxuJAUAl4NVe04TcQAviA+1E
         hQSW+rnxdGi7d9SDSBC1PUrxU2gPwbmw0ofFxJmHYH6mDDwwuLmLsiYkO2UGUWvWrQWw
         Nhw3Eh20rJbEo1ONMmfwCWKO/T95f61Ts78E0yvAND2fP3N1Q7e+5vNiq/DQ/oZuLGfN
         4PsxzpIKi6XbmwaI8hsUv3GMQDhaB2FNStByDt7Sp2/q/op9b02zgJXSRtCUjvxOovsA
         qJghdTMxk3+Kn300Wgc9rjtKZ5YTanFk3CuT5btqskoA/PNGDNygo5Y0WHQoPN9ZObWj
         nHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yo9h1s1BW8zwaie0UAm0eYHIJR1g4N+GT2rF9fz7vic=;
        b=F4nr3A1Ss5H70nUwoqtxfqAHV6JrCmExgoQhFJWNLpbOOd+aMBPsGWNOtNF7Fg8iCY
         ujDnO/kPG86x7hJuuvtrROAXwz9w71nOSsTdcbmyB9acz5/6U6SeCibks8tFh3WzFUqf
         s44ThhGGRGBr2kJ/tA2W4iAoJFTfUB7f5lStH6YrEVP8b5V1SvBIvd1ChM18FRAsuJbr
         qnMu2n06Zbf9CmqlUMP3wRf6PMmPM1l0JUi8XJnvbPB+wxw0l9hqizaavWG9M6OF49pk
         j2Pb0oaVuhQWt2yMLiYnsLyYHIlUWLzRygeyJyV7FkYQCRh3FSN07r8mLbTWouw0hT7Z
         oKGQ==
X-Gm-Message-State: AFqh2koBajpD+JIeggVU9lHDeR72AKqQN2n162ir18UN2bgWiOVmp/61
        TCA1j7+7QYUfwZBaxMpX4I4=
X-Google-Smtp-Source: AMrXdXtzfQWHHnPWPb1ZCg6RnAuIr+IAtaebPI2baMpcCwPSDN0D2ABCsJs1j6r043zth35mfgDwtw==
X-Received: by 2002:a05:6870:9a97:b0:13b:d910:5001 with SMTP id hp23-20020a0568709a9700b0013bd9105001mr7557544oab.1.1671550426293;
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t41-20020a05680815a900b003458d346a60sm5607487oiw.25.2022.12.20.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 07:33:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 07:33:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220153345.GC907923@roeck-us.net>
References: <20221219182940.701087296@linuxfoundation.org>
 <20221220144806.GB3748047@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220144806.GB3748047@roeck-us.net>
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

On Tue, Dec 20, 2022 at 06:48:08AM -0800, Guenter Roeck wrote:
> On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.161 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 162 pass: 162 fail: 0
> Qemu test results:
> 	total: 475 pass: 475 fail: 0
> 

Also wrong. Sorry.

Guenter
