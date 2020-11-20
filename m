Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD92BA231
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 07:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKTGSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 01:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKTGSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 01:18:18 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17216C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 22:18:18 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id w142so11837885lff.8
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 22:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vEmOCOrfpM5A3jL1+9XZ26REO2hC7P+nj39sUw6PyJQ=;
        b=K+0trdhxhMJJSGSAoIKMhEI0oQKDq1kNmhyvTgV33S8ptL3iDM6IJU1DVqLk+O4Yjv
         Pq8K6+Zttgceq5WcAc4MmL/Y2StwKO+hY1mrgFzjw8IcZTPQY0qVUMmmdgb+/PSwgtRI
         3PzZ3lbNJqiZ1A2CZyR0wqG07/BFwZHm3LKGdMEPY0rzcLO330+km74n8qV386G7f6gG
         2ttfBgfWNmY7Fw0YSXtbIl2BDDsDal0UqB+OBb0h/7c3esqeS5g+afelp66A244fVTL5
         wqs0VVKATHDnSa7wy9ON1RfJsZMsN9wFjKgZaof/W/26XzXJFkmlZ8MeKa0Qb4Djrex3
         L+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vEmOCOrfpM5A3jL1+9XZ26REO2hC7P+nj39sUw6PyJQ=;
        b=fXHE6R8lyt9+tgwyWAwNR5LLFhrvzQnQwYOkHl2KSFOqC7L2+2BRcnoukkjng0EnFo
         kb/zvCSfVp7ovuot+hAQrFt7GuOAobXmfdsjy5LcXEVHcvyu65yZIsL7qCQvHoXx2CtU
         PbwuMIB47UQP4IlbEC+Fc6QAQx01plssAlC7/mLjUXiYJ60SZBy73hO34g5CQrccfzLY
         wNINIsCX8pQmSdyN3q+hMqTrkAtngGr65vPsI6m65nzffYgV89zr60iRTKloFHdHQUbb
         GPuEKhSZ0KxJq3cvnnEcPDdHEzldnPvaK1mkI4X32pmOlF0kCNUA3CxOwQn/SkDJskHX
         ZsfQ==
X-Gm-Message-State: AOAM5316j422HR8gUYBCRe/Ut2LjQp/1Br6vB9p9GMiLSwpEXS+d4EIr
        i1JOqNUPm29YLUm614v0Wa0ce2rNuHjawr14DP1DhEem
X-Google-Smtp-Source: ABdhPJwqIgA+Hx+Q867QT4bUvw4cr2y1AiCEA+MaeizfiCTWEP6M3jqgNBUiDMWG/jOokb2W1TR4h+uNusGc9GgEFDo=
X-Received: by 2002:a19:7b06:: with SMTP id w6mr7824955lfc.260.1605853096451;
 Thu, 19 Nov 2020 22:18:16 -0800 (PST)
MIME-Version: 1.0
References: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
In-Reply-To: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
From:   Jack Wang <xjtuwjp@gmail.com>
Date:   Fri, 20 Nov 2020 07:18:04 +0100
Message-ID: <CAD+HZHWy1dba7z0UcX3cofSgzQvFUcfRms+zC+RvJoqh3p5MoQ@mail.gmail.com>
Subject: Re: Backport missing mlx5 fixes after 50b2412b7e7
To:     Timo Rothenpieler <timo@rothenpieler.org>,
        gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Timo Rothenpieler <timo@rothenpieler.org> =E4=BA=8E2020=E5=B9=B411=E6=9C=88=
18=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=887:28=E5=86=99=E9=81=93=EF=
=BC=9A
>
> Hi,
>
> After 50b2412b7e7862c5af0cbf4b10d93bc5c712d021 was backported to stable
> branches (I only tested 5.4), some serious issues started to arrise.
>
> According to linux-rdma, the following two patches that need to go along
> with 50b2412b7e are missing:
>
> > 1. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> > 2. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
>
> I managed to apply those mostly cleanly after also applying two
> dependencies.
> So the complete list of needed commits for 5.4 is:
>
> 1. 3ed879965cc4 net/mlx5: Use async EQ setup cleanup helpers ...
> 2. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> 3. d43b7007dbd1 net/mlx5: Fix a race when moving command ...
> 4. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
>
> With those 4 commits applied, the issue is fixed.
> For reference, that's the output I get with 5.4.77:
>
> > Nov 17 01:12:58 store01 kernel: mlx5_ib: Mellanox Connect-IB Infiniband=
 driver v5.0-0
> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handle=
r:887:(pid 383): failed to allocate command entry
> > Nov 17 01:12:58 store01 kernel: infiniband mlx5_0: reg_mr_callback:104:=
(pid 383): async reg mr failed. status -11
> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: cmd_work_handle=
r:887:(pid 383): failed to allocate command entry
> > Nov 17 01:12:58 store01 kernel: mlx5_core 0000:01:00.0: mlx5e_create_md=
ev_resources:104:(pid 1): alloc td failed, -11
> > Nov 17 01:12:58 store01 kernel: mlx5_0, 1: ipoib_intf_alloc failed -11
>
+cc Greg & Sascha
Hi,

We hit the same problem on mlx5, I've tested four mentioned commits,
it works fine, please include them in future 5.4 kernel.

Thanks!
Jack Wang
