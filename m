Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0AB27298A
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgIUPIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 11:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgIUPIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 11:08:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57BC061755;
        Mon, 21 Sep 2020 08:08:41 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l17so13093548edq.12;
        Mon, 21 Sep 2020 08:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RTrxC3+tWWFMcvMDD1rxCTJhbBP18x/dX/pnSb4qObw=;
        b=TrqbfqWlVos7QDcr0HshQVtptkHqDjkov5MYTBoJYDvGEsUCjVlXAJxATTOua0jggr
         6wypO1oq/iym9y6P0ZSKosEEt0Kny2+6FlGGXGAalEgzidEZCjhbR92SIVttgo5AHdPo
         lH1nWjDIPLngLEUYeKBeMYLqqtWsiUB8sJKKLHFlKl6XPdb+qWDknIaO2tCFP1CsSUwU
         vVTPA70d1sacUVDnA/4cR8syMB/lpJm7NgSXxuIPEEJ8n7r38KyGp9e8RioBUBeWJi5e
         2VzBQUn/z1A+006ADl2IgllXpn5PS2xvsxB9D7qnWeD5T4QgByFniEhzn67/CAIzu7UW
         lM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RTrxC3+tWWFMcvMDD1rxCTJhbBP18x/dX/pnSb4qObw=;
        b=GF5Fw9QWQzNRgxyPWowWU06PRvD+Z7UD4DTS+UaJ7sITc3WEhPDq4LJIARTrgyzDby
         ZM+u01dbnfEfdZEwqI2j8kx3XTmffMn3jv1Wqzlj6Avpj4LbuD10vHrKHVSMHVFH0P1t
         5PpikTnSmNzTr+yxwsWPhsfB8tyaDbutnYVYegr+83LC6o43ruPCBC4OYcBmwRtTCCC1
         3Nl9ZDkI+6TVu4NkR71QQvfOL/YsYejVl1jNhxvsvptzZ69VAT23qWwspnphZWa+Q/p3
         7PlPvT8sPCnCV6PdEBYFsIoJrGixQCDL8ghO1I/g/1E15Vq/Z8JCOeJIm9JfAYCHAcwM
         L9dw==
X-Gm-Message-State: AOAM532PcZ/HZQnUAl2UNNTHF0QtKl0CS7nLz41l9+qtTImWbvDTKtcj
        tk4gn3DaTr0PS77B1Cir5jlZ9kNdIv+PkTIv8w==
X-Google-Smtp-Source: ABdhPJwiKCg8AL/UzlOHLJ4kN4ff6Gkc1xYfvcFqrTK7JA1ZcUdV4luAuHM4LArXlXE6dh3o3yZ4W4Mab4/wL6P0XBg=
X-Received: by 2002:a50:fc04:: with SMTP id i4mr136672edr.14.1600700920173;
 Mon, 21 Sep 2020 08:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200921104234.9C539216C4@mail.kernel.org> <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
 <20200921132850.GM2431@sasha-vm> <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
 <20200921142807.GA643426@kroah.com> <601A8297-7002-43E1-93AB-DB29F7E3BA92@tencent.com>
In-Reply-To: <601A8297-7002-43E1-93AB-DB29F7E3BA92@tencent.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Mon, 21 Sep 2020 23:08:28 +0800
Message-ID: <CAB5KdObZ2PZZRF56xb0YT4i0Mt=_mz36fE9U-D2GOhuUVX5ujg@mail.gmail.com>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Sep 21, 2020, at 22:28, Greg KH <greg@kroah.com> wrote:
>
> On Mon, Sep 21, 2020 at 02:14:41PM +0000, lihaiwei(=E6=9D=8E=E6=B5=B7=E4=
=BC=9F) wrote:
>
>
> On Sep 21, 2020, at 21:28, Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Sep 21, 2020 at 10:54:38AM +0000, lihaiwei(=E6=9D=8E=E6=B5=B7=E4=
=BC=9F) wrote:
>
>
> On Sep 21, 2020, at 18:42, Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>  KVM: Check the allocation of pv cpu mask
>
> to the 5.8-stable tree which can be found at:
>  http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.git;=
a=3Dsummary
>
> The filename of the patch is:
>   kvm-check-the-allocation-of-pv-cpu-mask.patch
> and it can be found in the queue-5.8 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>
> This patch is not a correct version, so please don=E2=80=99t add this to =
the stable tree, thanks.
>
>
> What's wrong with it? That's what landed upstream.
>
>
> The patch landed upstream is the v1 version. There are some mistakes and =
shortcomings. The message discussed is
>
> https://lore.kernel.org/kvm/d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.co=
m/
>
> Then, a revert commit was pushed. Here,
>
> https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1=
LY=3DzMQ@mail.gmail.com/
>
>
> What is the git commit id of the revert in Linus's tree?
>
It is not landed Linus'tree yet. Maintainers suggested a revert before
5.9 is released. Message is here:

https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=
=3DzMQ@mail.gmail.com/

So I think it should not be added to the stable tree now.

Because of some error, I send this mail using my gmail instead of
enterprise email. I'm sorry.

--
Thanks,
Haiwei
