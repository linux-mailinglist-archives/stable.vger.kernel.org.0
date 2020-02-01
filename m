Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3118B14F5F1
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 03:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBACpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 21:45:21 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39269 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBACpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 21:45:21 -0500
Received: by mail-wr1-f42.google.com with SMTP id y11so10850707wrt.6
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 18:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=bn4yGpgz7YqpoDI1eoymmYWnk9FdjoqETeln/oElVHk=;
        b=cS/Od4PCPg+jmsuaJiqjroMY36UOvNpvmzeiWsDaWg5JaQg4M6tcgAyXVgccCJA79f
         hbRDKTgZqgN2oxJC9pSlYzNNjFwDrWDDh9n5skMnYGKjOlg6qDWfO6aBJeS/vfFnoDB3
         6NR0BIf3lxJWg1TRh/XAbmIRkCaHiSFWExmWdNgxi4mN49psbBJIvmXy1+BiHIlKWz+a
         MDqy1EiYmoA4uZKpfH+Os9QLjxuBRr4zIN4yaNs9w31F1EsY/zcoRR5nnk291shlSatg
         zCNB92PZIv4JWSlBFTSMxG5qUP2KPU36d89FnyNIEC8v4Gu1OcflYutyTtA9L/wG2kYG
         fN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bn4yGpgz7YqpoDI1eoymmYWnk9FdjoqETeln/oElVHk=;
        b=dvsU4x0QtfiFtstiouRJYeJozv7OzFPLucs9axD1Qbv1cykwllhp65Y8KlWqv1le0E
         bCQu1vh9ZVzNXpmjpOlKKiIfJBsmRg+IycbPBcEIcPW7ata8r5KMtOn/7fhhq93VJ5G3
         bezNmEt2Dr7TEmfpACFhbGcZHti/KlaykxbwLSaDUfh+Tdzte0SQ2QAN7piM3JY4zZDm
         A5pZr4E0s3rduGZfU0zw79AN0qLIg0/1PEdLnUsqDQykf1sUG2d2RENCpUx95rSNYpho
         kuT3nCY34ZtGq1ZjkLRKyKNyovR8HP/O7BjO65ChOV85L4FIdkIo138Hc+d8v0MVVeCh
         QLwg==
X-Gm-Message-State: APjAAAXyKjpHo0w4r0b5dhYT06u/dkz41Gj0xNvHcR4+XGJDLUbqR1Oj
        zB0Xk6fq0dUA0TOXmE+TP0GZqmGt7wlrEg/p2iDdvniq
X-Google-Smtp-Source: APXvYqzwsGfBKRuHePO2sS6YG3/bbWZZWEEStta+DGTpivJZeiFo571DpYx2UhAAGFaO4tCa8j39UJXIwol2RQA6Nqk=
X-Received: by 2002:adf:a50b:: with SMTP id i11mr787283wrb.362.1580525119793;
 Fri, 31 Jan 2020 18:45:19 -0800 (PST)
MIME-Version: 1.0
From:   David Michael <fedora.dm0@gmail.com>
Date:   Fri, 31 Jan 2020 21:45:08 -0500
Message-ID: <CAEvUa7=e9RKmb71NTU-uvyEVYC2CzdagUgwj4k=Tg97F5jWMfA@mail.gmail.com>
Subject: Patch fd24a86 ("KVM: PPC: Book3S PR: Fix -Werror=return-type build
 failure") for 5.5
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you please apply the following trivial patch to the next 5.5
stable release?  It corrects a build failure for a PowerPC KVM
configuration.

https://github.com/torvalds/linux/commit/fd24a8624eb29d3b6b7df68096ce0321b19b03c6

Thanks.

David
