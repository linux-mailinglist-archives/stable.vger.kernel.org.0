Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F6553045
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347464AbiFUKyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348951AbiFUKyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:54:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D733725EA4
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:54:46 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p69so13845949iod.0
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=9xyn9wgi+Qu35SfzSpjxkQ9ktOEp4TX7eV56n0CgFYQ=;
        b=qzL+/g6iOWEAAyyK/L3/jYH7ANqZr9B5BFraeYJEFy8+ZFqfItxSMM8zkHLShsoJed
         yLmrqLYpODZVzfSJyg6uTssw7n0BWm01Or6gikO99iof83xx9DDj2RshMddRTK9lCkOR
         CUVNHd/fKkTRWocx3LH2mj04uYf0xkNSnrX3lowe0ZPRPHyyVJI472oXTecRj2lDYEMB
         cs6StjdRsl+8n+d7jg06uZeowlwqJ90NPt+2rSgwPI5n8+8l7G2EjB6skPS3jxrHA6um
         Saanp8psuSlH51JvwPKQ9D149ffPNuVRnPFwlgWys4ZPJpcngsaQRdxldH8c3qABV2a/
         T2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=9xyn9wgi+Qu35SfzSpjxkQ9ktOEp4TX7eV56n0CgFYQ=;
        b=0Ikfiv1GlpP/TF+wLXFKmv+3nm5ig83PxpN4BGaf4rMhECsRPoYstvVOz1ipkjmgBh
         3h22miIC2h1VEFWHjPnY95SYXC3T/wXov/APp0vvCPpP8L4XXN8CFUaw2QhASfBCdTpG
         rv5CzJEClpUAB8geedl+RV3Ilcafda0q3p7sGsxisvQKEYENGeO4bdt0hON0r5wgIRuC
         68jLSQFknandeT2uslqkB/c4GTYSNEVAQ3tpmwkqVbGcFXDUd+3+GK4DV8d21SiJnltc
         GEKoaZL0fLAft0l7+S4HeZIaRESgHmxAAepRVdKyXzgp+caVmw12llPv4KjgM7rs9EXg
         hung==
X-Gm-Message-State: AJIora/kREir0kZ3BXMgS456lQKwW0F48hwZxnY+ivlm0JCnC2xwimjM
        tOnm298lGAITWzsjy6ZIcM88bkNMprkcH0v0fhw=
X-Google-Smtp-Source: AGRyM1tz1LQZffHHKNT0Mm2rHen82W0ZYrVTXVWplg1R140IIm4r+C3KJnLHr7ThlbnhnWDO1yRpBl/A9AE47csWLK8=
X-Received: by 2002:a05:6638:1608:b0:331:c83a:cc24 with SMTP id
 x8-20020a056638160800b00331c83acc24mr15049111jas.143.1655808885986; Tue, 21
 Jun 2022 03:54:45 -0700 (PDT)
MIME-Version: 1.0
Sender: lucassophia770@gmail.com
Received: by 2002:a4f:3e09:0:0:0:0:0 with HTTP; Tue, 21 Jun 2022 03:54:45
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Tue, 21 Jun 2022 12:54:45 +0200
X-Google-Sender-Auth: otmJBeEKRpn1DqB1EzSzbFFmMHM
Message-ID: <CADgTK4nk8TSnTHN0Ugw_CXOQDLerL6SUt51vMhpgeZcrnLj6Bg@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello ,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs. Sophia Erick, I am diagnosed
with ovarian cancer which my doctor have confirmed that I have only
some weeks to live so I have decided you handover the sum of($
11,000,000.00, Eleven Million Dollars) through I decided handover the
money in my account to you for help of the orphanage homes and the
needy once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my details to you please
assure me that you will only take 30%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs Sophia Erick.
