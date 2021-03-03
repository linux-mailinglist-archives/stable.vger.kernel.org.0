Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44232BC2C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhCCNl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582439AbhCCKVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:21:53 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B7BC08ECAF;
        Wed,  3 Mar 2021 01:57:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g20so13759548plo.2;
        Wed, 03 Mar 2021 01:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=rO9Y833nDH2+YLt8R02YKuOgTZIbRQR101oQDtAVGXE=;
        b=Xez7ZQlXgayaQh5vq8//StWeI9hfC35doRt6LcGRHN9oIldF2PoCtaVY6wtbEKOjqw
         MPzQOsjshSaQBkwSevXZMUeeEPlISMLBTuxRKLYuZkOA+/I1IyG3eAA4ATFd5KiTDf/T
         gjp/Znf++R1A5NFyP9vWUfQEYtaVgbCo8l/UAh2x4P7/weObZGBs9nxuPhAFxKCKw0ck
         y0MGXPxYbccLGh702YcP32UeW44R+k7EXHFHrCzolNkdkLnnsBD5UyVNKR4u+q1XhPlC
         TQc3ZpjX+nvqzm8/P63WXf0ogVMBlGaSSX9kSr3WaMJDiiiUjJ7+AenUxh5rE4tMzXsP
         Tm3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=rO9Y833nDH2+YLt8R02YKuOgTZIbRQR101oQDtAVGXE=;
        b=NmQuae08T8xH+5adqCYulP9jZvPL8EXY9oa1n0oGyNFTXl51xkdtoKYcS/GgN0tZYN
         xc1Vo90HKtrCwBs/ehfI4fLT0VmhSgfBqDfUZLMa609xCRfd8ZH1RF0FuGor4BSpOadV
         WoAh37qGEXnhyVOc6ql2D8Cv+ti/DnS1CIEpReyet6HmiJExjdfS7OxGM2vWHGdF7pNP
         EKtzkxw2af5nLTU5PXz2tenVP4hv0Ef8GPHm33ECg+aEvLeeB8gQ6UQubJBLtPWm+e8I
         GRbloT0x1bUk2dsbgN3UZ4/pfnM6RLdUk/CoWvNc7ilBDBWVSpTEi8RH+AXbhhMzaq+K
         Iw5g==
X-Gm-Message-State: AOAM530YtI5/a/EXmZiHi9Ot7+QFg27nr6vz/DLIfHD3Bba/JBNNi1NU
        j542gdvv+GxPInXW0dbgcvQ=
X-Google-Smtp-Source: ABdhPJx72uTlFuQaVNYA6wP7x5v8gHrLGgSfCqeuNhuWsiZh8GRNqH2txME6FMui3dokXUQCcXe6HA==
X-Received: by 2002:a17:90a:d516:: with SMTP id t22mr9016990pju.51.1614765432272;
        Wed, 03 Mar 2021 01:57:12 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id h12sm22299781pgs.7.2021.03.03.01.57.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 01:57:11 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
Message-Id: <A53B1EF2-345D-4D42-A662-77C38F3E8CB4@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_988504CF-EF92-4AFA-BE5D-F379324AE072";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3] mm/userfaultfd: fix memory corruption due to
 writeprotect
Date:   Wed, 3 Mar 2021 01:57:09 -0800
In-Reply-To: <20210303095116.3814443-1-namit@vmware.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Yu Zhao <yuzhao@google.com>
To:     Linux-MM <linux-mm@kvack.org>
References: <20210303095116.3814443-1-namit@vmware.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_988504CF-EF92-4AFA-BE5D-F379324AE072
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Mar 3, 2021, at 1:51 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
> 
> From: Nadav Amit <namit@vmware.com>
> 
> Userfaultfd self-test fails occasionally, indicating a memory
> corruption.

Please ignore - I will resend.

--Apple-Mail=_988504CF-EF92-4AFA-BE5D-F379324AE072
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmA/XXUACgkQHaAqSaba
D1rufBAAk4Vo6Q73H1mV4rFLQFiYKkzUoUxDgyK6hHTv8JcXg38x80iyNu6tL/2W
rsF9ql0mcPTI54NiTW+rvUeV4DuJjU0VuGM4xq7THZO9SV9P5K99B2Ozc1VEwJ2K
FhYSp+5qEUh2KlySgoh0XlQ3keFF+H1CsrzoJC1DYGJDgYIlj6DNuTZPF7Tv8B6M
GRpOHtA34v0K1nJTAa7LDhGTDxDqhUafu1d6SXI6wzfYO75OV1m/dJwkvJ1RSVKq
za+56HYFdcqdADFktmpjuIDH2fBGum/xdg37ytIniMIHXCdo16+K2YB9zoWqli6c
4prhAxACobX+4WB/+BkLOYaT1x8OCZTCH5aLHqKUy6lKHXRAIIMGSislXkoKJ+Mq
JqmsJIlxGZLEeDQYX03vApSiTaepIjqYstqBzo1XchjmLOFD2YoOs/144n+50wxA
xK5ejy7ZSh2iZXu8ttVJkqcZn3GSvnFyHlRXJZNSGUmH0cyuo7IoXFYC7rdHmxou
Rjf+xxd3mzhuj+dsTwh6WRGSePUr/PNuzjy7yq/aPWWtUVmtE12FjBR08VXVMm/v
IpP3XE7QuoLz3OyMczSYveKLDIsd2aJf5weYR/x8HZA1Qnli+zH5s41tWNAvrZk+
+xu83CA6lgkecw/Vueyiyjz+4ReCRPi/kGk2pny/GAEeC+TddgA=
=U4N0
-----END PGP SIGNATURE-----

--Apple-Mail=_988504CF-EF92-4AFA-BE5D-F379324AE072--
