Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07767B631
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 16:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjAYPsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 10:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjAYPsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 10:48:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C7659547
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 07:48:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bk16so17483223wrb.11
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 07:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WbCVpTXmOt3PhuSkGfAaSb6Dc7YjW0ejwuYxgg/UJZI=;
        b=ZGdpm7DnRcZ3w9rAbIMDbQqVY1h2w3oIxm/RvoN70Z7xe/U/IOmYBn5szrL+W2ZNRk
         dLO2gC3StADv4KcaY3D8a9RQ9TuQtUnQX7HzCUCv6VjSt3Joe9t0SqPIKoKYG22+4bIP
         uq+ix2/15Wb5gKx92av3LSU5cAcrdoeAr4rsxMtPO/uT7gcJj0U1z87sNseW1GnLNg9+
         uaeIvzuVMqdqCbEmn2db5izIFPe/+iS1OTU9IWOhKqICpbYYmaACJvwJx1lNgmwIR30b
         ODyBct3d7c1bQ78+DMwc+SHf1rGgbLrrbgSkMcLwEP1ewj4CNBYcQGAauxRCaUINLf2h
         GpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WbCVpTXmOt3PhuSkGfAaSb6Dc7YjW0ejwuYxgg/UJZI=;
        b=5SbCdUiTANHpuQZYu7FDGANSz4Kx8wKdTBcmAIWWAmfUU+hoWDJQv20neA3FWTaT8p
         vQJqX+zAPP4V+AyrujSRbRkxIUfG+UElY4ry3dlpnLRq1PmDBXvX8OKOk8FInqhv9N3C
         6aAp++EtAEK8nKU4Y2yXR2JFxdbm+C9kLcbjbG+cAcLeu7CJnzrmAWNR7yenpvmHO4S6
         cCXjVDhiXyCcHLF1Z6nLQpV65GU+WEP6FJwu8wOE9K7SNQPjtCXIItIpEKC9MMuEkUs7
         HlgbLfuriFMQY/Wb7bevcwRpcr7DL5PHP3n3M4n9MPE03zwb7FzIwjoHQMmSiinvSuK2
         vZyg==
X-Gm-Message-State: AFqh2ko+tIbckh4TAFSbfepunP+8k8F2dzliH+RZvXBs9dg5U1Nn6jTL
        QE2svVL6Jk9MqNbEDeciHFRZZO/CIJkA41H3OsZIdg==
X-Google-Smtp-Source: AMrXdXtXuK+bRyEFGXrD3dVKMM6j4zF7uG65dRSc/QVHP/dcTTRDNFaAINVuyNEbnglB5Ed8Hb6G2xPPjw4w0t21ez8=
X-Received: by 2002:adf:d229:0:b0:2bd:f5a5:5898 with SMTP id
 k9-20020adfd229000000b002bdf5a55898mr852248wrh.319.1674661693524; Wed, 25 Jan
 2023 07:48:13 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com> <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
 <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com>
 <CAFJ_xbrAVZDtXwe0Ku0V7b1xp580N+ao0caCRP1xiHBr11oKyQ@mail.gmail.com>
 <CALFERdwpbQdpnyLuHxo67S4KC=if97AzLGDRVEo+u-HN2Tu0fg@mail.gmail.com> <CALFERdwXwJxZ=jG=p6J1LUERzL9=xaiixN1t4Ux11axMW3CJuw@mail.gmail.com>
In-Reply-To: <CALFERdwXwJxZ=jG=p6J1LUERzL9=xaiixN1t4Ux11axMW3CJuw@mail.gmail.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Wed, 25 Jan 2023 16:48:02 +0100
Message-ID: <CAFJ_xbpsWVaRHxS_Q=5A1fTxzh_xuBd66garxX63WqEkiXieFw@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Sasa Ostrouska <casaxa@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi Lukasz, please see the dmesg with the non working sound kernel:
> https://gist.github.com/saxa/08b233a95d5e52046354b07d2e9ca13d
>
> > Rgds
> > Sasa
> > >
Thank you Sasa - two more things:
1) can you also share kernel configs (for both cases)
2) what procedure did you use to flash Fededora to Eve?

Best regards,
Lukasz
