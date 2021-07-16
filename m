Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A283CB9DE
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbhGPPdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:33:47 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57538
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240361AbhGPPdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:33:46 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 1460740A01
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626449446;
        bh=lzDyQtqSG+wcmjlQ/yngTHyuRcJlXYVjVPj//xbU6UM=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=G2iJbGHDSu50Aa8IFZd6UC/ntN+JmDLffa3IhgEaCJklrGJ8gmJazi8j88gJXk2MH
         9wPaUEvI+570tSL6oU6M0RyUbRJ0YODTejxbuLl+HhgW2ZkAPZF8VNDZ3wqgUBRC38
         G0oeXesV5waGXMFW0J45m2NsL/NfcQlPMJnAMD5+SsrH7JvIA6pjdx/haL/DKpv5xw
         XNzSY1XZkuGRyGMSXs6SvWxOUhG3hLwV7xUNU7w5PATU0NBwZ94kOUO+7S3O1VazXq
         178kK0/543kz7CDcMmEp/mNBo6x6YoGvDq3En74Psbf17HcvY+7PcALKmwWtSRx5ly
         T7jIDsu40EYVw==
Received: by mail-ed1-f72.google.com with SMTP id v4-20020a50a4440000b02903ab1f22e1dcso4994172edb.23
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 08:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lzDyQtqSG+wcmjlQ/yngTHyuRcJlXYVjVPj//xbU6UM=;
        b=P3MMB2DZSfO/LjS4zoGBXCLRdfajVX0dKeuy8XzYmFpyARrV5VZf6OPzSq1WuFWG2d
         U7RhdHBuqVHdqNRTWQTe3B3SjpM6Oxc9kUitZBkB162OabvKetPbv/mQpff+WUBNVZ50
         SEXXRSRbRvkQadeDK9X2v75c6gy0BoAea5h2pkv/F85a3CN3BoRwVRcUMbkV8eL68FhL
         toYbYfnDh1pgj7YBGPOoTOjFMfR+cUIwyg32UIAdAQHsbesWLGLsoOB6vOwm/pfRnF/5
         PVqSmjvRbUxoC7PuDq+TXd+Kc9mGyVG1jEwidpW2tRkdoFPoo/4vTL3xsU6Vo5zrFXQu
         VL9Q==
X-Gm-Message-State: AOAM530k+UdwolE/zydLWzOmRDjW8aRp9Ro3FCV4YigACAnVhqHErEBm
        KNurNqHGVncC3sGKBfbpI4LqNJoK4/1F58Zl/8zFEXoozyeTuGFz82PEcP1GTyw+jTG+kMgNPvt
        dDHrw1qWT+MTKjJq8sKbGRjluqgAQt/cGMg==
X-Received: by 2002:a17:906:f8da:: with SMTP id lh26mr12276255ejb.203.1626449445781;
        Fri, 16 Jul 2021 08:30:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3ZR6YnWdCijD+/urtHfcI6jlToLBCHTm2Ps4RlTgIkJGBVRrq5fffztq1qhaCEsSbr26unQ==
X-Received: by 2002:a17:906:f8da:: with SMTP id lh26mr12276241ejb.203.1626449445598;
        Fri, 16 Jul 2021 08:30:45 -0700 (PDT)
Received: from [192.168.3.211] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id a5sm3882632edj.20.2021.07.16.08.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 08:30:44 -0700 (PDT)
Subject: Re: [SRU][H][PATCH v2 1/1] usb: pci-quirks: disable D3cold on xhci
 suspend for s2idle on AMD Renoir
To:     Werner Sembach <wse@tuxedocomputers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <Prike.Liang@amd.com>
References: <20210716104010.4889-1-wse@tuxedocomputers.com>
 <20210716104010.4889-2-wse@tuxedocomputers.com> <YPGAq1zdem2QVTsb@kroah.com>
 <b5ba1134-d557-565c-ba45-556984a66e7b@tuxedocomputers.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <4b5dffd2-6966-f68e-5ec1-4dd946e81308@canonical.com>
Date:   Fri, 16 Jul 2021 17:30:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b5ba1134-d557-565c-ba45-556984a66e7b@tuxedocomputers.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/07/2021 17:12, Werner Sembach wrote:
> 
> Am 16.07.21 um 14:50 schrieb Greg Kroah-Hartman:
>> On Fri, Jul 16, 2021 at 12:40:10PM +0200, Werner Sembach wrote:
>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1936583
>>>
>>> The XHCI controller is required to enter D3hot rather than D3cold for AMD
>>> s2idle on this hardware generation.
>>>
>>> Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
>>> host in resume and eventually this results in xhci resume failures during
>>> the s2idle wakeup.
>>>
>>> Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
>>> Suggested-by: Prike Liang <Prike.Liang@amd.com>
>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>> Cc: stable <stable@vger.kernel.org> # 5.11+
>>> Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> (cherry picked from commit d1658268e43980c071dbffc3d894f6f6c4b6732a)
>>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>>> ---
>>>  drivers/usb/host/xhci-pci.c | 7 ++++++-
>>>  drivers/usb/host/xhci.h     | 1 +
>>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>>
>> Any reason you resent us a patch that is already in a stable release?
>>
>> And why not just use the stable kernel trees as-is?  Why attempt to
>> cherry-pick random portions of them?
>>
>> thanks,
>>
>> greg k-h
> 
> I didn't add the mailing list as recipent for my last replies so here again:
> 
> I only checked the Ubuntu 5.11 tree where the patch is actually missing.
> 
> The 5.8 kernel has other issues because of outdated amdgpu, that's why we never checked the 5.4 kernel.
> 
> Testing for 5.4: often hangs on boot before display manager shows up
> 
> 5.4 + amdgpu-dkms from here: https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20 : Hang on
> boot issue gone, but does not suspend anymore, and has graphic glitches.
> 
> Should I add these findings to the SRU?

Hi Werner,

This patch is specific to Ubuntu so it should not have been sent to LKML
(stable, Greg and others), which you did. I guess that's what Greg meant.

When sending such backports from your tree, be sure to set
"suppresscc=all" in your .git/config or use appropriate argument for git
send-email.

Best regards,
Krzysztof
