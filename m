Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B4C3C675B
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 02:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhGMAPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 20:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhGMAPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 20:15:42 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BD3C0613DD;
        Mon, 12 Jul 2021 17:12:53 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k16so24862798ios.10;
        Mon, 12 Jul 2021 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=BibkKMaAfEZ8hOIERin/RWZgV0FiHtAp06hOGW+WkZI=;
        b=OgSPeNxQINUMafyL4K+tMDB0PLCCQenEgVQfYGw3vImUT+xgexJTnA/WUxgSd3HIfR
         BEYUv/ki9CIWpJsV0kU5CCVM/V+lfxpcMjEQkEsSHnWGYlVa1PJlO3stgkJnP5upnFBH
         R8RS44V8fn0bu82TMDLCI8k7O/2XybPqklQvyr3hkZF6h8Ra9dViHqZ7SqbnGIKimKqf
         y2XMh87NM8wMUavxyZIgu5q2PiIcR3FYiyRfG4BSCRta/A5eEG4iUCNyjOQ1QVWUQNab
         OfnHfMei2wfCEzqegMoypR5c3ZxkKbSrKRyA/nltUB26ujG3t02O7yDEV7mXc/gtOnbK
         PAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=BibkKMaAfEZ8hOIERin/RWZgV0FiHtAp06hOGW+WkZI=;
        b=iBXM+UxQ8fiKQ/DJoE6AAWeFoMNbnhCEmIE5UgvgQNu4HOKK9o1azMQRfwuG1OvxBM
         o7l8Ub1V1AwbNoi/+LoP9uXgMF478ZWOLvB5DuvcODgQaG7+Gw5lODdJGeDV9lJVmB7Z
         NXBBVy47hMfXuSrllbl6PBlSlQx0zHfnA7MYYzNb85N683Ue5nmd3fFBDkSsQNVNEzp4
         KceeulEJIbYaeFFNsQqvUDmOIPTAum9SyHOHstIIpEbUJgHa/2/5lTyZNNLwKwzwZqvH
         vk7zog+2hv+1gwtZbT5NA0tc9C8VvtM735qXKYd0UNvkrhVS7Dmypto9pbaieLBEL8/J
         T2rw==
X-Gm-Message-State: AOAM533gnEDtw6tlMGxa9f4U/Xwzz/lvAy7JA2pkfM9xuxLb+3vDEGsN
        sXmT7lAfGa3vXwHUL1WyY4HxbN6NTT2nF2OegNGstQ==
X-Google-Smtp-Source: ABdhPJxc5UVlTVLMcdS7I/pKWpl79RASEJk+yKR98YI6d2HdZoimd2s1m7n3kvRHv9rw1JR9emxusw==
X-Received: by 2002:a05:6638:3594:: with SMTP id v20mr1334278jal.25.1626135172519;
        Mon, 12 Jul 2021 17:12:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id a12sm9440132ilt.3.2021.07.12.17.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 17:12:51 -0700 (PDT)
Message-ID: <60ecda83.1c69fb81.25eb1.68cb@mx.google.com>
Date:   Mon, 12 Jul 2021 17:12:51 -0700 (PDT)
X-Google-Original-Date: Tue, 13 Jul 2021 00:12:50 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/700] 5.12.17-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 08:01:23 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.17-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

