Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9430159B534
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiHUPvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiHUPve (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:51:34 -0400
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8459F1FCEE
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 08:51:33 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-3376851fe13so201187777b3.6
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 08:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc;
        bh=lYgoSzYrNdAJHRDpvyMHA0AN8YmF5hdaYVpe90B0Tz8=;
        b=G129SMtU59wTnXy7MwiVG+nTpWQiUzpSux/o6wewBlRFz0zPQ1/Z8IRQRyRWquc9qs
         syqUwjIjxASz/a0t8a0omw75LNc4kxXe10lIXgT8Ml0ToLlkYXRLGGpNbTirKk7viSMl
         NGGiQ2qV9CH+ASxTFSCD9sT6MtFK0oVcE5E24RTvemldBIXUS4VTqSj61T0mINZq8ghB
         iLyWHD2k4BT5vc6ret9By7e6tYtuSFbne/CvYsTZ1FBsJ9YUfOj2+pklrbi9joWx/bJL
         bK8LqucgegxItDHiTPRHyUuawJahyIdVXUDg/TNOYvNbTL8XLtjyeJUOEQCgL4aN8ayK
         FtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lYgoSzYrNdAJHRDpvyMHA0AN8YmF5hdaYVpe90B0Tz8=;
        b=JzDsbnX7tjEhRXJYvOX8f4F/QTITNxbD/ijUCQ99B2lAUyOVUx+123d5o81QFTSoOW
         DEBwfTbMdh7xr/w7fe2TonqbEX1Z4Ltc+5BgZaGdkQsMIIYgr9QOAzJEAki682VYTtgF
         hbmWo81H98TpJ3FIdFeqUDjl2l4Ppdg75qGH9zp5xya03BRybpg4h5YEthNXSfrLO4CZ
         MkZ2/pJTmWE0ZxhOUZxFk87ej+kjyj+KIqRIoxmpw67pxntb3H2oXrHiUIzF6XYul1Nh
         9n2dNCxhatx7+1BJAzEOO3Oe082HJsGV8xofVaq2uuV0wttv6/9ValhHJTCJCrkhNdFq
         DW2w==
X-Gm-Message-State: ACgBeo2KUWrMh2sutSzdegrkH8LeXX/0cA7u1xr1OIeDEHF6CKvRo/75
        En6q7QgBjP047QCUrYFZ0kUy7I0UEg3RtxxO/oE=
X-Google-Smtp-Source: AA6agR5bTJ4M4PETne0iMMuN0ZjK7/wR++cUluLx7hI75BThYXXyq6W8cieq3t2p8+FucOCs3476tWRZXUL3iAgYqU0=
X-Received: by 2002:a81:817:0:b0:333:c5c9:dfb4 with SMTP id
 23-20020a810817000000b00333c5c9dfb4mr16304549ywi.476.1661097092813; Sun, 21
 Aug 2022 08:51:32 -0700 (PDT)
MIME-Version: 1.0
Sender: shadainarang444@gmail.com
Received: by 2002:a05:7010:628e:b0:2ee:fd59:7df0 with HTTP; Sun, 21 Aug 2022
 08:51:32 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Sun, 21 Aug 2022 15:51:32 +0000
X-Google-Sender-Auth: 8xZbKLvR_GWLtosofcHxMj5rGb4
Message-ID: <CAME1XYdcyb4q+6azGVj2GaLw_1xW80TupzRjD8ALnSDmOSCJxg@mail.gmail.com>
Subject: Bonjour
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Bonjour
Avez-vous re=C3=A7u mon pr=C3=A9c=C3=A9dent e-mail ?
