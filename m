Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3BF58B438
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 09:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiHFHio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 03:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiHFHin (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 03:38:43 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08EE1115B
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 00:38:42 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-31f443e276fso42181207b3.1
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 00:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc;
        bh=9qVcN+Dt+9GvpbN7dxen7JWWI2wzROGJwd8itYyi90w=;
        b=UhWbzMt4MXJtIIVuqRM+z/AmWDYA2MPVH/veDXqu1YW+nCpZMcqDjUCHHghwgTOWCd
         DtKbpaVBKgZZ1OJQDNmVH8LuVseWFGnIm923i/spG+D8MA/mEFW8SIbMSAhhZ49KLflN
         nmS8Xz1JZDMDDDjMOsvEVcbiMHhUJs4zx7hVPhFkq4KI6mAIAkn/8YKOludiPjG1FHtq
         AaI1vgUn43m2NM7IzXIQoavAkIDvzQF1bmwsgZ6WZCvKtqNIWLvwyrJhzUMxea628YQr
         i8d6W3FFB7MbDc42dQbK+W0ad1a41IWXR7NTApIk/qPKlQ9fnOYGOhaSOK2Dh5iMjoIs
         HTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9qVcN+Dt+9GvpbN7dxen7JWWI2wzROGJwd8itYyi90w=;
        b=U0vUddy9i6Y48r/JpsE6cAGFlQcS/5H8L3xYtPzEWBYbqiGmfxM6r6BgIL8icGPaL3
         7u8N019/EvnQYEPO+B9cAv7k6KMJKPYTh1OlE8X83wpsfaJfAgSAbc8zyDSMJCLXgYy3
         PeaRz6R8gtn0ED8PjtcOLwZHtWg7pim4cAjWu8qBfStZF7565k3ymOj3lWLxcHmbB8JO
         AbNN/vSfTqYuVBjdTCfPTRazO6LYg5NspNI8kn+GluUgepvIZi04TSazVVIySv1NW2qL
         FvUFoq2bNtEXpSylUtVtvql2Ra4xo60/XmYTNjuWwvLNQS8Ne/i552OiaRKsQdrXhxMk
         EgOg==
X-Gm-Message-State: ACgBeo3ovAdiqdUsMC1lwvtsiGeGBHqNREHwZRo6bI4tQxDfLGR8h3JZ
        mS+BuicVq1MFP5jDK5WZ6F5RPwPPV91yprl3L3Q=
X-Google-Smtp-Source: AA6agR6FYB1wPuLzAsORBg/yOaq5rXd3X2UBMuSyHVNgoiXshHfhhVWRabqq8qePAoG3Wa8yh9niKETT5GvwU37vuZk=
X-Received: by 2002:a0d:fd05:0:b0:329:3836:53ac with SMTP id
 n5-20020a0dfd05000000b00329383653acmr7007522ywf.455.1659771522181; Sat, 06
 Aug 2022 00:38:42 -0700 (PDT)
MIME-Version: 1.0
Sender: nagarparkernagar@gmail.com
Received: by 2002:a05:7110:b009:b0:18d:8090:b49 with HTTP; Sat, 6 Aug 2022
 00:38:41 -0700 (PDT)
From:   Pavillion Tchi <tchi.pavillion@gmail.com>
Date:   Sat, 6 Aug 2022 07:38:41 +0000
X-Google-Sender-Auth: dVE7-tWTbXA7LnhbB6_pnRsZ88w
Message-ID: <CAF3hO+Gn4PofNkkQk-OqNOLtg22yjCZLWSy3JoJYWJndfu4ySw@mail.gmail.com>
Subject: Hola
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Hola
=C2=BFRecibiste mi correo electr=C3=B3nico anterior?
