Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5936E227357
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 01:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgGTXye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 19:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgGTXye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 19:54:34 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6CEC0619D2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:54:33 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id j11so15782748oiw.12
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 16:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=if+J3IVB9GmBlt0xwkKvRDuHXhNcTWZ9ERH3YUDWulU=;
        b=PpZ7kO7OncEuLolD3qAx3ZaBqS9vrWM95lqFbasCA2aXj+MZ+rVQtPZWEMNIanGf61
         Na6Oe+TcO5HMaPI7RB6zH6J/H5pLbYS/aukNu9udrsSzXPLt1r/0zM+8w1IfpiP1XrwB
         AkuqoV0NW1nuCu6cUp39D3jYjEPD/Wm2wFo3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=if+J3IVB9GmBlt0xwkKvRDuHXhNcTWZ9ERH3YUDWulU=;
        b=QHRZfA89TZeD3qtnt1Qr2fdn4nlv2yB7WYP/HI+MobsZB4WRROj/fRsU95XxgrySVi
         a73MGi+YyvrCIsDIaW1GyxfxXQBc1sIp9Vh9YADDYOU9jQ1AGvPnaLJo54Qtkr88ZqHi
         F87GgNlLasGOf2mIgon3VyV7w9NKMgP7hvP3uFk1O8F2Ve2q/cRFVJY1U8WLmdYZSS1x
         cUn+Tz7w9zIGmEq0MVaPW/Pgc0Q1c+0dwiQAJPPqOkbnN5EjWtxiyhMWYontnXzZMukn
         NksMfPCUC2UIHaAYRxgOFkOwIgxGIq2cXJNcTNfTAZLd4JaDKLOiIfpjINPXyW+o72l8
         uB6w==
X-Gm-Message-State: AOAM533sU5Ol9PRV6PEN8mjM7b7bF1EKh2UoWxmMauEmBJRt6GJG94zP
        S3NcAF7vBn+JIOYYcro8yNk59naJ0Tc=
X-Google-Smtp-Source: ABdhPJyDkBbrRB4Iv7wLrYZEpKoiuxvmE0USp8a8BxXTGbsstY3eCXpSVmnlfwVnDfDA0j21MXvBSg==
X-Received: by 2002:a05:6808:199:: with SMTP id w25mr1215562oic.38.1595289273305;
        Mon, 20 Jul 2020 16:54:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h16sm285021otr.10.2020.07.20.16.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:54:32 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/58] 4.4.231-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b089dde4-8f8b-908b-9131-52939b42a6a8@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 17:54:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/20 9:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

