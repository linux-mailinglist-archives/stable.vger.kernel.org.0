Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC712668934
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 02:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjAMBgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 20:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbjAMBgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 20:36:02 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B8456147;
        Thu, 12 Jan 2023 17:36:01 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 5E9F820DFE06; Thu, 12 Jan 2023 17:36:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E9F820DFE06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1673573760;
        bh=FkafJS8VsvJLT1ALvP9aAGd7nzhETQrBv0jT7rET+K0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JmqoviMH3EmMYkxuVUdAux/ZO1GkkEcWISx1nwhOAXwA5tl3eXQeLAww3G6jWusnZ
         cD2jwvczSIr8Ur9NT66kIWsPV5g/8bO/ghSaKP8CohnIJayb5mjyJS/vM6nqe/53xI
         X/UgljCl9NLF4VDitYQdX+tWQu82U9Yx66O9rueE=
Date:   Thu, 12 Jan 2023 17:36:00 -0800
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <20230113013600.GA27117@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230112135326.689857506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
