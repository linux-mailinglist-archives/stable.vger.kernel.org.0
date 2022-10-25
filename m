Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7143460C0F7
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 03:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiJYB0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 21:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiJYBZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 21:25:33 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE8E24E
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 17:58:42 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id g13so6107007ile.0
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 17:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+e9yaIyRL5G9NRU7XHyyNuC83ASqv5hLxXsPYmEbTgw=;
        b=km9zz7AOmFwUQvfBHe6dm8oIgaB7ydvT3Z3hM4GqG2XDoVBBTTbI8KaWndWd/8zg/k
         zya6Y3/1ZyAZ4ldo6+OOYIFNd+LtD74eEj2P2aKAXevwIq1OaMWiKCYU5mTX58WjGB5W
         9kzNhAKJA7Zm3kBO4U0cbUJ8OGP+QdA/tvgplT9JQBQGb00ELlCJ1DtLxiXZiMu8cmto
         roicxQxPwNyshlsJltpdjU03r6RUV1Fa4SLD4sg023FIE/6//S4P4fayzMSUK8/CUJHv
         FtFFJ9cM89CLPK8d4xuXgkmTLfYPQtXK3eSXEluVgzf23G48tac1TAjHfSGLdG2g5Nak
         4Ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+e9yaIyRL5G9NRU7XHyyNuC83ASqv5hLxXsPYmEbTgw=;
        b=FKxtbhgLR+WGS1IMPGfaWy02iudJbVJaW845wPjAefz+UqAMarHGfAURNJNvW1p3xx
         /FLzvebS47L5BkvU6goOw020HZ9i3LkZ0KYRgdT54PIZ670Hta+zXBzXlrfVFtZZzILC
         yg2xFi1iZhyIffTdHXiHdvIfdUVzjkOeAkfy1Et/UDrCfSdi3ubm9KvURl/7rT1sf+eF
         QCOSWcRYWduzTA4P/nMMYdHX1jr0exmrJDWsPctOQBsXIvSuEMjBqqq4Lys7DuIoz54Q
         BhlWOHAsNgSB6IDhCvXqJXamNm8OInPB3cFNpvsyCz6ni+TDSO29K/BtBvyTY9Qx2/Zt
         +UyA==
X-Gm-Message-State: ACrzQf2TEEK9aE4hKTZhprg34AFuTnG/ohKJvqulvcaBFYvNWG/n5zrY
        RVkiBJ4HG7bKoLOhUxymEcX71o8+vluLQA64fEkHu2yt2o8=
X-Google-Smtp-Source: AMsMyM4GxYQyKBri3zS04v7X4/fc0tUn5NLab6lLevk6Hvf2f8Ucfcs5baHVcP3dxnOwdaN5c5Jdp/5x4HGUcbv+yFg=
X-Received: by 2002:a05:6e02:b45:b0:2ff:9c07:fbb8 with SMTP id
 f5-20020a056e020b4500b002ff9c07fbb8mr9510443ilu.200.1666659522222; Mon, 24
 Oct 2022 17:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
 <Y1EGHnKcWzKv6t99@kroah.com>
In-Reply-To: <Y1EGHnKcWzKv6t99@kroah.com>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Tue, 25 Oct 2022 09:58:29 +0900
Message-ID: <CABCjUKAgYkLAneLub+JV=uBRMBsmrk8RuH3SVCaUMWozb638Nw@mail.gmail.com>
Subject: Re: LTS 5.15 EOL Date
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, Sangwhan Moon <sxm@google.com>,
        stable@vger.kernel.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 5:26 PM gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Oct 20, 2022 at 08:25:35AM +0900, Suleiman Souhlal wrote:
> > Hello,
> >
> > I saw that the projected EOL of LTS 5.15 is Oct 2023.
> > How likely is it that the date will be extended? I'm guessing it's
> > pretty likely, given that Android uses it.
>
> Android is the only user that has talked to me about this kernel
> version so far.  Please see:
>         http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/
> for what I require in order to keep an LTS kernel going longer than 2
> years.
>
> If your group at Google is going to rely on this kernel version, please
> read the above link and talk to me about it.

Yes, we are going to rely on this kernel version.
I know Guenter (cced) has done (and is still doing) testing on -rc
versions, but if more is needed I'm sure we can find a way.

Thanks,
-- Suleiman
