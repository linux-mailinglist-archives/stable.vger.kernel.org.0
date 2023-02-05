Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8690E68B0DE
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 17:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBEQPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 11:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBEQPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 11:15:47 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE1D1CF54
        for <stable@vger.kernel.org>; Sun,  5 Feb 2023 08:15:44 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-16332831ed0so12517749fac.10
        for <stable@vger.kernel.org>; Sun, 05 Feb 2023 08:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sx/dZTCZTWSCpap2GSWkb+uyyIlUwE8/Jo1YiJR44m8=;
        b=jMMwnJRdym4YX0ds/vsmSwPpYyKk7gRY9vllbhkhwyg2rrtp1Y17ofACrXzDLevCte
         EdaV1AwU/hnJqk+mcD0c7R+iKKWIdTfK/ZcDBtE1AwhBsVyHI4ora1uqldgwBi3PeY7d
         pFshWYjcZrEFOx9K7zaQ/x+QXK0OiNay9MZDOZ/Yj4jvALrtq2s0LGW7AaUr1av/sd+F
         KawWYLaQ6ZO3CkImTxOW32UW9WeHiIKj003/Clu+Af/QiXMA+3osSILRWH5WJk5yUDJ9
         Sdptc8LZ+E3GD9AsTbAHyuO8QCjI5JZ/bFmrc/SmpTLNebisuAPRbih7jk/Lzcn26Zqr
         pe+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sx/dZTCZTWSCpap2GSWkb+uyyIlUwE8/Jo1YiJR44m8=;
        b=FpGqFMIIAIEUH4oPp8xlpiyjdjcluub/jstaTyk4eyV/IfBHZjhPHh8Kc6KTacKZXc
         eQ5UXMM533gUu6kgLoLVuNXB2ULahn0FehP15/VSdCLhQ5VTE4j3IJKxXTQ8GTN5eFPL
         zGcUpn30B6lLO9vdNDZQdjamrEG+NibwtJU9/8JPxkKlZ+221FkYJILtXN205n/k+PuM
         i+b5WnZ1ILuvPSBOmsm7Nv8cb4zukT3LJhaPPi7FmNmOdAP4ajDsAdZqplzObR5jg5rP
         ZwN/tCINwLlpikiD0wBRjq0Jeab/T7IyXClljjvCXmDdrImwUD1hzq7VYZgvUhYSjHoR
         lXUQ==
X-Gm-Message-State: AO0yUKWuClGEm/74GprAvuZtqrT/1X1mLkuvZgrOfyiKqsKYVHb2Mu0l
        dbAzApxEKXjXEE1ff8VeKzP6ixD0BnGpiiXc5mA=
X-Google-Smtp-Source: AK7set+G3NhYcBlaGjsjhNJqml7z6eEn7zpFhinJbGsYlD/8epI/pNvp7A1FWvL2wdjgnDGC759JKOKYZ7ip6HsF6HA=
X-Received: by 2002:a05:6870:d69b:b0:16a:3ec3:6585 with SMTP id
 z27-20020a056870d69b00b0016a3ec36585mr133810oap.292.1675613744065; Sun, 05
 Feb 2023 08:15:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:491a:0:0:0:0:0 with HTTP; Sun, 5 Feb 2023 08:15:43 -0800 (PST)
Reply-To: te463602@gmail.com
From:   "Dr. Moustapha Sanon" <moustaphasanon4@gmail.com>
Date:   Sun, 5 Feb 2023 08:15:43 -0800
Message-ID: <CAPX2G2bR6TRokDjGrDjwWxyYRV_Ujfzj4BY=7+oMoPSUPBdSOA@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Dr. Moustapha Sanon
