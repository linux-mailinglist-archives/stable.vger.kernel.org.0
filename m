Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E540D15D1A0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 06:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgBNF2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 00:28:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55370 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgBNF2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 00:28:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so3373693pjz.5;
        Thu, 13 Feb 2020 21:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1uZtESjl7HpLdeVC/AAX+aRSr5H3TvQiHR9FhMEa2hA=;
        b=rYa9XgJGlI+sSN7980fT3QjT2S68H1NlrGjwKVZRQwju1aVkfz+i6F60197y56u2N0
         Q9ecw4D3cLXfNibJa+ppqx46wYKmOpcAQBiCf9kkf0SEt2r6eWXiPm9dLlvJk2Smmfrf
         qAjzHTSW1VvaIgqY9obLf1oprqpKxdFanPQyFrA4KdhlYf2Z/GpkbVyC1kEhINp1nH+x
         tXTgdhp0Z7qqZTy+Wc4o7XhMAKbcizAExaqozFvJmAd8sUcoWObI4xu4LdOJWUEyEBg+
         XrSmkZ9aHSWUrfz9zkNF3IIEnyF0tqA6XBfYti5U+VKpeI12T7wheVGKwbnFZa8JmToC
         ZWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1uZtESjl7HpLdeVC/AAX+aRSr5H3TvQiHR9FhMEa2hA=;
        b=bJIHBML8alnCmCdB+RW0U/jvpH/aq81wAU7nsyTWR1SmnDhhDTfNizaKAoM0aaccIV
         VHop8XrzsvUZ7bOygQLMy7HrGpXJMCrrFpHLcTH1FRww2q/liYzEp+u8w/wImwjDnL/+
         9elk7ADTKEMv17H8M10L9acTXr1Tgd7pvZaq1kgwbbG5crXyYOU+laEvrzwObbYOuQ+2
         kRXat6tjsK7uhKzzZQQ//MpEe2QqkEC06hafvLbykwMJC7/RoiGOFRVeMDSKjofCeyRq
         vDELCjYIZoMBl/3TjU/t3E1HM3LQUvWlv4WSCCqhrkKj1awT+pYGq27DqKKL0AsAHU7w
         3jwQ==
X-Gm-Message-State: APjAAAUj3VlLf61vvdcx0ru/FJyZEwMd7xfg68cjXRmBTkCjhbslTdKT
        gzkporVyjiOy6V0d9JSPazvfHtEi
X-Google-Smtp-Source: APXvYqzQytfYa5uIWf5nOsZBZa4V0DzDaJG6jHeCcVC6/11hKMQCXHcI+yiZ3VUlk9xlKDgMOyROlw==
X-Received: by 2002:a17:902:868e:: with SMTP id g14mr1602334plo.87.1581658084987;
        Thu, 13 Feb 2020 21:28:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c15sm4862461pja.30.2020.02.13.21.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 21:28:04 -0800 (PST)
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200213151931.677980430@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <edca878d-6318-54fa-c18d-60bf0186a9c8@roeck-us.net>
Date:   Thu, 13 Feb 2020 21:28:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 7:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.171 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 


Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 379 pass: 365 fail: 14
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:mem128:zynq-zc702:initrd
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc706:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zed:rootfs
	arm64:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:smp:mem2G:sd:rootfs:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:nosmp:mem2G:sd:rootfs:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:smp:mem2G:sd:rootfs:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:nosmp:mem2G:sd:rootfs:xilinx/zynqmp-ep108

Failures as reported separately.

Guenter
