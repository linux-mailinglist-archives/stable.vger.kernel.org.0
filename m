Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F46B1C5D
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 08:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCIHcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 02:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCIHbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 02:31:50 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF430DD347
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 23:31:16 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id s20so1088861lfb.11
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 23:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1678347067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ha/3mU3Llx0Wa0WUDy/uPl76sON4g9057OoIU9zRL5M=;
        b=Qtcqr7ffdSk4foYwmHCYlCxkgdTb3gmp7/PVtv7leT7UJxqj1XYVgAKrSWxc+lFTS/
         Rev8wfsj0fMgfNjI1T4d/s6gMi2grLLQfG9T/Ua4sxcfkwkcVAm/T5DEktpu5BnipoB7
         v8L02Nd4TsqrsxZizzBjmEw6Cm3KhBYJLUM/kJc2Rz7Z3f2M/P31gM3ldwkw5dTon9B8
         U2KyFcBKmOBVdLZJ7H6nzmUsXq9NQ92DFNXPautpgG/MFC3IL33JnVFR/0xRoQOygyHl
         /XgnbCXOxdKSoaFLjCZWjnhdfLz9mZjrOeu13FI1RiCIZvLonWvp1AwKZO20/h6epr2e
         GjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678347067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha/3mU3Llx0Wa0WUDy/uPl76sON4g9057OoIU9zRL5M=;
        b=RKH42I01J7B42CiBcB0NcmR5xwqhWUOgYjH2I45JMCODgy44uGDcZN0NalRm0+3hAv
         FqECjHZYoBro6NuPr88B67oqBVcoaVwuVjhr491pUqwB3lL5dQmj+NHOoAWj8hmWXcJP
         F+W0qv0pd3Txn3svVZfeAH2ytbR0GKKwCKfbmEnt4k1PfbZjBSuxyjTmQ/cVWZXZDEiI
         xpCzhlOrRQSFc6IVLGEh9QdEvwcYvMLm2ARFaXadQwP9uACuwiFhPkgFJ1825mtghZ2O
         ntup/7Af3qLd723XzOalcG9pLNxGsy49i265vH21UB+FrsG/LrjFIt/qMpuIjgZi2Ci1
         D06w==
X-Gm-Message-State: AO0yUKUYDCV0siATRghI4vLZ1N/PlwdxWIc/UhtI/b4oojxO1SAy5pFr
        +TZPvu+H+tyGGZo9sl03ThNl83RRj18p8lxohLHq8w==
X-Google-Smtp-Source: AK7set/CzLKvBYZT7akl9keu/O524xE6wDtFMN64SvHQrgjOET2PcHeMncNYZT90K5hf1/HQwtE9Gcpwc6bJMuvu2OE=
X-Received: by 2002:a19:7517:0:b0:4dd:805b:5b75 with SMTP id
 y23-20020a197517000000b004dd805b5b75mr6471232lfe.7.1678347067247; Wed, 08 Mar
 2023 23:31:07 -0800 (PST)
MIME-Version: 1.0
References: <20230302130650.2209938-1-max.kellermann@ionos.com>
 <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com> <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
 <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
In-Reply-To: <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Thu, 9 Mar 2023 08:30:56 +0100
Message-ID: <CAKPOu+-jCt6NoVaR=z6c-D-PY1skdt6u-2sKkzd8GFDHbsQdxQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 9, 2023 at 6:31=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:

> I attached one testing patch based yours, just added more debug logs,
> which won't be introduce perf issue since all the logs should be printed
> in corner cases.
>
> Could you help test it ?

The patch now runs on one of our clusters, and I'll get back to you as
soon as the problem occurs again. Thanks so far!
