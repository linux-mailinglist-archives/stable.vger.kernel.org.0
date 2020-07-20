Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA4225AFC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 11:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgGTJO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 05:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgGTJO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 05:14:27 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD8C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 02:14:26 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so17256542ejb.11
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 02:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HT/w08b/F9buVSOqAYhSLIx8cTyL3aCPU2r2G861cY4=;
        b=OA5nN++wZuWJJmmyx6R6FCVHjYMTUBPL34nidvIoel4g6ktGaqlxKyNUr3TPMsS0G1
         WMKFOvmMewDMMGRlkrDEAJbdX8m+wMCrV/aR38H0o6Qv5up7tgByjO8gEjbG4O++Ei0X
         p6p202E4/NMGCsVYHR6/5M7nRkSOppJyGugeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HT/w08b/F9buVSOqAYhSLIx8cTyL3aCPU2r2G861cY4=;
        b=a72gRxr5iycYJzuSmoB/xL1TES1m2O9s/VJjI14eMZBFQ09yq0imK+F90EoBOifyY3
         GfPnlTGiGpAdMeSPL2dX6sh9HBMFH8RUCapgDy7gbWnzUQJPb6v5VnsuDH7Uya6npb9N
         jiIo+lutSVGGyGF2qlj9eRWYmvAtCyWx3q1G1pGd2TSSMY403IkUIRDuRheK5mXZvFWU
         B3GXtdWqI9L1WmJobHmLgCZBln+1O/0PTuY54um2vw09h8jCdu16V8zV5cjN8tub0QcJ
         TwkfiXtqb5OFbVlPi/KHnBtGiFxfxvBrRZa8LeR8E3yzvdHRwXo4AcnJ66ufA3ouT4a5
         sPHA==
X-Gm-Message-State: AOAM530wZxkUy4mkEj8rqg/msaffhyoI34D3I5MDuLDqIerbQOzdeIgZ
        rrppBkhiRIt3qejEwBXBi797jFSPd6pDPNRv2BTTXA==
X-Google-Smtp-Source: ABdhPJxszkVSu9gAvj7UPfh6XgM9/UkJcRFmVPWwmNhBdDMlwZnGAQ0eHlvBlk6A+DyrwtJSxMkAfA+e0xBj5htEy5s=
X-Received: by 2002:a17:906:4f09:: with SMTP id t9mr19330994eju.110.1595236465448;
 Mon, 20 Jul 2020 02:14:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200710115805.4478-2-mszeredi@redhat.com> <20200716002733.3ECE62075B@mail.kernel.org>
In-Reply-To: <20200716002733.3ECE62075B@mail.kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 20 Jul 2020 11:14:14 +0200
Message-ID: <CAJfpeguY_fBNSQiTdL0PYj6Rj7Rev9mTupVqFcvAepo2+E0Oag@mail.gmail.com>
Subject: Re: [PATCH 2/3] fuse: ignore 'data' argument of mount(..., MS_REMOUNT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        Stefan Priebe <s.priebe@profihost.ag>,
        stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000dbb28b05aadbeeff"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000dbb28b05aadbeeff
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 16, 2020 at 2:27 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: c30da2e981a7 ("fuse: convert to use the new mount API").
>
> The bot has tested the following trees: v5.7.8, v5.4.51.
>
> v5.7.8: Build OK!
> v5.4.51: Failed to apply! Possible dependencies:
>     7f5d38141e309 ("new primitive: __fs_parse()")
>     82995cc6c5ae4 ("libceph, rbd, ceph: convert to use the new mount API")
>     d7167b149943e ("fs_parse: fold fs_parameter_desc/fs_parameter_spec")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Conflict resolution is trivial.

Thanks,
Miklos

--000000000000dbb28b05aadbeeff
Content-Type: text/x-patch; charset="US-ASCII"; name="merge.patch"
Content-Disposition: attachment; filename="merge.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kcuakxlf0>
X-Attachment-Id: f_kcuakxlf0

ZGlmZiAtLWNjIGZzL2Z1c2UvaW5vZGUuYwppbmRleCAxNmFlYzMyZjdmM2QsYmEyMDFiZjVmZmFk
Li4wMDAwMDAwMDAwMDAKLS0tIGEvZnMvZnVzZS9pbm9kZS5jCisrKyBiL2ZzL2Z1c2UvaW5vZGUu
YwpAQEAgLTQ3Myw3IC00NzcsMTQgKzQ3MywxNCBAQEAgc3RhdGljIGludCBmdXNlX3BhcnNlX3Bh
cmFtKHN0cnVjdCBmc19jCiAgCXN0cnVjdCBmdXNlX2ZzX2NvbnRleHQgKmN0eCA9IGZjLT5mc19w
cml2YXRlOwogIAlpbnQgb3B0OwogIAorIAkvKgorIAkgKiBJZ25vcmUgb3B0aW9ucyBjb21pbmcg
ZnJvbSBtb3VudChNU19SRU1PVU5UKSBmb3IgYmFja3dhcmQKKyAJICogY29tcGF0aWJpbGl0eS4K
KyAJICovCisgCWlmIChmYy0+cHVycG9zZSA9PSBGU19DT05URVhUX0ZPUl9SRUNPTkZJR1VSRSkK
KyAJCXJldHVybiAwOworIAogLQlvcHQgPSBmc19wYXJzZShmYywgZnVzZV9mc19wYXJhbWV0ZXJz
LCBwYXJhbSwgJnJlc3VsdCk7CiArCW9wdCA9IGZzX3BhcnNlKGZjLCAmZnVzZV9mc19wYXJhbWV0
ZXJzLCBwYXJhbSwgJnJlc3VsdCk7CiAgCWlmIChvcHQgPCAwKQogIAkJcmV0dXJuIG9wdDsKICAK
--000000000000dbb28b05aadbeeff--
