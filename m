Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918EA6AB6C6
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCFHJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:09:04 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A9483DB
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:09:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y10so5077738pfi.8
        for <stable@vger.kernel.org>; Sun, 05 Mar 2023 23:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678086543;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=d0rhMMzKlVg9zIuqZGl8JylqDIpn9asL3UZVwQURhCTrgITnI5cijEX2SdpEbngLy2
         Lyp4kodHH4WWAMDdaOzJvQpa02s4xEpunm0nHmfLmjKrKakMM8aNWqksMKhk+SIpBKhV
         2AIZtwxSgD/Ef78gzDf7bR8Ke4Pm7o3rrEbmJ6jITlWb76Ae4T6Ns/40Xa+rp1j/iIgr
         MmriL3KgzeD6DeHBylH5v6dbVL0CSrRqIt7xJw21oIi4BHJZJ7H7BccMjq4N+6y/+DAD
         rn4u77v200mRNcEiDdPgcSGFwrsLf7rRlHNfyr35DDawpJn7m012lwGkcX6DpTKwJYLo
         LeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678086543;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=7HJ97Xt/aiS8z91SzTVfbmPb/1eMrnfvmKndoSQXoo3OGAlCVFV7PnTWtHZRgINJGE
         RG+YOBVApDk7c9/C0rxBeF8OOfhbooq3I4jA5dpWM37ZyglylJMZpA+nqGRpL3GqCz2z
         +1Hh0YuYdz1qicBrZkU9xQj05XfKyKH+2974rX8yHfSFquweVZGvZyXMN3vVSucd5/iM
         kESKuo8TnEsUs7CIGTfTc24ycLBuAr5MtTmThfkoDLYDGqx9DPkQVwW5NDv4tjelXMy1
         QyfkSdStH4IiW1pBZijsjq8CuWd2063xB2Huv5MU1ukGjLWNNVI2rJxpn5H5+f3DFIo+
         heyw==
X-Gm-Message-State: AO0yUKUV30XdF7QA69e8b++avr5qQs9VsiIzzyenKLBiSy5Ryp2yWE8g
        Y1eKTQBUxvVFewZ5U+IbFqUnSXHbNGgpdmVA8Pk=
X-Google-Smtp-Source: AK7set8X/+42+FdhSa6e1dIwTeDphmc7A+WXvkq56VB9x4A3mohHjQiZAHIDqTSG+Q+O0hCvr+ILylokAMelYQvGCUg=
X-Received: by 2002:a62:838c:0:b0:592:5896:89cf with SMTP id
 h134-20020a62838c000000b00592589689cfmr4384484pfe.0.1678086543201; Sun, 05
 Mar 2023 23:09:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:6e96:b0:441:11d6:f6cc with HTTP; Sun, 5 Mar 2023
 23:09:02 -0800 (PST)
Reply-To: Lindacullbert@gmail.com
From:   Mrs Linda Culbert <adelinejohnson07@gmail.com>
Date:   Mon, 6 Mar 2023 07:09:02 +0000
Message-ID: <CAHXS7qLu-+rfksCHWp9yHOdYkqmVnH14jy14Q7LidE0PWqecnQ@mail.gmail.com>
Subject: =?UTF-8?Q?Hola=2C_Por_favor_como_est=C3=A1s=2E_Necesitar=C3=A9_su_respuest?=
        =?UTF-8?Q?a_urgente=2E_Saludos?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,EMPTY_MESSAGE,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:434 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adelinejohnson07[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adelinejohnson07[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.3 EMPTY_MESSAGE Message appears to have no textual parts
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


