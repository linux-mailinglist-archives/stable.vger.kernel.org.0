Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19DA64C556
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 09:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiLNIzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 03:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiLNIzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 03:55:13 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7FF193E5
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 00:55:12 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b2so42837626eja.7
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 00:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nuvBIf2lT6ew8E3Gonh9xI5Qgd+TLMqmI33+g9gdqOQ=;
        b=icJUABvbqeOfERLcLLPFpi8FXD+h24zm/830w611XKQoBahTh1uTufoHzdH1hxFFGW
         yr0e3ViNen4g5NSF8rs3vLE2KknBeQrNlysnWWSzhfMLbSxVYmyMAaSDgHZwntIEmDDv
         2msScGdmYHnLY3s9KNUhASBB1LLvN5c0yEtyuxVINY/89QYyZDDQV50XSwuJVgQwZNqQ
         ousMweyjWPIko9oIAo4j9y+D33ddyn0XegrbrIhrOPq1samk9rarMkiXAGrhtf/bDqfY
         RvUQYvyRBO6kD2FKeDpUuB/dk7653QP9ViwRLLUenN8Kdv1zVbXtND8BAa2PSah01uYj
         i4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuvBIf2lT6ew8E3Gonh9xI5Qgd+TLMqmI33+g9gdqOQ=;
        b=We+sTiuVyvoBVCvox5khuR670XxB3P9UxID6CnPV5ObMzcSeVy+phIds8FSxZvg33j
         1nGMI6V6Cn6llxTSfI13BS6DGLwmyxI9c+CwVtLzPabqzqavUsscOAEC16wH8f/FG9Tb
         DVGykx/rH1cjlVfE40oxKiskvIGzocBcldVjU4iYNcVxert2y/AN35CY4FpKMYhQDtA0
         t9Ztlsdr5WRucXKUnPxXpgIU57roR7T4di/V3sWfu4e4oIjbue7oj0OzKlWKk/VJspaj
         kzBzBL9OR16ESMJvjOxiJaHIFMCG6N25sd8kPreTXQxVvLuWnHHAwQMFPyq0dOw1u6A6
         x7iA==
X-Gm-Message-State: ANoB5pmScBEx0MCOg/DRJdhiNuQl1WPxKQ3Phfzq26BpsF+Bm0ENP/ak
        VIh/MOvXz8qFvPOX/tVbRataIdNEV5ifCX6nPfk=
X-Google-Smtp-Source: AA0mqf7L0F2seaNu+vMMjWi6a4uH9wPX/JU1ZN/RzvjOFaeP8OGVp2le0s2lGiiYZQ7V/5ScDC0oGpWD2qbccqpUfOI=
X-Received: by 2002:a17:907:98e8:b0:7c0:f685:31df with SMTP id
 ke8-20020a17090798e800b007c0f68531dfmr16827481ejc.142.1671008110544; Wed, 14
 Dec 2022 00:55:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:3b6:b0:27:90e6:e1d1 with HTTP; Wed, 14 Dec 2022
 00:55:09 -0800 (PST)
Reply-To: plml47@hotmail.com
From:   Philip Manul <alomassou1972@gmail.com>
Date:   Wed, 14 Dec 2022 00:55:09 -0800
Message-ID: <CA+_U6tiY_JmOMfpqL5TwQbZWt98wX+d3QhDPJgeUq9cqcCfYEA@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.5 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNCLAIMED_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:634 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [plml47[at]hotmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [alomassou1972[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [alomassou1972[at]gmail.com]
        *  2.4 UNCLAIMED_MONEY BODY: People just leave money laying around
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.0 ADVANCE_FEE_3_NEW Appears to be advance fee fraud (Nigerian
        *      419)
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.

***************************************************

Good day,
My name is Philip Manul. I am a lawyer by profession. I have a
deceased client who happens to share the same surname with you. I have
all paper documents in my possession. Your relative my late client
left an unclaimed fund here in my country. I await your reply for
Procedure.
Philip Manul.
