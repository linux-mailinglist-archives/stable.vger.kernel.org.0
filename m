Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851FB443ED7
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhKCJFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:05:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhKCJFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 05:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635930175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GW5PqdxSi5KCG7ItOvj913Dpzqt3ygKMONX1r+7pE00=;
        b=C/1YLh/stJI8+6mLhxjy/uOIJOnIyY3hwk0hNnNlqQH9zl7MZHPV7hrEz+7V7USleQMdn1
        lYbat/lCFncikMMFB5rxtOnr77C7Z3DaHNvK74UPNlubMbkq0sK052VuBFM/eyesbyqdYV
        oU7oztr/UOd3ruZDnbGFyO1wiPRq/ZA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-HCYJqVcDPMaHrAv6de7sVA-1; Wed, 03 Nov 2021 05:02:54 -0400
X-MC-Unique: HCYJqVcDPMaHrAv6de7sVA-1
Received: by mail-ed1-f69.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so1806638edx.15
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 02:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=GW5PqdxSi5KCG7ItOvj913Dpzqt3ygKMONX1r+7pE00=;
        b=gVyKVHcILa9Ekdlhye5Bk8UOwT4lKPssDFTGuCFSyDE1fFRpiNjSbiWEZm3DffhZqo
         EK3aV5IybI3BK0ZW01hB4WvdO/buIR6W3j9qEjMQwcpxEvZFdvgDqO4xlEaNSY2XCibK
         OsXZY3CxV/08B+2nszy5maNReJSxlUQxadW+N0BqGBjZMpm5Vk0ZrtR7it1VFfqHuuG/
         lAx2VTD3H99zHidZvXohWKAYsiv7sHQDTR8bUG61KJ9J7bF6BkC6J5aIVd5Hs/4iykIT
         dZtpXGxyhtPI84zmN4Asmv4yeeQwCZz2iJNp9D6B7F91EpyxpOn4JfAIoq8L/ssROCVR
         IpkQ==
X-Gm-Message-State: AOAM5309yDsg/JBN6oAUUg7kPU+qllg6NBx/exlaEyF7kXO3jKx5JL6f
        YFmzO+OVszMDOtJi6v4WaxPs4JotB1r+40fCLiZDtWngEVmlu2qGClsCDc8SBm8DwXqJyAX5irZ
        Q1na9IaNN5zK8UAre
X-Received: by 2002:a50:9993:: with SMTP id m19mr23521656edb.259.1635930173197;
        Wed, 03 Nov 2021 02:02:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWRmj9ilQ/OEJojJUo3AXlJoWFPzkEWa/XBkGAvH0th24PwLNoE1sjEIbVfGXcao4SjjlUiA==
X-Received: by 2002:a50:9993:: with SMTP id m19mr23521638edb.259.1635930173062;
        Wed, 03 Nov 2021 02:02:53 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:1054:9d19:e0f0:8214? (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id r18sm782177eje.90.2021.11.03.02.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 02:02:52 -0700 (PDT)
Message-ID: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
Date:   Wed, 3 Nov 2021 10:02:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
From:   Hans de Goede <hdegoede@redhat.com>
Subject: 5.14.14+ USB regression caused by "usb: core: hcd: Add support for
 deferring roothub registration" series
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

We (Fedora) have been receiving multiple reports about USB devices stopping
working starting with 5.14.14 .

An Arch Linux user has found that reverting the first 2 patches from this series:
https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/

Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).

See here for the Arch-linux discussion surrounding this:
https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956

And here are 2 Fedora bug reports of Fedora users being unable to use their
machines due their mouse + kbd not working:

https://bugzilla.redhat.com/show_bug.cgi?id=2019542
https://bugzilla.redhat.com/show_bug.cgi?id=2019576

Can we get this patch-series reverted from the 5.14.y releases please ?

Regards,

Hans

