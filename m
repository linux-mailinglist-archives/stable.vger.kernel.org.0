Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC230B0E4
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 20:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhBATzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 14:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbhBATvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 14:51:44 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2B9C0617AA
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 11:51:04 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id m20so9292857ilj.13
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 11:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=CCPEdP9NqdxlGr861DASAGy6SD+HGc1JahxOqviGWx8=;
        b=ATGIs2m4WGEYUZXSCQ4WedZH+wG33W0SSjCytr0K1yliGB2+RrpmTq7tFFXcmjU4O2
         RggzPE+g2K2RUWfXpbp/oi+nFX1RUmA2HUby5mV7fv+PZ9crdYWQEDTcw40JoCLbw1ia
         P6QdStIrthMWPcqC5VgXdoOa95T6oTbktPGDOxbNC8gK1LtALfrch0hbrWuy7APpa7U6
         F3COuEFCgu9B9fh0w/G4a/wRsgwLZ+/oXpXM9tUperrCaDeYSEVD5KZRRhUx9GGyOLC3
         FppbqKWTUVrP8dB/El3RG6q2WmgSAPJ9UpTSx/RDe3VbnCXdJbDAVnU8l2lfWAMgBukR
         KJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=CCPEdP9NqdxlGr861DASAGy6SD+HGc1JahxOqviGWx8=;
        b=QesU9lmOFb1BwpFqMtcrF8BEcqZNQDPq8Co5I2d6pSWCgw66Z+vq/u1iHtmXu1a/1o
         zx5x0B/j5hXY/JHxHE8hgk2vLc2RzN0eGhmNGcYLUq7KRs7TR0BzKheKAMp6XypVmaSd
         RtDSQ63/w0Men26gzHvF1bt1BRr00clcm6JTLTebh71G86/6qJ6PDliWHTSd82nDa3Zf
         ZoJmoTney/CZOewqTLvs5zFG5X1rmkZpmZSqOXw0VIFkUfICIVnxfzVQPTMIFn35/0Mb
         O7N0K5mK++4TiWxK98gb7ThuKGydlUsADMAjRwgAy2spkWJImDlSgwoA31CxPdMpZLAU
         YFpQ==
X-Gm-Message-State: AOAM532kftcyZeuIw8UgqU1Y+Ij//cWyMgNr5PrHawc6clO8RDCVsdF2
        bGt2re7Gk3A/5c2d5z19kbTRQ8QTNXOnuHAd551SUKhkXTdh0Q==
X-Google-Smtp-Source: ABdhPJzhWrm61Pwot5Sv5f7lU3X8QZNDewqUcfQbMJOn14OVnGEpRnujiWXsv74K/KS4V/FjAtj+48gg6M/YJ10jN1A=
X-Received: by 2002:a92:c5c8:: with SMTP id s8mr13677757ilt.186.1612209063897;
 Mon, 01 Feb 2021 11:51:03 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 1 Feb 2021 20:50:52 +0100
Message-ID: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
Subject: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi THUNK
 macro argument"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

you have in Linux 5.10.13-rc1:

"x86/entry: Emit a symbol for register restoring thunk"

While that discussion Boris and Peter recommended to remove unused code via:

"x86/entry: Remove put_ret_addr_in_rdi THUNK macro argument"
( upstream commit 0bab9cb2d980d7c075cffb9216155f7835237f98 )

OK, this has no CC:stable but I have both as a series in my local Git
and both were git-pulled from [1].
What do you think?

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86_entry_for_v5.11_rc6
[2] https://git.kernel.org/linus/0bab9cb2d980d7c075cffb9216155f7835237f98
