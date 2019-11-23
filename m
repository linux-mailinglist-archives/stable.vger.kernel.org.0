Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85AEF107C79
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 03:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfKWCez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 21:34:55 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46731 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfKWCez (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 21:34:55 -0500
Received: by mail-qk1-f196.google.com with SMTP id h15so8005562qka.13
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 18:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=qMVtz1dhXMqBrCKgZA3QUpUB+VFA5cQl33Mp8PpnTZk=;
        b=Duccxjl2Tl2Sm2yuNDXyGfVOdtU/RT33kPxdXdbbbaTMm55kO2tLnLiU3T+Ooi2Cw/
         KIbFSdyDEh91J6z1muHXqPHixjszlbISfVUuhJESWZC2vPrHqgcQhhsuuq+WScGMp5gQ
         7C7H62q9toI3dIv/GG8tu9IM3q/f8YJLcEDPrTKl6zvn4p6P1+57OWYzoXzRwyK8opRp
         ggjV1//u+QRE1opReAaSWo/Fb6VhFssyHs+f78A/kyk2zWJwXTb4QQZIyV469kAL/QOU
         t4TlKYjub5V/SUfUAHuVc7QnZikrGFt3H037kew8ZE7RmpaEkpzawOIv7IscyeeABbZG
         6pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=qMVtz1dhXMqBrCKgZA3QUpUB+VFA5cQl33Mp8PpnTZk=;
        b=MTOi78OiqwqvQn6SLMPbpOsM3F6q2ygeRq5vDnQaoEYSDP5kjq2f0oWy/Jq0qPRwOH
         miZcWmxbqU5sPzGiNBMZ5V5qEGEodglzTA+xR4UhYvtP3anJbQv+wuG6AMn+jbVhDe4J
         7aeRyodM3q4ECSPgTpWke0uxk1siIGD/s6J79s9dx3RwgBXwHL+gYov6FJ6Ma99QRIKw
         +nBiQDQXihCTI8fojP2IEKn1nHc0lAlZbKf27tPewZtTKy0maKn/QAxJj1myQz/Rg7A2
         qpbDP1JIsV44PgR9mlEmfoMTnFGq+b0dZ1l9oE/8sNvxpIhOSOPfOCcc4IRV1dxz7qL3
         YTFA==
X-Gm-Message-State: APjAAAVitk4LbxBZW8X717T1gISnLb4o1TOaVIO7fQ4+G+BSOlxyoJZf
        ybj7lH3uVUaxNwPaUhEUNN/C4ACmj+g=
X-Google-Smtp-Source: APXvYqyTrwwYEtlT0p2pO/PK6SulFN4m9egMwii3cZrBUzuyPyuYw8/Cb7xFhfrM7UEZTfa7A8pDyw==
X-Received: by 2002:a05:620a:12bc:: with SMTP id x28mr16384801qki.70.1574476494259;
        Fri, 22 Nov 2019 18:34:54 -0800 (PST)
Received: from [192.168.1.101] ([104.246.133.66])
        by smtp.gmail.com with ESMTPSA id o124sm1723044qkf.66.2019.11.22.18.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 18:34:53 -0800 (PST)
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org
From:   Bob Funk <bobfunk11@gmail.com>
Subject: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
Date:   Fri, 22 Nov 2019 20:33:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I am contacting the stable branch maintainers with a bug report concerning
the asus-wmi kernel driver in the 4.4 kernel branch. I had initially 
contacted
maintainers for the specific driver and received a response stating that I
should contact the stable branch maintainers about the issue instead. Their
opinion was that the patch in question should be reverted rather than
debugged. I will append my initial report here and let you decide what to do
with the bug.


Original Bug Report:

The 2019-01-26 commit to the asus-wmi.c driver code in the 4.4 kernel
branch has introduced a bug with several known models of EeePC netbooks.

Description of Problem:
The bug occurs during boot, where the screen (possibly backlight?) will
shut off and display hotkeys are unable to bring it back on. The problem
is present on all kernels since the 2019-01-26 commit. There have been
several reports of the issue in the slackware forum at linuxquestions.org

Corrective actions taken so far:
Appending acpi_osi=Linux will circumvent the issue and keep the screen
on, but this causes several error messages
in the boot log about eeepc_wmi "failing to load both WMI and and legacy
ATKD devices", and warns not to use acpi_osi=Linux.

Appending acpi_backlight=vendor also prevents the screen from shutting
off during boot. However, pressing the brightness hotkeys
causes the system to hang.

Reversing the asus-wmi.c patch that was committed on 2019-01-26 and
rebuilding the 4.4 series module also fixes the problem, and brightness
hotkeys work normally. The commit in question is
0c4a25cc6f2934f3aa99a0bbfd20b71949bcad25

Model I have tested this on: ASUS EeePC 1000H (Slackware 14.2, kernels
4.4.201, 4.4.202)
Additional models reporting this issue: ASUS Eee PC 1005HAB, ASUS Eee PC
1225b, ASUS Eee PC 1025c (Slackware 14.2, various kernels from 4.4.172
and higher)

Additional Notes:
This problem seems to have been corrected in the 4.19 kernel branch, as
reported by several users in the slackware forum.
I attempted to test some of the fixes from the 4.19 code as patches to
the 4.4 code but had no success. There have been multiple
changes in that branch and I am unsure what exactly has corrected the
bug in that version.

If there is any additional information that I can provide, please let me
know.

Regards,

Bob Funk
