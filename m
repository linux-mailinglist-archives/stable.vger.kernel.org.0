Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179325271F9
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiENO2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiENO2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:28:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84C2BA;
        Sat, 14 May 2022 07:28:44 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bd25-20020a05600c1f1900b0039485220e16so6391183wmb.0;
        Sat, 14 May 2022 07:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWBF7wNMgBnw/1Dr330eDqqa7w483SgU45I//Zy0x+k=;
        b=e5MBLV+T41NZUb1/+LitSnC7oXj//fBqt4glWDxiLsveSFRuZeLJ1I66lsUMuOg3VG
         MxHoqHmf9jp7koSILZmjW0jvecEWlOCslfzSsvgnQ5FFjhg2OgEmcXrw7Buszx9MIU1B
         L0kP3PEqiEN5U1MAshZ9p8H3oXeiezMyYzsqfk1phILHb6N7/KtrwSVPWyn8JEox7KQX
         Bol1ixsLlqV57a1aHB+bM3csQVoIy9FGYh0bKB9XGl9o85nxIxCocl1pYZGZKtbpATXz
         BPwVB9nEY93bxxqMHoGnf+O524ZCGBB9IBkTjS2IhNZFLchfAB97jDXN23g5XBGY9NFB
         Qjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OWBF7wNMgBnw/1Dr330eDqqa7w483SgU45I//Zy0x+k=;
        b=ZUhpgedQbc59R7FsFbNWksonGGL30fnifQ1rZZ4epGq9TJ1GbqtfwxZSjkBMY1f6kK
         xFSYc5oweiywN7UJJxDEvrgw1s2yY55oIqCEjUdmsMUCEQTCzkwEImNsM8Dp4VJS6kTd
         FnmwtodPbeeSoOVnG8znqBCKlGHftGeaYXEPkHglrwzsU4Ra4YXFrmc/mqS2Q7flqAUw
         YXK6PxLd48LpSU8Y3sIQFCBJKABelKokO/NydQgxC1aVzfUjNMtyg/Pgz7zfPwMymtnk
         +AhOI6cA7gJXzMJdvgdG9SAsYLVpoTjC3bDK4Nl83LnClF7Ot8eyhev1+76Qa5cS+JLm
         B9sQ==
X-Gm-Message-State: AOAM532N2b5eHk0nejX1VI/pfah7663vgsdHbJo2W7vUYB7Swg5HcbOQ
        tbTl+lqsB9UG3Tc5Ff/dHcFLGTtk6MA=
X-Google-Smtp-Source: ABdhPJyi6VCEDGuTnagRLvPlFe+GPrELZ3QSnQZ+cTcauWlHFR3PTmiy8d9hs6NUz2iK6AUwn1IleA==
X-Received: by 2002:a05:600c:3595:b0:394:8343:a66d with SMTP id p21-20020a05600c359500b003948343a66dmr19715566wmq.49.1652538523340;
        Sat, 14 May 2022 07:28:43 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id y15-20020a05600c364f00b003945237fea1sm5400156wmq.0.2022.05.14.07.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:28:43 -0700 (PDT)
Date:   Sat, 14 May 2022 15:28:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/15] 4.19.243-rc1 review
Message-ID: <Yn+8mTKCtT5+MbJm@debian>
References: <20220513142227.897535454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, May 13, 2022 at 04:23:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.243 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 12.1.0): 63 configs -> no  failure
arm (gcc version 12.1.0): 116 configs -> no new failure
arm64 (gcc version 12.1.0): 2 configs -> no failure
x86_64 (gcc version 12.1.0): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1137


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

