Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63A06ECD05
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjDXNT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjDXNTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:19:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030514EEF
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:19:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2febac9cacdso2654241f8f.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682342361; x=1684934361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kpj/quHCtWwAEy/HWT68YrA1m8HrVHHUNGqNDohmzE=;
        b=mi1SMj8MzqaCGgp6WKjkgRMA+Aqaix8xAjrqZYynDI9Z8bOevQFLFxZLT/woTUaazq
         G9MYXfCp9tLS1B1jweQWCl7UHsrw9j+qez3gZJgJO4VWZ4ywDOy7pzlFZb1wK1T5U+6n
         wa54T22A3HRmIlRjyXrZT1qrpBr+NVkeENOy2Gc1a2DryvHtVIJsH5qaSI0UVRZEVc8l
         zc0S4Lhf/TFHbfgY1P6EhqjIOa31WDcgzTw/VCdMbAPfFD1FqRQHxz9jhRydlDXRFgOU
         oxXkFpcO6HfCN7TkckKMtUv68p3p1x+VlQoVUTkgqSy/ZrGqKE/Igd4iBI/EISaiSWIG
         DHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682342361; x=1684934361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kpj/quHCtWwAEy/HWT68YrA1m8HrVHHUNGqNDohmzE=;
        b=TMYbVSBecOHeJwqncAVT8To+WM9QC8w2Cw4T2TRc7OlT4NhUkFQ+04zBQ22CjGPHMV
         JuTxHGRFpS46qRQjh0HCQJeCDyWSPx7eBmxZ8tjcCJci3NYB9vPfaX+/4+90F/KaZbPm
         +YlWjHAX71Ae8s55ejXTlkSD3pJOV9fnJzs+eshFpznho5ad45j1bEULS1cJu7olbqQf
         o8WIJAccGom9AH6IduWg4GQitycdljUN9mwfWCDve5eDJGe0c3vrtIxuuKMT0IihymH3
         Y6zCohBwIqAN+TUFAUGpYFPZV2h0rc65RUTwtHXfsJNVoeRcOGG65hRIZXC4Lz4zlaXQ
         g6HA==
X-Gm-Message-State: AAQBX9fbLzB48QwFSDD0RL4KD3avU3fwiBW4+K/oGooHgUMzq86nz9CE
        xH1bb3JCpRqg6TvZe36g4PMgxKZ/Msi2K/Bkgc5SvJhlNacfRQdL
X-Google-Smtp-Source: AKy350bKuTwTTYzhRjanpfZtTleU7Yz1/us5U/cDigvQnBtKMFsCRJaYuGzkYXcgY8Pz9vXsXYsd74/456a9jx0cc0k=
X-Received: by 2002:a05:6000:1b85:b0:2fb:2a43:4a97 with SMTP id
 r5-20020a0560001b8500b002fb2a434a97mr9196993wru.39.1682342361527; Mon, 24 Apr
 2023 06:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230424115618.185321-1-alexghiti@rivosinc.com> <2023042403-renewal-ripcord-736b@gregkh>
In-Reply-To: <2023042403-renewal-ripcord-736b@gregkh>
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
Date:   Mon, 24 Apr 2023 15:19:10 +0200
Message-ID: <CAHVXubi0_PW=rW2xUd+bjXR-x8HV+=7qYhvq7LVVoKeaa4ge9w@mail.gmail.com>
Subject: Re: [PATCH 5.15.108 0/3] Fixes for dtb mapping
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Conor,

On Mon, Apr 24, 2023 at 2:51=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Mon, Apr 24, 2023 at 01:56:15PM +0200, Alexandre Ghiti wrote:
> > We used to map the dtb differently between early_pg_dir and
> > swapper_pg_dir which caused issues when we referenced addresses from
> > the early mapping with swapper_pg_dir (reserved_mem): move the dtb mapp=
ing
> > to the fixmap region in patch 1, which allows to simplify dtb handling =
in
> > patch 2.
> >
> > base-commit-tag: v5.15.108
>
> Please look at the archives of the stable kernel mailing list for
> examples of how to do this.

Sorry, I should have done that.

>
> Also, what about 6.1.y and 6.2.y?  You can't have someone upgrade from
> an older kernel to a new one and have a regression, right?

Yes, it is ready and the patches are different, I was about to push
them when Conor replied. Let me fix that.

Thanks Conor, Greg,

Alex


>
> Please fix this up and send patches for all relevant trees.
>
> thanks,
>
> greg k-h
