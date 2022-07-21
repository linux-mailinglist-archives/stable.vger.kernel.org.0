Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A157D75A
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 01:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiGUXbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 19:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUXbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 19:31:48 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C8091CE2
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 16:31:45 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r22-20020a056830419600b0061c6edc5dcfso2282864otu.12
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 16:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/sAbUEtcTJXPWGLnJEGTRxiFlmb+PYYgzwIp7+NzKg=;
        b=FSl6ZX6WgKeGOe6ZW8IP66ZbHPByqA9XPz3e12c2P7DZXBwM0OZWCTvywxFGnoaBF0
         v01pucjNlGES/CZkk+Bv3nqBUa5O/QlTwDC9m7l69yVqnrrWjVRA+LajirlF85d0OPvP
         BuDKJ0d3PzSaUf97Cf5TC27zW11r3hzMe1A3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=l/sAbUEtcTJXPWGLnJEGTRxiFlmb+PYYgzwIp7+NzKg=;
        b=xHvygdjMwQI+3sKI7IDG2dN1LDhZB08oWJ2zhGKa2PbhcecIcTaqbUoRISRSGwVy3y
         QJB3OAmZho2JRBXkF29+RLEAZwvOKTjz87K9HqpvKkH0IEgP7vOTQ7vcgbGDu9zth2n1
         nxevlT0Kli4UJAIN+35gPFD0qihNMowZjBKF9m/uyepakFVyAUO3XDJ2yVEJphvPyMJw
         V5jtklhl8CeF0ZgUxiUxcKX4SbdNKxxcD6g7yjHR9tPjMy3MsKbWdYQHuWft4uL4CoWS
         J9UXMA8cgatH32Cvi7e4JnOP14rNPZvuv1jkDmKFJ8zz5z+Am824jqXh7i4Ej2gr1XqE
         1k1w==
X-Gm-Message-State: AJIora+bzcqN3uPqxEmVskgVPgoGHEh0GwozxRCognW2lqSslM2IsfsR
        5I61MFNkvLyKACTkOpF0RXoc3RYUamkbmx4B
X-Google-Smtp-Source: AGRyM1upRGuktIbtKYRvrwfiuKFQexHhl2NGbmNY1ZK7uAKQqA+AzMCyfT7ip1LxR6v4GBFVS5yCcg==
X-Received: by 2002:a05:6830:6081:b0:616:9107:3d5d with SMTP id by1-20020a056830608100b0061691073d5dmr332838otb.360.1658446304541;
        Thu, 21 Jul 2022 16:31:44 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e23-20020a9d7317000000b0061cace74ae5sm1353807otk.4.2022.07.21.16.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 16:31:43 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 21 Jul 2022 18:31:42 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/227] 5.18.13-rc3 review
Message-ID: <Ytnh3uTuecw/DaJB@fedora64.linuxtx.org>
References: <20220721182818.743726259@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721182818.743726259@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 21, 2022 at 08:34:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 23 Jul 2022 18:26:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
