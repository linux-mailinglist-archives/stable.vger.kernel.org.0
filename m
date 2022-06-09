Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83085448BB
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 12:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbiFIKYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 06:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiFIKYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 06:24:36 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D2C68984
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 03:24:35 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id a8-20020a05683012c800b0060c027c8afdso6780553otq.10
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 03:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=TpTnaHUSYpys6afjxjmQI6pcNurx5KZ9QlazVbW6Q3Y=;
        b=oDi8yFUBBf7q3AHeEsykoRPd2V2nWoL5eo0pdRfA0RiOLAUp41ch7oQmLO6EFFCst5
         G6knEMmUDoX3p1mtGKJ+JHj57AbRxFo3LG3Zp4o7eLd8v5vBg6jTOihH2ICVEvnlF8kH
         q2LxOgi2PlA7EZRNZPnMn/XYEu+1jdzbrCGQlOw/7SrBxCnHBZuHSdi8wwNzOVxxUvLs
         sAcPphXjh6HaArTrsLI00c0BLj9oVicQt7jWqwbc6Msv+vy18tlZC8WNcsziGJtLJZxz
         09nnFKPGk18aE1UwwyMCd96fHVtJbjuTalsqFPlKRdrjV9Iq1atSWFrdnf5J/LVmT7MN
         ME0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=TpTnaHUSYpys6afjxjmQI6pcNurx5KZ9QlazVbW6Q3Y=;
        b=orJP9NfrYl9bBieUBdKWqKLJTOvXIA6VMBo9CPZuUK//CRhMgGzcLdTvNDEF+PCD0F
         zhV25psRs+tGNhasAP/2kuasONW3JeDDkg3jpyQ/X2MJ7WsIyNggk2R9VyVdonnfboas
         Xl887wCt+zCxqDTFJmYwOe21QN23rpXR4n6CSl7z+djHrrTGjSMSIZTRmb8aDjSG+f3F
         rKMD4oqNkR9l7l4PI/i3V1j5IxlSsGtC4wWqbPv04LeJf0V1KM45BwN2L8RHYTaIlQDJ
         H/ZFEFzt4tvv9efzUaeDFnSk5wjOOyB/lT42KemAQY/JB+rIaLqv7tW7beBiGdlc8ZbK
         14og==
X-Gm-Message-State: AOAM5338ZJc+a/bE0ktWsDlzaIK/i3Q0ZvSsu5aI5BqH/OMYcbQYrCML
        7ZXuyUbCKeoNlLZNCq7TGwvuF0s6+O2iFh1kNBI=
X-Google-Smtp-Source: ABdhPJx9jHPbnR5pbsTpYj62C0czqhnQTWtB1HCtBl7Xkt5ed0TIPZktja/MNbMjEm4kfW+Bb6Epjd8MiqUera7/Ktg=
X-Received: by 2002:a05:6830:4386:b0:60b:3f98:a292 with SMTP id
 s6-20020a056830438600b0060b3f98a292mr16341689otv.111.1654770274903; Thu, 09
 Jun 2022 03:24:34 -0700 (PDT)
MIME-Version: 1.0
Sender: danikedaniel2@gmail.com
Received: by 2002:a05:6830:14d:0:0:0:0 with HTTP; Thu, 9 Jun 2022 03:24:34
 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Thu, 9 Jun 2022 10:24:34 +0000
X-Google-Sender-Auth: xQ4o2nNCglABQjyukTA0NTof0S4
Message-ID: <CAJj5oHEHG6gY0yfjnZbuY3LPDX5JFC-C5O+domLikyMsw3Z3pA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj jak jsi se m=C4=9Bl? Je=C5=A1t=C4=9B jsem od v=C3=A1s nedostal odpov=
=C4=9B=C4=8F na sv=C3=A9 dva
p=C5=99edchoz=C3=AD e-maily, pros=C3=ADm zkontrolujte a kontaktujte m=C4=9B=
.
