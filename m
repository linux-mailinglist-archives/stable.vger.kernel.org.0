Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12C34BE14C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358969AbiBUNVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 08:21:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358867AbiBUNVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 08:21:46 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FCB1EEDA
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 05:21:23 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id w37so5992432uad.10
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 05:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=94r73LrRNpO7YYFshzYM25uztFOXVTrm/QHuYFLiQ7w=;
        b=d402q43nEICG4Vbkle3InRY0tvdAgHlBr/HS0czEl1SuPXYV9zyangSu5/T1NKhp9W
         i+YBUFYLsN0wlE52bzGv9fTlsRgBqWL6bk4QBamvddrI+koJHuj94DByajYGAjOgyAxN
         OYAfd+FytWnl+gauxuqsCwIVaWK2ZS6OoCLeDWO3zZlZx2nt4COO+4Od+pSvGKG7d0Sg
         a0n4aTPAf9qsM9qIlX5TTWk9jed9pr4DzZp/dxGY00hxI+YJGoDoDODwlPaN2MC6ropw
         vi86ga4ETm1Ty4qJUWOg9Dvo/Ez64Xu0hryomJmGyaEyd9ni0P9RD40kTsxZx8708btS
         GRXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=94r73LrRNpO7YYFshzYM25uztFOXVTrm/QHuYFLiQ7w=;
        b=QK5rlBkCAMxurIbBlyzlNp3uXxopX5HaIu038aYTLNnLxQudnnWE518YIeY4nI4gMb
         NleZmgNgr05hoHscTVydkv1Ul303f9ZH9k2qU2w+1pCd+Cvs+CRciyke4/f3LurvY7QY
         3XcOOPwEXAZ4+c9s73kG2Nk2tsApEg/aq9+8gwHsBluEU0yw1TBgIhGq1CVoNRSEhv6x
         KsAQrUYYUDvE+GNX5rADd5C2cbXnIbGmV8Jp4AOTVwg+m92icWMOExxPewaog8TREJDd
         tD3hKuPfdyuUDR+pyqoSlUBLYkgYcQzxF2xOdxDYvC1hjMcAe8B4pQinNf4Apq73dR54
         Vpjg==
X-Gm-Message-State: AOAM531v0txSyQeC8rasXkkQtaSIb7q/xwwMeSECQNb6gkGGxMdy3JXG
        bdo8QNUHTzkIkx5Lk0BhEKSP1UZWlPd7MYgfHuo=
X-Google-Smtp-Source: ABdhPJyebt5xOR85cr+IgYxWgZAJQz4OgJZByOTjkuEkqSj+udPHRnlSEXQfPeOoNaIKQxLRJwwgTHVwDzvafV8VYCo=
X-Received: by 2002:ab0:168f:0:b0:342:48cb:7e4c with SMTP id
 e15-20020ab0168f000000b0034248cb7e4cmr2535196uaf.51.1645449682721; Mon, 21
 Feb 2022 05:21:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:d8cd:0:b0:28c:6bb4:8918 with HTTP; Mon, 21 Feb 2022
 05:21:22 -0800 (PST)
From:   Anders Pedersen <ousmanebarkissou@gmail.com>
Date:   Mon, 21 Feb 2022 13:21:22 +0000
Message-ID: <CAE0fZ3cJic5tEnr_L=pU1LnfziocVPMajBo=FKeuhcvr=e+ekw@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greeting, I'm Anders Pedersen, from Norway. I want to know if this
email is valid? Thanks.
