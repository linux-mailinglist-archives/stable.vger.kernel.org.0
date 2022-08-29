Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3976A5A535A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiH2RkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2RkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:40:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CB854C9F
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:40:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w19so17170183ejc.7
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KaIHRTFY2vCpVkISre+6CBQyJaDOCLw6Ra14gn35vYw=;
        b=Ab9aBweE06CoNh3KqziwdVWSPGJ3xzZxwa3U7XMBIKu4zMBlAvR+7VCoLNoVY1lA0+
         4y890N0nRobL2bz6Nt+Ho3HU+XSWliIVELM85ZzQmAhrH/Vt+cJvY74ccaIho58BE06d
         aF4Phq5I/oUI75NrRpNHEyhWXtMD3lxR774nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KaIHRTFY2vCpVkISre+6CBQyJaDOCLw6Ra14gn35vYw=;
        b=vh5NDJ2kHwhgQzf5H9W1G+DC6Co7CUdSErJyVHLWLY9PEsiwPypifYCNHKZXhKkxHB
         iRZe2LHKr3IQ+Y5dq/gy5X08Srrb01YRemT+s7xMNchdog1rvfPRusrGO3n5l3C6zwDd
         rf3wrgr7pVnOQ0Jjy4+wqhviesxe2OTqr8/HPKX6R3RdML1nMwAx0U6tfdAluH8yFM/D
         T7oyfZ/4CPZEBuJEyiLro4PX4eBKEus4guwOGSWpEciNe/0cSFQCGZbUsXh15y/Ch/z0
         DF0R/lgG2qstrNdqNyVTfB49mbvQQ8Trsi/pW8tKEtWol5AW4UYWF+fXX1nPQR53V1Ee
         dssw==
X-Gm-Message-State: ACgBeo1kHRP3nZkFVsu+jj+TL3aa7PE2lu8hjNKS7nipNyhs8t3idxMF
        yk91RAUCCUVnPW0UT8ql8XljSw3L9a6x8d8L
X-Google-Smtp-Source: AA6agR5B6oW2A8vBpm/eyJ+kDuEwTLiYH4UVgO0urGlbOMA0Sf1qnsK4UU6/ZGjE7T5Wpoi7ytQwdQ==
X-Received: by 2002:a17:907:9620:b0:730:d5f4:d448 with SMTP id gb32-20020a170907962000b00730d5f4d448mr14280629ejc.45.1661794815268;
        Mon, 29 Aug 2022 10:40:15 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906319500b007402796f065sm4506226ejy.132.2022.08.29.10.40.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 10:40:14 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id b5so11113369wrr.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:40:14 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr6584905wri.442.1661794814268; Mon, 29
 Aug 2022 10:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez3SEqOPcPCYGHVZv4iqEApujD5VtM3Re-tCKLDEFdEdbg@mail.gmail.com>
 <CAHk-=wgrZB20D1mz55ohTWpv9zbik4TLJi+N_UMK_N+y3ofYWQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgrZB20D1mz55ohTWpv9zbik4TLJi+N_UMK_N+y3ofYWQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 10:39:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wir0U3wydevpHUsHQyF_erDRY9t5Rtvh-mfikqG15XH+w@mail.gmail.com>
Message-ID: <CAHk-=wir0U3wydevpHUsHQyF_erDRY9t5Rtvh-mfikqG15XH+w@mail.gmail.com>
Subject: Re: stable-backporting the VM_PFNMAP TLB flushing fix (b67fbebd4cf9)
To:     Jann Horn <jannh@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Security Officers <security@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 10:38 AM Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> On Mon, Aug 29, 2022 at 10:36 AM Jann Horn <jannh@google.com> wrote:
> >
> > A minimal but also completely different fix would be:
>
> Looks sane to me.

Just to clarify: we've fixed things in stable backports differently
from the development kernel before - just make sure that the commit
message mentions what the devel fix was and why the stable fix is
different, and it's all good.

                 Linus
