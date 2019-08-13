Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A136B8AC10
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 02:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHMAkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 20:40:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39038 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHMAkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 20:40:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so1711808pln.6
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 17:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=wEjzfUHdySvpHZoE9Ji81eu76V6vjLajXj/MO0b1Tgk=;
        b=cOKIonQhJPjpmgaeZtWqCUdhLyRYcIFlBTsNTeMHsWIoB0GnU2m/P9gw9fLAcXCcsg
         SoHmuTpMF2/v5Lhke1NVyy1Zq6HxuXRsJllemjigoHp9o0u2BV+od6csQnDiEoSSYjWm
         t2A65OhvmqZNzb+eatdppJmKoRtBxbRm3otkgCGj1B/yxiyDPSG4LPkDBptYk+HzGvPX
         yJmc47n7WkRElBH5yzRxKrYzpNjZFjKY1Kt32oG2kBNAKAY+zYdlbZCUudCKg878NpR3
         X/ySymuKoyv81V9AT05ngz4v/TMHk1dASIH7TxPVJpNTh9fdbvoACyPnS7mi+GfbG5V7
         IgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wEjzfUHdySvpHZoE9Ji81eu76V6vjLajXj/MO0b1Tgk=;
        b=hAe7NS5OqNlgyIutydYcI10H9gzy+LVtu8BiPlySVnLyzQUHjHxJ7iaJpSlfZtT8e3
         I9vosQMnntHO+Ofo9PJQwmc0tdJt9eT7AphB/3p7sJSOx+Qp9avkVUHgwznycB93ZKzJ
         0nNiZiR2NN3KMEzMwJKmBdLqluOs0GgCju4aw54hJVNMPOx8v+fkDcaNkpOqyxZyO/NS
         lrNrj2PdTerl3SQl/TraZVpBCvwJFcdCDPbr2WASflLzDoCmVi7IUO60QXwc8x2pLoM+
         NE7FDn2cm+p07T9uQEoqeof3jQdXIQnMYdXabLo3Vj+/lGzUhneqa/7E0j/ifiZRR3X+
         6Vkw==
X-Gm-Message-State: APjAAAVwLLMKSWYkXOOdfh4Iq4uFCptYm4Fu5w3n4PAgX08y7HZjFjNQ
        7VYJVh1UgCFlIKxwroHmhavgf9IBhAdFSw==
X-Google-Smtp-Source: APXvYqwovxi4+LD8JcnlGBd0HqEiNZqc9KwjyNQxlfxPw1GDXP3FddZimhLoZamzzj/3dQf2czmwyw==
X-Received: by 2002:a17:902:8543:: with SMTP id d3mr28536971plo.80.1565656808287;
        Mon, 12 Aug 2019 17:40:08 -0700 (PDT)
Received: from localhost ([183.82.18.139])
        by smtp.gmail.com with ESMTPSA id g2sm173597842pfq.88.2019.08.12.17.40.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 17:40:07 -0700 (PDT)
From:   Santosh Sivaraj <santosh@fossix.org>
To:     Sasha Levin <sashal@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v9 2/7] powerpc/mce: Fix MCE handling for huge pages
In-Reply-To: <20190812135532.66AC120684@mail.kernel.org>
References: <20190812092236.16648-3-santosh@fossix.org> <20190812135532.66AC120684@mail.kernel.org>
Date:   Tue, 13 Aug 2019 06:10:04 +0530
Message-ID: <87tvalrj8b.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ba41e1e1ccb9 powerpc/mce: Hookup derror (load/store) UE errors.
>
> The bot has tested the following trees: v5.2.8, v4.19.66.
>
> v5.2.8: Build OK!
> v4.19.66: Failed to apply! Possible dependencies:
>     360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
>     41f4e631daf8 ("KVM: PPC: Book3S HV: Extract PMU save/restore operations as C-callable functions")
>     884dfb722db8 ("KVM: PPC: Book3S HV: Simplify machine check handling")
>     89329c0be8bd ("KVM: PPC: Book3S HV: Clear partition table entry on vm teardown")
>     8e3f5fc1045d ("KVM: PPC: Book3S HV: Framework and hcall stubs for nested virtualization")
>     95a6432ce903 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
>     a43c1590426c ("powerpc/pseries: Flush SLB contents on SLB MCE errors.")
>     c05772018491 ("powerpc/64s: Better printing of machine check info for guest MCEs")
>     d24ea8a7336a ("KVM: PPC: Book3S: Simplify external interrupt handling")
>     df709a296ef7 ("KVM: PPC: Book3S HV: Simplify real-mode interrupt handling")
>     f7035ce9f1df ("KVM: PPC: Book3S HV: Move interrupt delivery on guest entry to C code")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

I will send a backport once this has been merged upstream.

Thanks,
Santosh

>
> --
> Thanks,
> Sasha
