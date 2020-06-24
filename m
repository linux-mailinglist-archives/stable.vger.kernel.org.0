Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54DE207F05
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgFXV6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 17:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388452AbgFXV6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 17:58:34 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B569C0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:58:34 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n24so1167411otr.13
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h+nPaOF7g1qY8EOAE2i6vUjX5UoCottzvvovb2/RSXU=;
        b=ZZQnbXuyQKc0MQoausN18nmR8BjECWh1WF7+nC4nUcnCzFaIDISaNlFcskElS/j8p2
         Q3dj1L9xll9zyWN1yhydKD/lOSa0tmOXTdytpOeKrnv7f+qE0Hay+jP6ZzvOud7dN0LF
         FNBDKhlpf9/CW5ofqlXwhhSYrZILyzUX8xb9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h+nPaOF7g1qY8EOAE2i6vUjX5UoCottzvvovb2/RSXU=;
        b=jGO7w8ZzdtYGkYbgph9Zsa2gNWHJ8lsufy9en6ziHIRomM278m7TD9oYxneRtbhKpv
         UvyDxEl4TMUplN/1V8hy7XHzLjDY/ygjXxDQtPd1lwcMjJ/DjcyonOJ6lGq380jWsY/p
         NzCKTazquMlzjyFSJzluk4GRMYYRI2E9T37sI+VJzInUwYfHv9FrZDLIa3TlQs/bE0D/
         4lXaAs8dRwxVUhHozxIDHeHgBbkW4N5thaKwIRwdhf5Sl4uE0xtcGJuQfVn+UWlFkTMh
         XVdwpS3NAPeImV6HQRrRWcrHDuVwtyosrWmEFrTerf5zx0H/wxV0frbKKrQ0AFyJXiUR
         81sg==
X-Gm-Message-State: AOAM530b09Ha47N186HppfRrd6E6rd+6BnCJfZyeTFd9nom5gLqGNXER
        3D4wUdKg9Q8K4u49MBNbB33OCQ==
X-Google-Smtp-Source: ABdhPJzTPoZWg8CM7iAvZgzyIFkWBJXOWd2M3L+8xmyNFYd4cOYQN0plC/CfOQWEPu5FuiY15fGHhg==
X-Received: by 2002:a9d:7c90:: with SMTP id q16mr23928828otn.359.1593035913500;
        Wed, 24 Jun 2020 14:58:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z20sm97672oti.49.2020.06.24.14.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 14:58:32 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/314] 5.4.49-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <61d837be-c4d1-f0b8-7f15-6b40601d9aba@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 15:58:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/20 1:53 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.49 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah

