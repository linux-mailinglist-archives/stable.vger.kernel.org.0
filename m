Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A883BC573
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 06:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGFEaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 00:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhGFEaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 00:30:15 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228E5C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 21:27:37 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 10so8424375oiq.9
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 21:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vgcGPp9aZkXtzyTBQoqKKfRCWkZ+odsLG9ASOl08MJE=;
        b=VQzy0w/Ea25U2vjP3e5J2WdVUMMt0Xd4uGtp1elE9XSc7vOvA4CsEeU7LtYHcy8Jy1
         qjc6Mhsy/GuUAuf+W294e80/kID7B9nxlyB1+JayRYD7XUWX7qNmMjSxgxwUmg8LadR1
         hrRpWv937dPDQPfYYxHV9MTH4LScfiGdQW6SLVhR8LhoY06B0n6NWtcOHKB0MWcAV2bJ
         bJcM3M8Umdoj0zPM1IPySnL4HvOvkETgfbBr4sRJgzlLnS48vg+3/vQjo/dPHxbXG5R2
         jYKxXYBauZ6JwAEAATQ0KilrfhHUKDx80QknO1t9ThrzNzp1HcevUs356YnLAYlEXFYE
         eUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=vgcGPp9aZkXtzyTBQoqKKfRCWkZ+odsLG9ASOl08MJE=;
        b=W1JpgI/naante3Zj0yD2zrBR/NIfiRF92OylC3zUTRnzXdpOIYHrV3Qy0WsObDHstJ
         o0SBcCvF2YX0j6ceZzp+cVy2H5nYDr4i0dxLf5Jy1d8aOtzPOlU4HQOeCEYsQWP3Q0p9
         xndTh0JwB+TLiK5N9reB4bg+ZOcC/YvnjjGPK23DVd9QNbX3/BXLMumXjIRzanLxPTym
         BMziZbHfU1HFiDzEImv+usJjE8jDUGBOMqHmfX9bbtTZkDURXjFh7TYjxE55Im+n1HPb
         CPR7KjxzJen6ta6+u5FgnbP9zKzV/Azy8q8RB68uEdic9GmF36p6nXw4lY5/B2T0+MCf
         aVqw==
X-Gm-Message-State: AOAM532lX1vlBR9Ln5Wh4bTtD81qep5osHBPFuXY/vJ+/3Z8pxhpL8XT
        saCt+dkusKg+VGcOHWuBvxg=
X-Google-Smtp-Source: ABdhPJzHgcdJxfj8zDU1FYbdmR9Oa2v1nFvi3ceVKC1Qm/n0CAWPnOOa1/QFL74IBVtU8s+21yLDug==
X-Received: by 2002:a05:6808:8f7:: with SMTP id d23mr1980806oic.14.1625545656541;
        Mon, 05 Jul 2021 21:27:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 52sm546960otu.51.2021.07.05.21.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 21:27:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Brian Cain <bcain@codeaurora.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: patches for stable releases (hexagon related)
Message-ID: <7ea73971-13db-cd24-29e0-7910de3c5b49@roeck-us.net>
Date:   Mon, 5 Jul 2021 21:27:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please consider applying the following patches to v5.10.y and v5.12.y
stable branches.

788dcee0306e Hexagon: fix build errors
f1f99adf05f2 Hexagon: add target builtins to kernel
6fff7410f6be Hexagon: change jumps to must-extend in futex_atomic_*

The patches are needed to enable hexagon build tests using clang
in v5.10.y and v5.12.y.

Thanks,
Guenter
