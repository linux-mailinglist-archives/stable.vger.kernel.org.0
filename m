Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1712AF04B
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 13:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgKKMLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 07:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgKKMJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 07:09:32 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD088C0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 04:09:26 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b6so2310955wrt.4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 04:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=S+gK0Xl/kaPUtLz/mf9vHaRiwpygR3eSp1X7mGoA3U4=;
        b=fah+hb1Jbmt3i8zfiI/VxYXoQiA2JL0AYL2WCkZppd/qG/IaTMncc/Wcjvol06naqi
         dj5HeKMc3/7zxzq1QKrD8b33hUW9hiW9rEhaSSkNienHHpR4G8tUHS3BG5QwTKLJ2GCw
         FK1PMdAsWE0S4yWZ+Dkc7Wf1P4GBMmV2vzJZE+r0lp76hRDmxiXVTvzExiMifNoJrsbQ
         OtS8jrfEEYNjFMLn2e9Ktb8srrexP/CeQ76YAPMsKmRJjxd35VWx2DDAiG5VxzAiZQ6f
         CcENp6CcSRtXRIo1/D33IABWCkCxvC1L5hNtbQuTq6g1GXHoLxqLXECWLsE46vj4+R5a
         d3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=S+gK0Xl/kaPUtLz/mf9vHaRiwpygR3eSp1X7mGoA3U4=;
        b=EZcAFYb+9BjK22sXL/S7R7XIo3eDUY/fC/Ff9Z2rKjRjnHqlXAiu5wJGVy1IkNkefz
         pcG+n7WK9sEKiAl8b0xlPxX55YOZOg2UOwDZDy7fVyp9Z8dTD9vk7/b8I8kAcoc1sWq1
         CYE4I/s5LIy8Y7acu7lKPqbFDy/Cz2+RnvJEQ5E2JgL9aaD3HJ7LX3gXyWu/6D0EPHO0
         fDUfPHjtfzS1j2Jgrjcy0rCOyffjl37jhezDtHxjuUAY20KB5wVtuocqKo41PsyZsjtQ
         3ljIJxM3R0Cg5td4FMK6deaRA2Ld/VReN/5L96CLm7qHLWd38spgSTkF/ktDIL8dRPEJ
         URKg==
X-Gm-Message-State: AOAM5325+2LQtsY5J7XKNMbe14QpmsO6zSrZQRc4HxGF34/ynPuofjqq
        Bh+MFJgBPKtHV1etrQIPA0slPLDeSgFeAVsccISxToA/JwRTGQ==
X-Google-Smtp-Source: ABdhPJxyHrfCCTSCLD/6swjKdsyJ6PaUcQqRBw6uXBsCEVU4FzdHtyIZJENh3T3tzf2LOgVHUB0o2DRKV/3K56G6+wA=
X-Received: by 2002:adf:f6cd:: with SMTP id y13mr9747436wrp.363.1605096564732;
 Wed, 11 Nov 2020 04:09:24 -0800 (PST)
MIME-Version: 1.0
From:   "Anand K. Mistry" <amistry@google.com>
Date:   Wed, 11 Nov 2020 23:09:13 +1100
Message-ID: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
Subject: Requesting stable merge for commit 1978b3a53a74e3230cd46932b149c6e62e832e9a
To:     stable@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'm requesting a stable merge for commit
1978b3a53a74e3230cd46932b149c6e62e832e9a
("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with
always-on STIBP")
into the stable branch for 5.4. Note, the commit is already queued for
inclusion into the next 5.9 stable release
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.9/x86-speculation-allow-ibpb-to-be-conditionally-enabl.patch).

The patch fixes an issue where a Spectre-v2-user mitigation could not
be enabled via prctl() on certain AMD CPUs. The issue was introduced
in commit 21998a351512eba4ed5969006f0c55882d995ada
("x86/speculation: Avoid force-disabling IBPB based on STIBP and
enhanced IBRS.")
which was merged into the 5.4 stable branch as commit
6d60d5462a91eb46fb88b016508edfa8ee0bc7c8. This commit also exists in
4.19, 4.14, 4.9, and 4.4, so those kernels are also likely affected by
this bug.


-- 
Anand K. Mistry
Software Engineer
Google Australia
