Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1242758ED60
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiHJNdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiHJNdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:33:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB81F61DA9;
        Wed, 10 Aug 2022 06:32:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t22so14771070pjy.1;
        Wed, 10 Aug 2022 06:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=R39gwhribMbbXOTytoDPh241mFg8TUvXJGcKCdooFyE=;
        b=P/0jJE+XFLOcqowKtaqvTp4waGzUtcLzpciGjN9FIc939lWREBlXZP5Q8Jp6BCAoKJ
         c2/+AuIChOIiOW6QEVzDkJIWG7HYq0utHuh6yHunp4V7vls71lJoreMjuUzgVzFzaFte
         oMLSD2YSkafV9lHp0Sv3qX4OVatG0Aay4a43+TQuJOgmPBvzrlBzDRv85tkO0SF4RgB0
         G2rw1Jjd0+cCRbP93MbuNa3jixrYJzJyEZCpnf/zv9kayAX0+49ymnG6Z9SPAUIjU2gT
         AMbm691i0O0D7dTI7kvKYSRgiAqndGLruQEQGfHmG7PGT/6K77coNXKj1P534T7KmVCI
         6nYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=R39gwhribMbbXOTytoDPh241mFg8TUvXJGcKCdooFyE=;
        b=C7ADdl0SKgH91Jbcd5JTE8AMK1wnWlXwdunelsaDkgP6LGu8FUowDDivZMwhZdtvXY
         wTV7Hvni8Y4MyCZG7mKCUEzsNAGy2PJ7qe8RLxx5VUYON1aErGzB3OBEEtbxW2II8Lpb
         WoUdusGJXUco8IIrEfXo52ZpBlqQzB5Y5byGRzOrtwxcwg8LZ6e/heaJtZ9clhhWAzZB
         JdxqGjkk1AjMDDvQE3AxTVS9usZIH9Lnf8vgTo3L6ZQPIloumHJ3u/kvXO8RL7oLFCIR
         4dZViHpKWmIENrOO5+kt3C7uJwBH0eOSodr1t3s474FN2lhmooBvLJl5iVwgQE8lWN4Z
         6xEw==
X-Gm-Message-State: ACgBeo2z9/NTWv1/sBzu5SIdtUq6hRVFBJNGfIKfv8eR0fZ/Ka8KPZjH
        DyIDNOPQG5f96Vjilh0nueQ=
X-Google-Smtp-Source: AA6agR4OdCUgf0+g/PyDSgRt5q0P/evo1+e24n/Jbzxqce85yRsxR6iehgGNOWDWZp4mL2auiMdO0w==
X-Received: by 2002:a17:902:cec5:b0:170:d100:e6c0 with SMTP id d5-20020a170902cec500b00170d100e6c0mr10612616plg.132.1660138360209;
        Wed, 10 Aug 2022 06:32:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d64-20020a623643000000b0052e7f103138sm1965812pfa.38.2022.08.10.06.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:32:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Aug 2022 06:32:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
Message-ID: <20220810133238.GF274220@roeck-us.net>
References: <20220809175514.276643253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
