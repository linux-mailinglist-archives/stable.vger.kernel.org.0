Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D655C220018
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 23:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGNVh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 17:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgGNVh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 17:37:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB25C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 14:37:27 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a24so2568322pfc.10
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 14:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=C54nHXHsUM0Qzrx7nhavmp50YQVhcvTqM8Ua357T2Pw=;
        b=qTx730TfxP3JHwMdHeZOqrmvpY7Mg6iX9sEkXdL9theGEKszlTww7DhX3BJm36q918
         zqkrmNinmRP0OWR8vQ+dteXXFN3heC0Zk6aLTGhLgYlQx8qir3daIHA0nKHfV19fWrde
         UZNClH+UUrV/mWjU3Z9ygCqLiTTVgVIajCcGFI7JO3fhS3GcDA4FtbW6UX0b7a4VoXsq
         NxQPa+/HLOFE44obe2NHXwG0YNiCa124MgFjl8SpXx4fgBZkpHgsA7XyjDJ23hMyenA8
         dnOQM0J8JRSTe2fUS8TTDoV2Apo3GqvTNGTSMI/1Yr098hWPBXcpuxlS0fCjWczIlXzD
         n2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=C54nHXHsUM0Qzrx7nhavmp50YQVhcvTqM8Ua357T2Pw=;
        b=P4uVOJKLPaGKv6QrUHsMBEdijR05D2UiAsvXON5k0ILp8lAcLl+ydvUAycFYEtrguO
         TRy6UxDV4YTvLoSEtcFgndpcPAqgqJVSqTkAbERZH9sqdzz8mTpvY868iJIzyukBe8/F
         lMJtid0GJzrCqGMCdtlzJhIF00cFyXlIOS9gdghmOB9tWzTsTVnzmV9nyAdyD32ZJifx
         pam3usmxB4MWuuUy/HEdOe8M9OdBmAlL5KT28gs/Q3ltA0xQWfZSiVoqMz3wnhRzpl1P
         k6tyeQQAhvD8w5F1NSNRx18ZzPyIZL48WBl03WGcCsn7t+46gaNFlLuEbBdUppFciOLv
         R5HQ==
X-Gm-Message-State: AOAM530BuZgBsmG3mKdsPCpeDmAkIbBPUVNv9nM1bBr+WwW6fvavN+iO
        NjypUHUVWelgJbcXM9tMobyzLw==
X-Google-Smtp-Source: ABdhPJxbt04MjtWU9INStQlDLZYpgWBPOi6Ww+voTCMPjUB55b48eu35Lsfm+KBmADjDJ1Q6aZ6f4g==
X-Received: by 2002:a62:140e:: with SMTP id 14mr5745202pfu.196.1594762647015;
        Tue, 14 Jul 2020 14:37:27 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 141sm121736pfw.72.2020.07.14.14.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:37:26 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:37:26 -0700 (PDT)
X-Google-Original-Date: Tue, 14 Jul 2020 14:23:52 PDT (-0700)
Subject:     Re: [PATCH] RISC-V: Double the stack size on rv64
In-Reply-To: <87v9iq4q6d.fsf@igel.home>
CC:     colin.king@canonical.com, david.abdurachmanov@gmail.com,
        dvyukov@google.com, linux-riscv@lists.infradead.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     schwab@suse.de, Christoph Hellwig <hch@infradead.org>
Message-ID: <mhng-c3f9f747-5069-4688-ab68-9e43f413d4fa@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Jul 2020 22:32:42 PDT (-0700), schwab@suse.de wrote:
> On Jul 13 2020, Palmer Dabbelt wrote:
>
>> This was suggested in the syzkaller thread as a fix for a bunch of issues.  It
>> seems in line with what other architectures are doing, and while I haven't
>> personally figured out how to reproduce the issues they seem believable enough
>> to just change it.
>>
>> Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>> ---
>> I've put this on fixes as I don't see a patch from anyone on that thread, and
>> it seems straight-forward enough to just do it.  If there's any issues I'm
>> happy to listen, otherwise this is going up later this week.
>
> See
> <https://lore.kernel.org/linux-riscv/20200708145625.GA438@infradead.org/T/>.

Sorry, for some reason that didn't make my inbox.  I'm taking it instead (with
Anup's review and the stable stuff).  It's on fixes.

Christoph: Some sort of CONFIG_IRQSTACKS seems reasonable, as I'm assuming that
very small systems may want to try and save memory.  That seems like too
invasive of a change for rc6, and given this fixes some concrete issues I think
it's better to just take it for now and do the better version later.

I'll add it to my TODO list, though that's pretty long so if someone else wants
to take a look they're more than welcome to.

Thanks!
