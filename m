Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC2265744
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 05:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIKDKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 23:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgIKDKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 23:10:33 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B592C061573;
        Thu, 10 Sep 2020 20:10:32 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u21so10851045ljl.6;
        Thu, 10 Sep 2020 20:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4QzQDhaCJCst2HK6aH2WUPrdT5Dum1Od9MmMWsCaOcg=;
        b=WrsBlUuFA4/+FHg1Eeljuvw+qsz6YK/899CgQAlz/Qre86TlRsTLE8y27EP/H+6Zrd
         Fq96jMMD74Ob3Hs8Jy1SJYxGr7zLFCNGj0NcoJwtkKlIdfG4indfWnXUotYVWjcIZD3G
         pRCjTJXUTtNHtgJ4Vtoto3RQGrNRYVova4LSgXe64y2/G+goPuM5xFERgIz9lMFKAfDZ
         hhLTnqIpHi8Zo7ZYZ9whMRnRsGFNOJ+cwDIivOL7bfOEzh12BPkykzUBfR4nmLRetd9p
         9L2el3mi8t0s3RyyudX9w76Ba0CuoSlzNud+Tct6t0J3DxAZvv8ErsOIR+xGlyDsG73C
         vB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4QzQDhaCJCst2HK6aH2WUPrdT5Dum1Od9MmMWsCaOcg=;
        b=hfNO+tj+TzwTaHWN+KMpYtC8Hv1JkNRXj90LdDVFEtPQl0N3z4NRDiAxwZiq1Hu1+B
         RXTOascxcEwufvZnPTLTUWtDe1yBifEVeThINe4FZOsRLn+cBvKrxMlRqXa/v3JTnlzj
         LCzgxB7ltE8RMIkF9bDUs/osWM4vGAcSJKYEiCeEBfDovQI+ughfa1G/dfui55tE41D7
         VPRgwKf70si7+tTNq5GCRaZGmlzvm/pXb3T9nr8WRokvrLq0YFbf+lGYG4gwjZMhMDuZ
         3x4XCKTsWUKXhl7Rb0PvOJWK7P93uZbg9VGNnMWdXviqMVLAXI5Tn8ERfoKFyKN7Z+0Z
         pI7g==
X-Gm-Message-State: AOAM532ZgVETB0mnsVJKdtfhT1D+UJg39pZLmxrDuviI6n2SbhzS92wS
        U0r/cIB2PJSwy3j2IFQtyYPnvKMp5Kij351ffcE=
X-Google-Smtp-Source: ABdhPJzREqIAFoiLPnbTQN6MLaZVostzv8ZrlXvknLKeJmMPmicfB//y/LF9m4CMg7H4XWOFezdMVyywAOPJy1GSo/o=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr5633231lji.290.1599793830730;
 Thu, 10 Sep 2020 20:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200910203314.70018-1-songliubraving@fb.com>
In-Reply-To: <20200910203314.70018-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 20:10:19 -0700
Message-ID: <CAADnVQJjf-32YCbr1yRqb43rVMYSXbSdDZzt+UzocnWxZUxzKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix comment for helper bpf_current_task_under_cgroup()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 1:36 PM Song Liu <songliubraving@fb.com> wrote:
>
> This should be "current" not "skb".
>
> Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
