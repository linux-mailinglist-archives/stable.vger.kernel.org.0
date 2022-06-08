Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F5F5429EF
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 10:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiFHIw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 04:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiFHIwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 04:52:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF009270427
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 01:09:59 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u26so31277753lfd.8
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 01:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=DCTOHlnn9bgmau2O5B11dgpXKkwCcv7DNwv92J7STCs=;
        b=GOCuOTC1NYvg7hmPeNabbPm7yiBZto/raJc/qx+su0G8DOJwva27DBkcmL3GmsiSBB
         g2/zNkxqB5bBw99IA3M3lSdumLoT0Qtlj8Ys9GzVx2klvVlFKygYCVgjNHkjZytUrVGD
         hoXZSzKltsNKzIqC4iy0sIaCUfZXKDjCfnUyCXT+JoH0vHvrAe09YwkSnMjzB3V5H/yh
         1c5bstjAik6LpO5SVzamMYOkHLSC4ZGpUouUXZnPP9I1JZMglcGkTk5NFdkSLrZhv9Hc
         5paew0dm2nQav3GHoPgyOxWLriqIRxmZ1w2uXpqE+Y/FybnivWVCk2vRFr6/L2EP4A7P
         FKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=DCTOHlnn9bgmau2O5B11dgpXKkwCcv7DNwv92J7STCs=;
        b=Yaf6Py2ShUefdu9GddLT21SnxEqYpBtpHFrRqTczzQjx9dQRiCtQDNrSLZk1Yu70An
         oiRYhwBISKrFsZ3qrHBEPCkHTb5/NRuo016t7Ta1KWw1lzkK10ggYPYW/gBzixa7LTgg
         TrskPCd2kESsf63F+clfilI6ylhoBI+aueGiQhSix1etZlOnQu97iZqoRaKMHbLwfIAe
         9NLIj5WW+wXf8nFKmUlU/HEMh1R2l1mfruMxFDcPPSfu82LkI/vWskPJ3xcZjtBlL2ac
         c+vAN1wipHGnPLkNzyOdkphYhdkUb0mAPEMuaHi0WipSQTfiUX61Eko7WJ9NB5zI8tWu
         jRzQ==
X-Gm-Message-State: AOAM531hJYeKyTv4e3+aMk+IC+JXvqaQfsACKajVQUsE+Ws/C1eyeDY7
        Uo1QrMgmJ89FWul68wxioCZjCOcfCpPCV66xAjk=
X-Google-Smtp-Source: ABdhPJxeMGqW3oWbQMPqEYbRGmwPYdrgawIbsAYiY5PQaZX6RS3cOmoIk5imaCmTu4qxYI0gHYqN84vZspOVQXF4EXs=
X-Received: by 2002:a05:6512:3f91:b0:479:6402:1131 with SMTP id
 x17-20020a0565123f9100b0047964021131mr4358591lfa.213.1654675798137; Wed, 08
 Jun 2022 01:09:58 -0700 (PDT)
MIME-Version: 1.0
Sender: onyekachi612@gmail.com
Received: by 2002:ab2:51dd:0:b0:141:c553:50ed with HTTP; Wed, 8 Jun 2022
 01:09:56 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Wed, 8 Jun 2022 08:09:56 +0000
X-Google-Sender-Auth: bIrzNZiJAoF0KtU0idQexaTx2qM
Message-ID: <CAL9XvekF-AVZA7FrDA3sKHt6ihW-0bA5mNm_Oht8=K4OgB3GRQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, how have you been? I'm yet to receive a reply from you in regards
to my two previous emails, please check and get back to me.
