Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C392F29C01F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816984AbgJ0RLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:11:33 -0400
Received: from mail-vk1-f170.google.com ([209.85.221.170]:37035 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1816978AbgJ0RLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 13:11:31 -0400
Received: by mail-vk1-f170.google.com with SMTP id u202so539551vkb.4
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 10:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Ehllgwr0YmgeFGN1XAolu3UNvat5g7tdi9j5NW7Fi/Y=;
        b=HWfuWuSn2zATEhZx9H0GtfRpczHY40ON3hzSSYD1YjjmIQJTcYBzXa9sGBPZqbKMH2
         n+gvVcCapBFmSW6xN1EWdRqh/OSvhzdp1bq4Nk6pCJkb3sz1c3txDCRqv4jqvGYdaMvy
         egLjLTYkXVB64T/lb8sV8Gd1+9pIKosAZn9X9LNt3Bh51n/EtpNoUc2A8TgGvZiPLAZw
         xHTDCmlfDbGkiQH9lh/WslJPheGUADCWy0YFk6JEpSJGZv1TJrxrYw2HIPZINc4aAMw2
         bSMtOT7/JbyVe0yOcsvkJ+YB/9N7r0KQRm5f3gyKvkOk95uaTZIgqmywoomNzQe3fOpO
         TXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Ehllgwr0YmgeFGN1XAolu3UNvat5g7tdi9j5NW7Fi/Y=;
        b=oYBoPb36uYwj+pdf+ksD7IqMFKfbVjnOxQGG9SHu3hc8wBJmDvDcmLgdrAUUdd1qS3
         C7EI3epXrxKU1wvYUtmr0B8wE9KvjNMhDcxTV3vNzjfc0ky5mXlUIjvjMM+kT2qQEqSp
         22sSn7FWQj+YULs6oXxWrjvtzIJota67392/XxleanN6mCP7YZy4zeu4gn5RbHzATHko
         R8L8ql+lRulkjSkTgzjYlMZ/YMFpLRjWQmOMCjTWaUJu8CtWJ0v/wPniT55r2b4SXWRH
         9xeWm1Xx8G8iRdmiUSn+NCbOh5ztrRzBbNNpJUATEmOrjlIyqbykz5CQu5iFkHdNCzTp
         63LA==
X-Gm-Message-State: AOAM530GuQsAPTGFfOGeUjTwaqpb3RcltBekHt0JE6YZAbh8ILwXm/Ji
        8gCkChYccFB58nTSVdXFthLR765bVgL0FaV3q2napPAc5Ex1hi8V
X-Google-Smtp-Source: ABdhPJxWavAAXc3p+NSdzgL2KQ8VdSyPOO4+hiF2sFFBD3TJuWPs4ZAekNWEXDl99z+CmPEzYhfj88w8c+TrdUV9AmI=
X-Received: by 2002:a1f:5586:: with SMTP id j128mr2579707vkb.10.1603818689805;
 Tue, 27 Oct 2020 10:11:29 -0700 (PDT)
MIME-Version: 1.0
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Tue, 27 Oct 2020 22:40:53 +0530
Message-ID: <CAG=yYwm-xBMZf=jxQGBLq8RU8i4goCWYz9AwuwguAH7qw0FH3w@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/191] 4.14.203-rc1 review
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello ,

compiled and booted 4.14.203-rc1+ .
dmesg atleast throws issue or issues.

-----x----------------------x------------------------------------------x-------------------------------x-
[    1.822459] ACPI Error: [_SB_.PCI0.RP05.PXSX] Namespace lookup
failure, AE_NOT_FOUND (20170728/dswload2-191)
[    1.822502] ACPI Exception: AE_NOT_FOUND, During name
lookup/catalog (20170728/psobject-251)
[    1.822524] ACPI Error: Method parse/execution failed
\_SB.PCI0.RP04.PXSX, AE_NOT_FOUND (20170728/psparse-548)
[    1.852894] ACPI Error: [_SB_.PCI0.RP09.PXSX] Namespace lookup
failure, AE_NOT_FOUND (20170728/dswload2-191)
[    1.852938] ACPI Exception: AE_NOT_FOUND, During name
lookup/catalog (20170728/psobject-251)
[    1.852959] ACPI Error: Method parse/execution failed
\_SB.PCI0.RP08.PXSX, AE_NOT_FOUND (20170728/psparse-548)
[   19.924198] systemd[1]: Failed to find module 'autofs4'
------------------------------x--------------------------------------x----------------------------------x

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology -  autonomous
